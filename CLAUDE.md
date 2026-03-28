# CLAUDE.md

This file provides guidance to Claude Code when working in this repository.

## Project Overview

Sreeraj P QR Reader is a Flutter Android application for scanning QR codes and barcodes with URL safety verification. Version 1.2.0+1.

- **Flutter SDK**: >=3.41.4
- **Dart SDK**: >=3.11.1 <4.0.0
- **Min Android SDK**: 24 (Android 7.0)
- **Platform**: Android only
- **State management**: Provider (ChangeNotifier)
- **Navigation**: Named routes (Navigator 1.0)

## Common Commands

```bash
# Install dependencies
flutter pub get

# Run dev flavor (daily development)
flutter run --flavor dev

# Run prod flavor with debug tooling
flutter run --flavor prod

# Build dev debug APK (internal testing)
flutter build apk --flavor dev --debug

# Build prod release APKs split by ABI (shareable)
flutter build apk --flavor prod --release --split-per-abi --dart-define=BUILD_DATE=$(date +%Y-%m-%d)

# Build prod release App Bundle (Play Store) — auto-injects today's date
./tool/build_release.sh appbundle
# or manually:
flutter build appbundle --flavor prod --release --dart-define=BUILD_DATE=$(date +%Y-%m-%d)

# Run tests
flutter test

# Format code
dart format .

# Analyze code
flutter analyze
```

## Project Structure

```
lib/
|-- config/
|   `-- build_config.dart            # Build metadata (date, developer, AI credits)
|-- models/
|   `-- safety_check_result.dart     # Immutable result model for URL safety checks
|-- providers/
|   `-- scan_provider.dart           # ChangeNotifier: scan state, delegates checks to service
|-- screens/
|   |-- scanner_screen.dart          # Live camera scanning UI with animated overlay
|   |-- result_screen.dart           # Scan result display and actions
|   |-- settings_screen.dart         # Google Safe Browsing API key management
|   `-- about_screen.dart            # App info and features
|-- services/
|   `-- url_safety_service.dart      # Six URL safety check algorithms (injectable)
`-- main.dart                        # Entry point: Provider setup, theme, routes

test/
|-- providers/
|   `-- scan_provider_test.dart
`-- services/
    `-- url_safety_service_test.dart
```

This is a Tier 1 (layer-first) project. Do not restructure to feature-first without explicit instruction.

## Architecture Rules

- **State management**: Use Provider with ChangeNotifier exclusively. Do not introduce Bloc, Riverpod, or other state systems.
- **Data flow**: Widget -> ScanProvider -> UrlSafetyService -> HTTP/Storage. Widgets must not perform HTTP calls, storage operations, or URL analysis directly. ScanProvider must not contain check algorithms.
- **Service injection**: `UrlSafetyService` accepts an optional `http.Client` and `FlutterSecureStorage` via constructor for testability. Pass a `MockClient` in tests.
- **Navigation**: Four named routes: `/` (ScannerScreen), `/result`, `/about`, `/settings`. Use `Navigator.pushNamed` for navigation.
- **Theme**: Material Design 3 with blue seed color. Theme is defined in `main.dart`.
- **Immutable widgets**: All screens use `const` constructors with `StatelessWidget` or `StatefulWidget`.

## Key Dependencies

| Package | Purpose |
|---------|---------|
| `mobile_scanner` | QR/barcode camera scanning |
| `provider` | State management |
| `http` | HTTP requests for URL safety checks |
| `url_launcher` | Open URLs in browser |
| `share_plus` | Share scanned content |
| `permission_handler` | Runtime camera permissions |
| `flutter_secure_storage` | Encrypted storage for API keys |
| `shared_preferences` | Non-sensitive preferences (request counters) |
| `package_info_plus` | App version info |

## Security Considerations

- **API keys**: Google Safe Browsing API key is stored in `flutter_secure_storage`. Never store API keys in `SharedPreferences`, hardcode them, or log them.
- **SharedPreferences**: Only for non-sensitive data (daily request counters, UI preferences).
- **Logging**: Do not log secrets, API keys, or decrypted data. Use `debugPrint` gated behind `kDebugMode` if needed.
- **Permissions**: Camera permission is requested at point of use. Do not request unnecessary permissions.

## URL Safety Analysis

`UrlSafetyService` performs six security checks on detected URLs:
1. SSL/TLS certificate validation
2. Redirect chain analysis
3. Suspicious pattern detection (IP addresses, phishing keywords)
4. URL shortener detection
5. Homograph attack detection (Unicode lookalikes)
6. Google Safe Browsing API lookup (requires API key)

Each check method returns a `SafetyCheckResult` (from `lib/models/safety_check_result.dart`). `ScanProvider.checkUrlSafety` calls `UrlSafetyService.runAllChecks` and stores the results. When modifying checks, maintain all six and keep each method returning a single `SafetyCheckResult`.

## Code Style

- **Formatting**: Run `dart format .` before committing.
- **Linting**: Uses `flutter_lints` (via `package:flutter_lints/flutter.yaml`).
- **Naming**: `snake_case` for files, `PascalCase` for classes, `camelCase` for variables/functions.
- **Imports**: Use `package:` imports (e.g., `package:sreeraj_qr_reader/...`), not relative imports.
- **Prefer**: `const` constructors, `final` locals, single quotes.

## Current State

- **Tests**: Unit tests exist for `ScanProvider` and `UrlSafetyService`. Widget and integration tests not yet written.
- **Build flavors**: `dev` (applicationId suffix `.dev`, app label "QR Reader Dev") and `prod` (production, app label "Sreeraj P QR Reader"). Both can be installed side-by-side.
- **CI**: GitHub Actions workflow at `.github/workflows/ci.yml` (format + analyze + test).
- **analysis_options.yaml**: Present at project root with standard lint baseline.
- **Release signing**: `android/key.properties` and `android/keystore.jks` required (not in git). See `docs/release_process.md`.

## Dos and Don'ts

- **Do** read existing code before modifying it.
- **Do** run `flutter analyze` and `flutter test` after changes.
- **Do** keep `main.dart` thin (initialization, Provider setup, routes only).
- **Don't** add new state management patterns.
- **Don't** put business logic in widgets.
- **Don't** store sensitive data in `SharedPreferences`.
- **Don't** introduce unnecessary abstractions for single-use operations.
- **Don't** add dependencies without clear justification.
