import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:sreeraj_qr_reader/services/dom_sandbox_service.dart';

void main() {
  group('DomSandboxService Tests', () {
    test(
      'Offline / Private mode generates sanitized local pre-render model',
      () async {
        final service = DomSandboxService();
        final result = await service.analyzeAndRender(
          'https://example.com/login',
        );

        expect(result.url, equals('https://example.com/login'));
        expect(result.isSanitized, isTrue);
        expect(result.sslValid, isTrue);
        expect(result.pageTitle, equals('example.com'));
        expect(result.headings, contains('Host: example.com'));
      },
    );

    test(
      'Strips script tags, inline handlers, and tracking pixels from HTML',
      () async {
        const mockHtml = '''
        <!DOCTYPE html>
        <html>
        <head>
          <title>Test Security Portal</title>
          <meta name="description" content="A test security portal page">
          <meta name="theme-color" content="#008080">
          <script>console.log("malicious script");</script>
        </head>
        <body onload="alert('exploit')">
          <h1>Welcome to Security Portal</h1>
          <p>This is a safe text paragraph inside the DOM hierarchy.</p>
          <iframe src="https://exploit.com/frame"></iframe>
          <img src="https://tracker.com/pixel.gif" width="1" height="1">
          <a href="https://example.com/dashboard">Dashboard</a>
        </body>
        </html>
      ''';

        final mockClient = MockClient((request) async {
          return http.Response(
            mockHtml,
            200,
            headers: {'content-type': 'text/html; charset=utf-8'},
          );
        });

        final service = DomSandboxService(httpClient: mockClient);
        final result = await service.analyzeAndRender(
          'https://example.com',
          activeProbing: true,
        );

        expect(result.pageTitle, equals('Test Security Portal'));
        expect(result.metaDescription, equals('A test security portal page'));
        expect(result.headings, contains('Welcome to Security Portal'));
        expect(
          result.paragraphs,
          contains('This is a safe text paragraph inside the DOM hierarchy.'),
        );
        expect(result.links, contains('https://example.com/dashboard'));
        expect(result.blockedScriptsCount, equals(2)); // <script> + onload
        expect(result.blockedIframesCount, equals(1)); // <iframe>
        expect(result.blockedTrackersCount, equals(1)); // 1x1 image
        expect(result.isSanitized, isTrue);
      },
    );

    test('Detects open redirect traps in URL query parameters', () async {
      final service = DomSandboxService();
      final result = await service.analyzeAndRender(
        'https://login-portal.com/login?redirect=https://evil-phishing.com/steal',
      );

      expect(result.hasOpenRedirect, isTrue);
      expect(result.redirectTarget, equals('https://evil-phishing.com/steal'));
      expect(result.isSafe, isFalse);
    });
  });
}
