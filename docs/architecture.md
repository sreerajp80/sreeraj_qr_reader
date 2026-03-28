# Architecture

## 1. Scope

- Product: Sreeraj P QR Reader
- Repository type: application
- Engineering standard profiles in force:
  - `Core Baseline`
- Platforms: Android

## 2. Goals And Non-Goals

### Goals

- Scan QR codes and barcodes using the device camera
- Analyse scanned URLs across six security dimensions
- Allow users to copy, share, or open scanned content

### Non-Goals

- iOS, web, or desktop support
- Cloud sync or backend services
- User accounts or authentication

## 3. Architecture Summary

The app uses a Tier 1 layer-first Flutter structure with Provider for state management. `ScannerScreen` delegates scan events to `ScanProvider`, which coordinates URL safety analysis through `UrlSafetyService`. Sensitive data (the Google Safe Browsing API key) is isolated behind `flutter_secure_storage`; non-sensitive counters use `SharedPreferences`. Widgets do not know HTTP, storage, or cryptography.

## 4. Repository Structure

### Current Structure Tier

- `Tier 1`
- Why this tier is appropriate now:
  - Single domain, single developer, focused scope
  - No independent product areas requiring feature isolation

### Top-Level Source Layout

```text
lib/
|-- config/
|   `-- build_config.dart
|-- models/
|   `-- safety_check_result.dart
|-- providers/
|   `-- scan_provider.dart
|-- screens/
|   |-- about_screen.dart
|   |-- result_screen.dart
|   |-- scanner_screen.dart
|   `-- settings_screen.dart
|-- services/
|   `-- url_safety_service.dart
`-- main.dart
```

### Ownership Rules

| Path | Responsibility |
|------|----------------|
| `lib/config/` | Build-time constants |
| `lib/models/` | Immutable data types shared across layers |
| `lib/providers/` | ChangeNotifier state; bridges UI and service layer |
| `lib/screens/` | UI-only widgets; no business logic |
| `lib/services/` | Business logic and external API calls |

## 5. State Management

- Primary pattern: `Provider` (ChangeNotifier)
- Why this pattern was chosen:
  - Fits the simple linear data flow of scan → analyse → display
  - Flutter-native; no dependency beyond the `provider` package
- State boundaries:
  - Widgets own: UI-only state (copy feedback timer, scroll position)
  - `ScanProvider` owns: scan result, safety check results, loading flag
  - `UrlSafetyService` owns: stateless check logic only

## 6. Data Flow

```text
Widget -> ScanProvider -> UrlSafetyService -> HTTP / SecureStorage
```

`UrlSafetyService` is stateless and returns results as value objects. `ScanProvider` owns all mutable state.

### Rules

- Widgets must not know: HTTP, storage, encryption
- `ScanProvider` must not know: navigation, UI copy
- `UrlSafetyService` must not call `notifyListeners` or import widget classes

## 7. Domain Model

### Core Models Or Entities

| Type | Purpose | Mutable? | Notes |
|------|---------|----------|-------|
| `SafetyCheckResult` | Holds the outcome of one URL safety check | No | `const` constructor |
| `BarcodeType` | Identifies the kind of barcode scanned | No | From `mobile_scanner` package |

### Serialization Strategy

- JSON models: No (no persistence of domain entities)
- Database models: No
- Separate domain entities from transport models: No (Tier 1; single shape serves all purposes)

## 8. Dependency Management And Injection

- DI approach: Provider tree at root + optional constructor injection for testability
- App-root dependencies:
  - `ScanProvider` (created in `main.dart` via `ChangeNotifierProvider`)
  - `UrlSafetyService` (created inside `ScanProvider`; injectable via constructor for tests)
- Test replacement strategy:
  - Pass a `MockClient` (from `package:http/testing.dart`) via `UrlSafetyService(httpClient:)`
  - Pass a `UrlSafetyService` instance via `ScanProvider(urlSafetyService:)`

## 9. Navigation

- Navigation approach: Navigator 1.0 with named routes
- Route definition location: `lib/main.dart`
- Protected-route strategy: None (no authentication)
- Deep-link support: No

## 10. Persistence And External Systems

### Local Storage

- Database: None
- Key-value storage: `shared_preferences` (daily Safe Browsing request counter)
- Secure storage: `flutter_secure_storage` (Google Safe Browsing API key)

### Network

- Network client: `package:http` (injected into `UrlSafetyService`)
- Offline behavior: online-only; individual checks degrade gracefully when network is unavailable

### Platform Channels Or Native Integrations

- `mobile_scanner`: camera access and barcode detection
- `permission_handler`: runtime camera permission request
- `flutter_secure_storage`: platform keystore/keychain for API key
- `url_launcher`: open URLs in the device browser
- `share_plus`: system share sheet

## 11. Environment And Build Model

- Flavors used: None (single environment)
- Runtime config mechanism: N/A
- Build outputs supported:
  - Debug APK (`flutter build apk --debug`)
  - Release split APKs (`flutter build apk --release --split-per-abi`)
  - App Bundle (`flutter build appbundle --release`)

## 12. UI System

- Theme source of truth: `lib/main.dart`
- Design tokens location: `lib/main.dart` (`ThemeData`)
- Shared widget strategy: No shared widgets yet; all UI lives in screen files
- Accessibility expectations: Standard Material tappable targets; no custom semantics implemented

## 13. Testing Strategy

| Test Type | Scope | Notes |
|-----------|-------|-------|
| Unit | `ScanProvider` state transitions and URL detection | No mocking required |
| Unit | `UrlSafetyService` pattern/homograph checks | No mocking required |
| Unit | `UrlSafetyService` network checks | Uses `MockClient` from `package:http/testing.dart` |
| Widget | Screens | Not yet written |
| Integration | Camera → scan → result flow | Not yet written |

### Test Layout

```text
test/
|-- providers/
|   `-- scan_provider_test.dart
`-- services/
    `-- url_safety_service_test.dart
```

### Critical Test Areas

- URL detection regex in `ScanProvider`
- Suspicious pattern detection in `UrlSafetyService`
- Homograph attack detection in `UrlSafetyService`
- Rate limiting in Google Safe Browsing check

## 14. Operational Constraints

- Minimum supported OS versions: Android 7.0 (API 24)
- Performance constraints: Camera preview must run at interactive frame rate
- Regulatory or store constraints: None currently
- Team constraints: Single developer

## 15. Decisions And Tradeoffs

| Decision | Chosen Option | Why | Tradeoff |
|----------|---------------|-----|----------|
| State management | Provider/ChangeNotifier | Flutter-native, minimal setup for single-domain app | Less ergonomic than Riverpod for larger codebases |
| URL safety | 6 on-device heuristics + 1 optional API check | Privacy-friendly; API check is opt-in | No server-side intelligence without API key |
| No build flavors | Single variant | App has one environment and no side-by-side install need | Any future env split requires flavor setup from scratch |
| Tier 1 structure | Layer-first | Correct for current scope and complexity | Will need promotion to Tier 2 if independent features are added |

## 16. Known Risks And Follow-Ups

- Risk: `UrlSafetyService.checkSslCertificate` uses `dart:io` `HttpClient` which is not injectable
  Mitigation: Wrap behind an interface if unit-test coverage of the SSL check becomes necessary
- Risk: Release signing keystore is managed manually outside the repo
  Mitigation: Document location; store in a password manager; integrate CI secret store before any automated release

## 17. Related Documents

- `README.md`
- `docs/flutter_project_engineering_standard.md`
- `docs/security.md`
- `docs/release_process.md`
