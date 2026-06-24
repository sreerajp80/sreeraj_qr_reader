# Fix CI failure: formatting check (and Node 20 warning)

## Issue

GitHub Actions CI (`.github/workflows/ci.yml`) fails on the **Check formatting** step:

```
dart format --output=none --set-exit-if-changed .
Process completed with exit code 1.
```

7 files are not formatted to `dart format` standards, so the step exits non-zero and fails the `validate` job:

- `lib/main.dart`
- `lib/providers/scan_provider.dart`
- `lib/screens/result_screen.dart`
- `lib/screens/settings_screen.dart`
- `lib/services/url_safety_service.dart`
- `test/providers/scan_provider_test.dart`
- `test/services/url_safety_service_test.dart`

Separately, CI prints a non-fatal **warning**: `actions/checkout@v4` targets Node.js 20,
which GitHub is deprecating (forced onto Node 24). This does not fail the build.

## Files to be changed

1. The 7 source/test files above — reformatted by `dart format .` (whitespace/layout only, no logic changes).
2. (Optional, only if approved) `.github/workflows/ci.yml` — bump `actions/checkout@v4` -> `@v5` to clear the Node 20 deprecation warning.

## Plan for the fix

1. Run `dart format .` to reformat the 7 files.
2. Verify with `dart format --output=none --set-exit-if-changed .` (should exit 0).
3. Run `flutter analyze` and `flutter test` to confirm nothing broke.
4. (Optional) Update `actions/checkout@v4` to `@v5` in `ci.yml` to silence the Node 20 warning.

## Notes

- Formatting changes are mechanical and safe; no behavior change.
- The Node 20 item is a warning, not the cause of the failure. I recommend doing it too since it's a one-line change, but it can be skipped.
