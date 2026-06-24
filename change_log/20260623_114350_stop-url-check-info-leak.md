# Change log: Stop device/IP/connection info leaking during URL sanity check

Date: 2026-06-23 (implements
`plans/20260623_114350_stop-url-check-info-leak.md`)

## Problem

`UrlSafetyService.runAllChecks` automatically connected to the scanned URL's
own server in three checks (`checkSslCertificate`, `checkUrlRedirects`,
`checkUrlShorteners`), exposing the device's public IP (and therefore
approximate location and mobile carrier) plus the default
`Dart/<version> (dart:io)` User-Agent to a potentially malicious destination —
before the user chose to open the link.

## What changed

### `lib/services/url_safety_service.dart`
- Added `activeProbingPrefKey = 'active_probing_enabled'` (SharedPreferences,
  non-sensitive) and a private `_minimalHeaders` const with an empty
  User-Agent.
- `runAllChecks` reads the flag (default **false**) and threads it into the
  three network checks via a new `{bool activeProbing = false}` parameter.
- Private mode (default, flag false):
  - `checkSslCertificate`: no socket opened; confirms the `https` scheme only
    (plain `http` still fails). 
  - `checkUrlRedirects`: skipped with a neutral, non-failing result
    ("Skipped in private mode (destination server not contacted)").
  - `checkUrlShorteners`: local known-list + heuristics only; the `HEAD` probe
    is gated behind `activeProbing`.
- When the user opts in, the `dart:io HttpClient` User-Agent is set to `null`
  and the `http` requests send `_minimalHeaders`, so the Dart/device
  fingerprint is not sent (IP is inherent to a direct connection and cannot be
  hidden).
- All six checks retained, each still returns one `SafetyCheckResult`.
- `checkGoogleSafeBrowsing` unchanged (URL goes only to Google).

### `lib/screens/settings_screen.dart`
- New "Privacy" section with an "Active online checks" `SwitchListTile`
  (default off), persisted to `active_probing_enabled`, with explanatory copy
  describing the IP-exposure trade-off when enabled.

### `test/services/url_safety_service_test.dart`
- Existing redirect tests now pass `activeProbing: true`.
- Added tests: redirect/shortener make no request in private mode; SSL confirms
  https without connecting and still fails plain http; known shortener is still
  flagged locally.

## Verification
- `flutter analyze` — No issues found.
- `flutter test` — All 46 tests pass.

## Notes
- `lib/providers/scan_provider.dart` unchanged (service reads the flag itself).
- No new dependencies; no state-management changes; service injection preserved.
