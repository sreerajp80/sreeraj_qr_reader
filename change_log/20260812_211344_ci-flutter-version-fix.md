# Change log — CI Flutter version fix and code formatting

**Plan:** [plans/20260812_205949_ci-flutter-version-fix.md](../plans/20260812_205949_ci-flutter-version-fix.md)
**Date:** 2026-08-12 21:13:44 (local)

## Why

GitHub Actions run **CI #5** (commit `30b425f`, branch `main`) failed. The
`validate` job stopped at `flutter pub get` with:

> The current Dart SDK version is 3.11.1.
> Because sreeraj_qr_reader requires SDK version >=3.12.2 <4.0.0, version solving failed.

The workflow pinned Flutter `3.41.4`, which ships Dart `3.11.1`. The project needs
Dart `>=3.12.2` and Flutter `>=3.44.8`. So CI was older than the project.

A second problem appeared while checking the fix: 9 files were not formatted, so
the `dart format --set-exit-if-changed` step would have failed next.

## What changed

### 1. CI Flutter version — `.github/workflows/ci.yml`

- `flutter-version: '3.41.4'` → `flutter-version: '3.44.9'`
- `channel: 'stable'` left as is. No other workflow change.
- `3.44.9` is the version Flutter suggested in the failure log. It meets both the
  Dart (`>=3.12.2`) and Flutter (`>=3.44.8`) constraints in `pubspec.yaml`.

### 2. Code formatting — `dart format .`

Formatting-only edits (whitespace and line layout). No logic or behaviour change:

- `lib/screens/scanner_screen.dart`
- `lib/screens/settings_screen.dart`
- `lib/screens/widgets/calendar_action_card.dart`
- `lib/screens/widgets/contact_action_card.dart`
- `lib/screens/widgets/geo_action_card.dart`
- `lib/screens/widgets/totp_action_card.dart`
- `lib/screens/widgets/wifi_action_card.dart`
- `lib/services/media_scan_service.dart`
- `test/screens/settings_screen_test.dart`

`pubspec.yaml` was **not** changed. Its SDK constraints were already correct.

## Verification

All four CI steps were run locally on Flutter 3.44.8 / Dart 3.12.2:

| Step | Result |
|------|--------|
| `flutter pub get` | Passed |
| `dart format --output=none --set-exit-if-changed .` | Passed (0 changed) |
| `flutter analyze` | Passed — no issues found |
| `flutter test` | Passed — 150 tests |

Still to confirm: the CI run itself, after these changes are pushed.
