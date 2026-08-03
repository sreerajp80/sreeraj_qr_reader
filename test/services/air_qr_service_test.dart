import 'package:flutter_test/flutter_test.dart';
import 'package:sreeraj_qr_reader/models/air_qr_frame.dart';
import 'package:sreeraj_qr_reader/models/air_qr_progress.dart';
import 'package:sreeraj_qr_reader/services/air_qr_service.dart';

void main() {
  group('AirQrFrame tests', () {
    test('parses v1 systematic frame string correctly', () {
      const raw = 'AIRQR|v1|stream123|5|2|123456|SGVsbG8=';
      final frame = AirQrFrame.parse(raw);

      expect(frame, isNotNull);
      expect(frame!.streamId, equals('stream123'));
      expect(frame.totalBlocks, equals(5));
      expect(frame.sequenceIndex, equals(2));
      expect(frame.isParity, isFalse);
      expect(frame.checksum, equals(123456));
      expect(frame.payloadBytes, equals([72, 101, 108, 108, 111]));
    });

    test('parses LT1 fountain parity frame string correctly', () {
      const raw = 'AIRQR|LT1|stream123|5|3:0,2,4|654321|SGVsbG8=';
      final frame = AirQrFrame.parse(raw);

      expect(frame, isNotNull);
      expect(frame!.streamId, equals('stream123'));
      expect(frame.totalBlocks, equals(5));
      expect(frame.isParity, isTrue);
      expect(frame.degree, equals(3));
      expect(frame.indices, equals([0, 2, 4]));
      expect(frame.checksum, equals(654321));
    });

    test('returns null for invalid string format', () {
      expect(AirQrFrame.parse('INVALID_FRAME'), isNull);
      expect(AirQrFrame.parse('AIRQR|v1|short'), isNull);
    });
  });

  group('AirQrService Stream Decoding & Reassembly', () {
    late AirQrService service;

    setUp(() {
      service = AirQrService();
    });

    test('encodes payload and decodes frames in sequential order', () {
      const payload = 'AirQR High-Speed Optical Air-Gap Test Message';
      final frames = AirQrService.encodePayload(payload, blockSize: 10);

      AirQrProgress progress = const AirQrProgress();
      for (final frame in frames) {
        progress = service.processFrameString(frame.toQrString(), progress);
        if (progress.status == AirQrStatus.completed) break;
      }

      expect(progress.status, equals(AirQrStatus.completed));
      expect(progress.reassembledContent, equals(payload));
    });

    test('decodes frames delivered out of order', () {
      const payload = 'Optical air-gap transfer without wireless pairing.';
      final frames = AirQrService.encodePayload(payload, blockSize: 12);

      final shuffledFrames = List<AirQrFrame>.from(frames)..shuffle();

      AirQrProgress progress = const AirQrProgress();
      for (final frame in shuffledFrames) {
        progress = service.processFrameString(frame.toQrString(), progress);
        if (progress.status == AirQrStatus.completed) break;
      }

      expect(progress.status, equals(AirQrStatus.completed));
      expect(progress.reassembledContent, equals(payload));
    });

    test(
      'recovers missing systematic frame using LT Fountain parity frame',
      () {
        const payload = 'Fountain code error correction demo!';
        final frames = AirQrService.encodePayload(
          payload,
          blockSize: 10,
          extraParityRatioPercent: 100,
        );

        // Separate systematic frames and parity frames
        final systematicFrames = frames.where((f) => !f.isParity).toList();
        final parityFrames = frames.where((f) => f.isParity).toList();

        expect(systematicFrames.length, greaterThan(1));

        // Omit frame at index 0 and use parity frames to recover it
        final framesWithMissingIndex0 = <AirQrFrame>[
          ...systematicFrames.sublist(1),
          ...parityFrames,
        ];

        AirQrProgress progress = const AirQrProgress();
        for (final frame in framesWithMissingIndex0) {
          progress = service.processFrameString(frame.toQrString(), progress);
          if (progress.status == AirQrStatus.completed) break;
        }

        expect(progress.status, equals(AirQrStatus.completed));
        expect(progress.reassembledContent, equals(payload));
      },
    );

    test('computeCrc32 produces consistent checksum', () {
      final bytes = [72, 101, 108, 108, 111]; // "Hello"
      final crc1 = AirQrService.computeCrc32(bytes);
      final crc2 = AirQrService.computeCrc32(bytes);

      expect(crc1, equals(crc2));
      expect(crc1, isNot(equals(0)));
    });
  });
}
