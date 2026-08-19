// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SreerajP QR Reader';

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

  @override
  String get cancelButton => 'Cancel';

  @override
  String get historyScreenTitle => 'Scan History';

  @override
  String get historyExportTooltip => 'Export / Backup';

  @override
  String get historyClearAll => 'Clear All';

  @override
  String get historyClearTitle => 'Clear Scan History?';

  @override
  String get historyClearMessage =>
      'Are you sure you want to delete all persistent scan history? This action cannot be undone unless you have created a backup.';

  @override
  String get historySearchHint => 'Search history (content, format, notes)...';

  @override
  String get historyFilterAll => 'All';

  @override
  String get historyFilterStarred => 'Starred';

  @override
  String get historyFilterUrls => 'URLs';

  @override
  String get historyFilterWifi => 'Wi-Fi';

  @override
  String get historyFilterContacts => 'Contacts';

  @override
  String get historyFilterText => 'Text';

  @override
  String get historyFilterBarcodes => 'Barcodes';

  @override
  String get historyEmptyTitle => 'No Scan Records Found';

  @override
  String get historyEmptyMessage =>
      'Scanned barcodes will automatically appear here.';

  @override
  String historyNoMatches(String query) {
    return 'No matches for \"$query\"';
  }

  @override
  String get moreOptions => 'More options';

  @override
  String get menuHistory => 'History';

  @override
  String get menuSettings => 'Settings';

  @override
  String get grantPermission => 'Grant Permission';

  @override
  String get scanFromGallery => 'Scan Image from Gallery';

  @override
  String get scanPdfDocument => 'Scan PDF Document';

  @override
  String get scanPdfProgress => 'Extracting & scanning PDF pages...';

  @override
  String get scanSharedPdfProgress => 'Scanning shared PDF document...';

  @override
  String get scanInitializingCamera => 'Initializing camera...';

  @override
  String get scanInitializingFeed => 'Initializing camera feed...';

  @override
  String get scanTorchTooltip => 'Flashlight / Torch';

  @override
  String get scanZoomTooltip => 'Zoom slider';

  @override
  String get scanFlipCameraTooltip => 'Flip Camera (Front/Back)';

  @override
  String scanZoomValue(String value) {
    return '${value}x';
  }

  @override
  String get scanViewfinderHint =>
      'Position QR code or barcode within the frame';

  @override
  String get scanCameraPermissionRequired => 'Camera permission required';

  @override
  String get copiedLabel => 'Copied!';

  @override
  String get hideAction => 'Hide';

  @override
  String get revealAction => 'Reveal';

  @override
  String get openAnywayButton => 'Open Anyway';

  @override
  String get resultScreenTitle => 'Scan Result';

  @override
  String get resultNoResult => 'No result';

  @override
  String get resultContentLabel => 'Content:';

  @override
  String get resultDecoyContentLabel => 'Public Decoy Content:';

  @override
  String get resultDetectedType => 'Detected Type:';

  @override
  String get resultTypeStego => 'STEGO-QR (Encrypted Dual-Layer)';

  @override
  String get resultRecheckButton => 'Re-check';

  @override
  String get resultOpenInBrowser => 'Open in Browser';

  @override
  String get resultCopyText => 'Copy Text';

  @override
  String get resultCopyDecoyText => 'Copy Decoy Text';

  @override
  String get resultShareText => 'Share Text';

  @override
  String get resultShareDecoyText => 'Share Decoy Text';

  @override
  String get resultScanAnother => 'Scan Another Code';

  @override
  String get resultLaunchFailed => 'Could not launch URL';

  @override
  String get stegoUnlockedMessage =>
      'The hidden AES-256 encrypted payload has been decrypted successfully.';

  @override
  String get stegoLockedMessage =>
      'This QR code contains a hidden, encrypted secret layer. Authenticate to view the hidden payload.';

  @override
  String get stegoBiometricUnlock => 'Biometric Unlock';

  @override
  String get stegoPassphrase => 'Passphrase';

  @override
  String get stegoSecretPayload => 'Secret Payload:';

  @override
  String get stegoCopySecret => 'Copy Secret';

  @override
  String get stegoShareSecret => 'Share Secret';

  @override
  String get stegoSecretCopied => 'Secret copied to clipboard';

  @override
  String get stegoDialogTitleBiometric => 'Biometric + Passphrase';

  @override
  String get stegoDialogTitlePassphrase => 'Enter Passphrase';

  @override
  String get stegoDialogMessageBiometric =>
      'Confirm passphrase to authenticate with biometrics and decrypt payload.';

  @override
  String get stegoDialogMessagePassphrase =>
      'Enter the passphrase used to encrypt the secret payload.';

  @override
  String get stegoUnlockButton => 'Unlock';

  @override
  String get safetyCheckInProgress => 'Security Check In Progress';

  @override
  String get safetyAnalysisTitle => 'URL Security Analysis';

  @override
  String get safetyAnalyzing => 'Analyzing URL security...';

  @override
  String safetyIssuesDetected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count security issues detected',
      one: '1 security issue detected',
    );
    return '$_temp0';
  }

  @override
  String get safetyNoIssues => 'No issues detected';

  @override
  String get safetyTrustSourceHint =>
      'Only open this URL if you trust the source';

  @override
  String get safetyIssuesWarning =>
      'Security issues detected. Do not enter personal information or download files from this URL';

  @override
  String get safetyResultsHeading => 'Security Analysis Results:';

  @override
  String get probingBannerActive =>
      'Active online checks are ON: SSL, redirect and shortener checks contacted this site directly, exposing your IP address to it. Turn off \"Active online checks\" in Settings to check links privately.';

  @override
  String get probingBannerPrivate =>
      'Private mode: this link was analysed using local rules and Google Safe Browsing only — the site itself was never contacted, so your IP and device were not exposed. Enable \"Active online checks\" in Settings for live SSL/redirect verification.';

  @override
  String get warningDialogTitle => 'Security Warning';

  @override
  String get warningDialogMessage =>
      'This URL has security issues. Opening it may put your device or data at risk.\n\nAre you sure you want to proceed?';

  @override
  String get cautionDialogTitle => 'Caution';

  @override
  String get cautionDialogMessage =>
      'Always verify the source before opening URLs from QR codes.\n\nDo you want to open this URL?';

  @override
  String get overlayLaserLine => 'Laser Line';

  @override
  String get overlayPulsingCorners => 'Pulsing Corners';

  @override
  String get overlayCyberneticGrid => 'Cybernetic Grid';

  @override
  String get overlaySubtleDotMatrix => 'Subtle Dot Matrix';

  @override
  String get overlayLaserLineDesc =>
      'Scanning box with an animated vertical laser beam and glow line';

  @override
  String get overlayPulsingCornersDesc =>
      'Breathing corner reticles with color glow and scale animation';

  @override
  String get overlayCyberneticGridDesc =>
      'Sci-fi grid overlay pattern with target crosshair reticle';

  @override
  String get overlaySubtleDotMatrixDesc =>
      'Minimalist corner dot matrix pattern with pulsing accents';

  @override
  String get themeSystemDefault => 'System Default';

  @override
  String get themeLight => 'Light Theme';

  @override
  String get themeDark => 'Dark Theme';

  @override
  String get themeOled => 'OLED Pure Black';

  @override
  String get themeModeHeading => 'Theme Mode';

  @override
  String get themeChipSystem => 'System';

  @override
  String get themeChipLight => 'Light';

  @override
  String get themeChipDark => 'Dark';

  @override
  String get themeChipOled => 'OLED';

  @override
  String get themeDynamicColorsTitle => 'Material You Dynamic Colors';

  @override
  String get themeDynamicColorsSubtitle =>
      'Sample system wallpaper colors on Android 12+ (Monet engine)';

  @override
  String get themeDescSystem => 'Follow System Settings';

  @override
  String get themeDescLight => 'Standard Light Mode';

  @override
  String get themeDescDark => 'Standard Dark Mode';

  @override
  String get themeDescOled => 'True OLED Pure Black (Battery Saving)';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppearanceTitle => 'Appearance & Theme';

  @override
  String get settingsOverlayTitle => 'Customizable Scan Overlay';

  @override
  String get settingsFeedbackTitle => 'Scan Feedback & Alerts';

  @override
  String get settingsPrivacyTitle => 'Privacy & Online Probing';

  @override
  String get settingsSafeBrowsingTitle => 'Google Safe Browsing API';

  @override
  String get settingsPermissionsTitle => 'Permissions';

  @override
  String get settingsPermissionsSubtitle =>
      'Explicit, implicit & setting-dependent details';

  @override
  String get settingsHelpTitle => 'Help & Feature Guides';

  @override
  String get settingsHelpSubtitle =>
      'AR CodeVision, AirQR, Quishing Guard & URL Safety';

  @override
  String get settingsAboutSubtitle =>
      'App version, developer & license details';

  @override
  String get feedbackVibrationTitle => 'Vibration Feedback';

  @override
  String get feedbackVibrationSubtitle =>
      'Vibrate phone upon successful barcode recognition';

  @override
  String get feedbackSoundTitle => 'Audible Beep Sound';

  @override
  String get feedbackSoundSubtitle =>
      'Play audio beep signal upon successful code recognition';

  @override
  String get privacyScreenTitle => 'Privacy & Network Probing';

  @override
  String get privacyActiveChecksTitle => 'Active online checks';

  @override
  String get privacySummaryOn => 'Active online checks enabled';

  @override
  String get privacySummaryOff => 'Private offline checks only';

  @override
  String get apiKeyConfigured => 'Configured';

  @override
  String get apiKeyNotConfigured => 'Not configured';

  @override
  String get apiKeySaved => 'API key saved securely';

  @override
  String get apiKeyDeleted => 'API key deleted';

  @override
  String get apiKeyDeleteTitle => 'Delete API Key';

  @override
  String get deleteButton => 'Delete';

  @override
  String get apiAboutHeading => 'About Safe Browsing API';

  @override
  String get apiKeyConfiguredTitle => 'API Key Configured';

  @override
  String get apiKeyConfiguredSubtitle => 'Malicious URL checking is enabled';

  @override
  String get apiLimitReached => 'Daily limit reached. Resets tomorrow.';

  @override
  String get apiLimitApproaching => 'Approaching daily limit';

  @override
  String get apiKeyFieldLabel => 'API Key';

  @override
  String get apiKeyFieldHint => 'Enter your Google Safe Browsing API key';

  @override
  String get apiKeyRequired => 'Please enter an API key';

  @override
  String get apiKeyTooShort => 'API key appears to be too short';

  @override
  String get apiKeySaveButton => 'Save API Key';

  @override
  String get apiHowToHeading => 'How to get an API key';

  @override
  String get apiStep1Title => 'Go to Google Cloud Console';

  @override
  String get apiStep1Desc => 'Visit console.cloud.google.com';

  @override
  String get apiStep2Title => 'Create or select a project';

  @override
  String get apiStep2Desc => 'Choose an existing project or create a new one';

  @override
  String get apiStep3Title => 'Enable Safe Browsing API';

  @override
  String get apiStep4Title => 'Create credentials';

  @override
  String get apiStep4Desc => 'Go to Credentials → Create Credentials → API Key';

  @override
  String get apiStep5Title => 'Copy and paste';

  @override
  String get apiStep5Desc => 'Copy the generated API key and paste it above';

  @override
  String get apiFreeTierNote => 'Free tier includes 10,000 requests per day';

  @override
  String get permissionsScreenTitle => 'Permissions Overview';

  @override
  String get permissionsExplicitHeading =>
      'Explicit Permissions (Runtime / Manifest)';

  @override
  String get permissionCameraTitle =>
      'Camera Access (android.permission.CAMERA)';

  @override
  String get permissionCameraDesc =>
      'Requested on-demand at point of use. Required for live scanning, AR CodeVision HUD overlay, and AirQR optical stream decoding.';

  @override
  String get permissionBiometricTitle =>
      'Biometric Authentication (android.permission.USE_BIOMETRIC)';

  @override
  String get permissionBiometricDesc =>
      'Requested when unlocking biometric secure vaults or encrypted QR code payloads.';

  @override
  String get permissionsImplicitHeading => 'Implicit & System Permissions';

  @override
  String get permissionInternetTitle =>
      'Internet Access (android.permission.INTERNET)';

  @override
  String get permissionInternetDesc =>
      'Declared in Android Manifest. Used only when Active Online Probing or Google Safe Browsing API lookup is enabled.';

  @override
  String get permissionVibrateTitle =>
      'Vibration & Haptics (android.permission.VIBRATE)';

  @override
  String get permissionVibrateDesc =>
      'System permission. Triggers haptic vibration feedback during scan alerts and button taps.';

  @override
  String get permissionPhotoPickerTitle => 'Scoped Media Photo Picker';

  @override
  String get permissionPhotoPickerDesc =>
      'System photo picker access. Allows selecting QR images or videos from gallery without requesting full storage access.';

  @override
  String get permissionsSettingHeading => 'Setting-Dependent Permissions';

  @override
  String get permissionProbingTitle =>
      'Active Online Probing (Privacy Setting)';

  @override
  String get permissionProbingDesc =>
      'Active only when enabled. Performs outbound HTTP HEAD requests to follow URL redirects and check SSL certificates. When disabled, checks are 100% offline.';

  @override
  String get permissionSafeBrowsingTitle =>
      'Google Safe Browsing API (API Key Setting)';

  @override
  String get permissionSafeBrowsingDesc =>
      'Active only when API key is configured. Queries Google Threat API for malware & phishing checks.';

  @override
  String get permissionFeedbackTitle =>
      'Scan Feedback Vibrations (Alert Setting)';

  @override
  String get permissionFeedbackDesc =>
      'Active only when Vibration is enabled in Scan Feedback & Alerts settings.';

  @override
  String get helpArBadge => 'Augmented Reality';

  @override
  String get helpArDesc =>
      'Real-time camera overlay feature that highlights and visualizes barcode and QR code data directly within the 3D viewfinder.';

  @override
  String get helpArPoint1 =>
      'Multi-Target Detection: Automatically detects, indexes, and tracks multiple barcodes simultaneously in real time.';

  @override
  String get helpArPoint2 =>
      'Spatial Bounding Boxes: Overlays dynamic AR reticles and interactive floating chips above each detected code.';

  @override
  String get helpArPoint3 =>
      'Interactive Action Sheet: Tap any detected AR chip to inspect payload details, copy data, or execute smart actions without exiting the camera.';

  @override
  String get helpArPoint4 =>
      'Camera Viewport Suite: Built-in torch toggle, front/rear camera switching, and pinch-to-zoom controls.';

  @override
  String get helpAirQrBadge => 'Optical Data Protocol';

  @override
  String get helpAirQrDesc =>
      'High-speed optical data transfer receiver designed to reconstruct large multi-part payloads serialized across animated QR code loops.';

  @override
  String get helpAirQrPoint1 =>
      'Sequential Frame Assembly: Scans animated QR streams (AirQR format) frame-by-frame and stitches chunks back into complete files or text.';

  @override
  String get helpAirQrPoint2 =>
      'Real-Time Live Progress: Interactive progress indicator displaying completed percentage, total payload size, missing chunk count, and decoding speed.';

  @override
  String get helpAirQrPoint3 =>
      'Dual Input Modes: Supports live scanning through the camera feed or offline processing by importing saved video recordings/images from gallery.';

  @override
  String get helpAirQrPoint4 =>
      'AirQR Transmitter: Reverse mode allowing payload generation and animated QR stream transmission to other devices.';

  @override
  String get helpQuishingTitle =>
      'Quishing Guard (Physical QR Sticker Tamper Check)';

  @override
  String get helpQuishingBadge => 'On-Device Computer Vision';

  @override
  String get helpQuishingDesc =>
      'On-device computer vision engine that detects physical QR code sticker tampering, fake code overlays, and print alterations before processing payloads.';

  @override
  String get helpQuishingPoint1 =>
      '100% Offline & Private Guarantee: Operates entirely on-device using local camera frame computer vision with zero internet connection required.';

  @override
  String get helpQuishingPoint2 =>
      'Physical Sticker & Overlay Detection: Identifies physical stickers pasted over legitimate printed QR codes.';

  @override
  String get helpQuishingPoint3 =>
      'Edge & Alignment Anomaly Analysis: Checks for suspicious boundaries, cutouts, and alignment discrepancies.';

  @override
  String get helpQuishingPoint4 =>
      'Print Texture & Contrast Verification: Analyzes visual print artifacts, reflectivity shifts, and paper texture inconsistencies.';

  @override
  String get helpUrlTitle => 'URL Safety & Link Tamper Engine';

  @override
  String get helpUrlBadge => '6-Layer Digital Safety';

  @override
  String get helpUrlDesc =>
      'Comprehensive digital link analysis suite protecting against malicious web links, phishing (Quishing), and URL payload tampering.';

  @override
  String get helpUrlPoint1 =>
      'Homograph & IDN Attack Detection: Identifies spoofed domain names using mixed-script Cyrillic or lookalike Unicode characters.';

  @override
  String get helpUrlPoint2 =>
      'Zero-Width Space & Character Tamper Detector: Detects hidden zero-width spaces, non-printable control characters, or obfuscated payloads embedded in links.';

  @override
  String get helpUrlPoint3 =>
      'IP Literal & Userinfo Verification: Flags suspicious IP address hostnames and dangerous embedded credentials (e.g. user:pass@host).';

  @override
  String get helpUrlPoint4 =>
      'Suspicious TLD & Pattern Analysis: Scans for risky top-level domains, excessive subdomains, and unencrypted HTTP connections carrying login/payment data.';

  @override
  String get helpUrlPoint5 =>
      'URL Shortener Unrolling & Redirect Tracing: Identifies shortened links (bit.ly, t.co) and traces redirect chains (Active Probing required for live HTTP inspection).';

  @override
  String get helpUrlPoint6 =>
      'Google Safe Browsing Cloud Lookup: Optional cloud check against Google threat database when configured with an API key.';

  @override
  String get helpUrlPoint7 =>
      'Privacy First Guarantee: Core 5 pattern checks run 100% offline on your device without sending URLs anywhere.';

  @override
  String get helpCapabilitiesHeading => 'Key Capabilities:';

  @override
  String get onLabel => 'On';

  @override
  String get offLabel => 'Off';

  @override
  String get unknownLabel => 'Unknown';

  @override
  String get privacyActiveChecksSubtitle =>
      'Off: scanned links are checked privately — the destination server is never contacted.';

  @override
  String get privacyExplainerOn =>
      'When on, the SSL, redirect and shortener checks connect directly to the scanned site. This exposes your IP address (and therefore your approximate location and mobile carrier) to that server before you open the link.';

  @override
  String get privacyExplainerOff =>
      'SSL, redirect and shortener checks run from local rules only. Malicious-content lookup still uses Google Safe Browsing (the link is sent only to Google, never to the scanned site).';

  @override
  String get apiKeyDeleteMessage =>
      'Are you sure you want to delete your Google Safe Browsing API key? URL malicious content checking will be disabled.';

  @override
  String get apiAboutBody =>
      'The Google Safe Browsing API helps detect malicious URLs including phishing, malware, and unwanted software. Your API key is stored securely and encrypted on your device.';

  @override
  String get apiTodaysUsage => 'Today\'s Usage';

  @override
  String get apiStep3Desc => 'Search for \"Safe Browsing API\" and enable it';

  @override
  String feedbackSummary(String vibration, String sound) {
    return 'Vibration: $vibration • Sound: $sound';
  }

  @override
  String settingsApiKeySubtitle(String status) {
    return 'API Key: $status';
  }

  @override
  String apiKeySaveFailed(String error) {
    return 'Error saving API key: $error';
  }

  @override
  String apiKeyDeleteFailed(String error) {
    return 'Error deleting API key: $error';
  }

  @override
  String apiDailyLimit(int count) {
    return 'Daily Limit: $count requests per day';
  }

  @override
  String apiResets(String date) {
    return 'Resets: $date';
  }

  @override
  String get resultTypeTextFallback => 'TEXT';

  @override
  String get checkNameHttps => 'HTTPS Connection';

  @override
  String get checkNameSsl => 'SSL/TLS Certificate';

  @override
  String get checkNameRedirect => 'Redirect Analysis';

  @override
  String get checkNamePattern => 'Pattern Detection';

  @override
  String get checkNameShortener => 'URL Shortener Check';

  @override
  String get checkNameHomograph => 'Homograph Attack Check';

  @override
  String get checkNameMalicious => 'Malicious Content Check';

  @override
  String get httpsNotUsed => 'URL uses unencrypted HTTP connection';

  @override
  String get sslPrivateModeOk =>
      'Uses HTTPS (live certificate not checked in private mode)';

  @override
  String get sslValid => 'Valid SSL certificate';

  @override
  String get sslExpired => 'SSL certificate has expired';

  @override
  String get sslNotYetValid => 'SSL certificate not yet valid';

  @override
  String get sslUnverifiable => 'Unable to verify certificate';

  @override
  String get sslCheckFailed => 'Certificate check failed';

  @override
  String get redirectSkippedPrivate =>
      'Skipped in private mode (destination server not contacted)';

  @override
  String get redirectLoop => 'Redirect loop detected';

  @override
  String get redirectNone => 'No redirects detected';

  @override
  String get redirectUnavailable => 'Unable to check redirects';

  @override
  String get patternNone => 'No suspicious patterns found';

  @override
  String get patternUnavailable => 'Unable to analyze patterns';

  @override
  String get shortenerOfflineHeuristics =>
      'Unable to perform full check (offline) - heuristics only';

  @override
  String get shortenerNone => 'No URL shortener detected';

  @override
  String get shortenerUnavailable => 'Unable to check for shorteners';

  @override
  String get homographMixedScripts => 'Mixed character scripts detected';

  @override
  String get homographNone => 'No lookalike characters detected';

  @override
  String get homographUnavailable => 'Unable to check for homographs';

  @override
  String get maliciousSkippedNoKey => 'Skipped (API key not configured)';

  @override
  String get maliciousDailyLimit => 'Daily API limit reached (resets tomorrow)';

  @override
  String get maliciousNone => 'No known threats detected';

  @override
  String get maliciousInvalidKey => 'Invalid API key or request';

  @override
  String get maliciousRateLimited => 'Rate limit exceeded';

  @override
  String get maliciousUnavailable => 'Unable to check for malicious content';

  @override
  String get stegoWrongPassphrase =>
      'Decryption failed. Invalid passphrase or corrupted data.';

  @override
  String get airQrChecksumFailed =>
      'Checksum verification failed during reassembly.';

  @override
  String redirectSuspiciousChain(String count) {
    return 'Suspicious redirect chain ($count redirects)';
  }

  @override
  String redirectWithinRange(String count) {
    return '$count redirect(s) - within normal range';
  }

  @override
  String patternDetected(String patterns) {
    return 'Detected: $patterns';
  }

  @override
  String shortenerKnown(String shortener) {
    return 'Known URL shortener detected ($shortener)';
  }

  @override
  String shortenerRedirect(String host) {
    return 'Detected URL shortener (redirects to $host)';
  }

  @override
  String homographLookalikes(String characters) {
    return 'Lookalike characters detected: $characters';
  }

  @override
  String maliciousThreats(String threats) {
    return 'Threats detected: $threats';
  }

  @override
  String maliciousApiError(String status) {
    return 'API error (status: $status)';
  }

  @override
  String get quishingSummaryAuthentic =>
      'Authentic Printed Code. No physical tampering detected.';

  @override
  String get quishingSummaryWearAndTear =>
      'Wear & Tear Detected. Slight physical surface noise observed.';

  @override
  String get quishingSummaryHighWarning =>
      'High Warning: Physical Overlay Sticker Detected! Verify Before Tapping Links.';

  @override
  String get quishingStatusAuthentic => '🟢 Authentic Printed Code';

  @override
  String get quishingStatusWearAndTear => '🟡 Wear & Tear Detected';

  @override
  String get quishingStatusHighWarning =>
      '🔴 High Warning: Physical Overlay Sticker Detected!';

  @override
  String get quishingSignalMicroShadowPerimeter =>
      'Micro-shadow depth step line detected along matrix perimeter';

  @override
  String get quishingSignalGrainAberration =>
      'Mismatching inkjet/thermal grain chromatic aberration detected';

  @override
  String get quishingSignalUniformReflection =>
      'Uniform substrate reflection profile verified';

  @override
  String get quishingSignalConsistentDotsQrMatrix =>
      'Consistent halftone dot density across QR matrix perimeter';

  @override
  String get quishingSignalReflectionVerified =>
      'Substrate reflection profile verified';

  @override
  String get quishingSignalHalftoneConsistentQrMatrix =>
      'Halftone dot density consistent across QR matrix perimeter';

  @override
  String get quishingSignalHalftoneConsistentMatrix =>
      'Halftone dot density consistent across matrix';

  @override
  String get quishingSignalDoubleEdgeAroundMatrix =>
      'Perimeter double-edge reflection detected around QR matrix';

  @override
  String get quishingSignalMicroShadowStickerBorder =>
      'Micro-shadow depth step line detected along sticker border';

  @override
  String get quishingSignalGrainMismatchBase =>
      'Inkjet/thermal print grain mismatching base substrate';

  @override
  String get quishingSignalMinorScratch =>
      'Minor surface scratch or wear pattern observed';

  @override
  String get quishingSignalSlightDotIrregularity =>
      'Slight dot density irregularity along edges';

  @override
  String get quishingSignalConsistentDotsMatrixPerimeter =>
      'Consistent halftone dot density across matrix perimeter';

  @override
  String quishingSignalPerimeterDoubleEdge(String zones) {
    return 'Perimeter double-edge reflection detected ($zones boundary zones)';
  }

  @override
  String quishingSignalDotDensityVariance(String variance) {
    return 'Substrate halftone dot density inconsistency detected ($variance% variance)';
  }

  @override
  String get domSslInvalidScheme => 'Invalid URL scheme';

  @override
  String get domSslHttps => 'Uses encrypted HTTPS protocol';

  @override
  String get domSslHttp => 'Unencrypted HTTP connection (High Risk)';

  @override
  String get domStatusInvalidUrl => 'Invalid or unsupported web URL format.';

  @override
  String get domStatusHttpCaution => '⚠️ Caution: Unencrypted HTTP site';

  @override
  String get domStatusSafe =>
      '✅ Zero-Trust DOM Sandbox: HTML preview sanitized safely.';

  @override
  String domStatusOpenRedirect(String target) {
    return '⚠️ Warning: Open Redirect Trap detected pointing to $target';
  }

  @override
  String domStatusNewDomain(String days) {
    return '⚠️ Warning: Newly registered domain ($days days old)';
  }

  @override
  String get stegoPassphraseEmpty => 'Passphrase cannot be empty';

  @override
  String get stegoBiometricReason =>
      'Authenticate to view StegoQR secret payload';

  @override
  String get mediaNoCodeInImage => 'No barcodes or QR codes detected in image.';

  @override
  String get mediaNoCodeInPdf =>
      'No barcodes or QR codes found in PDF document.';

  @override
  String mediaImagePickFailed(String error) {
    return 'Failed to pick or scan image: $error';
  }

  @override
  String mediaImageAnalyzeFailed(String error) {
    return 'Error analyzing image: $error';
  }

  @override
  String mediaPdfPickFailed(String error) {
    return 'Failed to pick or parse PDF: $error';
  }

  @override
  String mediaPdfScanFailed(String error) {
    return 'Failed to scan PDF document: $error';
  }

  @override
  String get stegoBiometricCanceled =>
      'Biometric authentication canceled or failed.';

  @override
  String get formatQrUrl => 'QR (URL)';

  @override
  String get formatQrEmail => 'QR (Email)';

  @override
  String get formatQrPhone => 'QR (Phone)';

  @override
  String get formatQrSms => 'QR (SMS)';

  @override
  String get formatQrWifi => 'QR (Wi-Fi)';

  @override
  String get formatQrLocation => 'QR (Location)';

  @override
  String get formatQrContact => 'QR (Contact)';

  @override
  String get formatIsbn => 'ISBN';

  @override
  String get formatEanUpc => 'EAN/UPC';

  @override
  String get formatQrCode => 'QR Code';

  @override
  String get formatEanUpcProduct => 'EAN/UPC Product';

  @override
  String get formatBarcode => 'Barcode';

  @override
  String get wifiHiddenNetwork => 'Hidden Network';

  @override
  String get totpDefaultAccount => 'Account';

  @override
  String get backupInvalidFormat => 'Invalid backup file format.';

  @override
  String get backupBadHeader => 'Unrecognized or corrupted backup file header.';

  @override
  String get backupWrongPassphrase =>
      'Incorrect passphrase or corrupted backup payload.';

  @override
  String get reportHeading => 'SREERAJ P QR READER - SCAN HISTORY';

  @override
  String get reportTitle => 'Scan History Export';

  @override
  String get reportExportDate => 'Export Date';

  @override
  String get reportTotalScans => 'Total Scans';

  @override
  String get reportScanNumber => 'Scan #';

  @override
  String get reportId => 'ID           ';

  @override
  String get reportTimestamp => 'Timestamp    ';

  @override
  String get reportFormat => 'Format       ';

  @override
  String get reportCategory => 'Category     ';

  @override
  String get reportSafetyScore => 'Safety Score ';

  @override
  String get reportStarred => 'Starred      ';

  @override
  String get reportStarredYes => '⭐ Yes';

  @override
  String get reportStarredNo => 'No';

  @override
  String get reportLocation => 'Location     ';

  @override
  String get reportNotes => 'Notes        ';

  @override
  String get reportContent => 'Content      ';

  @override
  String get reportColumnDateTime => 'Date & Time';

  @override
  String get reportColumnFormat => 'Format';

  @override
  String get reportColumnCategory => 'Category';

  @override
  String get reportColumnSafety => 'Safety';

  @override
  String get reportColumnContent => 'Content Snippet';

  @override
  String get reportColumnNotes => 'Notes';

  @override
  String get patternIpAddress => 'IP Address';

  @override
  String get patternLongNumbers => 'Long Number Sequence';

  @override
  String get patternManyDashes => 'Multiple Dashes/Underscores';

  @override
  String get patternPhishingKeywords => 'Phishing Keywords';

  @override
  String get patternDataUri => 'Data URI';

  @override
  String get patternManySubdomains => 'Multiple Subdomains';

  @override
  String get shortenerPossibleShortDomain =>
      'Possible URL shortener: short domain with minimal path';

  @override
  String get shortenerPossibleRandomPath =>
      'Possible URL shortener: random character pattern in short path';

  @override
  String shortenerPossibleTld(String tld) {
    return 'Possible URL shortener: short domain with common shortener ending ($tld)';
  }
}
