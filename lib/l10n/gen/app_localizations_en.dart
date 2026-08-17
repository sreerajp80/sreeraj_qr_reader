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
}
