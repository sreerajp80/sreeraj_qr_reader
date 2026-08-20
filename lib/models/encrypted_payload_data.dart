import 'package:flutter/foundation.dart';
import 'package:sreeraj_qr_reader/models/app_message.dart';

/// The kind of encrypted container detected in the QR or barcode payload.
enum EncryptedContainerType {
  /// AirQR optical transfer frame (`textdataqr://`)
  airQr,

  /// Dual-layer StegoQR payload (`STEGOQR:v1:` or `--STEGOQR--`)
  stegoQr,

  /// Standard JSON Crypto container (`{"iv":..., "ciphertext":...}`)
  jsonEnvelope,

  /// PGP / ASCII-armored block (`-----BEGIN PGP MESSAGE-----`)
  pgp,

  /// Custom or raw ciphertext
  custom,
}

/// Immutable data model holding parsed encrypted container properties and decrypted payload state.
@immutable
class EncryptedPayloadData {
  final EncryptedContainerType containerType;
  final String rawContent;
  final String publicDisplay;
  final String? fileName;
  final String? mimeType;
  final String? salt;
  final String? iv;
  final String? ciphertext;
  final String? digest;
  final bool isGzipped;
  final int totalFrames;
  final int frameIndex;
  final bool isUnlocked;
  final String? decryptedPayload;
  final AppMessage? error;

  const EncryptedPayloadData({
    required this.containerType,
    required this.rawContent,
    required this.publicDisplay,
    this.fileName,
    this.mimeType,
    this.salt,
    this.iv,
    this.ciphertext,
    this.digest,
    this.isGzipped = false,
    this.totalFrames = 1,
    this.frameIndex = 0,
    this.isUnlocked = false,
    this.decryptedPayload,
    this.error,
  });

  EncryptedPayloadData copyWith({
    EncryptedContainerType? containerType,
    String? rawContent,
    String? publicDisplay,
    String? fileName,
    String? mimeType,
    String? salt,
    String? iv,
    String? ciphertext,
    String? digest,
    bool? isGzipped,
    int? totalFrames,
    int? frameIndex,
    bool? isUnlocked,
    String? decryptedPayload,
    AppMessage? error,
  }) {
    return EncryptedPayloadData(
      containerType: containerType ?? this.containerType,
      rawContent: rawContent ?? this.rawContent,
      publicDisplay: publicDisplay ?? this.publicDisplay,
      fileName: fileName ?? this.fileName,
      mimeType: mimeType ?? this.mimeType,
      salt: salt ?? this.salt,
      iv: iv ?? this.iv,
      ciphertext: ciphertext ?? this.ciphertext,
      digest: digest ?? this.digest,
      isGzipped: isGzipped ?? this.isGzipped,
      totalFrames: totalFrames ?? this.totalFrames,
      frameIndex: frameIndex ?? this.frameIndex,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      decryptedPayload: decryptedPayload ?? this.decryptedPayload,
      error: error ?? this.error,
    );
  }
}
