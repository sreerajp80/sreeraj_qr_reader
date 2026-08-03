# Plan: Comprehensive Persistent History & Database (Section 2.3)

**Status:** Pending Approval

## Problem Statement
The app currently retains scan results only in memory in `ScanProvider`. Scanned data is lost when navigating away or closing the app. Users cannot search past scans, filter by scan type, star favorites, edit custom notes, add location tags, or export/import their history across formats (CSV, JSON, TXT, PDF, encrypted local backup).

## Proposed Fix
Implement Section 2.3: Comprehensive Persistent History & Database following Tier 1 layer-first architecture, `CLAUDE.md`, and project guidelines.

### Key Changes

1. **Dependencies (`pubspec.yaml`)**:
   - Add `sqflite: ^2.4.1`, `path_provider: ^2.1.5`, `path: ^1.9.0`, `pdf: ^3.11.1` to dependencies.
   - Add `sqflite_common_ffi: ^2.3.4` to dev_dependencies for testing.

2. **Models Layer (`lib/models/scan_record.dart`)**:
   - Create `ScanRecord` model holding `id`, `timestamp`, `rawContent`, `barcodeFormat`, `category`, `imageThumbnail`, `locationTag`, `safetyScore`, `notes`, `isFavorite`, `metadata`.
   - Supports serialization, copying, filtering, and encryption payload encoding.

3. **Services Layer**:
   - **`lib/services/history_database_service.dart`**: SQLite database implementation with AES-256 encryption at rest (`encrypt` package + `flutter_secure_storage` master key). Provides full CRUD, text search, filtering, and favorites management.
   - **`lib/services/history_export_service.dart`**: Formats and exports scan history to CSV, JSON, TXT, and PDF reports. Handles encrypted local backup (`.sreerajqr` format) creation and restoration using master password encryption.

4. **Providers Layer (`lib/providers/history_provider.dart`)**:
   - `ChangeNotifier` state provider managing history records, category filtering, search queries, favorites, notes editing, and export/import operations.
   - Updates `ScanProvider` to automatically persist scans to history upon scanning.

5. **Screens & UI Components**:
   - **`lib/screens/history_screen.dart`**: Full Material 3 history view with search bar, category filter chips (All, URLs, Wi-Fi, Contacts, Text, Barcodes, Favorites), history list, summary bar, and export/import action trigger.
   - **`lib/screens/widgets/history_card.dart`**: Card rendering category icon, barcode format badge, raw content, thumbnail, safety score, favorite star, and contextual menu.
   - **`lib/screens/widgets/history_detail_sheet.dart`**: Modal bottom sheet for viewing full metadata, editing user notes, adding location tag, and inspecting payload details.
   - **`lib/screens/widgets/export_import_dialog.dart`**: Dialog for choosing export formats (CSV, JSON, TXT, PDF, Encrypted Backup) and restoring from local backup files.
   - **`lib/screens/scanner_screen.dart`**: Add History icon button to scanner app bar.
   - **`lib/screens/result_screen.dart`**: Add controls to star scan, edit notes, and view history metadata.
   - **`lib/main.dart`**: Register `HistoryProvider` and add `/history` route.

6. **Documentation & Tests**:
   - Mark Section 2.3 as completed in `docs/feature_analysis_and_roadmap.md`.
   - Add unit tests for `ScanRecord`, `HistoryDatabaseService`, `HistoryExportService`, and `HistoryProvider`.

## Files to Modify / Create
- `pubspec.yaml`
- `lib/models/scan_record.dart` [NEW]
- `lib/services/history_database_service.dart` [NEW]
- `lib/services/history_export_service.dart` [NEW]
- `lib/providers/history_provider.dart` [NEW]
- `lib/providers/scan_provider.dart`
- `lib/screens/history_screen.dart` [NEW]
- `lib/screens/widgets/history_card.dart` [NEW]
- `lib/screens/widgets/history_detail_sheet.dart` [NEW]
- `lib/screens/widgets/export_import_dialog.dart` [NEW]
- `lib/screens/scanner_screen.dart`
- `lib/screens/result_screen.dart`
- `lib/main.dart`
- `docs/feature_analysis_and_roadmap.md`
- `test/models/scan_record_test.dart` [NEW]
- `test/services/history_database_service_test.dart` [NEW]
- `test/services/history_export_service_test.dart` [NEW]
- `test/providers/history_provider_test.dart` [NEW]

## Verification Plan
1. Run `flutter pub get`.
2. Run `flutter analyze` to ensure clean static analysis.
3. Run `flutter test` to execute all unit tests.
