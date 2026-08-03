import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sreeraj_qr_reader/providers/scan_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ScanProvider DomSandbox Tests', () {
    test(
      'checkUrlSafety triggers DomSandboxService analysis and populates domSandboxResult',
      () async {
        final provider = ScanProvider();

        provider.setScanResult('https://example.com/test', BarcodeType.url);
        expect(provider.isUrl, isTrue);
        expect(provider.domSandboxResult, isNull);

        await provider.checkUrlSafety('https://example.com/test');

        expect(provider.domSandboxResult, isNotNull);
        expect(
          provider.domSandboxResult?.url,
          equals('https://example.com/test'),
        );
        expect(provider.domSandboxResult?.isSanitized, isTrue);

        provider.clearScan();
        expect(provider.domSandboxResult, isNull);
      },
    );
  });
}
