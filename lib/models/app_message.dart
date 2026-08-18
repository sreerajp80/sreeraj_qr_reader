/// Identifies one piece of user-visible text produced by a service or provider.
///
/// Services must not hold English text (see the layer rules in `CLAUDE.md`), so
/// they return an [AppMessage] carrying one of these keys instead. The screen
/// turns the key into words through `AppLocalizations`, using
/// `appMessageText` in `lib/l10n/app_message_text.dart`.
enum AppMessageKey {
  // --- names of the link safety checks ---
  checkNameHttps,
  checkNameSsl,
  checkNameRedirect,
  checkNamePattern,
  checkNameShortener,
  checkNameHomograph,
  checkNameMalicious,

  // --- HTTPS / certificate ---
  httpsNotUsed,
  sslPrivateModeOk,
  sslValid,
  sslExpired,
  sslNotYetValid,
  sslUnverifiable,
  sslCheckFailed,

  // --- redirects ---
  redirectSkippedPrivate,
  redirectLoop,
  redirectNone,
  redirectSuspiciousChain,
  redirectWithinRange,
  redirectUnavailable,

  // --- suspicious patterns ---
  patternNone,
  patternDetected,
  patternUnavailable,

  // --- URL shorteners ---
  shortenerKnown,
  shortenerRedirect,
  shortenerPossible,
  shortenerOfflineHeuristics,
  shortenerNone,
  shortenerUnavailable,

  // --- homograph / lookalike characters ---
  homographLookalikes,
  homographMixedScripts,
  homographNone,
  homographUnavailable,

  // --- Google Safe Browsing ---
  maliciousSkippedNoKey,
  maliciousDailyLimit,
  maliciousThreats,
  maliciousNone,
  maliciousInvalidKey,
  maliciousRateLimited,
  maliciousApiError,
  maliciousUnavailable,

  // --- printed-code tamper check: summaries and status labels ---
  quishingSummaryAuthentic,
  quishingSummaryWearAndTear,
  quishingSummaryHighWarning,
  quishingStatusAuthentic,
  quishingStatusWearAndTear,
  quishingStatusHighWarning,

  // --- printed-code tamper check: individual findings ---
  quishingSignalPerimeterDoubleEdge,
  quishingSignalMicroShadowPerimeter,
  quishingSignalDotDensityVariance,
  quishingSignalGrainAberration,
  quishingSignalUniformReflection,
  quishingSignalConsistentDotsQrMatrix,
  quishingSignalReflectionVerified,
  quishingSignalHalftoneConsistentQrMatrix,
  quishingSignalHalftoneConsistentMatrix,
  quishingSignalDoubleEdgeAroundMatrix,
  quishingSignalMicroShadowStickerBorder,
  quishingSignalGrainMismatchBase,
  quishingSignalMinorScratch,
  quishingSignalSlightDotIrregularity,
  quishingSignalConsistentDotsMatrixPerimeter,

  // --- sandboxed page preview ---
  domSslInvalidScheme,
  domSslHttps,
  domSslHttp,
  domStatusInvalidUrl,
  domStatusOpenRedirect,
  domStatusHttpCaution,
  domStatusNewDomain,
  domStatusSafe,

  // --- hidden encrypted payload ---
  stegoPassphraseEmpty,
  stegoWrongPassphrase,
  stegoBiometricCanceled,

  // --- optical stream transfer ---
  airQrChecksumFailed,

  // --- names for the kind of code seen in the AR view ---
  formatQrUrl,
  formatQrEmail,
  formatQrPhone,
  formatQrSms,
  formatQrWifi,
  formatQrLocation,
  formatQrContact,
  formatIsbn,
  formatEanUpc,
  formatQrCode,
  formatEanUpcProduct,
  formatBarcode,

  // --- reading codes from pictures and PDFs ---
  mediaImagePickFailed,
  mediaNoCodeInImage,
  mediaImageAnalyzeFailed,
  mediaPdfPickFailed,
  mediaNoCodeInPdf,
  mediaPdfScanFailed,
}

/// One user-visible message, named by [key], plus any values it carries.
///
/// [args] holds already-formatted values such as a host name or a count. The
/// screen passes them straight into the matching ARB placeholder.
class AppMessage {
  final AppMessageKey key;
  final Map<String, String> args;

  const AppMessage(this.key, {this.args = const <String, String>{}});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AppMessage) return false;
    if (other.key != key || other.args.length != args.length) return false;
    for (final entry in args.entries) {
      if (other.args[entry.key] != entry.value) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
    key,
    Object.hashAllUnordered(
      args.entries.map((e) => Object.hash(e.key, e.value)),
    ),
  );

  @override
  String toString() =>
      args.isEmpty ? 'AppMessage($key)' : 'AppMessage($key, $args)';
}
