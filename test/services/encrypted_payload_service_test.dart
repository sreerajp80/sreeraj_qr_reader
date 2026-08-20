import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter_test/flutter_test.dart';
import 'package:sreeraj_qr_reader/models/app_message.dart';
import 'package:sreeraj_qr_reader/models/encrypted_payload_data.dart';
import 'package:sreeraj_qr_reader/services/encrypted_payload_service.dart';
import 'package:sreeraj_qr_reader/services/stego_qr_service.dart';

void main() {
  late EncryptedPayloadService service;
  late StegoQrService stegoService;

  setUp(() {
    stegoService = StegoQrService();
    service = EncryptedPayloadService(stegoQrService: stegoService);
  });

  group('EncryptedPayloadService Detection Tests', () {
    test('Detects AirQR Manifest and Data Frames', () {
      const manifestUri =
          'textdataqr://m?v=1&n=1&k=snippet&h=e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855&z=1&e=1&s=c2FsdDEyMzQ1Njc4OTAxMg';
      const dataUri = 'textdataqr://f?v=1&i=0&n=1&d=ZGF0YWJvZHk';

      final manifestData = service.detectEncryptedPayload(manifestUri);
      expect(manifestData, isNotNull);
      expect(manifestData!.containerType, EncryptedContainerType.airQr);
      expect(manifestData.isGzipped, isTrue);

      final dataFrame = service.detectEncryptedPayload(dataUri);
      expect(dataFrame, isNotNull);
      expect(dataFrame!.containerType, EncryptedContainerType.airQr);
    });

    test('Detects StegoQR dual-layer payload', () {
      final stegoPayload = stegoService.createStegoPayload(
        decoyText: 'Public menu https://example.com',
        secretPayload: 'Secret admin password',
        passphrase: 'correctPassphrase123',
      );

      final detected = service.detectEncryptedPayload(stegoPayload);
      expect(detected, isNotNull);
      expect(detected!.containerType, EncryptedContainerType.stegoQr);
      expect(detected.publicDisplay, contains('Public menu'));
    });

    test('Detects JSON Crypto Envelope', () {
      final jsonEnvelope = jsonEncode({
        'iv': base64.encode(List.filled(12, 1)),
        'salt': base64.encode(List.filled(16, 2)),
        'ciphertext': base64.encode(utf8.encode('EncryptedPayload123')),
      });

      final detected = service.detectEncryptedPayload(jsonEnvelope);
      expect(detected, isNotNull);
      expect(detected!.containerType, EncryptedContainerType.jsonEnvelope);
      expect(detected.iv, isNotNull);
      expect(detected.salt, isNotNull);
    });

    test('Detects PGP armored message block', () {
      const pgpPayload =
          '-----BEGIN PGP MESSAGE-----\nVersion: BCPG v1.58\n\nhQGMA4...\n-----END PGP MESSAGE-----';

      final detected = service.detectEncryptedPayload(pgpPayload);
      expect(detected, isNotNull);
      expect(detected!.containerType, EncryptedContainerType.pgp);
    });

    test('Returns null for plain unencrypted text', () {
      expect(service.detectEncryptedPayload('https://flutter.dev'), isNull);
      expect(service.detectEncryptedPayload('WIFI:S:MyWifi;P:pass;;'), isNull);
      expect(service.detectEncryptedPayload(''), isNull);
    });
  });

  group('AirQR Encryption and Decryption Tests (Compatible with TextApp)', () {
    test('Successfully decrypts AirQR optical frame using session code', () {
      const sessionCode = 'ABC-DEF';
      const normalizedCode = 'ABCDEF';
      final saltBytes = Uint8List.fromList(List.generate(16, (i) => i + 1));
      const plainSecretText = 'Confidential AirQR Document Content';

      // 1. Construct payload envelope JSON
      final envelopeJson = jsonEncode({
        'app': 'text_data',
        'payloadVersion': 1,
        'kind': 'snippet',
        'name': 'note.txt',
        'mime': 'text/plain',
        'content': plainSecretText,
      });

      final plainBytes = Uint8List.fromList(utf8.encode(envelopeJson));
      final digestHex = sha256.convert(plainBytes).toString();
      final gzippedBytes = Uint8List.fromList(gzip.encode(plainBytes));

      // 2. Derive key: PBKDF2-HMAC-SHA256 (200k iter)
      final keyBytes = service.deriveKeyPbkdf2(
        normalizedCode,
        saltBytes,
        iterations: EncryptedPayloadService.airQrPbkdf2Iterations,
      );

      // 3. Encrypt using AES-256-GCM
      final encrypter = enc.Encrypter(
        enc.AES(enc.Key(keyBytes), mode: enc.AESMode.gcm),
      );
      final nonceBytes = Uint8List.fromList(List.generate(12, (i) => i + 10));
      final encryptedBytes = encrypter.encryptBytes(
        utf8.encode(base64.encode(gzippedBytes)),
        iv: enc.IV(nonceBytes),
      );

      final wireBytes =
          Uint8List(nonceBytes.length + encryptedBytes.bytes.length)
            ..setRange(0, nonceBytes.length, nonceBytes)
            ..setRange(
              nonceBytes.length,
              nonceBytes.length + encryptedBytes.bytes.length,
              encryptedBytes.bytes,
            );

      final wireBase64 = base64.encode(wireBytes);
      final wireBase64Url = base64Url
          .encode(utf8.encode(wireBase64))
          .replaceAll('=', '');
      final saltBase64Url = base64Url.encode(saltBytes).replaceAll('=', '');

      // 4. Assemble AirQR URI
      final airQrUri =
          'textdataqr://f?v=1&i=0&n=1&d=$wireBase64Url&s=$saltBase64Url&h=$digestHex&z=1&e=1';

      final detected = service.detectEncryptedPayload(airQrUri);
      expect(detected, isNotNull);

      // 5. Decrypt with correct session code
      final decrypted = service.decrypt(detected!, sessionCode);
      expect(decrypted.isUnlocked, isTrue);
      expect(decrypted.decryptedPayload, plainSecretText);
      expect(decrypted.fileName, 'note.txt');
      expect(decrypted.mimeType, 'text/plain');

      // 6. Test with wrong session code
      final failed = service.decrypt(detected, 'WRONG-CODE');
      expect(failed.isUnlocked, isFalse);
      expect(failed.error?.key, AppMessageKey.stegoWrongPassphrase);
    });
  });

  group('StegoQR Decryption Tests', () {
    test('Decrypts StegoQR payload', () {
      final stegoString = stegoService.createStegoPayload(
        decoyText: 'Decoy Text Here',
        secretPayload: 'Super Secret Payload 42',
        passphrase: 'CorrectPassword!',
      );

      final detected = service.detectEncryptedPayload(stegoString);
      expect(detected, isNotNull);

      final decrypted = service.decrypt(detected!, 'CorrectPassword!');
      expect(decrypted.isUnlocked, isTrue);
      expect(decrypted.decryptedPayload, 'Super Secret Payload 42');

      final wrongKeyResult = service.decrypt(detected, 'WrongPassword');
      expect(wrongKeyResult.isUnlocked, isFalse);
    });
  });

  group('Manual Decryption Tests', () {
    test('Decrypts raw AES-GCM ciphertext', () {
      const passphrase = 'mySecretKey123';
      final keyHash = Uint8List.fromList(
        sha256.convert(utf8.encode(passphrase)).bytes,
      );

      final nonce = Uint8List.fromList(List.generate(12, (i) => i + 5));
      final encrypter = enc.Encrypter(
        enc.AES(enc.Key(keyHash), mode: enc.AESMode.gcm),
      );
      final encrypted = encrypter.encryptBytes(
        utf8.encode('Hello Manual Decrypt'),
        iv: enc.IV(nonce),
      );

      final combined = Uint8List(nonce.length + encrypted.bytes.length)
        ..setRange(0, nonce.length, nonce)
        ..setRange(
          nonce.length,
          nonce.length + encrypted.bytes.length,
          encrypted.bytes,
        );

      final base64Cipher = base64.encode(combined);

      final result = service.decryptRaw(
        rawCipher: base64Cipher,
        passphrase: passphrase,
        mode: 'gcm',
      );
      expect(result, 'Hello Manual Decrypt');

      final failed = service.decryptRaw(
        rawCipher: base64Cipher,
        passphrase: 'wrongPassphrase',
        mode: 'gcm',
      );
      expect(failed, isNull);
    });
  });
}
