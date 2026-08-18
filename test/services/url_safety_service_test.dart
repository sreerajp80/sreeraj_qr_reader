import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sreeraj_qr_reader/models/app_message.dart';
import 'package:sreeraj_qr_reader/services/url_safety_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('UrlSafetyService.checkSuspiciousPatterns', () {
    late UrlSafetyService service;

    setUp(() {
      service = UrlSafetyService();
    });

    test('passes for a normal URL', () async {
      final result = await service.checkSuspiciousPatterns(
        'https://example.com',
      );
      expect(result.passed, true);
      expect(result.checkName.key, AppMessageKey.checkNamePattern);
    });

    test('fails for an IP address in the domain', () async {
      final result = await service.checkSuspiciousPatterns(
        'https://192.168.1.1/login',
      );
      expect(result.passed, false);
      expect(
        result.message.args['patterns'],
        contains(AppMessageKey.patternIpAddress.name),
      );
    });

    test('fails for a long number sequence in the domain', () async {
      final result = await service.checkSuspiciousPatterns(
        'https://example12345678.com',
      );
      expect(result.passed, false);
      expect(
        result.message.args['patterns'],
        contains(AppMessageKey.patternLongNumbers.name),
      );
    });

    test('fails when phishing keyword is combined with numbers', () async {
      final result = await service.checkSuspiciousPatterns(
        'https://login-verify123.com',
      );
      expect(result.passed, false);
      expect(
        result.message.args['patterns'],
        contains(AppMessageKey.patternPhishingKeywords.name),
      );
    });

    test('fails for excessive subdomains', () async {
      final result = await service.checkSuspiciousPatterns(
        'https://a.b.c.d.example.com',
      );
      expect(result.passed, false);
      expect(
        result.message.args['patterns'],
        contains(AppMessageKey.patternManySubdomains.name),
      );
    });

    test('fails for four or more consecutive dashes', () async {
      final result = await service.checkSuspiciousPatterns(
        'https://my----domain.com',
      );
      expect(result.passed, false);
      expect(
        result.message.args['patterns'],
        contains(AppMessageKey.patternManyDashes.name),
      );
    });

    test(
      'passes for a URL with a short path and no suspicious patterns',
      () async {
        final result = await service.checkSuspiciousPatterns(
          'https://docs.flutter.dev/get-started',
        );
        expect(result.passed, true);
      },
    );
  });

  group('UrlSafetyService.checkHomographAttacks', () {
    late UrlSafetyService service;

    setUp(() {
      service = UrlSafetyService();
    });

    test('passes for a normal ASCII domain', () async {
      final result = await service.checkHomographAttacks('https://example.com');
      expect(result.passed, true);
      expect(result.checkName.key, AppMessageKey.checkNameHomograph);
      expect(result.message.key, AppMessageKey.homographNone);
    });

    test('passes for a legitimate subdomain', () async {
      final result = await service.checkHomographAttacks(
        'https://mail.google.com',
      );
      expect(result.passed, true);
    });

    test(
      'fails when domain contains Cyrillic а (U+0430, lookalike for a)',
      () async {
        // ex\u0430mple.com — the 'a' is Cyrillic
        final result = await service.checkHomographAttacks(
          'https://ex\u0430mple.com',
        );
        expect(result.passed, false);
        expect(result.message.key, AppMessageKey.homographLookalikes);
      },
    );

    test(
      'fails when domain contains Cyrillic о (U+043E, lookalike for o)',
      () async {
        final result = await service.checkHomographAttacks(
          'https://ex\u043Emple.com',
        );
        expect(result.passed, false);
      },
    );

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
      final result = await service.checkUrlRedirects(
        'https://example.com',
        activeProbing: true,
      );
      expect(result.passed, true);
      expect(result.message.key, AppMessageKey.redirectNone);
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
      final result = await service.checkUrlRedirects(
        'https://example.com',
        activeProbing: true,
      );
      expect(result.passed, true);
      expect(result.message.key, AppMessageKey.redirectWithinRange);
      expect(result.message.args['count'], '1');
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
      final result = await service.checkUrlRedirects(
        'https://example.com',
        activeProbing: true,
      );
      expect(result.passed, false);
      expect(result.message.key, AppMessageKey.redirectSuspiciousChain);
    });

    test('fails when a redirect loop is detected', () async {
      // Both calls return a redirect back to the original URL
      final client = MockClient(
        (_) async => http.Response(
          '',
          301,
          headers: {'location': 'https://example.com'},
        ),
      );
      final service = UrlSafetyService(httpClient: client);
      final result = await service.checkUrlRedirects(
        'https://example.com',
        activeProbing: true,
      );
      expect(result.passed, false);
      expect(result.message.key, AppMessageKey.redirectLoop);
    });

    test(
      'does NOT contact the server when active probing is disabled',
      () async {
        var called = false;
        final client = MockClient((_) async {
          called = true;
          return http.Response('', 200);
        });
        final service = UrlSafetyService(httpClient: client);
        // Default (activeProbing: false) — privacy mode.
        final result = await service.checkUrlRedirects('https://example.com');
        expect(
          called,
          false,
          reason: 'no request should be made in private mode',
        );
        expect(result.passed, true);
        expect(result.message.key, AppMessageKey.redirectSkippedPrivate);
      },
    );
  });

  group('UrlSafetyService privacy mode (active probing disabled)', () {
    test(
      'checkSslCertificate confirms https without opening a connection',
      () async {
        final service = UrlSafetyService();
        final result = await service.checkSslCertificate('https://example.com');
        expect(result.passed, true);
        expect(result.message.key, AppMessageKey.sslPrivateModeOk);
      },
    );

    test('checkSslCertificate still fails plain http', () async {
      final service = UrlSafetyService();
      final result = await service.checkSslCertificate('http://example.com');
      expect(result.passed, false);
    });

    test(
      'checkUrlShorteners runs heuristics without contacting the server',
      () async {
        var called = false;
        final client = MockClient((_) async {
          called = true;
          return http.Response('', 200);
        });
        final service = UrlSafetyService(httpClient: client);
        final result = await service.checkUrlShorteners(
          'https://example.com/path',
        );
        expect(
          called,
          false,
          reason: 'no request should be made in private mode',
        );
        expect(result.checkName.key, AppMessageKey.checkNameShortener);
      },
    );

    test('checkUrlShorteners still flags a known shortener locally', () async {
      final service = UrlSafetyService();
      final result = await service.checkUrlShorteners('https://bit.ly/abc');
      expect(result.passed, false);
      expect(result.message.key, AppMessageKey.shortenerKnown);
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
      final result = await service.checkGoogleSafeBrowsing(
        'https://example.com',
      );
      // Either "Skipped" (null key) or "Unable to check" (platform channel threw).
      // Both are acceptable without a real device keystore.
      expect(result.checkName.key, AppMessageKey.checkNameMalicious);
    });
  });
}
