# Security

## 1. Security Scope

- App: Sreeraj P QR Reader
- Data sensitivity level: low
- Engineering standard profiles in force:
  - `Core Baseline`
  - `Sensitive Data Extension` (API key handling only)
- Platforms in scope:
  - Android

## 2. Security Objectives

- Protect the Google Safe Browsing API key from extraction via device backup or other mechanisms
- Prevent API key disclosure through log output or debug mode
- Ensure URL safety analysis degrades gracefully without exposing internal error details to users

## 3. Threat Model Summary

### In Scope Threats

- Device backup exposing the API key
- API key accidentally logged in debug output
- Accidental plain-text storage of API key (e.g., in `SharedPreferences`)

### Out Of Scope Threats

- Fully compromised or rooted device
- Physical hardware attacks
- Network interception (all API calls use HTTPS)
- Attacks requiring OS compromise

## 4. Sensitive Data Inventory

| Data Type | Example | Where It Exists | Protection Required |
|-----------|---------|-----------------|---------------------|
| Google Safe Browsing API key | `AIzaSy...` | `flutter_secure_storage`, briefly in memory during HTTP call | Platform keystore; never logged or stored in `SharedPreferences` |
| Daily request counter | Integer | `SharedPreferences` | None required (not sensitive) |

## 5. Storage Model

### At Rest

- Primary local storage: None (no user data persisted)
- Secure key storage: `flutter_secure_storage` (platform keystore on Android)
- Backup behavior: `android:allowBackup="false"` prevents API key from being included in device backups

### In Memory

- API key held briefly during the Google Safe Browsing HTTP call
- Not cached between checks

### In Transit

- Network use: HTTPS only (Google Safe Browsing API v4)
- Transport protections: TLS; no certificate pinning

## 6. Cryptography Design

No custom cryptography. API key protection delegated entirely to the platform keystore via `flutter_secure_storage`.

### Rules

- API key must not be hardcoded anywhere in source
- API key must not appear in log output
- `SharedPreferences` must not store the API key

## 7. Authentication And Access Control

No authentication or app-lock. The app is a utility with no user accounts. The only sensitive material is the optional API key, which is configured by the developer and not tied to any user identity.

## 8. Logging And Telemetry Policy

### Never Log

- API key (value)
- URL content that may contain credentials or tokens

### Allowed Diagnostic Context

- Operation name (e.g., `'Google Safe Browsing check error'`)
- Error category without sensitive values

### Logging Controls

- Logger implementation: `debugPrint` only
- Verbose logging gate: `kDebugMode` (Flutter built-in)
- Redaction strategy: API key is never passed to any logging call

## 9. Platform Security Controls

### Android

- `android:allowBackup`: `false` — prevents API key from being included in Android Auto Backup or `adb backup`
- `android:fullBackupContent`: Not configured (backup fully disabled)
- Screenshot protection: Not enabled (app displays no sensitive data)
- Root or tamper detection: None

## 10. Permissions

| Permission | Why It Is Needed | Requested When | Denial Handling |
|------------|------------------|----------------|-----------------|
| `CAMERA` | Barcode scanning via camera preview | First app launch | Permission-denied UI shown; scanning unavailable |
| `INTERNET` | Google Safe Browsing API calls and URL redirect checks | On first URL safety check | Individual checks fail gracefully; user sees check-failure result |

## 11. Backup, Import, Export, And Recovery

- Backup supported: No (`android:allowBackup="false"`)
- Import supported: No
- Export supported: No (API key is not exportable by design)
- Recovery flow: User must re-enter the API key if the app is uninstalled or data is cleared

## 12. Security Testing Strategy

| Area | Test Type | Notes |
|------|-----------|-------|
| URL pattern detection | Unit | Deterministic; no mocking required |
| Homograph detection | Unit | Deterministic; no mocking required |
| Google Safe Browsing API call | Unit | `MockClient` used; platform secure storage returns null in test environment |
| API key not logged | Code review | Verify no `debugPrint` passes the API key value |

### Required Test Vectors Or Regression Areas

- IP address in domain (`https://192.168.1.1`)
- Phishing keyword + number pattern (`https://login-verify123.com`)
- Cyrillic lookalike in domain (`https://ex\u0430mple.com`)
- API key absent → "Skipped" result (not a failure)

## 13. Incident Response Notes

- Triage owner: Sreeraj P (sole developer)
- Severity model: API key leak → revoke and replace immediately in Google Cloud Console
- Immediate containment:
  - Revoke the exposed key in Google Cloud Console
  - Publish an updated app version with instructions to re-enter a new key
- User communication trigger: If the leaked key is believed to have been used maliciously by a third party
- Patch release reference: `docs/release_process.md`

## 14. Open Risks And Follow-Ups

- Risk: Google Safe Browsing API key has no in-app access control — any device user can trigger API usage
  Hardening option: Add a device-credential or PIN gate before URL checks
- Risk: SSL certificate check uses `dart:io` `HttpClient` which is not injectable; cannot be unit-tested
  Hardening option: Wrap in an injectable abstraction

## 15. Security Review Checklist

- [x] Threat model reviewed
- [x] Sensitive data inventory updated
- [x] Logging policy reviewed — no secrets in `debugPrint` calls
- [x] `android:allowBackup="false"` confirmed in `AndroidManifest.xml`
- [x] Storage permissions not declared (not needed for QR scanning)
- [x] API key stored only in `flutter_secure_storage`
- [x] Tests cover URL pattern detection and homograph detection
- [ ] Full integration test for API key storage and retrieval
- [ ] Widget tests for settings screen (API key entry form)
