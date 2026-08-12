import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';

/// Represents a barcode found on a specific page of a PDF document.
class PdfPageBarcode {
  final int pageNumber;
  final String rawValue;
  final BarcodeType format;

  const PdfPageBarcode({
    required this.pageNumber,
    required this.rawValue,
    required this.format,
  });
}

/// Holds the result of an image or PDF media barcode scan.
class MediaScanResult {
  final List<Barcode> barcodes;
  final List<PdfPageBarcode> pdfBarcodes;
  final String? errorMessage;
  final bool isPdf;

  const MediaScanResult({
    this.barcodes = const [],
    this.pdfBarcodes = const [],
    this.errorMessage,
    this.isPdf = false,
  });

  bool get hasBarcodes => barcodes.isNotEmpty || pdfBarcodes.isNotEmpty;
}

/// Service handling image gallery selection, multi-page PDF rendering, and barcode extraction.
class MediaScanService {
  final ImagePicker _imagePicker;

  MediaScanService({ImagePicker? imagePicker})
    : _imagePicker = imagePicker ?? ImagePicker();

  /// Pick an image from gallery and analyze it for barcodes using [controller].
  Future<MediaScanResult> pickAndScanImage(
    MobileScannerController controller,
  ) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if (image == null) {
        return const MediaScanResult();
      }
      return await scanImageFile(controller, image.path);
    } catch (e) {
      if (kDebugMode) debugPrint('Error picking image: $e');
      return MediaScanResult(errorMessage: 'Failed to pick or scan image: $e');
    }
  }

  /// Scan a specific image file by path.
  Future<MediaScanResult> scanImageFile(
    MobileScannerController controller,
    String filePath,
  ) async {
    try {
      final capture = await controller.analyzeImage(filePath);
      if (capture == null || capture.barcodes.isEmpty) {
        return const MediaScanResult(
          errorMessage: 'No barcodes or QR codes detected in image.',
        );
      }
      return MediaScanResult(barcodes: capture.barcodes);
    } catch (e) {
      if (kDebugMode) debugPrint('Error scanning image file: $e');
      return MediaScanResult(errorMessage: 'Error analyzing image: $e');
    }
  }

  /// Pick a PDF document and analyze each page for embedded barcodes.
  Future<MediaScanResult> pickAndScanPdf(
    MobileScannerController controller, {
    void Function(int current, int total)? onProgress,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result == null ||
          result.files.isEmpty ||
          result.files.single.path == null) {
        return const MediaScanResult(isPdf: true);
      }
      return await scanPdfFile(
        controller,
        result.files.single.path!,
        onProgress: onProgress,
      );
    } catch (e) {
      if (kDebugMode) debugPrint('Error picking PDF: $e');
      return MediaScanResult(
        isPdf: true,
        errorMessage: 'Failed to pick or parse PDF: $e',
      );
    }
  }

  /// Scan a PDF file by path page-by-page.
  Future<MediaScanResult> scanPdfFile(
    MobileScannerController controller,
    String pdfPath, {
    void Function(int current, int total)? onProgress,
  }) async {
    final pdfBarcodes = <PdfPageBarcode>[];
    Directory? tempDir;

    try {
      tempDir = await getTemporaryDirectory();
      final document = await PdfDocument.openFile(pdfPath);
      final totalPages = document.pagesCount;

      for (int i = 1; i <= totalPages; i++) {
        onProgress?.call(i, totalPages);
        final page = await document.getPage(i);

        final pageImage = await page.render(
          width: page.width * 2,
          height: page.height * 2,
        );

        if (pageImage != null) {
          final tempFile = File(
            '${tempDir.path}/pdf_page_${DateTime.now().millisecondsSinceEpoch}_$i.jpg',
          );
          await tempFile.writeAsBytes(pageImage.bytes);

          try {
            final capture = await controller.analyzeImage(tempFile.path);
            if (capture != null && capture.barcodes.isNotEmpty) {
              for (final bc in capture.barcodes) {
                if (bc.rawValue != null && bc.rawValue!.isNotEmpty) {
                  pdfBarcodes.add(
                    PdfPageBarcode(
                      pageNumber: i,
                      rawValue: bc.rawValue!,
                      format: bc.type,
                    ),
                  );
                }
              }
            }
          } catch (e) {
            if (kDebugMode) debugPrint('Error analyzing page $i image: $e');
          } finally {
            try {
              if (await tempFile.exists()) {
                await tempFile.delete();
              }
            } catch (_) {}
          }
        }
        await page.close();
      }
      await document.close();

      if (pdfBarcodes.isEmpty) {
        return const MediaScanResult(
          isPdf: true,
          errorMessage: 'No barcodes or QR codes found in PDF document.',
        );
      }

      return MediaScanResult(isPdf: true, pdfBarcodes: pdfBarcodes);
    } catch (e) {
      if (kDebugMode) debugPrint('Error scanning PDF file: $e');
      return MediaScanResult(
        isPdf: true,
        errorMessage: 'Failed to scan PDF document: $e',
      );
    }
  }
}
