# Plan: On-screen private-mode awareness + minimal fingerprint when probing

Date: 2026-06-23 12:15:00 (local)

Follow-up to `20260623_114350_stop-url-check-info-leak.md`.

## Context

The attached server-side capture (before the first fix) shows exactly what a
scanned server received:

- Device / Browser / OS = "other/Other"  → derived from the
  `User-Agent: Dart/3.11 (dart:io)` header.
- ISP (Reliance Jio) / Location (Kottayam) → derived from the public IP
  `157.51.235.240`.
- Language = "—" (no Accept-Language was sent).

So the only fingerprint we can suppress on a direct connection is the
**User-Agent** (the IP is inherent to TCP and cannot be hidden without a
proxy/Tor, which is out of scope). The first fix already stops contact entirely
in the default (private) mode.

Two remaining asks:
1. Make the user **aware on the result screen** that, in private mode, links
   are checked locally and the destination server is never contacted.
2. When the user opts into active probing, **block the maximum information** —
   i.e. omit the User-Agent entirely rather than sending it.

## Changes

### 1. `lib/services/url_safety_service.dart`
- Replace the production-default `http.Client()` with an `IOClient` whose inner
  `HttpClient` has `userAgent = null`, so the redirect/shortener HEAD requests
  send **no** User-Agent header at all (today they send an empty one).
  (`SslCertificate` already sets `client.userAgent = null`.)
- Drop the now-redundant `_minimalHeaders` empty-UA workaround.
- Make `_isActiveProbingEnabled()` public as `isActiveProbingEnabled()` so the
  provider can surface the mode to the UI (storage read stays in the service
  layer — provider only asks).

### 2. `lib/providers/scan_provider.dart`
- Add `bool _activeProbingEnabled` + public getter `activeProbingEnabled`.
- In `checkUrlSafety`, set it from
  `_urlSafetyService.isActiveProbingEnabled()` before running the checks, so
  the result screen can render the correct banner.

### 3. `lib/screens/result_screen.dart`
- In the safety card, when `!provider.activeProbingEnabled`, show a prominent
  blue "Private mode" info banner: links are checked locally; the destination
  site is not contacted; enable "Active online checks" in Settings for live
  SSL/redirect verification.
- When `provider.activeProbingEnabled`, show a short amber note that live
  checks contacted the site and exposed this device's IP.

### 4. Tests
- `test/providers/scan_provider_test.dart`: `activeProbingEnabled` defaults to
  false (with an injected service whose flag is off).
- Existing service tests unaffected (they inject MockClient).

## Verification
- `flutter analyze`
- `flutter test`

## Out of scope / honest limits
- The public IP (and therefore ISP + approximate location) **cannot** be hidden
  on a direct connection; only a proxy/VPN/Tor relay could, which this plan does
  not add. The default private mode avoids the connection entirely, which is the
  real protection.
- No new dependencies (`http`/`dart:io` already present); no state-management
  changes; service injection preserved.
