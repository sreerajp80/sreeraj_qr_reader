import 'package:flutter_test/flutter_test.dart';
import 'package:sreeraj_qr_reader/models/air_qr_progress.dart';
import 'package:sreeraj_qr_reader/providers/air_qr_provider.dart';
import 'package:sreeraj_qr_reader/services/air_qr_service.dart';

void main() {
  group('AirQrProvider tests', () {
    late AirQrProvider provider;

    setUp(() {
      provider = AirQrProvider();
    });

    test('initial state is idle with zero blocks', () {
      expect(provider.status, equals(AirQrStatus.idle));
      expect(provider.isReceiving, isFalse);
      expect(provider.isCompleted, isFalse);
      expect(provider.reassembledContent, isNull);
    });

    test('processScannedCode updates state when receiving frames', () {
      const payload = 'Test AirQR Provider Stream';
      final frames = AirQrService.encodePayload(payload, blockSize: 8);

      bool notified = false;
      provider.addListener(() {
        notified = true;
      });

      provider.processScannedCode(frames.first.toQrString());

      expect(notified, isTrue);
      expect(provider.status, equals(AirQrStatus.receiving));
      expect(provider.progress.totalBlocks, greaterThan(0));
    });

    test('resetStream clears progress back to idle', () {
      const payload = 'Test payload for reset';
      final frames = AirQrService.encodePayload(payload, blockSize: 8);

      provider.processScannedCode(frames.first.toQrString());
      expect(provider.status, equals(AirQrStatus.receiving));

      provider.resetStream();

      expect(provider.status, equals(AirQrStatus.idle));
      expect(provider.progress.totalBlocks, equals(0));
      expect(provider.reassembledContent, isNull);
    });

    test('createScanRecord returns ScanRecord when completed', () {
      const payload = 'AirQR Payload for ScanRecord';
      final frames = AirQrService.encodePayload(payload, blockSize: 10);

      for (final frame in frames) {
        provider.processScannedCode(frame.toQrString());
      }

      expect(provider.isCompleted, isTrue);
      final record = provider.createScanRecord();

      expect(record, isNotNull);
      expect(record!.rawContent, equals(payload));
      expect(record.category, equals('air_qr'));
      expect(record.barcodeFormat, equals('airQrStream'));
      expect(record.metadata?['isAirQr'], isTrue);
    });
  });
}
