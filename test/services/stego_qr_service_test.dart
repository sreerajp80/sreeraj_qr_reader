import 'package:flutter_test/flutter_test.dart';
import 'package:sreeraj_qr_reader/services/stego_qr_service.dart';

void main() {
  group('StegoQrService', () {
    late StegoQrService service;

    setUp(() {
      service = StegoQrService();
    });

    test('isStegoQr returns true for valid header signatures', () {
      expect(
        service.isStegoQr('Menu Text\n\n[STEGOQR:v1:salt:iv:cipher]'),
        isTrue,
      );
      expect(service.isStegoQr('STEGOQR:v1:salt:iv:cipher'), isTrue);
      expect(
        service.isStegoQr(
          'Public\n\n--STEGOQR--\nSALT:abc\nIV:def\nCIPHERTEXT:ghi',
        ),
        isTrue,
      );
    });

    test('isStegoQr returns false for normal QR payloads', () {
      expect(service.isStegoQr('https://example.com'), isFalse);
      expect(service.isStegoQr('Plain text content'), isFalse);
      expect(service.isStegoQr(''), isFalse);
    });

    test('parseStegoQr extracts decoy text and payload components correctly', () {
      const payload =
          'Visit restaurant menu\n\n[STEGOQR:v1:c2FsdDEyMw==:aXZpdmk1Njc=:Y2lwaGVyODkw]';
      final result = service.parseStegoQr(payload);

      expect(result.decoyText, equals('Visit restaurant menu'));
      expect(result.version, equals('v1'));
      expect(result.salt, equals('c2FsdDEyMw=='));
      expect(result.iv, equals('aXZpdmk1Njc='));
      expect(result.ciphertext, equals('Y2lwaGVyODkw'));
      expect(result.isUnlocked, isFalse);
      expect(result.decryptedPayload, isNull);
    });

    test('encryptPayload and decryptPayload roundtrip successfully', () {
      const secret = 'Confidential Top Secret Passcode 1234';
      const passphrase = 'MySuperSecretPassphrase';
      const decoy = 'Scan to view lunch menu';

      final stegoPayloadString = service.createStegoPayload(
        secretPayload: secret,
        passphrase: passphrase,
        decoyText: decoy,
      );

      expect(service.isStegoQr(stegoPayloadString), isTrue);

      final parsed = service.parseStegoQr(stegoPayloadString);
      expect(parsed.decoyText, equals(decoy));

      final decrypted = service.decryptPayload(parsed, passphrase);
      expect(decrypted.isUnlocked, isTrue);
      expect(decrypted.decryptedPayload, equals(secret));
      expect(decrypted.error, isNull);
    });

    test('decryptPayload with incorrect passphrase fails gracefully', () {
      const secret = 'Confidential Top Secret Passcode 1234';
      const passphrase = 'MySuperSecretPassphrase';
      const wrongPassphrase = 'WrongPassphrase123';

      final stegoPayloadString = service.createStegoPayload(
        secretPayload: secret,
        passphrase: passphrase,
      );

      final parsed = service.parseStegoQr(stegoPayloadString);
      final decrypted = service.decryptPayload(parsed, wrongPassphrase);

      expect(decrypted.isUnlocked, isFalse);
      expect(decrypted.decryptedPayload, isNull);
      expect(decrypted.error, contains('Decryption failed'));
    });
  });
}
