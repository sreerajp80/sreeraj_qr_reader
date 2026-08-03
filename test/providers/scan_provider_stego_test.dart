import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sreeraj_qr_reader/providers/scan_provider.dart';
import 'package:sreeraj_qr_reader/services/stego_qr_service.dart';

void main() {
  group('ScanProvider StegoQR Integration', () {
    late ScanProvider provider;
    late StegoQrService stegoService;

    setUp(() {
      stegoService = StegoQrService();
      provider = ScanProvider(stegoQrService: stegoService);
    });

    test('setScanResult detects StegoQR payload and extracts decoy text', () {
      const secret = 'Private Vault Key 999';
      const passphrase = 'KeyPassphrase';
      const decoyUrl = 'https://example.com/menu';

      final stegoPayload = stegoService.createStegoPayload(
        secretPayload: secret,
        passphrase: passphrase,
        decoyText: decoyUrl,
      );

      provider.setScanResult(stegoPayload, BarcodeType.url);

      expect(provider.isStegoQr, isTrue);
      expect(provider.stegoQrData, isNotNull);
      expect(provider.stegoQrData!.decoyText, equals(decoyUrl));
      expect(provider.isUrl, isTrue); // Decoy text is URL
      expect(provider.stegoQrData!.isUnlocked, isFalse);
    });

    test('unlockStegoWithPassphrase decrypts StegoQR payload', () {
      const secret = 'Secret Contact: +15550199';
      const passphrase = 'CorrectPassphrase';
      const decoy = 'Visit our blog';

      final stegoPayload = stegoService.createStegoPayload(
        secretPayload: secret,
        passphrase: passphrase,
        decoyText: decoy,
      );

      provider.setScanResult(stegoPayload, BarcodeType.text);

      final success = provider.unlockStegoWithPassphrase(passphrase);
      expect(success, isTrue);
      expect(provider.stegoQrData!.isUnlocked, isTrue);
      expect(provider.stegoQrData!.decryptedPayload, equals(secret));
    });

    test('clearScan resets StegoQR state', () {
      const stegoPayload = 'Decoy\n\n[STEGOQR:v1:salt:iv:ciphertext]';
      provider.setScanResult(stegoPayload, BarcodeType.text);

      expect(provider.isStegoQr, isTrue);

      provider.clearScan();

      expect(provider.isStegoQr, isFalse);
      expect(provider.stegoQrData, isNull);
      expect(provider.scanResult, isNull);
    });
  });
}
