# Dependencies — SreerajP QR Reader

This document records approved packages, dependency categories, and prohibited packages for SreerajP QR Reader. Read this before adding or updating any dependency in `pubspec.yaml`.

**Read first:**
- [CLAUDE.md](../CLAUDE.md)
- [architecture.md](architecture.md)
- [security.md](security.md)
- [guidelines/flutter_project_engineering_standard.md](guidelines/flutter_project_engineering_standard.md)

---

## 1. Dependency Principles

- **Minimal Surface Area:** Prefer Flutter framework utilities over third-party packages when available (e.g. Flutter `Clipboard` service).
- **Security Gating:** Check package license, maintainer health, and transitive network requirements before adding dependencies.
- **No Unnecessary Abstractions:** Keep dependencies scoped to core requirements.

---

## 2. Approved Production Dependencies

| Package | Version | Purpose | Security / Privacy Note |
|---------|---------|---------|-------------------------|
| `mobile_scanner` | `^7.2.0` | Live camera QR and barcode scanning | Requires camera permission |
| `http` | `^1.6.0` | HTTP requests for URL safety checks | Gated within `UrlSafetyService` |
| `url_launcher` | `^6.3.2` | Open URLs in system web browser | System intent launcher |
| `share_plus` | `^12.0.1` | Share scanned text/URLs via system share sheet | System share sheet intent |
| `permission_handler` | `^12.0.1` | Manage runtime camera permissions | Requests camera permission on demand |
| `provider` | `^6.1.5` | App state management (`ChangeNotifier`) | Zero external network calls |
| `package_info_plus` | `^9.0.0` | Retrieve app name, package ID, and version | Local platform channel read |
| `flutter_secure_storage` | `^10.0.0` | Encrypted storage for API keys | Uses Android KeyStore |
| `shared_preferences` | `^2.5.5` | Non-sensitive preferences (request counters) | Plaintext local preferences |

---

## 3. Approved Development Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_test` | SDK | Framework test library |
| `flutter_lints` | `^6.0.0` | Static analysis rules baseline |

---

## 4. Prohibited Dependencies

> **WARNING:** Do not add any of the following package types to `pubspec.yaml` without explicit architectural review:

- **Analytics / Tracking SDKs:** Firebase Analytics, Mixpanel, Amplitude, Flurry.
- **Crash Reporting SDKs:** Sentry, Crashlytics.
- **Ad Frameworks:** AdMob, Unity Ads, AppLovin.
- **Heavy State Frameworks:** Riverpod, Bloc, Redux (Provider is the single standard for this app).
