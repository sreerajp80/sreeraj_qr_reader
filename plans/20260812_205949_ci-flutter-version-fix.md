# Fix CI failure — Flutter version too old in GitHub Actions

**Status:** completed

## Files to change

- `.github/workflows/ci.yml`

## What the issue is

The GitHub Actions run **CI #5** (commit `30b425f`, branch `main`) failed at the
`flutter pub get` step of the `validate` job.

The log says:

```
Resolving dependencies...
The current Dart SDK version is 3.11.1.

Because sreeraj_qr_reader requires SDK version >=3.12.2 <4.0.0, version solving failed.

You can try the following suggestion to make the pubspec resolve:
* Try using the Flutter SDK version: 3.44.9.
Failed to update packages.
```

Reason: the workflow pins Flutter `3.41.4` (see `.github/workflows/ci.yml` line 17).
That Flutter version bundles Dart `3.11.1`. But `pubspec.yaml` asks for:

- Dart SDK `>=3.12.2 <4.0.0`
- Flutter `>=3.44.8`

So the pinned CI Flutter is older than the project needs, and dependency
resolution stops. Every later step (format, analyze, test) never runs.

## The plan for the fix

1. In `.github/workflows/ci.yml`, change `flutter-version: '3.41.4'` to
   `flutter-version: '3.44.9'`.
   - `3.44.9` is the version Flutter itself suggested in the failure log, and it
     satisfies both the Dart (`>=3.12.2`) and Flutter (`>=3.44.8`) constraints.
   - Keep `channel: 'stable'` as is.
2. No other file changes. `pubspec.yaml` stays untouched — the project constraint
   is correct; only CI was behind.

## How it will be checked

- Run `flutter pub get`, `dart format --output=none --set-exit-if-changed .`,
  `flutter analyze`, and `flutter test` locally so the same steps CI runs are
  known to pass.
- After the change is pushed, confirm the CI `validate` job goes green.

## Added after approval — formatting fix

While running the CI steps locally, a second failure showed up. The format step
`dart format --output=none --set-exit-if-changed .` reported 9 files that were
not formatted, so CI would still fail even after the version bump.

The user approved widening this plan to also run `dart format .` on those files:

- `lib/screens/scanner_screen.dart`
- `lib/screens/settings_screen.dart`
- `lib/screens/widgets/calendar_action_card.dart`
- `lib/screens/widgets/contact_action_card.dart`
- `lib/screens/widgets/geo_action_card.dart`
- `lib/screens/widgets/totp_action_card.dart`
- `lib/screens/widgets/wifi_action_card.dart`
- `lib/services/media_scan_service.dart`
- `test/screens/settings_screen_test.dart`

These are whitespace/layout changes only. No app behaviour changes.

## Notes / risk

- Low risk: this is a CI-only change, no app code touched.
- If the local machine's Flutter is also older than `3.44.8`, the local checks
  may not run. In that case the CI run itself is the verification.
