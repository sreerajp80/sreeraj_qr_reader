# Change log: Fix CI failure (formatting + analyze)

Implements plan: `plans/20260624_192827_fix-ci-formatting.md`

## Context

GitHub Actions `validate` job failed at the **Check formatting** step
(`dart format --output=none --set-exit-if-changed .`, exit code 1). After fixing
formatting, the **Analyze** step would have failed next on 2 pre-existing `info`
lints (`flutter analyze` exits 1 even on info-level issues).

## Changes

1. **Reformatted 7 files** via `dart format .` (whitespace/layout only, no logic change):
   - `lib/main.dart`
   - `lib/providers/scan_provider.dart`
   - `lib/screens/result_screen.dart`
   - `lib/screens/settings_screen.dart`
   - `lib/services/url_safety_service.dart`
   - `test/providers/scan_provider_test.dart`
   - `test/services/url_safety_service_test.dart`

2. **Fixed 2 `curly_braces_in_flow_control_structures` lints** in
   `lib/services/url_safety_service.dart` (wrapped single-line `if (kDebugMode)`
   debugPrint statements in braces) at the former lines 360-361 and 570-571.

3. **`.github/workflows/ci.yml`**: bumped `actions/checkout@v4` -> `@v5` to clear the
   Node.js 20 deprecation warning (warning only; was not the cause of the failure).

## Verification (local)

- `dart format --output=none --set-exit-if-changed .` -> exit 0
- `flutter analyze` -> "No issues found!", exit 0
- `flutter test` -> 47 tests, all passed
