# Architecture — SreerajP QR Reader

This document defines the technical architecture, data flow, state management, and component boundaries for SreerajP QR Reader. Read this before modifying application structure, providers, services, models, or screens.

**Read first:**
- [CLAUDE.md](../CLAUDE.md)
- [security.md](security.md)
- [workflow_rules.md](workflow_rules.md)
- [guidelines/architecture.md](guidelines/architecture.md)
- [guidelines/flutter_project_engineering_standard.md](guidelines/flutter_project_engineering_standard.md)

---

## 1. Scope

- Product: SreerajP QR Reader
- Repository type: application
- Engineering standard profiles in force:
  - `Core Baseline`
- Platforms: Android (minSdk 24, targetSdk 35)

---

## 2. Goals And Non-Goals

### Goals

- Scan QR codes and barcodes using device camera
- Analyse scanned URLs across six security dimensions
- Allow users to copy, share, or open scanned content securely

### Non-Goals

- iOS, web, or desktop support
- Cloud sync or backend services
- User accounts or authentication

---

## 3. Architecture Summary

The app uses a Tier 1 layer-first Flutter structure with Provider for state management. `ScannerScreen` delegates scan events to `ScanProvider`, which coordinates URL safety analysis through `UrlSafetyService`. Sensitive data (the Google Safe Browsing API key) is isolated behind `flutter_secure_storage`; non-sensitive counters use `SharedPreferences`. Widgets do not know HTTP, storage, or cryptography.

---

## 4. Repository Structure

### Current Structure Tier

- `Tier 1`
- Why this tier is appropriate now:
  - Single domain, single developer, focused scope
  - No independent product areas requiring feature isolation

### Top-Level Source Layout

```text
assets/
`-- config/
    `-- app_config.json          # About screen values (single source of truth)
lib/
|-- core/
|   |-- config/
|   |   |-- app_config.dart      # AppConfig model & fallback
|   |   `-- config_service.dart  # Config asset loader
|   `-- constants/
|       `-- app_constants.dart   # Technical constants
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
| `assets/config/` | Data source of truth for About metadata |
| `lib/core/config/` | About screen data model (`AppConfig`) and loader service (`ConfigService`) |
| `lib/core/constants/` | Technical app constants (`AppConstants`) |
| `lib/models/` | Immutable data types shared across layers |
| `lib/providers/` | ChangeNotifier state; bridges UI and service layer |
| `lib/screens/` | UI-only widgets; no business logic |
| `lib/services/` | Business logic and external API calls |

---

## 5. State Management

- Primary pattern: `Provider` (`ChangeNotifier`)
- Why this pattern was chosen:
  - Fits the simple linear data flow of scan → analyse → display
  - Flutter-native; no dependency beyond the `provider` package
- State boundaries:
  - Widgets own: UI-only state (copy feedback timer, scroll position)
  - `ScanProvider` owns: scan result, safety check results, loading flag
  - `UrlSafetyService` owns: stateless check logic only

---

## 6. Data Flow

```text
Widget -> ScanProvider -> UrlSafetyService -> HTTP / SecureStorage
```

`UrlSafetyService` is stateless and returns results as value objects. `ScanProvider` owns all mutable state.

### Rules

- Widgets must not know: HTTP, storage, encryption
- `ScanProvider` must not know: navigation, UI copy
- `UrlSafetyService` must not call `notifyListeners` or import widget classes

---

## 7. Domain Model

### Core Models Or Entities

| Type | Purpose | Mutable? | Notes |
|------|---------|----------|-------|
| `SafetyCheckResult` | Holds outcome of one URL safety check | No | `const` constructor |
| `BarcodeType` | Identifies kind of barcode scanned | No | From `mobile_scanner` package |

### Serialization Strategy

- JSON models: No (no persistence of domain entities)
- Database models: No
- Separate domain entities from transport models: No (Tier 1; single shape serves all purposes)

---

## 8. Dependency Management And Injection

- DI approach: Provider tree at root + optional constructor injection for testability
- App-root dependencies:
  - `ScanProvider` (created in `main.dart` via `ChangeNotifierProvider`)
  - `UrlSafetyService` (created inside `ScanProvider`; injectable via constructor for tests)
- Test replacement strategy:
  - Pass a `MockClient` (from `package:http/testing.dart`) via `UrlSafetyService(httpClient:)`
  - Pass a `UrlSafetyService` instance via `ScanProvider(urlSafetyService:)`

---

## 9. Navigation

- Navigation approach: Navigator 1.0 with named routes
- Route definition location: `lib/main.dart`
- Protected-route strategy: None (no authentication)
- Deep-link support: No

---

## 10. Persistence And External Systems

### Local Storage

- Database: None
- Key-value storage: `shared_preferences` (daily Safe Browsing request counter)
- Secure storage: `flutter_secure_storage` (Google Safe Browsing API key)

### Network

- Network client: `package:http` (injected into `UrlSafetyService`)
- Offline behavior: online-only for API check; individual checks degrade gracefully when network is unavailable

### Platform Channels Or Native Integrations

- `mobile_scanner`: camera access and barcode detection
- `permission_handler`: runtime camera permission request
- `flutter_secure_storage`: platform keystore/keychain for API key
- `url_launcher`: open URLs in the device browser
- `share_plus`: system share sheet

---

## 11. Environment And Build Model

- Flavors used: `dev` and `prod`
- Runtime config mechanism: `FLUTTER_APP_FLAVOR`
- Build outputs supported:
  - Debug APK (`flutter build apk --flavor dev --debug`)
  - Release split APKs (`flutter build apk --flavor prod --release --split-per-abi`)
  - App Bundle (`flutter build appbundle --flavor prod --release`)

---

## 12. UI System

- Theme source of truth: `lib/main.dart`
- Design tokens location: `lib/main.dart` (`ThemeData`)
- Shared widget strategy: No shared widgets yet; all UI lives in screen files
- Accessibility expectations: Standard Material tappable targets

---

## 13. Testing Strategy

| Test Type | Scope | Notes |
|-----------|-------|-------|
| Unit | `ScanProvider` state transitions and URL detection | No mocking required |
| Unit | `UrlSafetyService` pattern/homograph checks | No mocking required |
| Unit | `UrlSafetyService` network checks | Uses `MockClient` from `package:http/testing.dart` |

### Test Layout

```text
test/
|-- providers/
|   `-- scan_provider_test.dart
`-- services/
    `-- url_safety_service_test.dart
```

---

## 14. Related Documents

- [CLAUDE.md](../CLAUDE.md)
- [security.md](security.md)
- [release_process.md](release_process.md)
- [dependencies.md](dependencies.md)
- [guidelines/architecture.md](guidelines/architecture.md)
