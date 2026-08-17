# Plan — 2.4 Gallery & File Media Scanning

**Status:** Completed

## Goal
Implement Feature 2.4 — Gallery & File Media Scanning:
1. **Gallery Image Picker**: Add a "Scan Image" option allowing users to pick photos from the Android Gallery / Photos app (`image_picker`) and decode contained QR/barcodes.
2. **Multi-Page PDF Scanning**: Allow users to select a PDF document (`file_picker`), extract/render pages using `pdfx`, and automatically scan each page for embedded QR/barcodes.
3. **Android System Share Sheet Target**: Register the app as a native Android "Share to..." receiver (`AndroidManifest.xml` intent filters for `image/*` & `application/pdf` and `receive_sharing_intent`) so users can share images/PDFs directly from web browsers or messaging apps into Sreeraj QR Reader.
4. **Documentation Update**: Mark Feature 2.4 as completed in `docs/feature_analysis_and_roadmap.md`.

---

## Architecture & Dependency Layer

### Dependencies to Add (`pubspec.yaml`)
- `image_picker`: `^1.1.2` (BSD-3-Clause open source, official Flutter package for photo picking).
- `file_picker`: `^8.1.7` (MIT open source, file selection for PDFs).
- `pdfx`: `^2.7.0` (MIT open source, PDF page rendering engine).
- `receive_sharing_intent`: `^1.8.1` (MIT open source, Android Share Sheet intent receiver).

All packages are 100% open source under OSI-approved permissive licenses, offline-friendly, and free of tracking/ads/analytics.

---

## Target Layer & Files to Modify / Create

### 1. Native Manifest Layer (`android/app/src/main/`)
- **[MODIFY]** `android/app/src/main/AndroidManifest.xml`:
  - Register `SEND` and `SEND_MULTIPLE` intent filters under `MainActivity` for `image/*` and `application/pdf` MIME types.

### 2. Services Layer (`lib/services/`)
- **[NEW]** [media_scan_service.dart](../lib/services/media_scan_service.dart):
  - `pickAndScanImage(MobileScannerController controller)`: Opens gallery via `image_picker` or `file_picker`, calls `controller.analyzeImage(path)`, returns detected barcodes.
  - `pickAndScanPdf(MobileScannerController controller)`: Opens file picker for `.pdf`, renders each page to a temporary image via `pdfx`, calls `controller.analyzeImage(pagePath)` per page, returns list of all detected barcodes with page numbers.
  - `scanImageFile(MobileScannerController controller, String filePath)`: Analyzes a specific image file path.
  - `scanPdfFile(MobileScannerController controller, String pdfPath)`: Analyzes a specific PDF file path.

### 3. State & Provider Layer (`lib/providers/`)
- **[MODIFY]** [scan_provider.dart](../lib/providers/scan_provider.dart):
  - Add support for handling media scan batch results and shared intent payload processing.

### 4. UI Layer (`lib/screens/`)
- **[MODIFY]** [scanner_screen.dart](../lib/screens/scanner_screen.dart):
  - Add "Scan Gallery Image" and "Scan PDF Document" action buttons in the scanner screen AppBar / toolbar.
  - Add `receive_sharing_intent` subscription listener to automatically trigger barcode scan when an image or PDF is shared to the app via Android system share sheet.
  - Display progress indicator while scanning multi-page PDF files.
  - Handle results: single barcode auto-navigates to `/result`; multiple barcodes present a multi-result selection bottom sheet.

- **[NEW]** [pdf_scan_results_sheet.dart](../lib/screens/widgets/pdf_scan_results_sheet.dart):
  - Modal bottom sheet displaying all barcodes discovered across multi-page PDFs, showing page number, raw content, and format, with 1-tap select to open result or batch save to history.

### 5. Documentation (`docs/`)
- **[MODIFY]** [feature_analysis_and_roadmap.md](../docs/feature_analysis_and_roadmap.md):
  - Mark Feature 2.4 as completed (`### 2.4 Gallery & File Media Scanning ✅ [COMPLETED]`).
  - Update roadmap status and comparative feature matrix table.

### 6. Tests (`test/`)
- **[NEW]** [media_scan_service_test.dart](../test/services/media_scan_service_test.dart):
  - Unit tests for media scanning service functions and PDF page result model handling.

---

## Architectural Impact & Security
- Follows Tier 1 layer-first structure (`lib/services/`, `lib/providers/`, `lib/screens/`).
- State managed strictly via `Provider` (`ScanProvider` & `HistoryProvider`).
- No external network calls for media parsing — 100% offline local processing.
- Error handling ensures app never crashes on corrupt or password-protected PDF files or malformed images.

---

## Verification Plan

### Automated Tests
```bash
flutter analyze                        # Static analysis (must be 0 errors/warnings)
flutter test                           # Run all unit and widget test suites
```

### Manual Verification
1. Open scanner screen and tap "Gallery" button to select a QR code photo from gallery. Verify it parses code and opens `/result`.
2. Tap "Scan PDF" button and pick a multi-page PDF document containing QR codes. Verify all pages are scanned and codes are extracted.
3. Share an image or PDF from Google Chrome / Photos / Files app to Sreeraj QR Reader via Android Share Sheet. Verify app launches and automatically scans shared media.
