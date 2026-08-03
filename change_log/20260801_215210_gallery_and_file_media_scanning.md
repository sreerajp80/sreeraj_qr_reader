# Change Log — 2.4 Gallery & File Media Scanning

**Plan File:** `plans/20260801_215033_gallery_and_file_media_scanning.md`

## Summary of Changes
Implemented Feature 2.4 — Gallery & File Media Scanning:
1. **Dependencies Added**:
   - `image_picker: ^1.1.2` (Gallery photo selection)
   - `file_picker: ^8.1.7` (PDF file picker)
   - `pdfx: ^2.7.0` (PDF page rendering)
   - `receive_sharing_intent: ^1.8.1` (Android System Share Sheet receiver)
2. **Android System Share Sheet Target**:
   - Added intent filters to `AndroidManifest.xml` for `image/*` and `application/pdf` (`android.intent.action.SEND` and `android.intent.action.SEND_MULTIPLE`).
3. **Media Scanning Service & UI**:
   - Created `MediaScanService` (`lib/services/media_scan_service.dart`) to pick/extract and scan gallery images and multi-page PDF documents page-by-page.
   - Created `PdfScanResultsSheet` (`lib/screens/widgets/pdf_scan_results_sheet.dart`) to display detected barcodes in multi-page PDFs with individual selection and "Save All to History" actions.
   - Updated `ScannerScreen` (`lib/screens/scanner_screen.dart`) with "Scan Image" and "Scan PDF" AppBar buttons and `receive_sharing_intent` listener streams.
4. **Documentation & Roadmap**:
   - Updated `docs/feature_analysis_and_roadmap.md` marking Feature 2.4 as completed (`✅ [COMPLETED]`).
5. **Testing**:
   - Added `test/services/media_scan_service_test.dart` covering data models and scan results.
