import 'package:sreeraj_qr_reader/models/app_message.dart';

/// Raised when an encrypted backup file cannot be read.
///
/// Carries a message key rather than English text, so the screen decides the
/// wording. See the layer rules in `CLAUDE.md`.
class BackupException implements Exception {
  final AppMessage message;

  const BackupException(this.message);

  @override
  String toString() => 'BackupException(${message.key})';
}
