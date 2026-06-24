import 'package:flutter/foundation.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sreeraj_qr_reader/models/safety_check_result.dart';
import 'package:sreeraj_qr_reader/services/url_safety_service.dart';

class ScanProvider extends ChangeNotifier {
  String? _scanResult;
  BarcodeType? _scanType;
  bool _isUrl = false;
  bool _isSafeUrl = true;
  bool _isLoading = false;
  bool _activeProbingEnabled = false;
  List<SafetyCheckResult> _safetyChecks = [];

  final UrlSafetyService _urlSafetyService;

  ScanProvider({UrlSafetyService? urlSafetyService})
      : _urlSafetyService = urlSafetyService ?? UrlSafetyService();

  String? get scanResult => _scanResult;
  BarcodeType? get scanType => _scanType;
  bool get isUrl => _isUrl;
  bool get isSafeUrl => _isSafeUrl;
  bool get isLoading => _isLoading;

  /// Whether the last safety run used active online probing. When false, the
  /// scanned site was never contacted (links checked from local rules only).
  bool get activeProbingEnabled => _activeProbingEnabled;
  List<SafetyCheckResult> get safetyChecks => List.unmodifiable(_safetyChecks);

  bool get hasNetworkError => _safetyChecks.any(
        (c) => c.message.contains(
          RegExp(
            r'Unable to|Error|network|timeout|certificate check failed',
            caseSensitive: false,
          ),
        ),
      );

  void setScanResult(String result, BarcodeType type) {
    _scanResult = result;
    _scanType = type;
    _isUrl = _checkIfUrl(result);
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

      final failedChecks = _safetyChecks.where((check) => !check.passed).length;
      _isSafeUrl = failedChecks == 0;
    } catch (e) {
      _isSafeUrl = false;
      if (kDebugMode) debugPrint('Error checking URL safety: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearScan() {
    _scanResult = null;
    _scanType = null;
    _isUrl = false;
    _isSafeUrl = true;
    _isLoading = false;
    _safetyChecks = [];
    notifyListeners();
  }
}
