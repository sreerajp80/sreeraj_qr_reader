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
    case AppMessageKey.quishingSummaryAuthentic:
      return l10n.quishingSummaryAuthentic;
    case AppMessageKey.quishingSummaryWearAndTear:
      return l10n.quishingSummaryWearAndTear;
    case AppMessageKey.quishingSummaryHighWarning:
      return l10n.quishingSummaryHighWarning;
    case AppMessageKey.quishingStatusAuthentic:
      return l10n.quishingStatusAuthentic;
    case AppMessageKey.quishingStatusWearAndTear:
      return l10n.quishingStatusWearAndTear;
    case AppMessageKey.quishingStatusHighWarning:
      return l10n.quishingStatusHighWarning;
    case AppMessageKey.quishingSignalPerimeterDoubleEdge:
      return l10n.quishingSignalPerimeterDoubleEdge(args['zones'] ?? '');
    case AppMessageKey.quishingSignalMicroShadowPerimeter:
      return l10n.quishingSignalMicroShadowPerimeter;
    case AppMessageKey.quishingSignalDotDensityVariance:
      return l10n.quishingSignalDotDensityVariance(args['variance'] ?? '');
    case AppMessageKey.quishingSignalGrainAberration:
      return l10n.quishingSignalGrainAberration;
    case AppMessageKey.quishingSignalUniformReflection:
      return l10n.quishingSignalUniformReflection;
    case AppMessageKey.quishingSignalConsistentDotsQrMatrix:
      return l10n.quishingSignalConsistentDotsQrMatrix;
    case AppMessageKey.quishingSignalReflectionVerified:
      return l10n.quishingSignalReflectionVerified;
    case AppMessageKey.quishingSignalHalftoneConsistentQrMatrix:
      return l10n.quishingSignalHalftoneConsistentQrMatrix;
    case AppMessageKey.quishingSignalHalftoneConsistentMatrix:
      return l10n.quishingSignalHalftoneConsistentMatrix;
    case AppMessageKey.quishingSignalDoubleEdgeAroundMatrix:
      return l10n.quishingSignalDoubleEdgeAroundMatrix;
    case AppMessageKey.quishingSignalMicroShadowStickerBorder:
      return l10n.quishingSignalMicroShadowStickerBorder;
    case AppMessageKey.quishingSignalGrainMismatchBase:
      return l10n.quishingSignalGrainMismatchBase;
    case AppMessageKey.quishingSignalMinorScratch:
      return l10n.quishingSignalMinorScratch;
    case AppMessageKey.quishingSignalSlightDotIrregularity:
      return l10n.quishingSignalSlightDotIrregularity;
    case AppMessageKey.quishingSignalConsistentDotsMatrixPerimeter:
      return l10n.quishingSignalConsistentDotsMatrixPerimeter;

    // sandboxed page preview
    case AppMessageKey.domSslInvalidScheme:
      return l10n.domSslInvalidScheme;
    case AppMessageKey.domSslHttps:
      return l10n.domSslHttps;
    case AppMessageKey.domSslHttp:
      return l10n.domSslHttp;
    case AppMessageKey.domStatusInvalidUrl:
      return l10n.domStatusInvalidUrl;
    case AppMessageKey.domStatusOpenRedirect:
      return l10n.domStatusOpenRedirect(args['target'] ?? '');
    case AppMessageKey.domStatusHttpCaution:
      return l10n.domStatusHttpCaution;
    case AppMessageKey.domStatusNewDomain:
      return l10n.domStatusNewDomain(args['days'] ?? '');
    case AppMessageKey.domStatusSafe:
      return l10n.domStatusSafe;

    // hidden encrypted payload
    case AppMessageKey.stegoPassphraseEmpty:
      return l10n.stegoPassphraseEmpty;
    case AppMessageKey.stegoWrongPassphrase:
      return l10n.stegoWrongPassphrase;
    case AppMessageKey.stegoBiometricCanceled:
      return l10n.stegoBiometricCanceled;

    // optical stream transfer
    case AppMessageKey.airQrChecksumFailed:
      return l10n.airQrChecksumFailed;

    // encrypted backup files
    case AppMessageKey.backupInvalidFormat:
      return l10n.backupInvalidFormat;
    case AppMessageKey.backupBadHeader:
      return l10n.backupBadHeader;
    case AppMessageKey.backupWrongPassphrase:
      return l10n.backupWrongPassphrase;

    // names for the kind of code seen in the AR view
    case AppMessageKey.formatQrUrl:
      return l10n.formatQrUrl;
    case AppMessageKey.formatQrEmail:
      return l10n.formatQrEmail;
    case AppMessageKey.formatQrPhone:
      return l10n.formatQrPhone;
    case AppMessageKey.formatQrSms:
      return l10n.formatQrSms;
    case AppMessageKey.formatQrWifi:
      return l10n.formatQrWifi;
    case AppMessageKey.formatQrLocation:
      return l10n.formatQrLocation;
    case AppMessageKey.formatQrContact:
      return l10n.formatQrContact;
    case AppMessageKey.formatIsbn:
      return l10n.formatIsbn;
    case AppMessageKey.formatEanUpc:
      return l10n.formatEanUpc;
    case AppMessageKey.formatQrCode:
      return l10n.formatQrCode;
    case AppMessageKey.formatEanUpcProduct:
      return l10n.formatEanUpcProduct;
    case AppMessageKey.formatBarcode:
      return l10n.formatBarcode;

    // reading codes from pictures and PDFs
    case AppMessageKey.mediaImagePickFailed:
      return l10n.mediaImagePickFailed(args['error'] ?? '');
    case AppMessageKey.mediaNoCodeInImage:
      return l10n.mediaNoCodeInImage;
    case AppMessageKey.mediaImageAnalyzeFailed:
      return l10n.mediaImageAnalyzeFailed(args['error'] ?? '');
    case AppMessageKey.mediaPdfPickFailed:
      return l10n.mediaPdfPickFailed(args['error'] ?? '');
    case AppMessageKey.mediaNoCodeInPdf:
      return l10n.mediaNoCodeInPdf;
    case AppMessageKey.mediaPdfScanFailed:
      return l10n.mediaPdfScanFailed(args['error'] ?? '');
  }
}
