# Change log — app name is now "SreerajP QR Reader"

Implements plan `plans/20260818_194824_app-name-sreerajp.md`.

## What was wrong

The app name was written two ways. `assets/config/app_config.json` said
**SreerajP QR Reader** (no space), while the Android label, the app code, the
localization file and all the documents said **Sreeraj P QR Reader** (with a
space).

## What changed

Every place that held the *app* name now says **SreerajP QR Reader**.

### App code and resources
- `android/app/src/prod/res/values/strings.xml` — the Android launcher label.
  The `dev` flavor label (`QR Reader Dev`) was left alone.
- `lib/core/config/app_config.dart` — the built-in fallback `appName`.
- `lib/l10n/app_en.arb` — the `appTitle` string.
- `lib/l10n/gen/app_localizations.dart` and
  `lib/l10n/gen/app_localizations_en.dart` — rebuilt with `flutter gen-l10n`.
- `lib/services/history_export_service.dart` — the `"app"` value written into
  the JSON export.

### Tests
- `test/services/history_export_service_test.dart` — the matching expectation
  for the JSON export `app` field.

### Documentation
- `CLAUDE.md`, `AGENTS.md`, `README.md`
- `docs/architecture.md`, `docs/dependencies.md`, `docs/features.md`,
  `docs/feature_analysis_and_roadmap.md`, `docs/implementation_plan.md`,
  `docs/implementation_progress.md`, `docs/project_structure.md`,
  `docs/release_process.md`, `docs/security.md`, `docs/workflow_rules.md`

Older files in `plans/` were left as they are, because they are history.

## What did NOT change

- The person's name **Sreeraj P** stays the same: the `Author` field in
  `assets/config/app_config.json`, the copyright line on the About screen,
  the release-owner rows in `docs/release_process.md`, and the vCard test
  fixture. The replacement matched only the full phrase, so a bare
  "Sreeraj P" was never touched.
- The package id `in.sreeraj.qr_reader`, the Flutter project name
  `sreeraj_qr_reader`, the version, and the signing setup. Only the shown
  label changed, so this is not a new app for the store.

## Note on exported files

New JSON exports carry `"app": "SreerajP QR Reader"`. The import path does not
read that field (it reads only `records`), so files exported by older builds
still import correctly.

## Checks run

- `flutter gen-l10n` — regenerated the localization files.
- `dart format .` — 86 files, 0 changed.
- `flutter analyze` — No issues found.
- `flutter test` — 154 tests, all passed.
