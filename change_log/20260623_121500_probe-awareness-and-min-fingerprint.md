# Change log: Private-mode awareness on screen + minimal fingerprint when probing

Date: 2026-06-23 (implements
`plans/20260623_121500_probe-awareness-and-min-fingerprint.md`)

Follow-up to `20260623_114350_stop-url-check-info-leak.md`.

## What changed

### `lib/services/url_safety_service.dart`
- The production-default HTTP client is now
  `IOClient(HttpClient()..userAgent = null)`, so redirect/shortener requests
  (when active probing is enabled) carry **no User-Agent header at all** —
  removing the `Dart/<version> (dart:io)` string that gave the server
  Device/Browser/OS. Previously an empty UA was sent.
- Removed the now-redundant `_minimalHeaders` constant and its two usages.
- Renamed `_isActiveProbingEnabled()` to public `isActiveProbingEnabled()` so
  the provider can surface the mode to the UI (storage read stays in the
  service layer).

### `lib/providers/scan_provider.dart`
- Added `bool _activeProbingEnabled` with public getter `activeProbingEnabled`.
- `checkUrlSafety` sets it from `_urlSafetyService.isActiveProbingEnabled()`
  before running the checks.

### `lib/screens/result_screen.dart`
- Added `_buildProbingModeBanner` to the URL safety card:
  - Private mode (default): blue banner explaining the link was analysed with
    local rules + Google Safe Browsing only, the site was never contacted, and
    the IP/device were not exposed; hints to enable active checks in Settings.
  - Active mode: amber banner warning that the checks contacted the site and
    exposed the device IP, with how to turn it off.

### `test/providers/scan_provider_test.dart`
- Added: `activeProbingEnabled` defaults to false.

## Verification
- `flutter analyze` — No issues found.
- `flutter test` — All 47 tests pass.

## Honest limits
- On a direct connection the public IP (and thus ISP + approximate location)
  cannot be hidden; only a proxy/VPN/Tor could, which was not added. The default
  private mode avoids the connection entirely, which is the real protection.
  The User-Agent is the only fingerprint suppressible here, and it is now fully
  omitted.
