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
