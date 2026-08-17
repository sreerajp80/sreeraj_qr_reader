// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Sreeraj P QR Reader';

  @override
  String get wifiCardTitle => 'Wi-Fi Network';

  @override
  String get wifiShowPassword => 'Show Password';

  @override
  String get wifiHidePassword => 'Hide Password';

  @override
  String get wifiCopyPassword => 'Copy Password';

  @override
  String get wifiConnectButton => 'Connect to Wi-Fi';

  @override
  String get wifiPasswordCopied => 'Password copied to clipboard';

  @override
  String get wifiOpenSettingsHint =>
      'Password copied. Open Wi-Fi Settings on your device to connect.';

  @override
  String geoLatLng(String latitude, String longitude) {
    return 'Lat: $latitude, Lng: $longitude';
  }

  @override
  String geoQuery(String query) {
    return 'Query: $query';
  }

  @override
  String get geoNavigateButton => 'Navigate in Google Maps';

  @override
  String get geoLaunchFailed => 'Could not launch Google Maps app';

  @override
  String get calendarCardTitle => 'Calendar Event';

  @override
  String get calendarNoDate => 'N/A';

  @override
  String calendarStart(String dateTime) {
    return 'Start: $dateTime';
  }

  @override
  String calendarEnd(String dateTime) {
    return 'End:   $dateTime';
  }

  @override
  String get calendarAddButton => 'Add to Device Calendar';

  @override
  String get calendarLaunchFailed => 'Could not open Calendar app';

  @override
  String get contactCardTitle => 'Contact Card';

  @override
  String get contactInitialFallback => 'C';

  @override
  String get contactSaveButton => 'Save to Contacts';

  @override
  String get contactLaunchFailed => 'Could not open Contacts app';

  @override
  String contactCallFailed(String number) {
    return 'Could not place call to $number';
  }

  @override
  String contactEmailFailed(String email) {
    return 'Could not open email app for $email';
  }

  @override
  String pdfResultsTitle(int count) {
    return 'PDF Scan Results ($count)';
  }

  @override
  String pdfPageBadge(int page) {
    return 'P$page';
  }

  @override
  String pdfPageLabel(int page) {
    return 'Page $page';
  }

  @override
  String pdfSaveAllButton(int count) {
    return 'Save All ($count) to History';
  }

  @override
  String pdfScanNote(int page) {
    return 'Scanned from PDF (Page $page)';
  }

  @override
  String pdfSavedToHistory(int count) {
    return 'Saved $count codes to history.';
  }

  @override
  String get totpDefaultIssuer => '2FA Authenticator';

  @override
  String totpLivePasscode(int period) {
    return 'Live Passcode (${period}s TOTP)';
  }

  @override
  String totpSecondsLeft(int seconds) {
    return '${seconds}s';
  }

  @override
  String get totpCopyToken => 'Copy Token';

  @override
  String get totpSecretLabel => 'Secret: ';

  @override
  String get totpImportButton => 'Import into Authenticator App';

  @override
  String get totpLaunchFailed => 'Could not open Authenticator app';

  @override
  String get totpTokenCopied => 'TOTP token copied to clipboard';

  @override
  String get totpSecretCopied => 'Secret key copied to clipboard';

  @override
  String get paymentSchemeUpi => 'UPI Payment';

  @override
  String get paymentSchemeSepa => 'SEPA Transfer';

  @override
  String get paymentSchemeCrypto => 'Crypto Payment';

  @override
  String get paymentPayeeFallback => 'Merchant / Payee';

  @override
  String get paymentAddressLabelUpi => 'VPA / UPI ID:';

  @override
  String get paymentAddressLabelSepa => 'IBAN:';

  @override
  String get paymentAddressLabelCrypto => 'Wallet Address:';

  @override
  String get paymentCopyAction => 'Copy';

  @override
  String get paymentUpiIdCopied => 'UPI ID copied to clipboard';

  @override
  String get paymentAddressCopied => 'Address copied to clipboard';

  @override
  String paymentNote(String note) {
    return 'Note: $note';
  }

  @override
  String get paymentPayButtonUpi => 'Pay via App (GPay / PhonePe / Paytm)';

  @override
  String get paymentPayButton => 'Pay via App';

  @override
  String get paymentUpiLaunchFailed =>
      'Could not open UPI app. Make sure GPay, PhonePe, or Paytm is installed.';

  @override
  String get paymentLaunchFailed =>
      'Could not open payment app for this scheme.';

  @override
  String get paymentCopyIdAction => 'Copy ID';

  @override
  String percentValue(String value) {
    return '$value%';
  }

  @override
  String get quishingGuardTitle => 'QuishingGuard™';

  @override
  String get quishingTamperBadge => 'Physical Tamper CV';

  @override
  String get quishingRiskScoreLabel => 'Tamper Risk Score:';

  @override
  String get quishingViewSignals => 'View Forensic Analysis';

  @override
  String get quishingHideSignals => 'Hide Forensic Signals';

  @override
  String get quishingMetricEdgeLabel => 'Edge Discontinuity';

  @override
  String get quishingMetricEdgeDescription => 'Double edges & shadow lines';

  @override
  String get quishingMetricGrainLabel => 'Print Grain & DPI';

  @override
  String get quishingMetricGrainDescription => 'Halftone dot & chromatic noise';

  @override
  String get quishingSignalsHeading => 'Detected Computer Vision Signals:';

  @override
  String get arCloseSheet => 'Close Sheet';

  @override
  String arItemPriceTag(String price) {
    return 'Item Price Tag: $price';
  }

  @override
  String get arContentCopied => 'Copied content to clipboard';

  @override
  String get arCopyButton => 'Copy';

  @override
  String get arOpenUrlButton => 'Open URL';

  @override
  String get arSelectButton => 'Select Item';

  @override
  String get arDeselectButton => 'Deselect';

  @override
  String get arSafetyStatusSafe => 'Safety Status: Verified Safe';

  @override
  String get arSafetyStatusWarning =>
      'Safety Status: Warning / Phishing Suspicion';

  @override
  String get arSafetyStatusUnknown => 'Safety Status: Analyzing link safety...';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String historyTimestamp(String date, String time) {
    return '$date • $time';
  }

  @override
  String get historyStar => 'Star favorite';

  @override
  String get historyUnstar => 'Unstar';

  @override
  String get historyEditNotes => 'Edit Notes';

  @override
  String get historyCopyString => 'Copy String';

  @override
  String get historyShare => 'Share';

  @override
  String get historyDelete => 'Delete';

  @override
  String get historyDetailTitle => 'Scan Record Details';

  @override
  String historySafetyBadge(int score) {
    return '🛡️ $score% Safe';
  }

  @override
  String historyScoreBadge(int score) {
    return '🛡️ $score%';
  }

  @override
  String get historyScannedContent => 'Scanned Content:';

  @override
  String get historyCopyButton => 'Copy';

  @override
  String get historyNotesLabel => 'Custom User Notes';

  @override
  String get historyNotesHint =>
      'Add personal notes or remarks about this scan...';

  @override
  String get historyLocationLabel => 'Location Tag (Optional)';

  @override
  String get historyLocationHint =>
      'e.g. Office Desk, Grocery Store, Conference';

  @override
  String get historySaveChanges => 'Save Metadata Changes';

  @override
  String get closeButton => 'Close';

  @override
  String get exportDialogTitle => 'Export & Cloud Backup';

  @override
  String get restoreDialogTitle => 'Restore Encrypted Backup';

  @override
  String get exportRecordsTab => 'Export Records';

  @override
  String get restoreBackupTab => 'Restore Backup';

  @override
  String get exportFormatHeading => 'Select Export Format:';

  @override
  String get exportCsvTitle => 'CSV Format (.csv)';

  @override
  String get exportCsvSubtitle => 'Compatible with Excel and Sheets';

  @override
  String get exportJsonTitle => 'JSON Dataset (.json)';

  @override
  String get exportJsonSubtitle => 'Structured developer format';

  @override
  String get exportTxtTitle => 'Formatted TXT Report (.txt)';

  @override
  String get exportTxtSubtitle => 'Human readable summary document';

  @override
  String get exportPdfTitle => 'PDF Document Report (.pdf)';

  @override
  String get exportPdfSubtitle => 'Formatted printable report table';

  @override
  String get exportBackupHeading => 'Encrypted Local Backup File (.sreerajqr)';

  @override
  String get exportPassphraseLabel => 'Backup Encryption Passphrase';

  @override
  String get exportPassphraseHint => 'Enter secret passphrase...';

  @override
  String get exportPassphraseRequired =>
      'Please enter a password to encrypt your backup file.';

  @override
  String get exportCreateBackupButton => 'Create Encrypted Backup File';

  @override
  String get exportShareText => 'Sreeraj QR Reader Scan History Export';

  @override
  String get exportSharePdfText =>
      'Sreeraj QR Reader Scan History Report (PDF)';

  @override
  String get exportShareBackupText => 'Sreeraj QR Reader Encrypted Backup File';

  @override
  String get restoreHeading => 'Restore History from Encrypted Backup File:';

  @override
  String get restorePassphraseLabel => 'Backup Decryption Passphrase';

  @override
  String get restorePayloadLabel => 'Encrypted Backup Payload (.sreerajqr)';

  @override
  String get restorePayloadHint => 'Paste backup JSON payload string here...';

  @override
  String get restoreFieldsRequired =>
      'Please provide both the password and backup content.';

  @override
  String get restoreButton => 'Decrypt & Restore History';

  @override
  String restoreSuccess(int count) {
    return 'Successfully restored $count scan records!';
  }

  @override
  String restoreFailed(String reason) {
    return 'Restore failed: $reason';
  }

  @override
  String get domSandboxedBadge => 'SANDBOXED';

  @override
  String get domTitleInitialFallback => 'W';

  @override
  String get domUntitledPage => 'Untitled Web Page';

  @override
  String get domThumbnailCaption =>
      'Visual Thumbnail Pre-Render (Script Execution Blocked)';

  @override
  String domBlockedBadge(int scripts, int trackers) {
    return 'Blocked: $scripts Scripts, $trackers Trackers';
  }

  @override
  String domNewlyRegistered(int days) {
    return 'Newly Registered (${days}d)';
  }

  @override
  String domDomainAge(int days) {
    return 'Domain Age: $days days';
  }

  @override
  String get domOpenRedirectFound => 'Open Redirect Trap!';

  @override
  String get domNoOpenRedirect => 'No Open Redirects';

  @override
  String get domInspectButton => 'Inspect DOM Sandbox Structure';

  @override
  String get domInspectTitle => 'Zero-Trust DOM Sandbox Hierarchy';

  @override
  String get domDetailPageTitle => 'Page Title';

  @override
  String get domDetailNotSpecified => 'Not specified';

  @override
  String get domDetailMetaDescription => 'Meta Description';

  @override
  String get domDetailNoneFound => 'None found';

  @override
  String get domDetailHeadingsCount => 'Headings Count';

  @override
  String domDetailHeadingsValue(int count) {
    return '$count headings extracted';
  }

  @override
  String get domDetailLinksFound => 'Links Found';

  @override
  String domDetailLinksValue(int count) {
    return '$count URLs extracted';
  }

  @override
  String get domDetailBlockedScripts => 'Blocked Scripts';

  @override
  String domDetailBlockedScriptsValue(int count) {
    return '$count executable script tags/events stripped';
  }

  @override
  String get domDetailBlockedTrackers => 'Blocked Trackers';

  @override
  String domDetailBlockedTrackersValue(int count) {
    return '$count tracking pixels stripped';
  }

  @override
  String get domDetailBlockedIframes => 'Blocked Iframes';

  @override
  String domDetailBlockedIframesValue(int count) {
    return '$count iframe/embed elements removed';
  }

  @override
  String get domSanitizedSnippetHeading => 'Sanitized HTML Preview Snippet:';

  @override
  String get aboutTitle => 'About';

  @override
  String aboutVersion(String version, String build) {
    return 'Version $version+$build';
  }

  @override
  String get aboutMadeWithLove => 'Made with ❤️ from India';

  @override
  String get airQrTransmitterTitle => 'AirQR Stream Transmitter';

  @override
  String get airQrSamplePayload =>
      'AirQR High-Speed Optical Air-Gap Transfer Test Payload. This payload is encoded into 256-byte chunks with Fountain FEC error correction.';

  @override
  String get airQrPayloadLabel => 'Payload Data to Broadcast';

  @override
  String get airQrPayloadHint => 'Enter text, contact, or file payload...';

  @override
  String get airQrStreamSpeed => 'Stream Speed:';

  @override
  String airQrFps(int fps) {
    return '$fps FPS';
  }

  @override
  String get airQrStartStream => 'Broadcast Optical Stream';

  @override
  String get airQrStopStream => 'Stop Optical Stream';

  @override
  String airQrFrameParity(int current, int total) {
    return 'Frame $current/$total [Fountain PARITY]';
  }

  @override
  String airQrFrameBlock(int current, int total, int block) {
    return 'Frame $current/$total [Block $block]';
  }

  @override
  String airQrTotalFrames(int total, int source, int parity) {
    return 'Total Stream Frames: $total ($source Source + $parity Fountain FEC)';
  }

  @override
  String get toggleFlashlight => 'Toggle Flashlight';

  @override
  String get grantCameraPermission => 'Grant Camera Permission';

  @override
  String get arScreenTitle => 'AR CodeVision HUD';

  @override
  String get arInitializing => 'Initializing AR HUD Viewport...';

  @override
  String get arClearSelection => 'Clear';

  @override
  String get arBatchCopy => 'Batch Copy';

  @override
  String arBatchCopied(int count) {
    return 'Copied $count barcodes to clipboard';
  }

  @override
  String get arCameraPermissionMessage =>
      'Camera permission is required for AR CodeVision';

  @override
  String get doneButton => 'Done';

  @override
  String get airQrReceiverTitle => 'AirQR Stream Receiver';

  @override
  String get airQrTransmitterTooltip => 'AirQR Transmitter';

  @override
  String get airQrResetStream => 'Reset Stream';

  @override
  String get airQrInitializing => 'Initializing AirQR Stream Receiver...';

  @override
  String get airQrStatusReassembled => 'STREAM REASSEMBLED';

  @override
  String get airQrStatusCapturing => 'CAPTURING OPTICAL STREAM...';

  @override
  String get airQrStatusIdle => 'POINT AT ANIMATED QR STREAM';

  @override
  String airQrCaptured(int received, int total) {
    return 'Captured: $received / $total Blocks';
  }

  @override
  String airQrMissing(int count) {
    return 'Missing: $count';
  }

  @override
  String get airQrTransferComplete => 'Air-Gap Transfer Complete!';

  @override
  String get airQrTransferCompleteDetail =>
      'Payload reassembled and verified offline via Fountain error correction.';

  @override
  String get airQrPayloadCopied => 'Copied payload to clipboard';
}
