# Plan: Stop device/IP/connection info leaking to scanned servers during URL sanity check

Date: 2026-06-23 11:43:50 (local)

## The issue

`UrlSafetyService.runAllChecks` proactively contacts the **scanned URL's own
server** in three of its six checks, automatically, before the user decides to
open the link:

- `checkSslCertificate` — `HttpClient.getUrl()` GET to the host.
- `checkUrlRedirects` — `HEAD` request, then follows redirects to each hop.
- `checkUrlShorteners` — `HEAD` request to the host.

Each direct connection exposes to a potentially malicious destination:

- The device's **public IP address** (reveals approximate location and the
  **mobile carrier / ISP** — the "mobile connection").
- The **`User-Agent`** header that `dart:io` adds automatically
  (`Dart/<version> (dart:io)`), a runtime/device fingerprint.
- The TLS client fingerprint.

Result: scanning a phishing/malware QR makes the app immediately ping the
attacker's server, leaking the user's IP and the fact that they scanned it.

Not affected:
- `checkSuspiciousPatterns`, `checkHomographAttacks` — purely local, no network.
- `checkGoogleSafeBrowsing` — sends the URL only to Google's API (trusted
  endpoint), never to the destination. This is the correct channel and stays.
- `result_screen.dart` `launchUrl` — user-initiated open, not a leak.

## Fix (recommended: privacy-first, opt-in)

Stop contacting the destination server **by default**; require an explicit
user opt-in for active online probing, and even then minimize what is sent.

1. New non-sensitive preference `active_probing_enabled` (default **false**),
   stored in `SharedPreferences` (counter-style data, allowed by project rules).
2. `UrlSafetyService` reads this flag at the start of `runAllChecks` (the
   service already reads `SharedPreferences`/secure storage, so the provider
   stays thin and no check algorithms move into the provider). The flag is
   threaded into the three network checks. When the flag is **false**:
   - `checkSslCertificate`: local-only — confirm the scheme is `https`
     (encrypted) without opening a socket. Message reflects that the live
     certificate was not contacted. `http` scheme still fails as today.
   - `checkUrlRedirects`: skip the network probe; return a neutral,
     non-failing result ("Skipped — private mode, server not contacted").
   - `checkUrlShorteners`: run only the local known-shortener list + heuristic
     pattern detection; skip the `HEAD` probe.
   - Pattern, Homograph, Safe Browsing: unchanged.
3. When the flag is **true** (user opted in), still strip the fingerprint:
   set a neutral/empty `User-Agent` on both the `dart:io HttpClient` and the
   `http` requests so the `Dart/... (dart:io)` string is not sent. (The IP
   cannot be hidden on a direct connection — the Settings copy will say so.)
4. All six checks remain, each still returns a single `SafetyCheckResult`
   (per CLAUDE.md). Skipped checks return `passed: true` so they do not produce
   false "unsafe" verdicts, and their messages don't match `hasNetworkError`.

## Alternative (if you prefer)

Remove the three active probes entirely (no toggle): SSL becomes a local
https-scheme check, redirect analysis is dropped to a local note, shortener
check keeps only local heuristics. Simpler, but permanently loses live
certificate/redirect detection. I recommend the opt-in approach above instead.

## Files to change

- `lib/services/url_safety_service.dart`
  - Read `active_probing_enabled` (default false) in `runAllChecks`.
  - Guard the three network checks behind the flag; add local-only fallbacks.
  - Set a neutral `User-Agent` on outbound requests when probing is enabled.
- `lib/screens/settings_screen.dart`
  - Add a `SwitchListTile` for "Active online checks" (default off) with
    explanatory + warning text about contacting the destination and exposing IP.
- `test/services/url_safety_service_test.dart`
  - Add coverage: default (flag false) performs no network call to the host;
    opt-in path still works; neutral User-Agent is sent.

## Verification

- `flutter analyze`
- `flutter test`

## Out of scope

- No new dependencies, no state-management changes, service injection preserved.
- `lib/providers/scan_provider.dart` unchanged (service reads the flag itself).
