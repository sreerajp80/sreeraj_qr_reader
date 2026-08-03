import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/key_derivators/api.dart';
import 'package:pointycastle/key_derivators/pbkdf2.dart';
import 'package:pointycastle/macs/hmac.dart';
import 'package:sreeraj_qr_reader/models/stego_qr_data.dart';

/// StegoQR Service - Tier 1 Service Layer
/// Performs detection, parsing, key derivation, and AES-256 decryption
/// for dual-layer steganographic QR payloads.
class StegoQrService {
  static const String stegoHeaderV1 = 'STEGOQR:v1:';
  static const String stegoBlockHeader = '--STEGOQR--';

  /// Checks if the raw barcode payload contains a StegoQR signature header.
  bool isStegoQr(String rawPayload) {
    if (rawPayload.isEmpty) return false;
    return rawPayload.contains(stegoHeaderV1) ||
        rawPayload.contains(stegoBlockHeader);
  }

  /// Parses a raw barcode payload into a [StegoQrData] model.
  StegoQrData parseStegoQr(String rawPayload) {
    if (!isStegoQr(rawPayload)) {
      throw ArgumentError('Payload is not a valid StegoQR format');
    }

    String decoyText = '';
    String salt = '';
    String iv = '';
    String ciphertext = '';

    // Match compact/bracket format: STEGOQR:v1:<salt>:<iv>:<ciphertext>
    final regexCompact = RegExp(
      r'(?:\[|\#)?STEGOQR:v1:([^:\s\]]+):([^:\s\]]+):([^:\s\]]+)\]?',
    );
    final match = regexCompact.firstMatch(rawPayload);

    if (match != null) {
      salt = match.group(1)!;
      iv = match.group(2)!;
      ciphertext = match.group(3)!;

      final matchStart = match.start;
      decoyText = rawPayload.substring(0, matchStart).trim();
      if (decoyText.endsWith('#')) {
        decoyText = decoyText.substring(0, decoyText.length - 1).trim();
      }
    } else if (rawPayload.contains(stegoBlockHeader)) {
      final parts = rawPayload.split(stegoBlockHeader);
      decoyText = parts[0].trim();
      final stegoBlock = parts.length > 1 ? parts[1] : '';

      final lines = stegoBlock.split('\n');
      for (final line in lines) {
        final trimmed = line.trim();
        if (trimmed.startsWith('SALT:')) {
          salt = trimmed.substring(5).trim();
        } else if (trimmed.startsWith('IV:')) {
          iv = trimmed.substring(3).trim();
        } else if (trimmed.startsWith('CIPHERTEXT:')) {
          ciphertext = trimmed.substring(11).trim();
        }
      }
    }

    if (decoyText.isEmpty) {
      decoyText = 'Innocent Public Content';
    }

    return StegoQrData(
      decoyText: decoyText,
      version: 'v1',
      salt: salt,
      iv: iv,
      ciphertext: ciphertext,
    );
  }

  /// Derives a 256-bit AES key from a passphrase and salt using PBKDF2-HMAC-SHA256.
  Uint8List deriveKey(
    String passphrase,
    Uint8List salt, {
    int iterations = 10000,
  }) {
    final pkdf2 = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64))
      ..init(Pbkdf2Parameters(salt, iterations, 32));
    return pkdf2.process(Uint8List.fromList(utf8.encode(passphrase)));
  }

  /// Decrypts the steganographic payload using AES-256 with key derived from [passphrase].
  StegoQrData decryptPayload(StegoQrData data, String passphrase) {
    if (passphrase.isEmpty) {
      return data.copyWith(error: 'Passphrase cannot be empty');
    }

    try {
      final saltBytes = base64.decode(data.salt);
      final ivBytes = base64.decode(data.iv);
      final derivedKeyBytes = deriveKey(passphrase, saltBytes);

      final key = Key(derivedKeyBytes);
      final ivObj = IV(ivBytes);
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

      final decryptedText = encrypter.decrypt(
        Encrypted.fromBase64(data.ciphertext),
        iv: ivObj,
      );

      return data.copyWith(isUnlocked: true, decryptedPayload: decryptedText);
    } catch (e) {
      return data.copyWith(
        error: 'Decryption failed. Invalid passphrase or corrupted data.',
      );
    }
  }

  /// Utility helper to generate a StegoQR payload string for testing or encoding.
  String createStegoPayload({
    required String secretPayload,
    required String passphrase,
    String decoyText = 'Scan to view menu',
  }) {
    final random = Random.secure();
    final saltBytes = Uint8List.fromList(
      List.generate(16, (_) => random.nextInt(256)),
    );
    final ivBytes = Uint8List.fromList(
      List.generate(16, (_) => random.nextInt(256)),
    );

    final derivedKeyBytes = deriveKey(passphrase, saltBytes);
    final key = Key(derivedKeyBytes);
    final ivObj = IV(ivBytes);

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(secretPayload, iv: ivObj);

    final saltB64 = base64.encode(saltBytes);
    final ivB64 = base64.encode(ivBytes);
    final cipherB64 = encrypted.base64;

    return '$decoyText\n\n[STEGOQR:v1:$saltB64:$ivB64:$cipherB64]';
  }
}
