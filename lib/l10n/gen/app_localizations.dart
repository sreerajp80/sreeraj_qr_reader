import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// The application name, shown as the task title and in the About screen
  ///
  /// In en, this message translates to:
  /// **'Sreeraj P QR Reader'**
  String get appTitle;

  /// Label above the network name on the Wi-Fi action card
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi Network'**
  String get wifiCardTitle;

  /// Tooltip on the button that reveals the Wi-Fi password
  ///
  /// In en, this message translates to:
  /// **'Show Password'**
  String get wifiShowPassword;

  /// Tooltip on the button that hides the Wi-Fi password
  ///
  /// In en, this message translates to:
  /// **'Hide Password'**
  String get wifiHidePassword;

  /// Tooltip on the button that copies the Wi-Fi password
  ///
  /// In en, this message translates to:
  /// **'Copy Password'**
  String get wifiCopyPassword;

  /// Button that opens the device Wi-Fi settings to connect
  ///
  /// In en, this message translates to:
  /// **'Connect to Wi-Fi'**
  String get wifiConnectButton;

  /// Message shown after the Wi-Fi password is copied
  ///
  /// In en, this message translates to:
  /// **'Password copied to clipboard'**
  String get wifiPasswordCopied;

  /// Message shown when the app cannot open Wi-Fi settings directly
  ///
  /// In en, this message translates to:
  /// **'Password copied. Open Wi-Fi Settings on your device to connect.'**
  String get wifiOpenSettingsHint;

  /// Coordinates line on the location action card
  ///
  /// In en, this message translates to:
  /// **'Lat: {latitude}, Lng: {longitude}'**
  String geoLatLng(String latitude, String longitude);

  /// Search text carried by a scanned location code
  ///
  /// In en, this message translates to:
  /// **'Query: {query}'**
  String geoQuery(String query);

  /// Button that opens the scanned location in Google Maps
  ///
  /// In en, this message translates to:
  /// **'Navigate in Google Maps'**
  String get geoNavigateButton;

  /// Message shown when Google Maps cannot be opened
  ///
  /// In en, this message translates to:
  /// **'Could not launch Google Maps app'**
  String get geoLaunchFailed;

  /// Label above the event name on the calendar action card
  ///
  /// In en, this message translates to:
  /// **'Calendar Event'**
  String get calendarCardTitle;

  /// Shown in place of a date when the scanned event has none
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get calendarNoDate;

  /// Start date and time of a scanned calendar event
  ///
  /// In en, this message translates to:
  /// **'Start: {dateTime}'**
  String calendarStart(String dateTime);

  /// End date and time of a scanned calendar event. The extra spaces line it up under the start line
  ///
  /// In en, this message translates to:
  /// **'End:   {dateTime}'**
  String calendarEnd(String dateTime);

  /// Button that adds the scanned event to the device calendar
  ///
  /// In en, this message translates to:
  /// **'Add to Device Calendar'**
  String get calendarAddButton;

  /// Message shown when the calendar app cannot be opened
  ///
  /// In en, this message translates to:
  /// **'Could not open Calendar app'**
  String get calendarLaunchFailed;

  /// Label above the person's name on the contact action card
  ///
  /// In en, this message translates to:
  /// **'Contact Card'**
  String get contactCardTitle;

  /// Single letter shown in the contact avatar when the scanned contact has no name
  ///
  /// In en, this message translates to:
  /// **'C'**
  String get contactInitialFallback;

  /// Button that saves the scanned contact to the device
  ///
  /// In en, this message translates to:
  /// **'Save to Contacts'**
  String get contactSaveButton;

  /// Message shown when the contacts app cannot be opened
  ///
  /// In en, this message translates to:
  /// **'Could not open Contacts app'**
  String get contactLaunchFailed;

  /// Message shown when a phone call cannot be started
  ///
  /// In en, this message translates to:
  /// **'Could not place call to {number}'**
  String contactCallFailed(String number);

  /// Message shown when the email app cannot be opened
  ///
  /// In en, this message translates to:
  /// **'Could not open email app for {email}'**
  String contactEmailFailed(String email);

  /// Title of the sheet listing codes found in a PDF, with how many were found
  ///
  /// In en, this message translates to:
  /// **'PDF Scan Results ({count})'**
  String pdfResultsTitle(int count);

  /// Short page badge on a PDF result row, for example P3
  ///
  /// In en, this message translates to:
  /// **'P{page}'**
  String pdfPageBadge(int page);

  /// Page number of a code found in a PDF
  ///
  /// In en, this message translates to:
  /// **'Page {page}'**
  String pdfPageLabel(int page);

  /// Button that saves every code found in the PDF to history
  ///
  /// In en, this message translates to:
  /// **'Save All ({count}) to History'**
  String pdfSaveAllButton(int count);

  /// Note stored with a history record for a code found in a PDF
  ///
  /// In en, this message translates to:
  /// **'Scanned from PDF (Page {page})'**
  String pdfScanNote(int page);

  /// Message shown after saving all PDF codes to history
  ///
  /// In en, this message translates to:
  /// **'Saved {count} codes to history.'**
  String pdfSavedToHistory(int count);

  /// Shown in place of the issuer name when a scanned 2FA code has none
  ///
  /// In en, this message translates to:
  /// **'2FA Authenticator'**
  String get totpDefaultIssuer;

  /// Label above the rolling one-time passcode, with how many seconds each code lasts
  ///
  /// In en, this message translates to:
  /// **'Live Passcode ({period}s TOTP)'**
  String totpLivePasscode(int period);

  /// Seconds left before the current one-time passcode changes
  ///
  /// In en, this message translates to:
  /// **'{seconds}s'**
  String totpSecondsLeft(int seconds);

  /// Tooltip on the button that copies the current one-time passcode
  ///
  /// In en, this message translates to:
  /// **'Copy Token'**
  String get totpCopyToken;

  /// Label before the 2FA secret key. Keeps a trailing space
  ///
  /// In en, this message translates to:
  /// **'Secret: '**
  String get totpSecretLabel;

  /// Button that sends the scanned 2FA code to an authenticator app
  ///
  /// In en, this message translates to:
  /// **'Import into Authenticator App'**
  String get totpImportButton;

  /// Message shown when no authenticator app could be opened
  ///
  /// In en, this message translates to:
  /// **'Could not open Authenticator app'**
  String get totpLaunchFailed;

  /// Message shown after the one-time passcode is copied
  ///
  /// In en, this message translates to:
  /// **'TOTP token copied to clipboard'**
  String get totpTokenCopied;

  /// Message shown after the 2FA secret key is copied
  ///
  /// In en, this message translates to:
  /// **'Secret key copied to clipboard'**
  String get totpSecretCopied;

  /// Title of the payment card for an Indian UPI code
  ///
  /// In en, this message translates to:
  /// **'UPI Payment'**
  String get paymentSchemeUpi;

  /// Title of the payment card for a European SEPA transfer code
  ///
  /// In en, this message translates to:
  /// **'SEPA Transfer'**
  String get paymentSchemeSepa;

  /// Title of the payment card for a cryptocurrency code
  ///
  /// In en, this message translates to:
  /// **'Crypto Payment'**
  String get paymentSchemeCrypto;

  /// Shown in place of the payee name when the scanned code has none
  ///
  /// In en, this message translates to:
  /// **'Merchant / Payee'**
  String get paymentPayeeFallback;

  /// Label before the payee address for a UPI code
  ///
  /// In en, this message translates to:
  /// **'VPA / UPI ID:'**
  String get paymentAddressLabelUpi;

  /// Label before the payee address for a SEPA transfer code
  ///
  /// In en, this message translates to:
  /// **'IBAN:'**
  String get paymentAddressLabelSepa;

  /// Label before the payee address for a cryptocurrency code
  ///
  /// In en, this message translates to:
  /// **'Wallet Address:'**
  String get paymentAddressLabelCrypto;

  /// Small button that copies the payee address
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get paymentCopyAction;

  /// Message shown after a UPI id is copied
  ///
  /// In en, this message translates to:
  /// **'UPI ID copied to clipboard'**
  String get paymentUpiIdCopied;

  /// Message shown after a payment address is copied
  ///
  /// In en, this message translates to:
  /// **'Address copied to clipboard'**
  String get paymentAddressCopied;

  /// Transaction note carried by a scanned payment code
  ///
  /// In en, this message translates to:
  /// **'Note: {note}'**
  String paymentNote(String note);

  /// Button that opens a UPI payment app
  ///
  /// In en, this message translates to:
  /// **'Pay via App (GPay / PhonePe / Paytm)'**
  String get paymentPayButtonUpi;

  /// Button that opens a payment app for a non-UPI code
  ///
  /// In en, this message translates to:
  /// **'Pay via App'**
  String get paymentPayButton;

  /// Message shown when no UPI payment app could be opened
  ///
  /// In en, this message translates to:
  /// **'Could not open UPI app. Make sure GPay, PhonePe, or Paytm is installed.'**
  String get paymentUpiLaunchFailed;

  /// Message shown when no payment app could be opened
  ///
  /// In en, this message translates to:
  /// **'Could not open payment app for this scheme.'**
  String get paymentLaunchFailed;

  /// Action on the failure message that copies the payee address instead
  ///
  /// In en, this message translates to:
  /// **'Copy ID'**
  String get paymentCopyIdAction;

  /// A percentage shown to the user, for example 42%
  ///
  /// In en, this message translates to:
  /// **'{value}%'**
  String percentValue(String value);

  /// Name of the feature that checks a printed code for physical tampering
  ///
  /// In en, this message translates to:
  /// **'QuishingGuard™'**
  String get quishingGuardTitle;

  /// Small badge saying the check uses computer vision on the printed code
  ///
  /// In en, this message translates to:
  /// **'Physical Tamper CV'**
  String get quishingTamperBadge;

  /// Label before the tamper risk percentage
  ///
  /// In en, this message translates to:
  /// **'Tamper Risk Score:'**
  String get quishingRiskScoreLabel;

  /// Link that opens the detailed tamper findings
  ///
  /// In en, this message translates to:
  /// **'View Forensic Analysis'**
  String get quishingViewSignals;

  /// Link that closes the detailed tamper findings
  ///
  /// In en, this message translates to:
  /// **'Hide Forensic Signals'**
  String get quishingHideSignals;

  /// Name of the tamper metric that looks at the edges of the printed code
  ///
  /// In en, this message translates to:
  /// **'Edge Discontinuity'**
  String get quishingMetricEdgeLabel;

  /// Short explanation of the edge discontinuity metric
  ///
  /// In en, this message translates to:
  /// **'Double edges & shadow lines'**
  String get quishingMetricEdgeDescription;

  /// Name of the tamper metric that looks at print quality
  ///
  /// In en, this message translates to:
  /// **'Print Grain & DPI'**
  String get quishingMetricGrainLabel;

  /// Short explanation of the print grain metric
  ///
  /// In en, this message translates to:
  /// **'Halftone dot & chromatic noise'**
  String get quishingMetricGrainDescription;

  /// Heading above the list of tamper findings
  ///
  /// In en, this message translates to:
  /// **'Detected Computer Vision Signals:'**
  String get quishingSignalsHeading;

  /// Tooltip on the button that closes the AR detail sheet
  ///
  /// In en, this message translates to:
  /// **'Close Sheet'**
  String get arCloseSheet;

  /// Price read from a scanned item label in warehouse mode
  ///
  /// In en, this message translates to:
  /// **'Item Price Tag: {price}'**
  String arItemPriceTag(String price);

  /// Message shown after the AR target content is copied
  ///
  /// In en, this message translates to:
  /// **'Copied content to clipboard'**
  String get arContentCopied;

  /// Button that copies the AR target content
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get arCopyButton;

  /// Button that opens the link held by the AR target
  ///
  /// In en, this message translates to:
  /// **'Open URL'**
  String get arOpenUrlButton;

  /// Button that marks an AR target as selected
  ///
  /// In en, this message translates to:
  /// **'Select Item'**
  String get arSelectButton;

  /// Button that clears the selection on an AR target
  ///
  /// In en, this message translates to:
  /// **'Deselect'**
  String get arDeselectButton;

  /// Shown when the AR target link passed the safety checks
  ///
  /// In en, this message translates to:
  /// **'Safety Status: Verified Safe'**
  String get arSafetyStatusSafe;

  /// Shown when the AR target link may be a phishing attempt
  ///
  /// In en, this message translates to:
  /// **'Safety Status: Warning / Phishing Suspicion'**
  String get arSafetyStatusWarning;

  /// Shown while the AR target link is still being checked
  ///
  /// In en, this message translates to:
  /// **'Safety Status: Analyzing link safety...'**
  String get arSafetyStatusUnknown;

  /// Message shown after content is copied, used on several screens
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// Date and time of a saved scan, joined by a dot
  ///
  /// In en, this message translates to:
  /// **'{date} • {time}'**
  String historyTimestamp(String date, String time);

  /// Tooltip on the button that marks a saved scan as a favourite
  ///
  /// In en, this message translates to:
  /// **'Star favorite'**
  String get historyStar;

  /// Tooltip on the button that removes a saved scan from favourites
  ///
  /// In en, this message translates to:
  /// **'Unstar'**
  String get historyUnstar;

  /// Menu item that opens the notes editor for a saved scan
  ///
  /// In en, this message translates to:
  /// **'Edit Notes'**
  String get historyEditNotes;

  /// Menu item that copies the saved scan content
  ///
  /// In en, this message translates to:
  /// **'Copy String'**
  String get historyCopyString;

  /// Button and menu item that shares the saved scan content
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get historyShare;

  /// Menu item that deletes a saved scan
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get historyDelete;

  /// Title of the sheet showing one saved scan in full
  ///
  /// In en, this message translates to:
  /// **'Scan Record Details'**
  String get historyDetailTitle;

  /// Safety score badge on a saved scan
  ///
  /// In en, this message translates to:
  /// **'🛡️ {score}% Safe'**
  String historySafetyBadge(int score);

  /// Short safety score badge on a history card
  ///
  /// In en, this message translates to:
  /// **'🛡️ {score}%'**
  String historyScoreBadge(int score);

  /// Label above the raw content of a saved scan
  ///
  /// In en, this message translates to:
  /// **'Scanned Content:'**
  String get historyScannedContent;

  /// Button that copies the saved scan content
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get historyCopyButton;

  /// Label of the field where the user writes their own note
  ///
  /// In en, this message translates to:
  /// **'Custom User Notes'**
  String get historyNotesLabel;

  /// Hint inside the empty notes field
  ///
  /// In en, this message translates to:
  /// **'Add personal notes or remarks about this scan...'**
  String get historyNotesHint;

  /// Label of the field where the user names the place of the scan
  ///
  /// In en, this message translates to:
  /// **'Location Tag (Optional)'**
  String get historyLocationLabel;

  /// Hint inside the empty location field
  ///
  /// In en, this message translates to:
  /// **'e.g. Office Desk, Grocery Store, Conference'**
  String get historyLocationHint;

  /// Button that saves the edited note and location
  ///
  /// In en, this message translates to:
  /// **'Save Metadata Changes'**
  String get historySaveChanges;

  /// Button that closes a dialog, used on several screens
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeButton;

  /// Title of the dialog when it is exporting scan history
  ///
  /// In en, this message translates to:
  /// **'Export & Cloud Backup'**
  String get exportDialogTitle;

  /// Title of the dialog when it is restoring a backup
  ///
  /// In en, this message translates to:
  /// **'Restore Encrypted Backup'**
  String get restoreDialogTitle;

  /// Button that switches the dialog to export mode
  ///
  /// In en, this message translates to:
  /// **'Export Records'**
  String get exportRecordsTab;

  /// Button that switches the dialog to restore mode
  ///
  /// In en, this message translates to:
  /// **'Restore Backup'**
  String get restoreBackupTab;

  /// Heading above the list of export file formats
  ///
  /// In en, this message translates to:
  /// **'Select Export Format:'**
  String get exportFormatHeading;

  /// Name of the CSV export option
  ///
  /// In en, this message translates to:
  /// **'CSV Format (.csv)'**
  String get exportCsvTitle;

  /// Short explanation of the CSV export option
  ///
  /// In en, this message translates to:
  /// **'Compatible with Excel and Sheets'**
  String get exportCsvSubtitle;

  /// Name of the JSON export option
  ///
  /// In en, this message translates to:
  /// **'JSON Dataset (.json)'**
  String get exportJsonTitle;

  /// Short explanation of the JSON export option
  ///
  /// In en, this message translates to:
  /// **'Structured developer format'**
  String get exportJsonSubtitle;

  /// Name of the plain text export option
  ///
  /// In en, this message translates to:
  /// **'Formatted TXT Report (.txt)'**
  String get exportTxtTitle;

  /// Short explanation of the plain text export option
  ///
  /// In en, this message translates to:
  /// **'Human readable summary document'**
  String get exportTxtSubtitle;

  /// Name of the PDF export option
  ///
  /// In en, this message translates to:
  /// **'PDF Document Report (.pdf)'**
  String get exportPdfTitle;

  /// Short explanation of the PDF export option
  ///
  /// In en, this message translates to:
  /// **'Formatted printable report table'**
  String get exportPdfSubtitle;

  /// Heading above the encrypted backup controls
  ///
  /// In en, this message translates to:
  /// **'Encrypted Local Backup File (.sreerajqr)'**
  String get exportBackupHeading;

  /// Label of the field for the backup password
  ///
  /// In en, this message translates to:
  /// **'Backup Encryption Passphrase'**
  String get exportPassphraseLabel;

  /// Hint inside the empty backup password field
  ///
  /// In en, this message translates to:
  /// **'Enter secret passphrase...'**
  String get exportPassphraseHint;

  /// Message shown when the user tries to back up without a password
  ///
  /// In en, this message translates to:
  /// **'Please enter a password to encrypt your backup file.'**
  String get exportPassphraseRequired;

  /// Button that builds and shares the encrypted backup file
  ///
  /// In en, this message translates to:
  /// **'Create Encrypted Backup File'**
  String get exportCreateBackupButton;

  /// Message attached when sharing an exported history file
  ///
  /// In en, this message translates to:
  /// **'Sreeraj QR Reader Scan History Export'**
  String get exportShareText;

  /// Message attached when sharing the PDF history report
  ///
  /// In en, this message translates to:
  /// **'Sreeraj QR Reader Scan History Report (PDF)'**
  String get exportSharePdfText;

  /// Message attached when sharing the encrypted backup file
  ///
  /// In en, this message translates to:
  /// **'Sreeraj QR Reader Encrypted Backup File'**
  String get exportShareBackupText;

  /// Heading above the restore controls
  ///
  /// In en, this message translates to:
  /// **'Restore History from Encrypted Backup File:'**
  String get restoreHeading;

  /// Label of the field for the password that unlocks a backup
  ///
  /// In en, this message translates to:
  /// **'Backup Decryption Passphrase'**
  String get restorePassphraseLabel;

  /// Label of the field holding the backup file content
  ///
  /// In en, this message translates to:
  /// **'Encrypted Backup Payload (.sreerajqr)'**
  String get restorePayloadLabel;

  /// Hint inside the empty backup content field
  ///
  /// In en, this message translates to:
  /// **'Paste backup JSON payload string here...'**
  String get restorePayloadHint;

  /// Message shown when a restore is tried with a missing field
  ///
  /// In en, this message translates to:
  /// **'Please provide both the password and backup content.'**
  String get restoreFieldsRequired;

  /// Button that unlocks a backup and restores the scans in it
  ///
  /// In en, this message translates to:
  /// **'Decrypt & Restore History'**
  String get restoreButton;

  /// Message shown after a backup is restored
  ///
  /// In en, this message translates to:
  /// **'Successfully restored {count} scan records!'**
  String restoreSuccess(int count);

  /// Message shown when a backup could not be restored
  ///
  /// In en, this message translates to:
  /// **'Restore failed: {reason}'**
  String restoreFailed(String reason);

  /// Badge saying the page preview ran with scripts blocked
  ///
  /// In en, this message translates to:
  /// **'SANDBOXED'**
  String get domSandboxedBadge;

  /// Single letter shown in the site avatar when the page has no title
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get domTitleInitialFallback;

  /// Shown in place of the page title when the page has none
  ///
  /// In en, this message translates to:
  /// **'Untitled Web Page'**
  String get domUntitledPage;

  /// Caption under the safe preview image of a scanned web page
  ///
  /// In en, this message translates to:
  /// **'Visual Thumbnail Pre-Render (Script Execution Blocked)'**
  String get domThumbnailCaption;

  /// Badge counting the scripts and trackers the preview blocked
  ///
  /// In en, this message translates to:
  /// **'Blocked: {scripts} Scripts, {trackers} Trackers'**
  String domBlockedBadge(int scripts, int trackers);

  /// Badge warning that the site domain was registered very recently
  ///
  /// In en, this message translates to:
  /// **'Newly Registered ({days}d)'**
  String domNewlyRegistered(int days);

  /// Badge showing how old the site domain is
  ///
  /// In en, this message translates to:
  /// **'Domain Age: {days} days'**
  String domDomainAge(int days);

  /// Badge warning that the link forwards to another site
  ///
  /// In en, this message translates to:
  /// **'Open Redirect Trap!'**
  String get domOpenRedirectFound;

  /// Badge saying the link does not forward to another site
  ///
  /// In en, this message translates to:
  /// **'No Open Redirects'**
  String get domNoOpenRedirect;

  /// Button that opens the detailed page structure sheet
  ///
  /// In en, this message translates to:
  /// **'Inspect DOM Sandbox Structure'**
  String get domInspectButton;

  /// Title of the detailed page structure sheet
  ///
  /// In en, this message translates to:
  /// **'Zero-Trust DOM Sandbox Hierarchy'**
  String get domInspectTitle;

  /// Row label for the page title
  ///
  /// In en, this message translates to:
  /// **'Page Title'**
  String get domDetailPageTitle;

  /// Shown when the page did not give a title
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get domDetailNotSpecified;

  /// Row label for the page description
  ///
  /// In en, this message translates to:
  /// **'Meta Description'**
  String get domDetailMetaDescription;

  /// Shown when the page did not give a description
  ///
  /// In en, this message translates to:
  /// **'None found'**
  String get domDetailNoneFound;

  /// Row label for how many headings the page had
  ///
  /// In en, this message translates to:
  /// **'Headings Count'**
  String get domDetailHeadingsCount;

  /// How many headings were read from the page
  ///
  /// In en, this message translates to:
  /// **'{count} headings extracted'**
  String domDetailHeadingsValue(int count);

  /// Row label for how many links the page had
  ///
  /// In en, this message translates to:
  /// **'Links Found'**
  String get domDetailLinksFound;

  /// How many links were read from the page
  ///
  /// In en, this message translates to:
  /// **'{count} URLs extracted'**
  String domDetailLinksValue(int count);

  /// Row label for blocked scripts
  ///
  /// In en, this message translates to:
  /// **'Blocked Scripts'**
  String get domDetailBlockedScripts;

  /// How many scripts were removed before the preview
  ///
  /// In en, this message translates to:
  /// **'{count} executable script tags/events stripped'**
  String domDetailBlockedScriptsValue(int count);

  /// Row label for blocked trackers
  ///
  /// In en, this message translates to:
  /// **'Blocked Trackers'**
  String get domDetailBlockedTrackers;

  /// How many trackers were removed before the preview
  ///
  /// In en, this message translates to:
  /// **'{count} tracking pixels stripped'**
  String domDetailBlockedTrackersValue(int count);

  /// Row label for blocked embedded frames
  ///
  /// In en, this message translates to:
  /// **'Blocked Iframes'**
  String get domDetailBlockedIframes;

  /// How many embedded frames were removed before the preview
  ///
  /// In en, this message translates to:
  /// **'{count} iframe/embed elements removed'**
  String domDetailBlockedIframesValue(int count);

  /// Heading above the cleaned page source snippet
  ///
  /// In en, this message translates to:
  /// **'Sanitized HTML Preview Snippet:'**
  String get domSanitizedSnippetHeading;

  /// Title of the About screen
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// App version and build number on the About screen
  ///
  /// In en, this message translates to:
  /// **'Version {version}+{build}'**
  String aboutVersion(String version, String build);

  /// Footer line on the About screen
  ///
  /// In en, this message translates to:
  /// **'Made with ❤️ from India'**
  String get aboutMadeWithLove;

  /// Title of the screen that sends data as a stream of codes
  ///
  /// In en, this message translates to:
  /// **'AirQR Stream Transmitter'**
  String get airQrTransmitterTitle;

  /// Sample text that fills the payload box when the transmitter screen opens
  ///
  /// In en, this message translates to:
  /// **'AirQR High-Speed Optical Air-Gap Transfer Test Payload. This payload is encoded into 256-byte chunks with Fountain FEC error correction.'**
  String get airQrSamplePayload;

  /// Label of the box holding the data to send
  ///
  /// In en, this message translates to:
  /// **'Payload Data to Broadcast'**
  String get airQrPayloadLabel;

  /// Hint inside the empty payload box
  ///
  /// In en, this message translates to:
  /// **'Enter text, contact, or file payload...'**
  String get airQrPayloadHint;

  /// Label before the slider that sets how fast codes are shown
  ///
  /// In en, this message translates to:
  /// **'Stream Speed:'**
  String get airQrStreamSpeed;

  /// How many code frames are shown per second
  ///
  /// In en, this message translates to:
  /// **'{fps} FPS'**
  String airQrFps(int fps);

  /// Button that starts showing the stream of codes
  ///
  /// In en, this message translates to:
  /// **'Broadcast Optical Stream'**
  String get airQrStartStream;

  /// Button that stops showing the stream of codes
  ///
  /// In en, this message translates to:
  /// **'Stop Optical Stream'**
  String get airQrStopStream;

  /// Caption under a repair frame of the stream
  ///
  /// In en, this message translates to:
  /// **'Frame {current}/{total} [Fountain PARITY]'**
  String airQrFrameParity(int current, int total);

  /// Caption under a data frame of the stream
  ///
  /// In en, this message translates to:
  /// **'Frame {current}/{total} [Block {block}]'**
  String airQrFrameBlock(int current, int total, int block);

  /// Summary of how many frames the stream holds
  ///
  /// In en, this message translates to:
  /// **'Total Stream Frames: {total} ({source} Source + {parity} Fountain FEC)'**
  String airQrTotalFrames(int total, int source, int parity);

  /// Tooltip on the button that turns the camera light on or off
  ///
  /// In en, this message translates to:
  /// **'Toggle Flashlight'**
  String get toggleFlashlight;

  /// Button that asks the system for camera permission again
  ///
  /// In en, this message translates to:
  /// **'Grant Camera Permission'**
  String get grantCameraPermission;

  /// Title of the screen that marks up live camera view with found codes
  ///
  /// In en, this message translates to:
  /// **'AR CodeVision HUD'**
  String get arScreenTitle;

  /// Shown while the live camera view is starting
  ///
  /// In en, this message translates to:
  /// **'Initializing AR HUD Viewport...'**
  String get arInitializing;

  /// Button that unselects every marked code
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get arClearSelection;

  /// Button that copies every selected code at once
  ///
  /// In en, this message translates to:
  /// **'Batch Copy'**
  String get arBatchCopy;

  /// Message shown after copying several codes at once
  ///
  /// In en, this message translates to:
  /// **'Copied {count} barcodes to clipboard'**
  String arBatchCopied(int count);

  /// Shown when camera permission is missing on the AR screen
  ///
  /// In en, this message translates to:
  /// **'Camera permission is required for AR CodeVision'**
  String get arCameraPermissionMessage;

  /// Button that closes a finished step, used on several screens
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get doneButton;

  /// Title of the screen that reads a stream of codes
  ///
  /// In en, this message translates to:
  /// **'AirQR Stream Receiver'**
  String get airQrReceiverTitle;

  /// Tooltip on the button that opens the sending screen
  ///
  /// In en, this message translates to:
  /// **'AirQR Transmitter'**
  String get airQrTransmitterTooltip;

  /// Tooltip on the button that starts the capture again
  ///
  /// In en, this message translates to:
  /// **'Reset Stream'**
  String get airQrResetStream;

  /// Shown while the stream reader is starting
  ///
  /// In en, this message translates to:
  /// **'Initializing AirQR Stream Receiver...'**
  String get airQrInitializing;

  /// Status shown when every part of the stream has been received
  ///
  /// In en, this message translates to:
  /// **'STREAM REASSEMBLED'**
  String get airQrStatusReassembled;

  /// Status shown while parts of the stream are being read
  ///
  /// In en, this message translates to:
  /// **'CAPTURING OPTICAL STREAM...'**
  String get airQrStatusCapturing;

  /// Status telling the user to aim the camera at the sending screen
  ///
  /// In en, this message translates to:
  /// **'POINT AT ANIMATED QR STREAM'**
  String get airQrStatusIdle;

  /// How many parts of the stream have been read so far
  ///
  /// In en, this message translates to:
  /// **'Captured: {received} / {total} Blocks'**
  String airQrCaptured(int received, int total);

  /// How many parts of the stream are still missing
  ///
  /// In en, this message translates to:
  /// **'Missing: {count}'**
  String airQrMissing(int count);

  /// Title of the panel shown when the whole stream has been received
  ///
  /// In en, this message translates to:
  /// **'Air-Gap Transfer Complete!'**
  String get airQrTransferComplete;

  /// Explanation under the transfer complete title
  ///
  /// In en, this message translates to:
  /// **'Payload reassembled and verified offline via Fountain error correction.'**
  String get airQrTransferCompleteDetail;

  /// Message shown after the received data is copied
  ///
  /// In en, this message translates to:
  /// **'Copied payload to clipboard'**
  String get airQrPayloadCopied;

  /// Button that closes a dialog without acting, used on several screens
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// Title of the saved scans screen
  ///
  /// In en, this message translates to:
  /// **'Scan History'**
  String get historyScreenTitle;

  /// Tooltip on the button that opens the export and backup dialog
  ///
  /// In en, this message translates to:
  /// **'Export / Backup'**
  String get historyExportTooltip;

  /// Button and tooltip for deleting every saved scan
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get historyClearAll;

  /// Title of the dialog asking to confirm deleting all saved scans
  ///
  /// In en, this message translates to:
  /// **'Clear Scan History?'**
  String get historyClearTitle;

  /// Warning shown before all saved scans are deleted
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all persistent scan history? This action cannot be undone unless you have created a backup.'**
  String get historyClearMessage;

  /// Hint inside the empty search box on the saved scans screen
  ///
  /// In en, this message translates to:
  /// **'Search history (content, format, notes)...'**
  String get historySearchHint;

  /// Filter chip showing every saved scan
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get historyFilterAll;

  /// Filter chip showing only favourite scans
  ///
  /// In en, this message translates to:
  /// **'Starred'**
  String get historyFilterStarred;

  /// Filter chip showing only saved links
  ///
  /// In en, this message translates to:
  /// **'URLs'**
  String get historyFilterUrls;

  /// Filter chip showing only saved Wi-Fi codes
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi'**
  String get historyFilterWifi;

  /// Filter chip showing only saved contact cards
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get historyFilterContacts;

  /// Filter chip showing only saved plain text scans
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get historyFilterText;

  /// Filter chip showing only saved product barcodes
  ///
  /// In en, this message translates to:
  /// **'Barcodes'**
  String get historyFilterBarcodes;

  /// Title shown when the saved scans list is empty
  ///
  /// In en, this message translates to:
  /// **'No Scan Records Found'**
  String get historyEmptyTitle;

  /// Explanation shown when no scans have been saved yet
  ///
  /// In en, this message translates to:
  /// **'Scanned barcodes will automatically appear here.'**
  String get historyEmptyMessage;

  /// Shown when a search over saved scans finds nothing
  ///
  /// In en, this message translates to:
  /// **'No matches for \"{query}\"'**
  String historyNoMatches(String query);

  /// Tooltip on the button that opens the overflow menu
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get moreOptions;

  /// Menu item that opens the saved scans screen
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get menuHistory;

  /// Menu item that opens the settings screen
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get menuSettings;

  /// Button that asks the system for a permission again
  ///
  /// In en, this message translates to:
  /// **'Grant Permission'**
  String get grantPermission;

  /// Tooltip on the button that reads a code from a saved picture
  ///
  /// In en, this message translates to:
  /// **'Scan Image from Gallery'**
  String get scanFromGallery;

  /// Tooltip on the button that reads codes from a PDF file
  ///
  /// In en, this message translates to:
  /// **'Scan PDF Document'**
  String get scanPdfDocument;

  /// Shown while the pages of a chosen PDF are being read
  ///
  /// In en, this message translates to:
  /// **'Extracting & scanning PDF pages...'**
  String get scanPdfProgress;

  /// Shown while a PDF shared from another app is being read
  ///
  /// In en, this message translates to:
  /// **'Scanning shared PDF document...'**
  String get scanSharedPdfProgress;

  /// Shown while the camera is starting
  ///
  /// In en, this message translates to:
  /// **'Initializing camera...'**
  String get scanInitializingCamera;

  /// Shown while the live camera picture is starting
  ///
  /// In en, this message translates to:
  /// **'Initializing camera feed...'**
  String get scanInitializingFeed;

  /// Tooltip on the camera light button
  ///
  /// In en, this message translates to:
  /// **'Flashlight / Torch'**
  String get scanTorchTooltip;

  /// Tooltip on the button that shows the zoom slider
  ///
  /// In en, this message translates to:
  /// **'Zoom slider'**
  String get scanZoomTooltip;

  /// Tooltip on the button that switches between front and back cameras
  ///
  /// In en, this message translates to:
  /// **'Flip Camera (Front/Back)'**
  String get scanFlipCameraTooltip;

  /// A zoom level, for example 2.5x
  ///
  /// In en, this message translates to:
  /// **'{value}x'**
  String scanZoomValue(String value);

  /// Instruction shown over the camera picture
  ///
  /// In en, this message translates to:
  /// **'Position QR code or barcode within the frame'**
  String get scanViewfinderHint;

  /// Shown when camera permission is missing on the scanner screen
  ///
  /// In en, this message translates to:
  /// **'Camera permission required'**
  String get scanCameraPermissionRequired;

  /// Short confirmation shown on a button right after copying
  ///
  /// In en, this message translates to:
  /// **'Copied!'**
  String get copiedLabel;

  /// Tooltip on a button that hides secret text
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get hideAction;

  /// Tooltip on a button that shows secret text
  ///
  /// In en, this message translates to:
  /// **'Reveal'**
  String get revealAction;

  /// Button that opens a link despite a safety warning
  ///
  /// In en, this message translates to:
  /// **'Open Anyway'**
  String get openAnywayButton;

  /// Title of the screen showing what was scanned
  ///
  /// In en, this message translates to:
  /// **'Scan Result'**
  String get resultScreenTitle;

  /// Shown when the screen opens with nothing scanned
  ///
  /// In en, this message translates to:
  /// **'No result'**
  String get resultNoResult;

  /// Label above the scanned content
  ///
  /// In en, this message translates to:
  /// **'Content:'**
  String get resultContentLabel;

  /// Label above the visible content of a code that also hides a secret
  ///
  /// In en, this message translates to:
  /// **'Public Decoy Content:'**
  String get resultDecoyContentLabel;

  /// Label above the kind of code that was scanned
  ///
  /// In en, this message translates to:
  /// **'Detected Type:'**
  String get resultDetectedType;

  /// Type name for a code that carries a hidden encrypted layer
  ///
  /// In en, this message translates to:
  /// **'STEGO-QR (Encrypted Dual-Layer)'**
  String get resultTypeStego;

  /// Button that runs the link safety checks again
  ///
  /// In en, this message translates to:
  /// **'Re-check'**
  String get resultRecheckButton;

  /// Button that opens the scanned link in a browser
  ///
  /// In en, this message translates to:
  /// **'Open in Browser'**
  String get resultOpenInBrowser;

  /// Button that copies the scanned content
  ///
  /// In en, this message translates to:
  /// **'Copy Text'**
  String get resultCopyText;

  /// Button that copies the visible content of a code hiding a secret
  ///
  /// In en, this message translates to:
  /// **'Copy Decoy Text'**
  String get resultCopyDecoyText;

  /// Button that shares the scanned content
  ///
  /// In en, this message translates to:
  /// **'Share Text'**
  String get resultShareText;

  /// Button that shares the visible content of a code hiding a secret
  ///
  /// In en, this message translates to:
  /// **'Share Decoy Text'**
  String get resultShareDecoyText;

  /// Button that returns to the camera to scan again
  ///
  /// In en, this message translates to:
  /// **'Scan Another Code'**
  String get resultScanAnother;

  /// Message shown when a link could not be opened
  ///
  /// In en, this message translates to:
  /// **'Could not launch URL'**
  String get resultLaunchFailed;

  /// Shown after the hidden secret layer has been unlocked
  ///
  /// In en, this message translates to:
  /// **'The hidden AES-256 encrypted payload has been decrypted successfully.'**
  String get stegoUnlockedMessage;

  /// Shown when a code hides a secret that is still locked
  ///
  /// In en, this message translates to:
  /// **'This QR code contains a hidden, encrypted secret layer. Authenticate to view the hidden payload.'**
  String get stegoLockedMessage;

  /// Button that unlocks the secret using fingerprint or face
  ///
  /// In en, this message translates to:
  /// **'Biometric Unlock'**
  String get stegoBiometricUnlock;

  /// Button and field label for the secret password
  ///
  /// In en, this message translates to:
  /// **'Passphrase'**
  String get stegoPassphrase;

  /// Label above the unlocked secret content
  ///
  /// In en, this message translates to:
  /// **'Secret Payload:'**
  String get stegoSecretPayload;

  /// Button that copies the unlocked secret
  ///
  /// In en, this message translates to:
  /// **'Copy Secret'**
  String get stegoCopySecret;

  /// Button that shares the unlocked secret
  ///
  /// In en, this message translates to:
  /// **'Share Secret'**
  String get stegoShareSecret;

  /// Message shown after the secret is copied
  ///
  /// In en, this message translates to:
  /// **'Secret copied to clipboard'**
  String get stegoSecretCopied;

  /// Title of the unlock dialog when fingerprint or face is also used
  ///
  /// In en, this message translates to:
  /// **'Biometric + Passphrase'**
  String get stegoDialogTitleBiometric;

  /// Title of the unlock dialog when only the password is used
  ///
  /// In en, this message translates to:
  /// **'Enter Passphrase'**
  String get stegoDialogTitlePassphrase;

  /// Explanation in the unlock dialog when fingerprint or face is also used
  ///
  /// In en, this message translates to:
  /// **'Confirm passphrase to authenticate with biometrics and decrypt payload.'**
  String get stegoDialogMessageBiometric;

  /// Explanation in the unlock dialog when only the password is used
  ///
  /// In en, this message translates to:
  /// **'Enter the passphrase used to encrypt the secret payload.'**
  String get stegoDialogMessagePassphrase;

  /// Button that confirms the unlock dialog
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get stegoUnlockButton;

  /// Title shown while the link safety checks are running
  ///
  /// In en, this message translates to:
  /// **'Security Check In Progress'**
  String get safetyCheckInProgress;

  /// Title of the link safety result panel
  ///
  /// In en, this message translates to:
  /// **'URL Security Analysis'**
  String get safetyAnalysisTitle;

  /// Shown under the panel while the checks run
  ///
  /// In en, this message translates to:
  /// **'Analyzing URL security...'**
  String get safetyAnalyzing;

  /// How many safety checks failed
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 security issue detected} other{{count} security issues detected}}'**
  String safetyIssuesDetected(int count);

  /// Shown when every safety check passed
  ///
  /// In en, this message translates to:
  /// **'No issues detected'**
  String get safetyNoIssues;

  /// Advice shown when the link passed the checks but still needs care
  ///
  /// In en, this message translates to:
  /// **'Only open this URL if you trust the source'**
  String get safetyTrustSourceHint;

  /// Warning shown when the link failed one or more checks
  ///
  /// In en, this message translates to:
  /// **'Security issues detected. Do not enter personal information or download files from this URL'**
  String get safetyIssuesWarning;

  /// Heading above the list of individual safety checks
  ///
  /// In en, this message translates to:
  /// **'Security Analysis Results:'**
  String get safetyResultsHeading;

  /// Banner shown when the app contacted the scanned site directly
  ///
  /// In en, this message translates to:
  /// **'Active online checks are ON: SSL, redirect and shortener checks contacted this site directly, exposing your IP address to it. Turn off \"Active online checks\" in Settings to check links privately.'**
  String get probingBannerActive;

  /// Banner shown when the app checked the link without contacting the site
  ///
  /// In en, this message translates to:
  /// **'Private mode: this link was analysed using local rules and Google Safe Browsing only — the site itself was never contacted, so your IP and device were not exposed. Enable \"Active online checks\" in Settings for live SSL/redirect verification.'**
  String get probingBannerPrivate;

  /// Title of the dialog shown before opening a risky link
  ///
  /// In en, this message translates to:
  /// **'Security Warning'**
  String get warningDialogTitle;

  /// Warning shown before opening a link that failed the checks
  ///
  /// In en, this message translates to:
  /// **'This URL has security issues. Opening it may put your device or data at risk.\n\nAre you sure you want to proceed?'**
  String get warningDialogMessage;

  /// Title of the dialog shown before opening any scanned link
  ///
  /// In en, this message translates to:
  /// **'Caution'**
  String get cautionDialogTitle;

  /// Advice shown before opening a link that passed the checks
  ///
  /// In en, this message translates to:
  /// **'Always verify the source before opening URLs from QR codes.\n\nDo you want to open this URL?'**
  String get cautionDialogMessage;

  /// Name of the laser line scan overlay style
  ///
  /// In en, this message translates to:
  /// **'Laser Line'**
  String get overlayLaserLine;

  /// Name of the pulsing corners scan overlay style
  ///
  /// In en, this message translates to:
  /// **'Pulsing Corners'**
  String get overlayPulsingCorners;

  /// Name of the grid scan overlay style
  ///
  /// In en, this message translates to:
  /// **'Cybernetic Grid'**
  String get overlayCyberneticGrid;

  /// Name of the dot matrix scan overlay style
  ///
  /// In en, this message translates to:
  /// **'Subtle Dot Matrix'**
  String get overlaySubtleDotMatrix;

  /// Explanation of the laser line overlay style
  ///
  /// In en, this message translates to:
  /// **'Scanning box with an animated vertical laser beam and glow line'**
  String get overlayLaserLineDesc;

  /// Explanation of the pulsing corners overlay style
  ///
  /// In en, this message translates to:
  /// **'Breathing corner reticles with color glow and scale animation'**
  String get overlayPulsingCornersDesc;

  /// Explanation of the grid overlay style
  ///
  /// In en, this message translates to:
  /// **'Sci-fi grid overlay pattern with target crosshair reticle'**
  String get overlayCyberneticGridDesc;

  /// Explanation of the dot matrix overlay style
  ///
  /// In en, this message translates to:
  /// **'Minimalist corner dot matrix pattern with pulsing accents'**
  String get overlaySubtleDotMatrixDesc;

  /// Theme setting that follows the device
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get themeSystemDefault;

  /// Light theme setting
  ///
  /// In en, this message translates to:
  /// **'Light Theme'**
  String get themeLight;

  /// Dark theme setting
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get themeDark;

  /// Pure black theme setting for OLED screens
  ///
  /// In en, this message translates to:
  /// **'OLED Pure Black'**
  String get themeOled;

  /// Heading above the theme choice buttons
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get themeModeHeading;

  /// Short theme button that follows the device
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeChipSystem;

  /// Short theme button for the light theme
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeChipLight;

  /// Short theme button for the dark theme
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeChipDark;

  /// Short theme button for the pure black theme
  ///
  /// In en, this message translates to:
  /// **'OLED'**
  String get themeChipOled;

  /// Setting that takes colours from the device wallpaper
  ///
  /// In en, this message translates to:
  /// **'Material You Dynamic Colors'**
  String get themeDynamicColorsTitle;

  /// Explanation of the wallpaper colour setting
  ///
  /// In en, this message translates to:
  /// **'Sample system wallpaper colors on Android 12+ (Monet engine)'**
  String get themeDynamicColorsSubtitle;

  /// Explanation shown for the system theme
  ///
  /// In en, this message translates to:
  /// **'Follow System Settings'**
  String get themeDescSystem;

  /// Explanation shown for the light theme
  ///
  /// In en, this message translates to:
  /// **'Standard Light Mode'**
  String get themeDescLight;

  /// Explanation shown for the dark theme
  ///
  /// In en, this message translates to:
  /// **'Standard Dark Mode'**
  String get themeDescDark;

  /// Explanation shown for the pure black theme
  ///
  /// In en, this message translates to:
  /// **'True OLED Pure Black (Battery Saving)'**
  String get themeDescOled;

  /// Title of the settings screen
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Settings card that opens the theme options
  ///
  /// In en, this message translates to:
  /// **'Appearance & Theme'**
  String get settingsAppearanceTitle;

  /// Settings card that opens the scan overlay options
  ///
  /// In en, this message translates to:
  /// **'Customizable Scan Overlay'**
  String get settingsOverlayTitle;

  /// Settings card that opens the vibration and sound options
  ///
  /// In en, this message translates to:
  /// **'Scan Feedback & Alerts'**
  String get settingsFeedbackTitle;

  /// Settings card that opens the privacy options
  ///
  /// In en, this message translates to:
  /// **'Privacy & Online Probing'**
  String get settingsPrivacyTitle;

  /// Settings card that opens the Safe Browsing key options
  ///
  /// In en, this message translates to:
  /// **'Google Safe Browsing API'**
  String get settingsSafeBrowsingTitle;

  /// Settings card that opens the permissions overview
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get settingsPermissionsTitle;

  /// Explanation under the permissions card
  ///
  /// In en, this message translates to:
  /// **'Explicit, implicit & setting-dependent details'**
  String get settingsPermissionsSubtitle;

  /// Settings card that opens the feature guides
  ///
  /// In en, this message translates to:
  /// **'Help & Feature Guides'**
  String get settingsHelpTitle;

  /// Explanation under the help card
  ///
  /// In en, this message translates to:
  /// **'AR CodeVision, AirQR, Quishing Guard & URL Safety'**
  String get settingsHelpSubtitle;

  /// Explanation under the about card
  ///
  /// In en, this message translates to:
  /// **'App version, developer & license details'**
  String get settingsAboutSubtitle;

  /// Setting that turns scan vibration on or off
  ///
  /// In en, this message translates to:
  /// **'Vibration Feedback'**
  String get feedbackVibrationTitle;

  /// Explanation of the vibration setting
  ///
  /// In en, this message translates to:
  /// **'Vibrate phone upon successful barcode recognition'**
  String get feedbackVibrationSubtitle;

  /// Setting that turns the scan beep on or off
  ///
  /// In en, this message translates to:
  /// **'Audible Beep Sound'**
  String get feedbackSoundTitle;

  /// Explanation of the beep setting
  ///
  /// In en, this message translates to:
  /// **'Play audio beep signal upon successful code recognition'**
  String get feedbackSoundSubtitle;

  /// Title of the privacy settings screen
  ///
  /// In en, this message translates to:
  /// **'Privacy & Network Probing'**
  String get privacyScreenTitle;

  /// Setting that allows contacting the scanned site directly
  ///
  /// In en, this message translates to:
  /// **'Active online checks'**
  String get privacyActiveChecksTitle;

  /// Summary shown on the settings card when online checks are on
  ///
  /// In en, this message translates to:
  /// **'Active online checks enabled'**
  String get privacySummaryOn;

  /// Summary shown on the settings card when online checks are off
  ///
  /// In en, this message translates to:
  /// **'Private offline checks only'**
  String get privacySummaryOff;

  /// Shown when a Safe Browsing key is saved
  ///
  /// In en, this message translates to:
  /// **'Configured'**
  String get apiKeyConfigured;

  /// Shown when no Safe Browsing key is saved
  ///
  /// In en, this message translates to:
  /// **'Not configured'**
  String get apiKeyNotConfigured;

  /// Message shown after the key is saved
  ///
  /// In en, this message translates to:
  /// **'API key saved securely'**
  String get apiKeySaved;

  /// Message shown after the key is deleted
  ///
  /// In en, this message translates to:
  /// **'API key deleted'**
  String get apiKeyDeleted;

  /// Title of the dialog and button for deleting the key
  ///
  /// In en, this message translates to:
  /// **'Delete API Key'**
  String get apiKeyDeleteTitle;

  /// Button that confirms deleting something
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteButton;

  /// Heading of the panel explaining the Safe Browsing service
  ///
  /// In en, this message translates to:
  /// **'About Safe Browsing API'**
  String get apiAboutHeading;

  /// Title shown when a key is in place
  ///
  /// In en, this message translates to:
  /// **'API Key Configured'**
  String get apiKeyConfiguredTitle;

  /// Explanation shown when a key is in place
  ///
  /// In en, this message translates to:
  /// **'Malicious URL checking is enabled'**
  String get apiKeyConfiguredSubtitle;

  /// Shown when the free daily lookups are used up
  ///
  /// In en, this message translates to:
  /// **'Daily limit reached. Resets tomorrow.'**
  String get apiLimitReached;

  /// Shown when few free daily lookups are left
  ///
  /// In en, this message translates to:
  /// **'Approaching daily limit'**
  String get apiLimitApproaching;

  /// Label of the field holding the Safe Browsing key
  ///
  /// In en, this message translates to:
  /// **'API Key'**
  String get apiKeyFieldLabel;

  /// Hint inside the empty key field
  ///
  /// In en, this message translates to:
  /// **'Enter your Google Safe Browsing API key'**
  String get apiKeyFieldHint;

  /// Validation message when the key field is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter an API key'**
  String get apiKeyRequired;

  /// Validation message when the key looks wrong
  ///
  /// In en, this message translates to:
  /// **'API key appears to be too short'**
  String get apiKeyTooShort;

  /// Button that stores the key
  ///
  /// In en, this message translates to:
  /// **'Save API Key'**
  String get apiKeySaveButton;

  /// Heading of the step-by-step key instructions
  ///
  /// In en, this message translates to:
  /// **'How to get an API key'**
  String get apiHowToHeading;

  /// First step of getting a key
  ///
  /// In en, this message translates to:
  /// **'Go to Google Cloud Console'**
  String get apiStep1Title;

  /// Explanation of the first step
  ///
  /// In en, this message translates to:
  /// **'Visit console.cloud.google.com'**
  String get apiStep1Desc;

  /// Second step of getting a key
  ///
  /// In en, this message translates to:
  /// **'Create or select a project'**
  String get apiStep2Title;

  /// Explanation of the second step
  ///
  /// In en, this message translates to:
  /// **'Choose an existing project or create a new one'**
  String get apiStep2Desc;

  /// Third step of getting a key
  ///
  /// In en, this message translates to:
  /// **'Enable Safe Browsing API'**
  String get apiStep3Title;

  /// Fourth step of getting a key
  ///
  /// In en, this message translates to:
  /// **'Create credentials'**
  String get apiStep4Title;

  /// Explanation of the fourth step
  ///
  /// In en, this message translates to:
  /// **'Go to Credentials → Create Credentials → API Key'**
  String get apiStep4Desc;

  /// Fifth step of getting a key
  ///
  /// In en, this message translates to:
  /// **'Copy and paste'**
  String get apiStep5Title;

  /// Explanation of the fifth step
  ///
  /// In en, this message translates to:
  /// **'Copy the generated API key and paste it above'**
  String get apiStep5Desc;

  /// Note about the free daily allowance
  ///
  /// In en, this message translates to:
  /// **'Free tier includes 10,000 requests per day'**
  String get apiFreeTierNote;

  /// Title of the permissions screen
  ///
  /// In en, this message translates to:
  /// **'Permissions Overview'**
  String get permissionsScreenTitle;

  /// Heading for permissions the user is asked for
  ///
  /// In en, this message translates to:
  /// **'Explicit Permissions (Runtime / Manifest)'**
  String get permissionsExplicitHeading;

  /// Name of the camera permission
  ///
  /// In en, this message translates to:
  /// **'Camera Access (android.permission.CAMERA)'**
  String get permissionCameraTitle;

  /// What the camera permission is used for
  ///
  /// In en, this message translates to:
  /// **'Requested on-demand at point of use. Required for live scanning, AR CodeVision HUD overlay, and AirQR optical stream decoding.'**
  String get permissionCameraDesc;

  /// Name of the fingerprint and face permission
  ///
  /// In en, this message translates to:
  /// **'Biometric Authentication (android.permission.USE_BIOMETRIC)'**
  String get permissionBiometricTitle;

  /// What the biometric permission is used for
  ///
  /// In en, this message translates to:
  /// **'Requested when unlocking biometric secure vaults or encrypted QR code payloads.'**
  String get permissionBiometricDesc;

  /// Heading for permissions granted by the system
  ///
  /// In en, this message translates to:
  /// **'Implicit & System Permissions'**
  String get permissionsImplicitHeading;

  /// Name of the internet permission
  ///
  /// In en, this message translates to:
  /// **'Internet Access (android.permission.INTERNET)'**
  String get permissionInternetTitle;

  /// What the internet permission is used for
  ///
  /// In en, this message translates to:
  /// **'Declared in Android Manifest. Used only when Active Online Probing or Google Safe Browsing API lookup is enabled.'**
  String get permissionInternetDesc;

  /// Name of the vibration permission
  ///
  /// In en, this message translates to:
  /// **'Vibration & Haptics (android.permission.VIBRATE)'**
  String get permissionVibrateTitle;

  /// What the vibration permission is used for
  ///
  /// In en, this message translates to:
  /// **'System permission. Triggers haptic vibration feedback during scan alerts and button taps.'**
  String get permissionVibrateDesc;

  /// Name of the photo picker access
  ///
  /// In en, this message translates to:
  /// **'Scoped Media Photo Picker'**
  String get permissionPhotoPickerTitle;

  /// What the photo picker access is used for
  ///
  /// In en, this message translates to:
  /// **'System photo picker access. Allows selecting QR images or videos from gallery without requesting full storage access.'**
  String get permissionPhotoPickerDesc;

  /// Heading for permissions that depend on a setting
  ///
  /// In en, this message translates to:
  /// **'Setting-Dependent Permissions'**
  String get permissionsSettingHeading;

  /// Name of the active online checks setting
  ///
  /// In en, this message translates to:
  /// **'Active Online Probing (Privacy Setting)'**
  String get permissionProbingTitle;

  /// What active online checks do
  ///
  /// In en, this message translates to:
  /// **'Active only when enabled. Performs outbound HTTP HEAD requests to follow URL redirects and check SSL certificates. When disabled, checks are 100% offline.'**
  String get permissionProbingDesc;

  /// Name of the Safe Browsing lookup setting
  ///
  /// In en, this message translates to:
  /// **'Google Safe Browsing API (API Key Setting)'**
  String get permissionSafeBrowsingTitle;

  /// What the Safe Browsing lookup does
  ///
  /// In en, this message translates to:
  /// **'Active only when API key is configured. Queries Google Threat API for malware & phishing checks.'**
  String get permissionSafeBrowsingDesc;

  /// Name of the scan vibration setting
  ///
  /// In en, this message translates to:
  /// **'Scan Feedback Vibrations (Alert Setting)'**
  String get permissionFeedbackTitle;

  /// When scan vibration is used
  ///
  /// In en, this message translates to:
  /// **'Active only when Vibration is enabled in Scan Feedback & Alerts settings.'**
  String get permissionFeedbackDesc;

  /// Badge on the AR CodeVision help card
  ///
  /// In en, this message translates to:
  /// **'Augmented Reality'**
  String get helpArBadge;

  /// Summary of the AR CodeVision feature
  ///
  /// In en, this message translates to:
  /// **'Real-time camera overlay feature that highlights and visualizes barcode and QR code data directly within the 3D viewfinder.'**
  String get helpArDesc;

  /// AR CodeVision capability
  ///
  /// In en, this message translates to:
  /// **'Multi-Target Detection: Automatically detects, indexes, and tracks multiple barcodes simultaneously in real time.'**
  String get helpArPoint1;

  /// AR CodeVision capability
  ///
  /// In en, this message translates to:
  /// **'Spatial Bounding Boxes: Overlays dynamic AR reticles and interactive floating chips above each detected code.'**
  String get helpArPoint2;

  /// AR CodeVision capability
  ///
  /// In en, this message translates to:
  /// **'Interactive Action Sheet: Tap any detected AR chip to inspect payload details, copy data, or execute smart actions without exiting the camera.'**
  String get helpArPoint3;

  /// AR CodeVision capability
  ///
  /// In en, this message translates to:
  /// **'Camera Viewport Suite: Built-in torch toggle, front/rear camera switching, and pinch-to-zoom controls.'**
  String get helpArPoint4;

  /// Badge on the AirQR help card
  ///
  /// In en, this message translates to:
  /// **'Optical Data Protocol'**
  String get helpAirQrBadge;

  /// Summary of the AirQR feature
  ///
  /// In en, this message translates to:
  /// **'High-speed optical data transfer receiver designed to reconstruct large multi-part payloads serialized across animated QR code loops.'**
  String get helpAirQrDesc;

  /// AirQR capability
  ///
  /// In en, this message translates to:
  /// **'Sequential Frame Assembly: Scans animated QR streams (AirQR format) frame-by-frame and stitches chunks back into complete files or text.'**
  String get helpAirQrPoint1;

  /// AirQR capability
  ///
  /// In en, this message translates to:
  /// **'Real-Time Live Progress: Interactive progress indicator displaying completed percentage, total payload size, missing chunk count, and decoding speed.'**
  String get helpAirQrPoint2;

  /// AirQR capability
  ///
  /// In en, this message translates to:
  /// **'Dual Input Modes: Supports live scanning through the camera feed or offline processing by importing saved video recordings/images from gallery.'**
  String get helpAirQrPoint3;

  /// AirQR capability
  ///
  /// In en, this message translates to:
  /// **'AirQR Transmitter: Reverse mode allowing payload generation and animated QR stream transmission to other devices.'**
  String get helpAirQrPoint4;

  /// Title of the tamper check help card
  ///
  /// In en, this message translates to:
  /// **'Quishing Guard (Physical QR Sticker Tamper Check)'**
  String get helpQuishingTitle;

  /// Badge on the tamper check help card
  ///
  /// In en, this message translates to:
  /// **'On-Device Computer Vision'**
  String get helpQuishingBadge;

  /// Summary of the tamper check feature
  ///
  /// In en, this message translates to:
  /// **'On-device computer vision engine that detects physical QR code sticker tampering, fake code overlays, and print alterations before processing payloads.'**
  String get helpQuishingDesc;

  /// Tamper check capability
  ///
  /// In en, this message translates to:
  /// **'100% Offline & Private Guarantee: Operates entirely on-device using local camera frame computer vision with zero internet connection required.'**
  String get helpQuishingPoint1;

  /// Tamper check capability
  ///
  /// In en, this message translates to:
  /// **'Physical Sticker & Overlay Detection: Identifies physical stickers pasted over legitimate printed QR codes.'**
  String get helpQuishingPoint2;

  /// Tamper check capability
  ///
  /// In en, this message translates to:
  /// **'Edge & Alignment Anomaly Analysis: Checks for suspicious boundaries, cutouts, and alignment discrepancies.'**
  String get helpQuishingPoint3;

  /// Tamper check capability
  ///
  /// In en, this message translates to:
  /// **'Print Texture & Contrast Verification: Analyzes visual print artifacts, reflectivity shifts, and paper texture inconsistencies.'**
  String get helpQuishingPoint4;

  /// Title of the link safety help card
  ///
  /// In en, this message translates to:
  /// **'URL Safety & Link Tamper Engine'**
  String get helpUrlTitle;

  /// Badge on the link safety help card
  ///
  /// In en, this message translates to:
  /// **'6-Layer Digital Safety'**
  String get helpUrlBadge;

  /// Summary of the link safety feature
  ///
  /// In en, this message translates to:
  /// **'Comprehensive digital link analysis suite protecting against malicious web links, phishing (Quishing), and URL payload tampering.'**
  String get helpUrlDesc;

  /// Link safety capability
  ///
  /// In en, this message translates to:
  /// **'Homograph & IDN Attack Detection: Identifies spoofed domain names using mixed-script Cyrillic or lookalike Unicode characters.'**
  String get helpUrlPoint1;

  /// Link safety capability
  ///
  /// In en, this message translates to:
  /// **'Zero-Width Space & Character Tamper Detector: Detects hidden zero-width spaces, non-printable control characters, or obfuscated payloads embedded in links.'**
  String get helpUrlPoint2;

  /// Link safety capability
  ///
  /// In en, this message translates to:
  /// **'IP Literal & Userinfo Verification: Flags suspicious IP address hostnames and dangerous embedded credentials (e.g. user:pass@host).'**
  String get helpUrlPoint3;

  /// Link safety capability
  ///
  /// In en, this message translates to:
  /// **'Suspicious TLD & Pattern Analysis: Scans for risky top-level domains, excessive subdomains, and unencrypted HTTP connections carrying login/payment data.'**
  String get helpUrlPoint4;

  /// Link safety capability
  ///
  /// In en, this message translates to:
  /// **'URL Shortener Unrolling & Redirect Tracing: Identifies shortened links (bit.ly, t.co) and traces redirect chains (Active Probing required for live HTTP inspection).'**
  String get helpUrlPoint5;

  /// Link safety capability
  ///
  /// In en, this message translates to:
  /// **'Google Safe Browsing Cloud Lookup: Optional cloud check against Google threat database when configured with an API key.'**
  String get helpUrlPoint6;

  /// Link safety capability
  ///
  /// In en, this message translates to:
  /// **'Privacy First Guarantee: Core 5 pattern checks run 100% offline on your device without sending URLs anywhere.'**
  String get helpUrlPoint7;

  /// Heading above the list of what a feature can do
  ///
  /// In en, this message translates to:
  /// **'Key Capabilities:'**
  String get helpCapabilitiesHeading;

  /// Word shown when a setting is turned on
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get onLabel;

  /// Word shown when a setting is turned off
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get offLabel;

  /// Shown when a value is not known
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownLabel;

  /// Explanation under the active online checks switch
  ///
  /// In en, this message translates to:
  /// **'Off: scanned links are checked privately — the destination server is never contacted.'**
  String get privacyActiveChecksSubtitle;

  /// Longer explanation shown when active online checks are on
  ///
  /// In en, this message translates to:
  /// **'When on, the SSL, redirect and shortener checks connect directly to the scanned site. This exposes your IP address (and therefore your approximate location and mobile carrier) to that server before you open the link.'**
  String get privacyExplainerOn;

  /// Longer explanation shown when active online checks are off
  ///
  /// In en, this message translates to:
  /// **'SSL, redirect and shortener checks run from local rules only. Malicious-content lookup still uses Google Safe Browsing (the link is sent only to Google, never to the scanned site).'**
  String get privacyExplainerOff;

  /// Warning shown before the Safe Browsing key is deleted
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your Google Safe Browsing API key? URL malicious content checking will be disabled.'**
  String get apiKeyDeleteMessage;

  /// Explanation of what the Safe Browsing service does
  ///
  /// In en, this message translates to:
  /// **'The Google Safe Browsing API helps detect malicious URLs including phishing, malware, and unwanted software. Your API key is stored securely and encrypted on your device.'**
  String get apiAboutBody;

  /// Heading above how many lookups were used today
  ///
  /// In en, this message translates to:
  /// **'Today\'s Usage'**
  String get apiTodaysUsage;

  /// Explanation of the third step of getting a key
  ///
  /// In en, this message translates to:
  /// **'Search for \"Safe Browsing API\" and enable it'**
  String get apiStep3Desc;

  /// Summary of the scan feedback settings shown on the settings card
  ///
  /// In en, this message translates to:
  /// **'Vibration: {vibration} • Sound: {sound}'**
  String feedbackSummary(String vibration, String sound);

  /// Whether a Safe Browsing key is saved, shown on the settings card
  ///
  /// In en, this message translates to:
  /// **'API Key: {status}'**
  String settingsApiKeySubtitle(String status);

  /// Message shown when the key could not be saved
  ///
  /// In en, this message translates to:
  /// **'Error saving API key: {error}'**
  String apiKeySaveFailed(String error);

  /// Message shown when the key could not be deleted
  ///
  /// In en, this message translates to:
  /// **'Error deleting API key: {error}'**
  String apiKeyDeleteFailed(String error);

  /// How many free lookups are allowed each day
  ///
  /// In en, this message translates to:
  /// **'Daily Limit: {count} requests per day'**
  String apiDailyLimit(int count);

  /// When the daily lookup count starts again
  ///
  /// In en, this message translates to:
  /// **'Resets: {date}'**
  String apiResets(String date);

  /// Type label shown when the scanned code is plain text
  ///
  /// In en, this message translates to:
  /// **'TEXT'**
  String get resultTypeTextFallback;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
