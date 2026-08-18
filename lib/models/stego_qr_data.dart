import 'package:sreeraj_qr_reader/models/app_message.dart';

class StegoQrData {
  final String decoyText;
  final String version;
  final String salt;
  final String iv;
  final String ciphertext;
  final bool isUnlocked;
  final String? decryptedPayload;
  final AppMessage? error;

  const StegoQrData({
    required this.decoyText,
    required this.version,
    required this.salt,
    required this.iv,
    required this.ciphertext,
    this.isUnlocked = false,
    this.decryptedPayload,
    this.error,
  });

  StegoQrData copyWith({
    String? decoyText,
    String? version,
    String? salt,
    String? iv,
    String? ciphertext,
    bool? isUnlocked,
    String? decryptedPayload,
    AppMessage? error,
  }) {
    return StegoQrData(
      decoyText: decoyText ?? this.decoyText,
      version: version ?? this.version,
      salt: salt ?? this.salt,
      iv: iv ?? this.iv,
      ciphertext: ciphertext ?? this.ciphertext,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      decryptedPayload: decryptedPayload ?? this.decryptedPayload,
      error: error ?? this.error,
    );
  }
}
