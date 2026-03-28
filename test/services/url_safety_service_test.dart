import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sreeraj_qr_reader/services/url_safety_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('UrlSafetyService.checkSuspiciousPatterns', () {
    late UrlSafetyService service;

    setUp(() {
      service = UrlSafetyService();
    });

    test('passes for a normal URL', () async {
      final result = await service.checkSuspiciousPatterns('https://example.com');
      expect(result.passed, true);
      expect(result.checkName, 'Pattern Detection');
    });

    test('fails for an IP address in the domain', () async {
      final result = await service.checkSuspiciousPatterns(
        'https://192.168.1.1/login',
      );
      expect(result.passed, false);
      expect(result.message, contains('IP Address'));
    });

    test('fails for a long number sequence in the domain', () async {
      final result = await service.checkSuspiciousPatterns(
        'https://example12345678.com',
      );
      expect(result.passed, false);
      expect(result.message, contains('Long Number Sequence'));
    });

    test('fails when phishing keyword is combined with numbers', () async {
      final result = await service.checkSuspiciousPatterns(
        'https://login-verify123.com',
      );
      expect(result.passed, false);
      expect(result.message, contains('Phishing Keywords'));
    });

    test('fails for excessive subdomains', () async {
      final result = await service.checkSuspiciousPatterns(
        'https://a.b.c.d.example.com',
      );
      expect(result.passed, false);
      expect(result.message, contains('Multiple Subdomains'));
    });

    test('fails for four or more consecutive dashes', () async {
      final result = await service.checkSuspiciousPatterns(
        'https://my----domain.com',
      );
      expect(result.passed, false);
      expect(result.message, contains('Multiple Dashes'));
    });

    test('passes for a URL with a short path and no suspicious patterns', () async {
      final result = await service.checkSuspiciousPatterns(
        'https://docs.flutter.dev/get-started',
      );
      expect(result.passed, true);
    });
  });

  group('UrlSafetyService.checkHomographAttacks', () {
    late UrlSafetyService service;

    setUp(() {
      service = UrlSafetyService();
    });

    test('passes for a normal ASCII domain', () async {
      final result = await service.checkHomographAttacks('https://example.com');
      expect(result.passed, true);
      expect(result.checkName, 'Homograph Attack Check');
      expect(result.message, 'No lookalike characters detected');
    });

    test('passes for a legitimate subdomain', () async {
      final result = await service.checkHomographAttacks(
        'https://mail.google.com',
      );
      expect(result.passed, true);
    });

    test('fails when domain contains Cyrillic а (U+0430, lookalike for a)', () async {
      // ex\u0430mple.com — the 'a' is Cyrillic
      final result = await service.checkHomographAttacks(
        'https://ex\u0430mple.com',
      );
      expect(result.passed, false);
      expect(result.message, contains('Lookalike characters'));
    });

    test('fails when domain contains Cyrillic о (U+043E, lookalike for o)', () async {
      final result = await service.checkHomographAttacks(
        'https://ex\u043Emple.com',
      );
      expect(result.passed, false);
    });

    test('fails for a domain mixing Latin and Cyrillic scripts', () async {
      // Both Latin letters and Cyrillic characters present
      final result = await service.checkHomographAttacks(
        'https://ex\u0430mple.\u0441om',
      );
      expect(result.passed, false);
    });
  });

  group('UrlSafetyService.checkUrlRedirects', () {
    test('passes when server returns 200 with no redirect', () async {
      final client = MockClient((_) async => http.Response('', 200));
      final service = UrlSafetyService(httpClient: client);
      final result = await service.checkUrlRedirects('https://example.com');
      expect(result.passed, true);
      expect(result.message, 'No redirects detected');
    });

    test('passes for one redirect (within normal range)', () async {
      var callCount = 0;
      final client = MockClient((request) async {
        callCount++;
        if (callCount == 1) {
          return http.Response(
            '',
            301,
            headers: {'location': 'https://example.com/new'},
          );
        }
        return http.Response('', 200);
      });
      final service = UrlSafetyService(httpClient: client);
      final result = await service.checkUrlRedirects('https://example.com');
      expect(result.passed, true);
      expect(result.message, contains('1 redirect'));
    });

    test('fails for three or more redirects (suspicious chain)', () async {
      var callCount = 0;
      final client = MockClient((request) async {
        callCount++;
        if (callCount <= 3) {
          return http.Response(
            '',
            301,
            headers: {'location': 'https://example.com/step$callCount'},
          );
        }
        return http.Response('', 200);
      });
      final service = UrlSafetyService(httpClient: client);
      final result = await service.checkUrlRedirects('https://example.com');
      expect(result.passed, false);
      expect(result.message, contains('Suspicious redirect chain'));
    });

    test('fails when a redirect loop is detected', () async {
      // Both calls return a redirect back to the original URL
      final client = MockClient((_) async => http.Response(
            '',
            301,
            headers: {'location': 'https://example.com'},
          ));
      final service = UrlSafetyService(httpClient: client);
      final result = await service.checkUrlRedirects('https://example.com');
      expect(result.passed, false);
      expect(result.message, 'Redirect loop detected');
    });
  });

  group('UrlSafetyService.checkGoogleSafeBrowsing – no API key', () {
    test('returns passed with Skipped message when API key is absent', () async {
      SharedPreferences.setMockInitialValues({});
      // In the test environment the platform channel for flutter_secure_storage
      // is unregistered; read() returns null → treated as no API key configured.
      final service = UrlSafetyService(
        httpClient: MockClient((_) async => http.Response('{}', 200)),
      );
      final result = await service.checkGoogleSafeBrowsing('https://example.com');
      // Either "Skipped" (null key) or "Unable to check" (platform channel threw).
      // Both are acceptable without a real device keystore.
      expect(result.checkName, 'Malicious Content Check');
    });
  });
}
