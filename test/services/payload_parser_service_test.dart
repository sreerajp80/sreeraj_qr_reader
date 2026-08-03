import 'package:flutter_test/flutter_test.dart';
import 'package:sreeraj_qr_reader/models/parsed_payload.dart';
import 'package:sreeraj_qr_reader/services/payload_parser_service.dart';

void main() {
  group('PayloadParserService', () {
    late PayloadParserService parser;

    setUp(() {
      parser = PayloadParserService();
    });

    test('parses Wi-Fi QR payload correctly', () {
      const raw = 'WIFI:S:MyHomeWiFi;T:WPA;P:SuperSecret123;H:false;;';
      final payload = parser.parse(raw);

      expect(payload, isA<WifiPayload>());
      final wifi = payload as WifiPayload;
      expect(wifi.ssid, equals('MyHomeWiFi'));
      expect(wifi.securityType, equals('WPA'));
      expect(wifi.password, equals('SuperSecret123'));
      expect(wifi.isHidden, isFalse);
    });

    test('parses vCard contact payload correctly', () {
      const raw = '''
BEGIN:VCARD
VERSION:3.0
FN:Sreeraj P
TEL;TYPE=CELL:+1234567890
EMAIL:sreeraj@example.com
ORG:Deepmind
TITLE:Engineer
END:VCARD
''';
      final payload = parser.parse(raw);

      expect(payload, isA<ContactPayload>());
      final contact = payload as ContactPayload;
      expect(contact.name, equals('Sreeraj P'));
      expect(contact.phones.length, equals(1));
      expect(contact.phones.first.value, equals('+1234567890'));
      expect(contact.emails.first.value, equals('sreeraj@example.com'));
      expect(contact.organization, equals('Deepmind'));
    });

    test('parses MeCard contact payload correctly', () {
      const raw = 'MECARD:N:Doe,John;TEL:9876543210;EMAIL:john@doe.com;;';
      final payload = parser.parse(raw);

      expect(payload, isA<ContactPayload>());
      final contact = payload as ContactPayload;
      expect(contact.name, equals('Doe John'));
      expect(contact.phones.first.value, equals('9876543210'));
      expect(contact.emails.first.value, equals('john@doe.com'));
    });

    test('parses Geographic location payload correctly', () {
      const raw = 'geo:37.7749,-122.4194?q=San+Francisco';
      final payload = parser.parse(raw);

      expect(payload, isA<GeoPayload>());
      final geo = payload as GeoPayload;
      expect(geo.latitude, equals(37.7749));
      expect(geo.longitude, equals(-122.4194));
      expect(geo.query, equals('San Francisco'));
    });

    test('parses Calendar iCal event payload correctly', () {
      const raw = '''
BEGIN:VCALENDAR
BEGIN:VEVENT
SUMMARY:Team Sync Meeting
LOCATION:Conference Room A
DTSTART:20260731T090000Z
DTEND:20260731T100000Z
END:VEVENT
END:VCALENDAR
''';
      final payload = parser.parse(raw);

      expect(payload, isA<CalendarPayload>());
      final cal = payload as CalendarPayload;
      expect(cal.summary, equals('Team Sync Meeting'));
      expect(cal.location, equals('Conference Room A'));
      expect(cal.dtStart, equals(DateTime(2026, 7, 31, 9)));
      expect(cal.dtEnd, equals(DateTime(2026, 7, 31, 10)));
    });

    test('parses UPI Payment payload correctly', () {
      const raw =
          'upi://pay?pa=merchant@upi&pn=Store%20Name&am=150.00&cu=INR&tn=Order123';
      final payload = parser.parse(raw);

      expect(payload, isA<PaymentPayload>());
      final payment = payload as PaymentPayload;
      expect(payment.scheme, equals(PaymentScheme.upi));
      expect(payment.payeeAddress, equals('merchant@upi'));
      expect(payment.payeeName, equals('Store Name'));
      expect(payment.amount, equals('150.00'));
      expect(payment.currency, equals('INR'));
    });

    test('parses Crypto Payment payload correctly', () {
      const raw =
          'bitcoin:1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa?amount=0.05&label=Satoshi';
      final payload = parser.parse(raw);

      expect(payload, isA<PaymentPayload>());
      final payment = payload as PaymentPayload;
      expect(payment.scheme, equals(PaymentScheme.crypto));
      expect(
        payment.payeeAddress,
        equals('1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa'),
      );
      expect(payment.amount, equals('0.05'));
      expect(payment.currency, equals('BITCOIN'));
    });

    test('parses 2FA TOTP payload correctly', () {
      const raw =
          'otpauth://totp/Google:user@gmail.com?secret=JBSWY3DPEHPK3PXP&issuer=Google';
      final payload = parser.parse(raw);

      expect(payload, isA<TotpPayload>());
      final totp = payload as TotpPayload;
      expect(totp.issuer, equals('Google'));
      expect(totp.accountName, equals('user@gmail.com'));
      expect(totp.secret, equals('JBSWY3DPEHPK3PXP'));
      expect(totp.digits, equals(6));
      expect(totp.period, equals(30));
    });

    test('falls back to GenericPayload for plain text', () {
      const raw = 'Hello Sreeraj QR Reader';
      final payload = parser.parse(raw);

      expect(payload, isA<GenericPayload>());
      expect(payload.rawContent, equals(raw));
    });
  });
}
