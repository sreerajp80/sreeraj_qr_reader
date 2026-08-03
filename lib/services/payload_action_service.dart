import 'package:url_launcher/url_launcher.dart';
import 'package:sreeraj_qr_reader/models/parsed_payload.dart';

/// Helper service for performing native 1-tap actions on parsed QR payloads.
class PayloadActionService {
  /// Opens system Wi-Fi settings or Wi-Fi configuration screen.
  static Future<bool> openWifiSettings() async {
    final intentUri = Uri.parse(
      'intent:#Intent;action=android.settings.WIFI_SETTINGS;end',
    );
    if (await canLaunchUrl(intentUri)) {
      return await launchUrl(intentUri, mode: LaunchMode.externalApplication);
    }
    // Fallback to settings URI
    final settingsUri = Uri.parse('android.settings.WIFI_SETTINGS');
    if (await canLaunchUrl(settingsUri)) {
      return await launchUrl(settingsUri, mode: LaunchMode.externalApplication);
    }
    return false;
  }

  /// Opens Google Maps with coordinates.
  static Future<bool> openGoogleMaps(GeoPayload geo) async {
    final mapsUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${geo.latitude},${geo.longitude}',
    );
    if (await canLaunchUrl(mapsUrl)) {
      return await launchUrl(mapsUrl, mode: LaunchMode.externalApplication);
    }
    final geoUri = Uri.parse('geo:${geo.latitude},${geo.longitude}');
    if (await canLaunchUrl(geoUri)) {
      return await launchUrl(geoUri, mode: LaunchMode.externalApplication);
    }
    return false;
  }

  /// Launches device contact card insertion or phone/email intents.
  static Future<bool> saveContact(ContactPayload contact) async {
    // Android Insert Contact Intent
    final nameEncoded = Uri.encodeComponent(contact.name);
    final phoneEncoded = contact.phones.isNotEmpty
        ? Uri.encodeComponent(contact.phones.first.value)
        : '';
    final emailEncoded = contact.emails.isNotEmpty
        ? Uri.encodeComponent(contact.emails.first.value)
        : '';

    final intentUri = Uri.parse(
      'intent:#Intent;action=android.intent.action.INSERT;type=vnd.android.cursor.dir/contact;'
      's.name=$nameEncoded;s.phone=$phoneEncoded;s.email=$emailEncoded;end',
    );

    if (await canLaunchUrl(intentUri)) {
      return await launchUrl(intentUri, mode: LaunchMode.externalApplication);
    }

    if (contact.phones.isNotEmpty) {
      final telUri = Uri.parse('tel:${contact.phones.first.value}');
      if (await canLaunchUrl(telUri)) {
        return await launchUrl(telUri, mode: LaunchMode.externalApplication);
      }
    }
    return false;
  }

  /// Adds event to device calendar via Google Calendar template URL or system intent.
  static Future<bool> addToCalendar(CalendarPayload calendar) async {
    String formatCalDate(DateTime? dt) {
      if (dt == null) return '';
      return '${dt.toUtc().toString().replaceAll(RegExp(r'[^0-9]'), '').substring(0, 15)}Z';
    }

    final startStr = formatCalDate(calendar.dtStart ?? DateTime.now());
    final endStr = formatCalDate(
      calendar.dtEnd ??
          (calendar.dtStart ?? DateTime.now()).add(const Duration(hours: 1)),
    );

    final calUrl = Uri.parse(
      'https://calendar.google.com/calendar/render?action=TEMPLATE'
      '&text=${Uri.encodeComponent(calendar.summary)}'
      '&details=${Uri.encodeComponent(calendar.description)}'
      '&location=${Uri.encodeComponent(calendar.location)}'
      '&dates=$startStr/$endStr',
    );

    if (await canLaunchUrl(calUrl)) {
      return await launchUrl(calUrl, mode: LaunchMode.externalApplication);
    }
    return false;
  }

  /// Launches payment app deep link (UPI, Crypto, SEPA).
  static Future<bool> payViaApp(PaymentPayload payment) async {
    final uri = Uri.tryParse(payment.rawContent);
    if (uri == null) return false;
    try {
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      // Fallback direct launch attempt for custom deep link schemes
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }

  /// Imports TOTP payload into an authenticator app (Google Authenticator, Authy, etc.).
  static Future<bool> importToAuthenticator(TotpPayload totp) async {
    final uri = Uri.tryParse(totp.rawContent);
    if (uri == null) return false;
    try {
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }
}
