import 'package:flutter_test/flutter_test.dart';
import 'package:sreeraj_qr_reader/models/app_message.dart';
import 'package:sreeraj_qr_reader/models/quishing_analysis_result.dart';
import 'package:sreeraj_qr_reader/services/quishing_guard_service.dart';

void main() {
  group('QuishingGuardService', () {
    late QuishingGuardService service;

    setUp(() {
      service = const QuishingGuardService();
    });

    test('analyzeQrContext returns authentic result for baseline context', () {
      final result = service.analyzeQrContext(
        rawContent: 'https://legitimate-parking.com/pay',
      );

      expect(result.overallRiskScore, lessThan(0.35));
      expect(result.riskLevel, equals(QuishingRiskLevel.authentic));
      expect(result.statusLabel.key, AppMessageKey.quishingStatusAuthentic);
      expect(result.detectedSignals, isNotEmpty);
    });

    test(
      'analyzeQrContext correctly processes simulated metadata overrides',
      () {
        final warningResult = service.analyzeQrContext(
          rawContent: 'https://parking-meter-overlay.com',
          metadata: {
            'simulatedRiskLevel': QuishingRiskLevel.highWarning,
            'simulatedEdgeScore': 0.88,
            'simulatedTextureScore': 0.82,
            'simulatedSignals': [
              AppMessage(AppMessageKey.quishingSignalDoubleEdgeAroundMatrix),
              AppMessage(AppMessageKey.quishingSignalMicroShadowStickerBorder),
            ],
          },
        );

        expect(warningResult.overallRiskScore, equals(0.85));
        expect(warningResult.riskLevel, equals(QuishingRiskLevel.highWarning));
        expect(warningResult.edgeDiscontinuityScore, equals(0.88));
        expect(warningResult.textureGrainScore, equals(0.82));
        expect(warningResult.detectedSignals, hasLength(2));
        expect(
          warningResult.statusLabel.key,
          AppMessageKey.quishingStatusHighWarning,
        );
      },
    );

    test(
      'analyzeQrContext handles simulated wear & tear metadata correctly',
      () {
        final wearResult = service.analyzeQrContext(
          rawContent: 'https://restaurant.com/menu',
          metadata: {'simulatedRiskLevel': QuishingRiskLevel.wearAndTear},
        );

        expect(wearResult.overallRiskScore, greaterThanOrEqualTo(0.35));
        expect(wearResult.overallRiskScore, lessThan(0.70));
        expect(wearResult.riskLevel, equals(QuishingRiskLevel.wearAndTear));
        expect(
          wearResult.statusLabel.key,
          AppMessageKey.quishingStatusWearAndTear,
        );
      },
    );

    test(
      'analyzeFrameBytes detects double-edge reflection and micro-shadows in synthetic image data',
      () {
        const width = 40;
        const height = 40;
        final List<int> bytes = List<int>.filled(width * height, 128);

        // Inject synthetic perimeter double edge gradient (d1 > 45 and d2 > 45)
        for (int y = 5; y < 35; y++) {
          final lineOffset = y * width;
          bytes[lineOffset + 10] = 220;
          bytes[lineOffset + 11] = 30;
          bytes[lineOffset + 12] = 230;
          bytes[lineOffset + 13] = 20;
        }

        final result = service.analyzeFrameBytes(
          imageBytes: bytes,
          width: width,
          height: height,
        );

        expect(result.edgeDiscontinuityScore, greaterThan(0.2));
        expect(result.detectedSignals, isNotEmpty);
      },
    );
  });
}
