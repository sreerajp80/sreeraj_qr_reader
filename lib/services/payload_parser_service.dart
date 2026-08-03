import 'package:sreeraj_qr_reader/models/parsed_payload.dart';

/// Robust service that parses raw QR barcode strings into structured [ParsedPayload] objects.
class PayloadParserService {
  /// Parses any scanned string content safely without throwing errors.
  ParsedPayload parse(String content) {
    final trimmed = content.trim();
    if (trimmed.isEmpty) {
      return GenericPayload(content);
    }

    try {
      // 1. Wi-Fi QR
      if (trimmed.toUpperCase().startsWith('WIFI:')) {
        final wifi = _parseWifi(trimmed);
        if (wifi != null) return wifi;
      }

      // 2. 2FA / TOTP
      if (trimmed.toLowerCase().startsWith('otpauth://')) {
        final totp = _parseTotp(trimmed);
        if (totp != null) return totp;
      }

      // 3. Geographic Location
      if (trimmed.toLowerCase().startsWith('geo:')) {
        final geo = _parseGeo(trimmed);
        if (geo != null) return geo;
      }

      // 4. Payment Code (UPI, Crypto, SEPA)
      if (trimmed.toLowerCase().startsWith('upi://pay') ||
          trimmed.toLowerCase().startsWith('bitcoin:') ||
          trimmed.toLowerCase().startsWith('ethereum:') ||
          trimmed.toLowerCase().startsWith('solana:') ||
          trimmed.toUpperCase().startsWith('BCD\n') ||
          trimmed.toLowerCase().startsWith('sepa:')) {
        final payment = _parsePayment(trimmed);
        if (payment != null) return payment;
      }

      // 5. Calendar Event (iCalendar / VEVENT)
      if (trimmed.toUpperCase().contains('BEGIN:VEVENT') ||
          trimmed.toUpperCase().contains('BEGIN:VCALENDAR')) {
        final calendar = _parseCalendar(trimmed);
        if (calendar != null) return calendar;
      }

      // 6. Contact Card (vCard / MeCard)
      if (trimmed.toUpperCase().contains('BEGIN:VCARD') ||
          trimmed.toUpperCase().startsWith('MECARD:')) {
        final contact = _parseContact(trimmed);
        if (contact != null) return contact;
      }
    } catch (_) {
      // Safe fallback on any unexpected format
    }

    return GenericPayload(content);
  }

  // --- Wi-Fi Parser ---
  WifiPayload? _parseWifi(String raw) {
    final body = raw.substring(5);
    String ssid = '';
    String securityType = 'WPA';
    String password = '';
    bool isHidden = false;

    final tokens = _splitEscaped(body, ';');
    for (final token in tokens) {
      if (token.startsWith('S:')) {
        ssid = _unescape(token.substring(2));
      } else if (token.startsWith('T:')) {
        securityType = _unescape(token.substring(2));
      } else if (token.startsWith('P:')) {
        password = _unescape(token.substring(2));
      } else if (token.startsWith('H:')) {
        isHidden = _unescape(token.substring(2)).toLowerCase() == 'true';
      }
    }

    if (ssid.isEmpty && password.isEmpty) return null;
    return WifiPayload(
      rawContent: raw,
      ssid: ssid.isEmpty ? 'Hidden Network' : ssid,
      securityType: securityType.isEmpty ? 'WPA' : securityType,
      password: password,
      isHidden: isHidden,
    );
  }

  // --- 2FA TOTP Parser ---
  TotpPayload? _parseTotp(String raw) {
    final uri = Uri.tryParse(raw);
    if (uri == null || !uri.hasScheme || uri.scheme != 'otpauth') return null;

    final host = uri.host.toLowerCase(); // totp or hotp
    if (host != 'totp') return null;

    String path = Uri.decodeComponent(uri.path);
    if (path.startsWith('/')) path = path.substring(1);

    String accountName = path;
    String issuer = uri.queryParameters['issuer'] ?? '';

    if (path.contains(':')) {
      final parts = path.split(':');
      if (issuer.isEmpty) issuer = parts[0].trim();
      accountName = parts.sublist(1).join(':').trim();
    }

    final secret = uri.queryParameters['secret'] ?? '';
    if (secret.isEmpty) return null;

    final algorithm = uri.queryParameters['algorithm']?.toUpperCase() ?? 'SHA1';
    final digits = int.tryParse(uri.queryParameters['digits'] ?? '6') ?? 6;
    final period = int.tryParse(uri.queryParameters['period'] ?? '30') ?? 30;

    return TotpPayload(
      rawContent: raw,
      accountName: accountName.isEmpty ? 'Account' : accountName,
      issuer: issuer,
      secret: secret,
      algorithm: algorithm,
      digits: digits,
      period: period,
    );
  }

  // --- Geo Parser ---
  GeoPayload? _parseGeo(String raw) {
    // geo:37.7749,-122.4194?q=San+Francisco
    final schemeBody = raw.substring(4);
    final parts = schemeBody.split('?');
    final coordsPart = parts[0];

    final coordTokens = coordsPart.split(',');
    if (coordTokens.length < 2) return null;

    final lat = double.tryParse(coordTokens[0].trim());
    final lng = double.tryParse(coordTokens[1].trim());

    if (lat == null || lng == null) return null;

    String query = '';
    String label = '';

    if (parts.length > 1) {
      final queryParams = Uri.splitQueryString(parts[1]);
      query = queryParams['q'] ?? '';
      label = queryParams['label'] ?? query;
    }

    return GeoPayload(
      rawContent: raw,
      latitude: lat,
      longitude: lng,
      query: query,
      label: label,
    );
  }

  // --- Payment Parser ---
  PaymentPayload? _parsePayment(String raw) {
    if (raw.toLowerCase().startsWith('upi://pay')) {
      final uri = Uri.tryParse(raw);
      if (uri != null) {
        final qp = uri.queryParameters;
        return PaymentPayload(
          rawContent: raw,
          scheme: PaymentScheme.upi,
          payeeName: qp['pn'] ?? qp['pa'] ?? 'UPI Payee',
          payeeAddress: qp['pa'] ?? '',
          amount: qp['am'] ?? '',
          currency: qp['cu'] ?? 'INR',
          transactionNote: qp['tn'] ?? '',
          refId: qp['tr'] ?? qp['refUrl'] ?? '',
        );
      }
    }

    if (raw.toLowerCase().startsWith('bitcoin:') ||
        raw.toLowerCase().startsWith('ethereum:') ||
        raw.toLowerCase().startsWith('solana:')) {
      final schemeStr = raw.split(':')[0].toLowerCase();
      final uri = Uri.tryParse(raw);
      String address = '';
      String amount = '';
      String note = '';

      if (uri != null) {
        address = uri.path;
        amount = uri.queryParameters['amount'] ?? '';
        note =
            uri.queryParameters['label'] ??
            uri.queryParameters['message'] ??
            '';
      }

      return PaymentPayload(
        rawContent: raw,
        scheme: PaymentScheme.crypto,
        payeeName: '${schemeStr.toUpperCase()} Wallet',
        payeeAddress: address,
        amount: amount,
        currency: schemeStr.toUpperCase(),
        transactionNote: note,
      );
    }

    if (raw.toUpperCase().startsWith('BCD\n') ||
        raw.toLowerCase().startsWith('sepa:')) {
      final lines = raw.split('\n');
      String payee = 'SEPA Recipient';
      String iban = '';

      for (final line in lines) {
        if (line.startsWith('IBAN:') ||
            line.startsWith('DE') ||
            line.startsWith('FR')) {
          iban = line.replaceFirst('IBAN:', '').trim();
        } else if (line.length > 5 && payee == 'SEPA Recipient') {
          payee = line.trim();
        }
      }

      return PaymentPayload(
        rawContent: raw,
        scheme: PaymentScheme.sepa,
        payeeName: payee,
        payeeAddress: iban,
        currency: 'EUR',
      );
    }

    return null;
  }

  // --- Calendar Event Parser ---
  CalendarPayload? _parseCalendar(String raw) {
    String summary = '';
    String description = '';
    String location = '';
    DateTime? dtStart;
    DateTime? dtEnd;

    final lines = raw.split(RegExp(r'\r?\n'));
    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.startsWith('SUMMARY:')) {
        summary = trimmed.substring(8);
      } else if (trimmed.startsWith('DESCRIPTION:')) {
        description = trimmed.substring(12);
      } else if (trimmed.startsWith('LOCATION:')) {
        location = trimmed.substring(9);
      } else if (trimmed.startsWith('DTSTART:')) {
        dtStart = _parseICalDate(trimmed.substring(8));
      } else if (trimmed.startsWith('DTSTART;VALUE=DATE:')) {
        dtStart = _parseICalDate(trimmed.substring(19));
      } else if (trimmed.startsWith('DTEND:')) {
        dtEnd = _parseICalDate(trimmed.substring(6));
      } else if (trimmed.startsWith('DTEND;VALUE=DATE:')) {
        dtEnd = _parseICalDate(trimmed.substring(17));
      }
    }

    if (summary.isEmpty && dtStart == null) return null;

    return CalendarPayload(
      rawContent: raw,
      summary: summary.isEmpty ? 'Calendar Event' : summary,
      description: description,
      location: location,
      dtStart: dtStart,
      dtEnd: dtEnd,
      isAllDay: dtStart != null && dtStart.hour == 0 && dtStart.minute == 0,
    );
  }

  // --- Contact Card Parser ---
  ContactPayload? _parseContact(String raw) {
    if (raw.toUpperCase().startsWith('MECARD:')) {
      final body = raw.substring(7);
      String name = '';
      final List<ContactField> phones = [];
      final List<ContactField> emails = [];
      final List<String> addresses = [];
      String note = '';

      final tokens = _splitEscaped(body, ';');
      for (final token in tokens) {
        if (token.startsWith('N:')) {
          name = _unescape(token.substring(2)).replaceAll(',', ' ');
        } else if (token.startsWith('TEL:')) {
          phones.add(
            ContactField(label: 'Phone', value: _unescape(token.substring(4))),
          );
        } else if (token.startsWith('EMAIL:')) {
          emails.add(
            ContactField(label: 'Email', value: _unescape(token.substring(6))),
          );
        } else if (token.startsWith('ADR:')) {
          addresses.add(_unescape(token.substring(4)));
        } else if (token.startsWith('NOTE:')) {
          note = _unescape(token.substring(5));
        }
      }

      return ContactPayload(
        rawContent: raw,
        name: name.isEmpty ? 'Contact' : name,
        phones: phones,
        emails: emails,
        addresses: addresses,
        title: note,
      );
    }

    if (raw.toUpperCase().contains('BEGIN:VCARD')) {
      String name = '';
      final List<ContactField> phones = [];
      final List<ContactField> emails = [];
      final List<String> addresses = [];
      String org = '';
      String title = '';
      String url = '';

      final lines = raw.split(RegExp(r'\r?\n'));
      for (final line in lines) {
        final trimmed = line.trim();
        if (trimmed.startsWith('FN:')) {
          name = trimmed.substring(3);
        } else if (name.isEmpty && trimmed.startsWith('N:')) {
          name = trimmed
              .substring(2)
              .split(';')
              .where((s) => s.isNotEmpty)
              .join(' ');
        } else if (trimmed.contains('TEL')) {
          final idx = trimmed.indexOf(':');
          if (idx != -1) {
            phones.add(
              ContactField(label: 'Phone', value: trimmed.substring(idx + 1)),
            );
          }
        } else if (trimmed.contains('EMAIL')) {
          final idx = trimmed.indexOf(':');
          if (idx != -1) {
            emails.add(
              ContactField(label: 'Email', value: trimmed.substring(idx + 1)),
            );
          }
        } else if (trimmed.startsWith('ORG:')) {
          org = trimmed.substring(4);
        } else if (trimmed.startsWith('TITLE:')) {
          title = trimmed.substring(6);
        } else if (trimmed.startsWith('URL:')) {
          url = trimmed.substring(4);
        } else if (trimmed.startsWith('ADR')) {
          final idx = trimmed.indexOf(':');
          if (idx != -1) {
            addresses.add(
              trimmed.substring(idx + 1).replaceAll(';', ' ').trim(),
            );
          }
        }
      }

      return ContactPayload(
        rawContent: raw,
        name: name.isEmpty ? 'vCard Contact' : name,
        phones: phones,
        emails: emails,
        addresses: addresses,
        organization: org,
        title: title,
        url: url,
      );
    }

    return null;
  }

  // --- Utility Helpers ---
  DateTime? _parseICalDate(String rawStr) {
    final clean = rawStr.replaceAll(RegExp(r'[^0-9T]'), '');
    if (clean.length >= 8) {
      try {
        final year = int.parse(clean.substring(0, 4));
        final month = int.parse(clean.substring(4, 6));
        final day = int.parse(clean.substring(6, 8));

        int hour = 0;
        int minute = 0;
        int second = 0;

        if (clean.length >= 13 && clean.contains('T')) {
          final tIdx = clean.indexOf('T');
          hour = int.parse(clean.substring(tIdx + 1, tIdx + 3));
          minute = int.parse(clean.substring(tIdx + 3, tIdx + 5));
          if (clean.length >= tIdx + 7) {
            second = int.parse(clean.substring(tIdx + 5, tIdx + 7));
          }
        }

        return DateTime(year, month, day, hour, minute, second);
      } catch (_) {}
    }
    return null;
  }

  List<String> _splitEscaped(String source, String delimiter) {
    final List<String> result = [];
    final sb = StringBuffer();
    bool escaped = false;

    for (int i = 0; i < source.length; i++) {
      final char = source[i];
      if (escaped) {
        sb.write(char);
        escaped = false;
      } else if (char == '\\') {
        escaped = true;
      } else if (char == delimiter) {
        result.add(sb.toString());
        sb.clear();
      } else {
        sb.write(char);
      }
    }
    if (sb.isNotEmpty) result.add(sb.toString());
    return result;
  }

  String _unescape(String val) {
    return val
        .replaceAll(r'\;', ';')
        .replaceAll(r'\:', ':')
        .replaceAll(r'\,', ',')
        .replaceAll(r'\\', '\\');
  }
}
