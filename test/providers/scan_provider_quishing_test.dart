import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sreeraj_qr_reader/models/app_message.dart';
import 'package:sreeraj_qr_reader/models/quishing_analysis_result.dart';
import 'package:sreeraj_qr_reader/providers/scan_provider.dart';

void main() {
  group('ScanProvider QuishingGuard Integration', () {
    late ScanProvider provider;

    setUp(() {
      provider = ScanProvider();
    });

    test('setScanResult populates quishingResult automatically', () {
      expect(provider.quishingResult, isNull);

      provider.setScanResult(
        'https://example-parking.com/pay',
        BarcodeType.url,
      );

      expect(provider.quishingResult, isNotNull);
      expect(
        provider.quishingResult!.riskLevel,
        equals(QuishingRiskLevel.authentic),
      );
      expect(provider.quishingResult!.overallRiskScore, lessThan(0.35));
    });

    test(
      'setScanResult forwards quishingMetadata for overlay sticker detection',
      () {
        provider.setScanResult(
          'https://fake-phishing-sticker.com',
          BarcodeType.url,
          quishingMetadata: {
            'simulatedRiskLevel': QuishingRiskLevel.highWarning,
            'simulatedEdgeScore': 0.90,
            'simulatedTextureScore': 0.85,
          },
        );

        expect(provider.quishingResult, isNotNull);
        expect(
          provider.quishingResult!.riskLevel,
          equals(QuishingRiskLevel.highWarning),
        );
        expect(provider.quishingResult!.overallRiskScore, equals(0.88));
        expect(
          provider.quishingResult!.statusLabel.key,
          AppMessageKey.quishingStatusHighWarning,
        );
      },
    );

    test('runQuishingAnalysis updates quishingResult for active scan', () {
      provider.setScanResult(
        'https://test-restaurant.com/menu',
        BarcodeType.url,
      );

      provider.runQuishingAnalysis(
        metadata: {'simulatedRiskLevel': QuishingRiskLevel.wearAndTear},
      );

      expect(provider.quishingResult, isNotNull);
      expect(
        provider.quishingResult!.riskLevel,
        equals(QuishingRiskLevel.wearAndTear),
      );
    });

    test('clearScan resets quishingResult state', () {
      provider.setScanResult('https://example.com', BarcodeType.url);
      expect(provider.quishingResult, isNotNull);

      provider.clearScan();
      expect(provider.quishingResult, isNull);
    });
  });
}
