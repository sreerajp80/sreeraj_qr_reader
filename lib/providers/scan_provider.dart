import 'package:flutter/foundation.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sreeraj_qr_reader/models/dom_sandbox_result.dart';
import 'package:sreeraj_qr_reader/models/parsed_payload.dart';
import 'package:sreeraj_qr_reader/models/quishing_analysis_result.dart';
import 'package:sreeraj_qr_reader/models/app_message.dart';
import 'package:sreeraj_qr_reader/models/safety_check_result.dart';
import 'package:sreeraj_qr_reader/models/scan_record.dart';
import 'package:sreeraj_qr_reader/models/stego_qr_data.dart';
import 'package:sreeraj_qr_reader/services/biometric_service.dart';
import 'package:sreeraj_qr_reader/services/dom_sandbox_service.dart';
import 'package:sreeraj_qr_reader/services/payload_parser_service.dart';
import 'package:sreeraj_qr_reader/services/quishing_guard_service.dart';
import 'package:sreeraj_qr_reader/services/stego_qr_service.dart';
import 'package:sreeraj_qr_reader/services/url_safety_service.dart';

/// Provider managing scan results, URL safety checks, StegoQR state, Smart Payload parsing, QuishingGuard tamper detection, Zero-Trust DOM Sandboxing, and Scan Feedback preferences.
class ScanProvider extends ChangeNotifier {
  static const String vibrationPrefKey = 'scan_feedback_vibration';
  static const String soundPrefKey = 'scan_feedback_sound';

  String? _scanResult;
  BarcodeType? _scanType;
  bool _isUrl = false;
  bool _isSafeUrl = true;
  bool _isLoading = false;
  bool _activeProbingEnabled = false;
  bool _isVibrationEnabled = true;
  bool _isSoundEnabled = true;
  List<SafetyCheckResult> _safetyChecks = [];
  StegoQrData? _stegoQrData;
  ParsedPayload? _parsedPayload;
  QuishingAnalysisResult? _quishingResult;
  DomSandboxResult? _domSandboxResult;

  final UrlSafetyService _urlSafetyService;
  final StegoQrService _stegoQrService;
  final BiometricService _biometricService;
  final PayloadParserService _payloadParserService;
  final QuishingGuardService _quishingGuardService;
  final DomSandboxService _domSandboxService;

  ScanProvider({
    UrlSafetyService? urlSafetyService,
    StegoQrService? stegoQrService,
    BiometricService? biometricService,
    PayloadParserService? payloadParserService,
    QuishingGuardService? quishingGuardService,
    DomSandboxService? domSandboxService,
  }) : _urlSafetyService = urlSafetyService ?? UrlSafetyService(),
       _stegoQrService = stegoQrService ?? StegoQrService(),
       _biometricService = biometricService ?? BiometricService(),
       _payloadParserService = payloadParserService ?? PayloadParserService(),
       _quishingGuardService =
           quishingGuardService ?? const QuishingGuardService(),
       _domSandboxService = domSandboxService ?? DomSandboxService() {
    _loadFeedbackSettings();
  }

  String? get scanResult => _scanResult;
  BarcodeType? get scanType => _scanType;
  bool get isUrl => _isUrl;
  bool get isSafeUrl => _isSafeUrl;
  bool get isLoading => _isLoading;
  bool get isVibrationEnabled => _isVibrationEnabled;
  bool get isSoundEnabled => _isSoundEnabled;
  ParsedPayload? get parsedPayload => _parsedPayload;
  QuishingAnalysisResult? get quishingResult => _quishingResult;
  DomSandboxResult? get domSandboxResult => _domSandboxResult;

  Future<void> _loadFeedbackSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isVibrationEnabled = prefs.getBool(vibrationPrefKey) ?? true;
      _isSoundEnabled = prefs.getBool(soundPrefKey) ?? true;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) debugPrint('Error loading scan feedback settings: $e');
    }
  }

  Future<void> setVibrationEnabled(bool enabled) async {
    _isVibrationEnabled = enabled;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(vibrationPrefKey, enabled);
    } catch (e) {
      if (kDebugMode) debugPrint('Error persisting vibration setting: $e');
    }
  }

  Future<void> setSoundEnabled(bool enabled) async {
    _isSoundEnabled = enabled;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(soundPrefKey, enabled);
    } catch (e) {
      if (kDebugMode) debugPrint('Error persisting sound setting: $e');
    }
  }

  /// Whether the scanned code contains a StegoQR hidden payload.
  bool get isStegoQr => _stegoQrData != null;

  /// The StegoQR data model if current scan is StegoQR.
  StegoQrData? get stegoQrData => _stegoQrData;

  /// Whether the last safety run used active online probing.
  bool get activeProbingEnabled => _activeProbingEnabled;
  List<SafetyCheckResult> get safetyChecks => List.unmodifiable(_safetyChecks);

  /// Message keys that mean a check could not finish because the network or
  /// the remote server was unavailable. Used to offer a re-check button.
  static const Set<AppMessageKey> _networkErrorKeys = {
    AppMessageKey.sslUnverifiable,
    AppMessageKey.sslCheckFailed,
    AppMessageKey.redirectUnavailable,
    AppMessageKey.patternUnavailable,
    AppMessageKey.shortenerUnavailable,
    AppMessageKey.shortenerOfflineHeuristics,
    AppMessageKey.homographUnavailable,
    AppMessageKey.maliciousUnavailable,
    AppMessageKey.maliciousApiError,
    AppMessageKey.maliciousRateLimited,
  };

  bool get hasNetworkError =>
      _safetyChecks.any((c) => _networkErrorKeys.contains(c.message.key));

  void setScanResult(
    String result,
    BarcodeType type, {
    List<int>? rawFrameBytes,
    int frameWidth = 0,
    int frameHeight = 0,
    Map<String, dynamic>? quishingMetadata,
  }) {
    _scanResult = result;
    _scanType = type;

    if (_stegoQrService.isStegoQr(result)) {
      _stegoQrData = _stegoQrService.parseStegoQr(result);
      _parsedPayload = _payloadParserService.parse(_stegoQrData!.decoyText);
      _isUrl = _checkIfUrl(_stegoQrData!.decoyText);
    } else {
      _stegoQrData = null;
      _parsedPayload = _payloadParserService.parse(result);
      _isUrl = _checkIfUrl(result);
    }

    _quishingResult = _quishingGuardService.analyzeQrContext(
      rawContent: result,
      rawBytes: rawFrameBytes,
      width: frameWidth,
      height: frameHeight,
      metadata: quishingMetadata,
    );

    notifyListeners();
  }

  /// Explicitly triggers QuishingGuard physical tamper analysis with custom camera frame or metadata parameters.
  void runQuishingAnalysis({
    List<int>? rawFrameBytes,
    int width = 0,
    int height = 0,
    Map<String, dynamic>? metadata,
  }) {
    if (_scanResult == null) return;
    _quishingResult = _quishingGuardService.analyzeQrContext(
      rawContent: _scanResult!,
      rawBytes: rawFrameBytes,
      width: width,
      height: height,
      metadata: metadata,
    );
    notifyListeners();
  }

  bool _checkIfUrl(String text) {
    final urlRegex = RegExp(
      r'^https?://[\w\-]+(\.[\w\-]+)+[/#?]?.*$',
      caseSensitive: false,
    );
    return urlRegex.hasMatch(text);
  }

  Future<void> checkUrlSafety(String url) async {
    if (!_isUrl) return;

    _isLoading = true;
    _safetyChecks = [];
    _activeProbingEnabled = await _urlSafetyService.isActiveProbingEnabled();
    notifyListeners();

    try {
      _safetyChecks = await _urlSafetyService.runAllChecks(url);
      _domSandboxResult = await _domSandboxService.analyzeAndRender(
        url,
        activeProbing: _activeProbingEnabled,
      );

      final failedChecks = _safetyChecks.where((check) => !check.passed).length;
      _isSafeUrl = failedChecks == 0 && (_domSandboxResult?.isSafe ?? true);
    } catch (e) {
      _isSafeUrl = false;
      if (kDebugMode) debugPrint('Error checking URL safety: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Unlocks the StegoQR payload using biometric authentication and a passphrase.
  /// [biometricReason] is the text the system dialog shows. The screen passes
  /// it in already localized, so this layer holds no UI strings.
  Future<bool> unlockStegoWithBiometrics({
    required String passphrase,
    required String biometricReason,
  }) async {
    if (_stegoQrData == null) return false;

    final authenticated = await _biometricService.authenticate(
      localizedReason: biometricReason,
    );

    if (authenticated) {
      _stegoQrData = _stegoQrService.decryptPayload(_stegoQrData!, passphrase);
      if (_stegoQrData!.decryptedPayload != null) {
        _parsedPayload = _payloadParserService.parse(
          _stegoQrData!.decryptedPayload!,
        );
      }
      notifyListeners();
      return _stegoQrData!.isUnlocked;
    } else {
      _stegoQrData = _stegoQrData!.copyWith(
        error: const AppMessage(AppMessageKey.stegoBiometricCanceled),
      );
      notifyListeners();
      return false;
    }
  }

  /// Unlocks the StegoQR payload directly using a passphrase.
  bool unlockStegoWithPassphrase(String passphrase) {
    if (_stegoQrData == null) return false;

    _stegoQrData = _stegoQrService.decryptPayload(_stegoQrData!, passphrase);
    if (_stegoQrData!.decryptedPayload != null) {
      _parsedPayload = _payloadParserService.parse(
        _stegoQrData!.decryptedPayload!,
      );
    }
    notifyListeners();
    return _stegoQrData!.isUnlocked;
  }

  /// Creates a ScanRecord representation of the current scan state.
  ScanRecord? createScanRecord({
    String? notes,
    String? locationTag,
    bool isFavorite = false,
  }) {
    if (_scanResult == null) return null;

    String category = 'text';
    if (_parsedPayload != null && _parsedPayload!.type != PayloadType.generic) {
      category = _parsedPayload!.type.name;
    } else if (_isUrl) {
      category = 'url';
    } else if (_scanType != null && _scanType != BarcodeType.unknown) {
      category = 'barcode';
    }

    int score = 100;
    if (_isUrl && _safetyChecks.isNotEmpty) {
      final passedCount = _safetyChecks.where((c) => c.passed).length;
      score = ((passedCount / _safetyChecks.length) * 100).round();
    }

    return ScanRecord(
      id: '${DateTime.now().millisecondsSinceEpoch}',
      timestamp: DateTime.now(),
      rawContent: _scanResult!,
      barcodeFormat: _scanType?.name ?? 'qrCode',
      category: category,
      safetyScore: score,
      notes: notes,
      locationTag: locationTag,
      isFavorite: isFavorite,
      metadata: {
        'isStego': isStegoQr,
        'isSafeUrl': _isSafeUrl,
        'quishingRisk': _quishingResult?.riskLevel.name,
      },
    );
  }

  void clearScan() {
    _scanResult = null;
    _scanType = null;
    _isUrl = false;
    _isSafeUrl = true;
    _isLoading = false;
    _safetyChecks = [];
    _stegoQrData = null;
    _parsedPayload = null;
    _quishingResult = null;
    _domSandboxResult = null;
    notifyListeners();
  }
}
