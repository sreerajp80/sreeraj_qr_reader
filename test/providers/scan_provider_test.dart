import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sreeraj_qr_reader/providers/scan_provider.dart';

void main() {
  group('ScanProvider', () {
    late ScanProvider provider;

    setUp(() {
      provider = ScanProvider();
    });

    tearDown(() {
      provider.dispose();
    });

    group('initial state', () {
      test('scanResult is null', () {
        expect(provider.scanResult, isNull);
      });

      test('scanType is null', () {
        expect(provider.scanType, isNull);
      });

      test('isUrl is false', () {
        expect(provider.isUrl, false);
      });

      test('isSafeUrl is true', () {
        expect(provider.isSafeUrl, true);
      });

      test('isLoading is false', () {
        expect(provider.isLoading, false);
      });

      test('safetyChecks is empty', () {
        expect(provider.safetyChecks, isEmpty);
      });

      test('hasNetworkError is false', () {
        expect(provider.hasNetworkError, false);
      });

      test('activeProbingEnabled defaults to false', () {
        expect(provider.activeProbingEnabled, false);
      });
    });

    group('setScanResult – URL detection', () {
      test('stores result and type', () {
        provider.setScanResult('Hello', BarcodeType.text);
        expect(provider.scanResult, 'Hello');
        expect(provider.scanType, BarcodeType.text);
      });

      test('detects https URL', () {
        provider.setScanResult('https://example.com', BarcodeType.url);
        expect(provider.isUrl, true);
      });

      test('detects http URL', () {
        provider.setScanResult('http://example.com/path', BarcodeType.url);
        expect(provider.isUrl, true);
      });

      test('detects URL with query string', () {
        provider.setScanResult(
          'https://example.com/page?q=1&lang=en',
          BarcodeType.url,
        );
        expect(provider.isUrl, true);
      });

      test('detects URL with path and fragment', () {
        provider.setScanResult(
          'https://example.com/docs#section',
          BarcodeType.url,
        );
        expect(provider.isUrl, true);
      });

      test('does not flag plain text as URL', () {
        provider.setScanResult('Just some text', BarcodeType.text);
        expect(provider.isUrl, false);
      });

      test('does not flag bare domain without scheme as URL', () {
        provider.setScanResult('example.com', BarcodeType.text);
        expect(provider.isUrl, false);
      });

      test('does not flag email address as URL', () {
        provider.setScanResult('user@example.com', BarcodeType.email);
        expect(provider.isUrl, false);
      });

      test('does not flag WiFi credential string as URL', () {
        provider.setScanResult('WIFI:T:WPA;S:MyNetwork;P:password;;', BarcodeType.wifi);
        expect(provider.isUrl, false);
      });

      test('notifies listeners on change', () {
        var notified = false;
        provider.addListener(() => notified = true);
        provider.setScanResult('test', BarcodeType.text);
        expect(notified, true);
      });
    });

    group('clearScan', () {
      setUp(() {
        provider.setScanResult('https://example.com', BarcodeType.url);
      });

      test('clears scanResult', () {
        provider.clearScan();
        expect(provider.scanResult, isNull);
      });

      test('clears scanType', () {
        provider.clearScan();
        expect(provider.scanType, isNull);
      });

      test('resets isUrl to false', () {
        provider.clearScan();
        expect(provider.isUrl, false);
      });

      test('resets isSafeUrl to true', () {
        provider.clearScan();
        expect(provider.isSafeUrl, true);
      });

      test('resets isLoading to false', () {
        provider.clearScan();
        expect(provider.isLoading, false);
      });

      test('clears safetyChecks', () {
        provider.clearScan();
        expect(provider.safetyChecks, isEmpty);
      });

      test('notifies listeners', () {
        var notified = false;
        provider.addListener(() => notified = true);
        provider.clearScan();
        expect(notified, true);
      });
    });
  });
}
