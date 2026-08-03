import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sreeraj_qr_reader/models/parsed_payload.dart';
import 'package:sreeraj_qr_reader/providers/scan_provider.dart';

void main() {
  group('ScanProvider Smart Payload Integration', () {
    late ScanProvider provider;

    setUp(() {
      provider = ScanProvider();
    });

    test('setScanResult populates parsedPayload for Wi-Fi QR', () {
      const raw = 'WIFI:S:TestNet;T:WPA;P:pass123;;';
      provider.setScanResult(raw, BarcodeType.wifi);

      expect(provider.scanResult, equals(raw));
      expect(provider.parsedPayload, isNotNull);
      expect(provider.parsedPayload, isA<WifiPayload>());
      final wifi = provider.parsedPayload as WifiPayload;
      expect(wifi.ssid, equals('TestNet'));
    });

    test('setScanResult populates parsedPayload for TOTP QR', () {
      const raw =
          'otpauth://totp/MyApp:user@domain.com?secret=JBSWY3DPEHPK3PXP';
      provider.setScanResult(raw, BarcodeType.text);

      expect(provider.parsedPayload, isNotNull);
      expect(provider.parsedPayload, isA<TotpPayload>());
      final totp = provider.parsedPayload as TotpPayload;
      expect(totp.secret, equals('JBSWY3DPEHPK3PXP'));
    });

    test('clearScan clears parsedPayload', () {
      provider.setScanResult(
        'WIFI:S:TestNet;T:WPA;P:pass123;;',
        BarcodeType.wifi,
      );
      expect(provider.parsedPayload, isNotNull);

      provider.clearScan();
      expect(provider.parsedPayload, isNull);
    });
  });
}
