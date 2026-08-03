import 'package:flutter/foundation.dart';
import 'package:sreeraj_qr_reader/models/air_qr_progress.dart';
import 'package:sreeraj_qr_reader/models/scan_record.dart';
import 'package:sreeraj_qr_reader/services/air_qr_service.dart';

/// Provider managing AirQR optical stream decoding state, progress, and reassembled result.
class AirQrProvider extends ChangeNotifier {
  final AirQrService _airQrService;
  AirQrProgress _progress = const AirQrProgress();

  AirQrProvider({AirQrService? airQrService})
    : _airQrService = airQrService ?? AirQrService();

  AirQrProgress get progress => _progress;
  AirQrStatus get status => _progress.status;
  bool get isReceiving => _progress.status == AirQrStatus.receiving;
  bool get isCompleted => _progress.status == AirQrStatus.completed;
  String? get reassembledContent => _progress.reassembledContent;

  /// Processes a single frame raw payload captured by camera scanner.
  void processScannedCode(String rawCode) {
    if (_progress.status == AirQrStatus.completed) return;

    final updatedProgress = _airQrService.processFrameString(
      rawCode,
      _progress,
    );

    if (updatedProgress != _progress) {
      _progress = updatedProgress;
      notifyListeners();
    }
  }

  /// Resets the current stream decoding session.
  void resetStream() {
    _airQrService.reset();
    _progress = const AirQrProgress();
    notifyListeners();
  }

  /// Creates a ScanRecord for saving the reassembled AirQR payload to history.
  ScanRecord? createScanRecord() {
    if (_progress.reassembledContent == null) return null;

    return ScanRecord(
      id: '${DateTime.now().millisecondsSinceEpoch}',
      timestamp: DateTime.now(),
      rawContent: _progress.reassembledContent!,
      barcodeFormat: 'airQrStream',
      category: 'air_qr',
      notes: 'Received via AirQR Optical Air-Gap Stream Reader',
      locationTag: 'Air-Gap Transfer',
      metadata: {
        'isAirQr': true,
        'streamId': _progress.streamId,
        'totalBlocks': _progress.totalBlocks,
      },
    );
  }
}
