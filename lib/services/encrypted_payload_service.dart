import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart' as crypto;
import 'package:encrypt/encrypt.dart' as enc;
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/key_derivators/api.dart';
import 'package:pointycastle/key_derivators/pbkdf2.dart';
import 'package:pointycastle/macs/hmac.dart';
import 'package:sreeraj_qr_reader/models/app_message.dart';
import 'package:sreeraj_qr_reader/models/encrypted_payload_data.dart';
import 'package:sreeraj_qr_reader/services/stego_qr_service.dart';

/// Service for auto-detecting and decrypting multi-protocol encrypted QR codes,
/// including AirQR (`textdataqr://`), StegoQR, JSON crypto containers, and raw ciphertexts.
class EncryptedPayloadService {
  final StegoQrService _stegoQrService;

  EncryptedPayloadService({StegoQrService? stegoQrService})
    : _stegoQrService = stegoQrService ?? StegoQrService();

  /// AirQR constants matching the sender protocol.
  static const String airQrScheme = 'textdataqr';
  static const String airQrHostManifest = 'm';
  static const String airQrHostFrame = 'f';
  static const int airQrPbkdf2Iterations = 200000;

  /// Inspects [rawPayload] to determine if it carries an encrypted container.
  /// Returns parsed [EncryptedPayloadData] or null if not recognized as an encrypted container.
  EncryptedPayloadData? detectEncryptedPayload(String rawPayload) {
    final trimmed = rawPayload.trim();
    if (trimmed.isEmpty) return null;

    // 1. Check AirQR URI scheme (Optical transfer from TextApp)
    if (_isAirQr(trimmed)) {
      return _parseAirQr(trimmed);
    }

    // 2. Check StegoQR format
    if (_stegoQrService.isStegoQr(trimmed)) {
      final stego = _stegoQrService.parseStegoQr(trimmed);
      return EncryptedPayloadData(
        containerType: EncryptedContainerType.stegoQr,
        rawContent: trimmed,
        publicDisplay: stego.decoyText.isNotEmpty
            ? stego.decoyText
            : '🔒 StegoQR Encrypted Payload',
        salt: stego.salt,
        iv: stego.iv,
        ciphertext: stego.ciphertext,
      );
    }

    // 3. Check JSON Crypto Envelope
    if (trimmed.startsWith('{') && trimmed.endsWith('}')) {
      final jsonContainer = _tryParseJsonContainer(trimmed);
      if (jsonContainer != null) {
        return jsonContainer;
      }
    }

    // 4. Check PGP / ASCII-armored message
    if (trimmed.contains('-----BEGIN PGP MESSAGE-----') ||
        trimmed.contains('-----BEGIN ENCRYPTED MESSAGE-----')) {
      return EncryptedPayloadData(
        containerType: EncryptedContainerType.pgp,
        rawContent: trimmed,
        publicDisplay: '🔒 PGP Encrypted Message Block',
      );
    }

    return null;
  }

  bool _isAirQr(String text) {
    return text.startsWith('$airQrScheme://') ||
        text.startsWith('textdatasync://');
  }

  EncryptedPayloadData? _parseAirQr(String raw) {
    try {
      final uri = Uri.parse(raw);
      if (uri.scheme != airQrScheme) {
        // Pairing URI or other textdatasync
        return EncryptedPayloadData(
          containerType: EncryptedContainerType.airQr,
          rawContent: raw,
          publicDisplay: '🔒 Sync Pairing QR Code',
        );
      }

      final q = uri.queryParameters;
      final isManifest = uri.host == airQrHostManifest;
      final totalFrames = int.tryParse(q['n'] ?? '') ?? 1;
      final frameIndex = int.tryParse(q['i'] ?? '') ?? 0;
      final kind = q['k'] ?? 'snippet';
      final digest = q['h'];
      final salt = q['s'];
      final data = q['d'];
      final isGzipped = q['z'] == '1';

      return EncryptedPayloadData(
        containerType: EncryptedContainerType.airQr,
        rawContent: raw,
        publicDisplay: isManifest
            ? '🔒 AirQR Transfer Manifest ($kind, $totalFrames frames)'
            : '🔒 AirQR Transfer Frame (${frameIndex + 1}/$totalFrames)',
        salt: salt,
        ciphertext: data,
        digest: digest,
        isGzipped: isGzipped,
        totalFrames: totalFrames,
        frameIndex: frameIndex,
      );
    } catch (_) {
      return null;
    }
  }

  EncryptedPayloadData? _tryParseJsonContainer(String jsonText) {
    try {
      final decoded = jsonDecode(jsonText);
      if (decoded is Map<String, dynamic>) {
        final cipher =
            decoded['ciphertext'] ??
            decoded['cipherText'] ??
            decoded['data'] ??
            decoded['content'];
        final iv = decoded['iv'] ?? decoded['nonce'];
        final salt = decoded['salt'];

        if (cipher is String && iv is String) {
          return EncryptedPayloadData(
            containerType: EncryptedContainerType.jsonEnvelope,
            rawContent: jsonText,
            publicDisplay: '🔒 JSON Encrypted Container',
            salt: salt is String ? salt : null,
            iv: iv,
            ciphertext: cipher,
          );
        }
      }
    } catch (_) {
      // Not valid JSON
    }
    return null;
  }

  /// Derives an AES-256 key from a passphrase and salt using PBKDF2-HMAC-SHA256.
  Uint8List deriveKeyPbkdf2(
    String passphrase,
    Uint8List salt, {
    int iterations = 10000,
    int keyLengthBytes = 32,
  }) {
    final pkdf2 = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64))
      ..init(Pbkdf2Parameters(salt, iterations, keyLengthBytes));
    return pkdf2.process(Uint8List.fromList(utf8.encode(passphrase)));
  }

  /// Decrypts an [EncryptedPayloadData] object using [passphraseOrCode].
  EncryptedPayloadData decrypt(
    EncryptedPayloadData data,
    String passphraseOrCode,
  ) {
    final cleanedKey = passphraseOrCode.trim();
    if (cleanedKey.isEmpty) {
      return data.copyWith(
        error: const AppMessage(AppMessageKey.stegoPassphraseEmpty),
      );
    }

    switch (data.containerType) {
      case EncryptedContainerType.airQr:
        return _decryptAirQr(data, cleanedKey);
      case EncryptedContainerType.stegoQr:
        return _decryptStegoQr(data, cleanedKey);
      case EncryptedContainerType.jsonEnvelope:
        return _decryptJsonEnvelope(data, cleanedKey);
      case EncryptedContainerType.pgp:
      case EncryptedContainerType.custom:
        return _decryptGeneric(data, cleanedKey);
    }
  }

  EncryptedPayloadData _decryptAirQr(
    EncryptedPayloadData data,
    String sessionCode,
  ) {
    try {
      final normalizedCode = sessionCode.toUpperCase().replaceAll(
        RegExp(r'[\s\-]'),
        '',
      );

      // Check if data carries salt or if URI contains it
      String? saltStr = data.salt;
      String? cipherStr = data.ciphertext;

      if (saltStr == null || cipherStr == null) {
        final uri = Uri.parse(data.rawContent);
        saltStr ??= uri.queryParameters['s'];
        cipherStr ??= uri.queryParameters['d'];
      }

      if (saltStr == null || saltStr.isEmpty) {
        return data.copyWith(
          error: const AppMessage(AppMessageKey.stegoWrongPassphrase),
        );
      }

      final saltBytes = Uint8List.fromList(
        base64Url.decode(_repadBase64(saltStr)),
      );
      final derivedKey = deriveKeyPbkdf2(
        normalizedCode,
        saltBytes,
        iterations: airQrPbkdf2Iterations,
      );

      // Decrypt wire payload using AES-256-GCM
      // Payload format: base64(nonce(12) || ciphertext+tag(16))
      if (cipherStr == null || cipherStr.isEmpty) {
        return data.copyWith(
          error: const AppMessage(AppMessageKey.stegoWrongPassphrase),
        );
      }

      final rawBodyBytes = Uint8List.fromList(
        base64Url.decode(_repadBase64(cipherStr)),
      );
      final wireStr = utf8.decode(rawBodyBytes);

      // Decrypt wire line
      final rawDecoded = base64.decode(wireStr.trim());
      const nonceLen = 12;
      if (rawDecoded.length <= nonceLen) {
        return data.copyWith(
          error: const AppMessage(AppMessageKey.stegoWrongPassphrase),
        );
      }

      final nonce = rawDecoded.sublist(0, nonceLen);
      final body = rawDecoded.sublist(nonceLen);

      final encrypter = enc.Encrypter(
        enc.AES(enc.Key(derivedKey), mode: enc.AESMode.gcm),
      );

      final decryptedBytes = encrypter.decryptBytes(
        enc.Encrypted(body),
        iv: enc.IV(nonce),
      );

      final innerBase64 = utf8.decode(decryptedBytes);
      var innerBytes = Uint8List.fromList(base64.decode(innerBase64));

      // Decompress if gzipped
      if (data.isGzipped) {
        try {
          innerBytes = Uint8List.fromList(gzip.decode(innerBytes));
        } catch (_) {
          // Fall through if not gzip
        }
      }

      // Check SHA-256 digest if available
      if (data.digest != null && data.digest!.isNotEmpty) {
        final computedDigest = crypto.sha256.convert(innerBytes).toString();
        if (computedDigest != data.digest) {
          return data.copyWith(
            error: const AppMessage(AppMessageKey.airQrChecksumFailed),
          );
        }
      }

      final plainUtf8 = utf8.decode(innerBytes, allowMalformed: true);

      // Parse payload envelope if JSON
      String displayText = plainUtf8;
      String? fileName;
      String? mimeType;

      try {
        final parsedJson = jsonDecode(plainUtf8);
        if (parsedJson is Map<String, dynamic>) {
          if (parsedJson['content'] != null) {
            displayText = parsedJson['content'].toString();
          }
          fileName = parsedJson['name']?.toString();
          mimeType = parsedJson['mime']?.toString();
        }
      } catch (_) {
        // Plaintext payload
      }

      return data.copyWith(
        isUnlocked: true,
        decryptedPayload: displayText,
        fileName: fileName,
        mimeType: mimeType,
      );
    } catch (_) {
      return data.copyWith(
        error: const AppMessage(AppMessageKey.stegoWrongPassphrase),
      );
    }
  }

  EncryptedPayloadData _decryptStegoQr(
    EncryptedPayloadData data,
    String passphrase,
  ) {
    if (data.salt == null || data.iv == null || data.ciphertext == null) {
      return data.copyWith(
        error: const AppMessage(AppMessageKey.stegoWrongPassphrase),
      );
    }

    try {
      final saltBytes = base64.decode(data.salt!);
      final ivBytes = base64.decode(data.iv!);
      final derivedKeyBytes = deriveKeyPbkdf2(passphrase, saltBytes);

      final key = enc.Key(derivedKeyBytes);
      final ivObj = enc.IV(ivBytes);
      final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));

      final decryptedText = encrypter.decrypt(
        enc.Encrypted.fromBase64(data.ciphertext!),
        iv: ivObj,
      );

      return data.copyWith(isUnlocked: true, decryptedPayload: decryptedText);
    } catch (_) {
      return data.copyWith(
        error: const AppMessage(AppMessageKey.stegoWrongPassphrase),
      );
    }
  }

  EncryptedPayloadData _decryptJsonEnvelope(
    EncryptedPayloadData data,
    String passphrase,
  ) {
    if (data.ciphertext == null || data.iv == null) {
      return data.copyWith(
        error: const AppMessage(AppMessageKey.stegoWrongPassphrase),
      );
    }

    try {
      final ivBytes = _decodeFlexibleBase64(data.iv!);
      Uint8List keyBytes;

      if (data.salt != null && data.salt!.isNotEmpty) {
        final saltBytes = _decodeFlexibleBase64(data.salt!);
        keyBytes = deriveKeyPbkdf2(passphrase, saltBytes);
      } else {
        keyBytes = Uint8List.fromList(
          crypto.sha256.convert(utf8.encode(passphrase)).bytes,
        );
      }

      final key = enc.Key(keyBytes);
      final ivObj = enc.IV(ivBytes);

      // Try GCM if IV is 12 bytes, else CBC
      final mode = ivBytes.length == 12 ? enc.AESMode.gcm : enc.AESMode.cbc;
      final encrypter = enc.Encrypter(enc.AES(key, mode: mode));

      final decrypted = encrypter.decrypt(
        enc.Encrypted.fromBase64(_repadBase64(data.ciphertext!)),
        iv: ivObj,
      );

      return data.copyWith(isUnlocked: true, decryptedPayload: decrypted);
    } catch (_) {
      return data.copyWith(
        error: const AppMessage(AppMessageKey.stegoWrongPassphrase),
      );
    }
  }

  EncryptedPayloadData _decryptGeneric(
    EncryptedPayloadData data,
    String passphrase,
  ) {
    // Attempt manual decryption on raw text using SHA-256 derived key
    final result = decryptRaw(
      rawCipher: data.rawContent,
      passphrase: passphrase,
    );
    if (result != null) {
      return data.copyWith(isUnlocked: true, decryptedPayload: result);
    }
    return data.copyWith(
      error: const AppMessage(AppMessageKey.stegoWrongPassphrase),
    );
  }

  /// Manually decrypts raw ciphertext with customizable or auto-detected options.
  String? decryptRaw({
    required String rawCipher,
    required String passphrase,
    String? mode,
    String? salt,
    String? iv,
  }) {
    try {
      final trimmedCipher = rawCipher.trim();
      final keyHash = Uint8List.fromList(
        crypto.sha256.convert(utf8.encode(passphrase)).bytes,
      );

      // Mode: GCM or CBC
      if (mode == 'gcm' || mode == null) {
        try {
          final cipherBytes = _decodeFlexibleBase64(trimmedCipher);
          if (cipherBytes.length > 12) {
            final nonce = cipherBytes.sublist(0, 12);
            final body = cipherBytes.sublist(12);
            final encrypter = enc.Encrypter(
              enc.AES(enc.Key(keyHash), mode: enc.AESMode.gcm),
            );
            final decrypted = encrypter.decryptBytes(
              enc.Encrypted(body),
              iv: enc.IV(nonce),
            );
            return utf8.decode(decrypted);
          }
        } catch (_) {}
      }

      // Mode: CBC with optional IV or zero IV
      final ivBytes = iv != null
          ? _decodeFlexibleBase64(iv)
          : Uint8List(16); // 16-byte default IV
      final encrypter = enc.Encrypter(
        enc.AES(enc.Key(keyHash), mode: enc.AESMode.cbc),
      );
      final decrypted = encrypter.decrypt(
        enc.Encrypted.fromBase64(_repadBase64(trimmedCipher)),
        iv: enc.IV(ivBytes),
      );
      return decrypted;
    } catch (_) {
      return null;
    }
  }

  Uint8List _decodeFlexibleBase64(String input) {
    final repadded = _repadBase64(input.trim());
    try {
      return Uint8List.fromList(base64Url.decode(repadded));
    } catch (_) {
      return Uint8List.fromList(base64.decode(repadded));
    }
  }

  String _repadBase64(String s) {
    final remainder = s.length % 4;
    if (remainder == 0) return s;
    return s + ('=' * (4 - remainder));
  }
}
