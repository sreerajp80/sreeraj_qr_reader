class SafetyCheckResult {
  final String checkName;
  final bool passed;
  final String message;

  const SafetyCheckResult({
    required this.checkName,
    required this.passed,
    required this.message,
  });
}
