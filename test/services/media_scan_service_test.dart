import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sreeraj_qr_reader/models/app_message.dart';
import 'package:sreeraj_qr_reader/services/media_scan_service.dart';

void main() {
  group('PdfPageBarcode', () {
    test('instantiates correctly with page number and raw value', () {
      const pageBarcode = PdfPageBarcode(
        pageNumber: 3,
        rawValue: 'https://example.com/qr',
        format: BarcodeType.url,
      );

      expect(pageBarcode.pageNumber, equals(3));
      expect(pageBarcode.rawValue, equals('https://example.com/qr'));
      expect(pageBarcode.format, equals(BarcodeType.url));
    });
  });

  group('MediaScanResult', () {
    test('hasBarcodes returns false when empty', () {
      const result = MediaScanResult();
      expect(result.hasBarcodes, isFalse);
      expect(result.isPdf, isFalse);
      expect(result.errorMessage, isNull);
    });

    test('hasBarcodes returns true when pdfBarcodes is not empty', () {
      const result = MediaScanResult(
        isPdf: true,
        pdfBarcodes: [
          PdfPageBarcode(
            pageNumber: 1,
            rawValue: 'CODE128_TEST',
            format: BarcodeType.text,
          ),
        ],
      );

      expect(result.hasBarcodes, isTrue);
      expect(result.isPdf, isTrue);
      expect(result.pdfBarcodes.length, equals(1));
    });

    test('carries error message when parsing fails', () {
      const result = MediaScanResult(
        isPdf: true,
        errorMessage: AppMessage(
          AppMessageKey.mediaPdfPickFailed,
          args: {'error': 'Failed to parse PDF file.'},
        ),
      );

      expect(result.hasBarcodes, isFalse);
      expect(result.errorMessage?.key, AppMessageKey.mediaPdfPickFailed);
      expect(
        result.errorMessage?.args['error'],
        equals('Failed to parse PDF file.'),
      );
    });
  });
}
