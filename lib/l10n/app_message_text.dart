import 'package:sreeraj_qr_reader/l10n/gen/app_localizations.dart';
import 'package:sreeraj_qr_reader/models/app_message.dart';

/// Turns an [AppMessage] produced by a service into text the user can read.
///
/// This is the only place that joins message keys to words. Services return
/// keys; screens call this with the [AppLocalizations] from their context.
String appMessageText(AppLocalizations l10n, AppMessage message) {
  final args = message.args;

  switch (message.key) {
    // names of the link safety checks
    case AppMessageKey.checkNameHttps:
      return l10n.checkNameHttps;
    case AppMessageKey.checkNameSsl:
      return l10n.checkNameSsl;
    case AppMessageKey.checkNameRedirect:
      return l10n.checkNameRedirect;
    case AppMessageKey.checkNamePattern:
      return l10n.checkNamePattern;
    case AppMessageKey.checkNameShortener:
      return l10n.checkNameShortener;
    case AppMessageKey.checkNameHomograph:
      return l10n.checkNameHomograph;
    case AppMessageKey.checkNameMalicious:
      return l10n.checkNameMalicious;

    // HTTPS and certificate
    case AppMessageKey.httpsNotUsed:
      return l10n.httpsNotUsed;
    case AppMessageKey.sslPrivateModeOk:
      return l10n.sslPrivateModeOk;
    case AppMessageKey.sslValid:
      return l10n.sslValid;
    case AppMessageKey.sslExpired:
      return l10n.sslExpired;
    case AppMessageKey.sslNotYetValid:
      return l10n.sslNotYetValid;
    case AppMessageKey.sslUnverifiable:
      return l10n.sslUnverifiable;
    case AppMessageKey.sslCheckFailed:
      return l10n.sslCheckFailed;

    // redirects
    case AppMessageKey.redirectSkippedPrivate:
      return l10n.redirectSkippedPrivate;
    case AppMessageKey.redirectLoop:
      return l10n.redirectLoop;
    case AppMessageKey.redirectNone:
      return l10n.redirectNone;
    case AppMessageKey.redirectSuspiciousChain:
      return l10n.redirectSuspiciousChain(args['count'] ?? '');
    case AppMessageKey.redirectWithinRange:
      return l10n.redirectWithinRange(args['count'] ?? '');
    case AppMessageKey.redirectUnavailable:
      return l10n.redirectUnavailable;

    // suspicious patterns
    case AppMessageKey.patternNone:
      return l10n.patternNone;
    case AppMessageKey.patternDetected:
      return l10n.patternDetected(args['patterns'] ?? '');
    case AppMessageKey.patternUnavailable:
      return l10n.patternUnavailable;

    // URL shorteners
    case AppMessageKey.shortenerKnown:
      return l10n.shortenerKnown(args['shortener'] ?? '');
    case AppMessageKey.shortenerRedirect:
      return l10n.shortenerRedirect(args['host'] ?? '');
    case AppMessageKey.shortenerPossible:
      return l10n.shortenerPossible(args['reason'] ?? '');
    case AppMessageKey.shortenerOfflineHeuristics:
      return l10n.shortenerOfflineHeuristics;
    case AppMessageKey.shortenerNone:
      return l10n.shortenerNone;
    case AppMessageKey.shortenerUnavailable:
      return l10n.shortenerUnavailable;

    // lookalike characters
    case AppMessageKey.homographLookalikes:
      return l10n.homographLookalikes(args['characters'] ?? '');
    case AppMessageKey.homographMixedScripts:
      return l10n.homographMixedScripts;
    case AppMessageKey.homographNone:
      return l10n.homographNone;
    case AppMessageKey.homographUnavailable:
      return l10n.homographUnavailable;

    // Google Safe Browsing
    case AppMessageKey.maliciousSkippedNoKey:
      return l10n.maliciousSkippedNoKey;
    case AppMessageKey.maliciousDailyLimit:
      return l10n.maliciousDailyLimit;
    case AppMessageKey.maliciousThreats:
      return l10n.maliciousThreats(args['threats'] ?? '');
    case AppMessageKey.maliciousNone:
      return l10n.maliciousNone;
    case AppMessageKey.maliciousInvalidKey:
      return l10n.maliciousInvalidKey;
    case AppMessageKey.maliciousRateLimited:
      return l10n.maliciousRateLimited;
    case AppMessageKey.maliciousApiError:
      return l10n.maliciousApiError(args['status'] ?? '');
    case AppMessageKey.maliciousUnavailable:
      return l10n.maliciousUnavailable;

    // printed-code tamper check
    case AppMessageKey.quishingAuthentic:
      return l10n.quishingAuthentic;
    case AppMessageKey.quishingWearAndTear:
      return l10n.quishingWearAndTear;
    case AppMessageKey.quishingHighWarning:
      return l10n.quishingHighWarning;
    case AppMessageKey.quishingSignalConsistentDots:
      return l10n.quishingSignalConsistentDots;
    case AppMessageKey.quishingSignalConsistentPerimeter:
      return l10n.quishingSignalConsistentPerimeter;
    case AppMessageKey.quishingSignalEdgeDoubling:
      return l10n.quishingSignalEdgeDoubling;
    case AppMessageKey.quishingSignalOverlaySticker:
      return l10n.quishingSignalOverlaySticker;
    case AppMessageKey.quishingSignalPrintMismatch:
      return l10n.quishingSignalPrintMismatch;
    case AppMessageKey.quishingSignalGlareShift:
      return l10n.quishingSignalGlareShift;

    // sandboxed page preview
    case AppMessageKey.domStatusOk:
      return l10n.domStatusOk;
    case AppMessageKey.domStatusBlocked:
      return l10n.domStatusBlocked;
    case AppMessageKey.domStatusUnreachable:
      return l10n.domStatusUnreachable;
    case AppMessageKey.domSslValid:
      return l10n.domSslValid;
    case AppMessageKey.domSslInvalid:
      return l10n.domSslInvalid;
    case AppMessageKey.domSslUnknown:
      return l10n.domSslUnknown;

    // hidden encrypted payload
    case AppMessageKey.stegoWrongPassphrase:
      return l10n.stegoWrongPassphrase;
    case AppMessageKey.stegoCorruptData:
      return l10n.stegoCorruptData;
    case AppMessageKey.stegoChecksumFailed:
      return l10n.stegoChecksumFailed;
    case AppMessageKey.stegoBiometricFailed:
      return l10n.stegoBiometricFailed;

    // optical stream transfer
    case AppMessageKey.airQrChecksumFailed:
      return l10n.airQrChecksumFailed;
    case AppMessageKey.airQrIncompleteStream:
      return l10n.airQrIncompleteStream;

    // reading codes from pictures and PDFs
    case AppMessageKey.mediaNoCodeFound:
      return l10n.mediaNoCodeFound;
    case AppMessageKey.mediaUnreadableFile:
      return l10n.mediaUnreadableFile;
    case AppMessageKey.mediaPdfNoPages:
      return l10n.mediaPdfNoPages;
    case AppMessageKey.mediaPermissionDenied:
      return l10n.mediaPermissionDenied;
  }
}
