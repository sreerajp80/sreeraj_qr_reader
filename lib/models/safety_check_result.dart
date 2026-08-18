import 'package:sreeraj_qr_reader/models/app_message.dart';

/// Outcome of one link safety check.
///
/// [checkName] and [message] carry message keys, not English text, so the
/// service layer stays free of UI strings. The screen turns them into words
/// with `appMessageText`.
class SafetyCheckResult {
  final AppMessage checkName;
  final bool passed;
  final AppMessage message;

  const SafetyCheckResult({
    required this.checkName,
    required this.passed,
    required this.message,
  });
}
