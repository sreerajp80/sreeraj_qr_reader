# Full localization: ARB setup and removal of every user-visible string literal

**Status:** in_progress

## Progress so far (updated 2026-08-17)

Steps 1 and part of step 2 are done and committed. The repository is green at every
commit: `flutter analyze` reports no issues and all 150 tests pass.

**Done**

- Step 1 infrastructure: `flutter_localizations`, `intl`, `generate: true`, `l10n.yaml`,
  `lib/l10n/app_en.arb`, generated code in `lib/l10n/gen/` (committed), and `MaterialApp`
  wired with `localizationsDelegates`, `supportedLocales`, and `onGenerateTitle`.
- All 16 files in `lib/screens/widgets/` — every user-visible literal moved to ARB.
  `scan_overlay_widget.dart` and `ar_floating_chip_widget.dart` had none to move.
- 4 of 8 screens: `about_screen.dart`, `air_qr_transmitter_screen.dart`,
  `ar_codevision_screen.dart`, `air_qr_screen.dart`.
- `history_card.dart` now formats dates with `intl` `DateFormat` using the reader's locale,
  replacing a hard-coded English month list and AM/PM.
- `test/screens/settings_screen_test.dart` now installs the localization delegates.

**Not started**

- Step 2 remainder — 4 screens: `history_screen.dart` (about 29 literals),
  `scanner_screen.dart` (43), `result_screen.dart` (71), `settings_screen.dart` (187).
- Step 3 — `AppMessageKey`, `AppMessage`, `lib/l10n/app_message_text.dart`, the 5 models,
  the 10 services, and the 5 providers.
- Step 4 — the biometric prompt and the PDF report label special cases.
- Step 5 — the remaining test updates and `test/l10n/app_message_text_test.dart`.

**Deviation from the plan, agreed by the tool**

`l10n.yaml` does not set `synthetic-package: false` as the plan said. Flutter 3.44.8 reports
that option as removed and ignores it. Generated code still lands in `lib/l10n/gen/` through
`output-dir`, which was the point of the setting, so the outcome is unchanged.

Gap 1 of 3, and by far the largest. Do this last, after the two smaller plans.

## What the issue is

The updated engineering standard makes §8.2 **mandatory for every app, even a single-language
one**. `docs/guidelines/guideline.md` repeats it as a MUST. This project meets none of it:

| Required | Now |
|---|---|
| `l10n.yaml` at project root | missing |
| `lib/l10n/app_en.arb` | missing |
| `flutter_localizations` + `intl` in `pubspec.yaml`, `generate: true` | missing |
| `localizationsDelegates` / `supportedLocales` in `MaterialApp` | missing |
| No raw user-visible string literal in a widget | about 421 in `lib/screens/` |
| All user-visible text from `AppLocalizations` | about 218 more come from `lib/services/`, 16 from `lib/providers/` |

There is a second, older problem that the same work must fix. Both `CLAUDE.md` and `AGENTS.md`
already say: *"Services must not depend on `BuildContext`, UI strings, or navigation routes."*
Today many services do hold English UI text — for example `lib/services/url_safety_service.dart`
builds 31 `SafetyCheckResult` objects with English `checkName` and `message` values. So the
services are already breaking the project's own layer rule. Localizing them fixes both problems
at once.

The user has chosen the **full one-pass** scope: screens, widgets, providers, services, models
and tests, all in this plan.

## Design

Services must not import `AppLocalizations` (that would need a `BuildContext`). So services stop
returning English text and start returning a **message key plus arguments**. The UI turns that
into text.

New pieces:

- `lib/models/app_message_key.dart` — an `enum AppMessageKey` with one value per message a
  service or provider can produce (for example `httpsNotUsed`, `certificateExpired`,
  `shortenerRedirect`).
- `lib/models/app_message.dart` — an immutable `AppMessage` holding an `AppMessageKey` and a
  `Map<String, String>` of arguments, for messages that carry data such as a host name.
- `lib/l10n/app_message_text.dart` — a UI-layer function that takes `AppLocalizations` and an
  `AppMessage` and returns the final string. One `switch` over the enum. This is the only place
  that joins keys to text.

Flow: `service → AppMessage → provider → screen → AppLocalizations → text on screen`.
This keeps the existing dependency direction `screens → providers → services → models`.

### Settings for `l10n.yaml`

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
nullable-getter: false
synthetic-package: false
output-dir: lib/l10n/gen
```

`synthetic-package: false` is the choice the guideline asks us to make and document: generated
code lands in `lib/l10n/gen/` and is imported by a normal `package:` import. The generated files
**will be committed**, so `flutter analyze` in CI passes without an extra generation step.

### Key naming

`screenOrArea` + `whatItIs`, in `camelCase` — for example `settingsTitle`,
`settingsActiveProbingSubtitle`, `resultCopyButton`, `safetyHttpsNotUsed`. Every key gets an
`@key` description entry, as §8.2 requires.

## Files to be changed

### New files

- `l10n.yaml`
- `lib/l10n/app_en.arb`
- `lib/l10n/app_message_text.dart`
- `lib/l10n/gen/` (generated by `flutter gen-l10n`, committed)
- `lib/models/app_message.dart`
- `lib/models/app_message_key.dart`
- `test/l10n/app_message_text_test.dart`

### Changed files

- `pubspec.yaml` — add `flutter_localizations` (sdk), `intl`, and `flutter: generate: true`
- `lib/main.dart` — add `localizationsDelegates`, `supportedLocales`, and take the `MaterialApp`
  title from `onGenerateTitle` so the app name is localized too
- All 23 files under `lib/screens/` (7 screens, 16 widgets)
- All 5 files under `lib/providers/`
- Services holding user-visible text: `url_safety_service.dart`, `quishing_guard_service.dart`,
  `dom_sandbox_service.dart`, `stego_qr_service.dart`, `air_qr_service.dart`,
  `payload_parser_service.dart`, `media_scan_service.dart`, `payload_action_service.dart`,
  `biometric_service.dart`, `history_export_service.dart`
- Models carrying message text: `safety_check_result.dart`, `quishing_analysis_result.dart`,
  `dom_sandbox_result.dart`, `stego_qr_data.dart`, `air_qr_progress.dart`
- Tests that assert on English message text: `test/services/url_safety_service_test.dart`,
  `quishing_guard_service_test.dart`, `dom_sandbox_service_test.dart`, `stego_qr_service_test.dart`,
  `payload_parser_service_test.dart`, `media_scan_service_test.dart`,
  `history_export_service_test.dart`, `test/providers/scan_provider_quishing_test.dart`,
  `test/screens/settings_screen_test.dart`

## Plan for the fix

**Step 1 — infrastructure.** Add the dependencies, `l10n.yaml`, an empty-but-valid
`lib/l10n/app_en.arb`, and wire `MaterialApp`. Run `flutter gen-l10n`. Confirm the app still
builds. No strings moved yet.

**Step 2 — screens and widgets.** File by file, move every user-visible literal into
`app_en.arb` and read it through `AppLocalizations.of(context)`. Start with the largest,
`lib/screens/settings_screen.dart` (1557 lines, about 54 obvious labels), then the rest.
Run `flutter analyze` after each file.

**Step 3 — message keys for services.** Add `AppMessageKey`, `AppMessage`, and
`app_message_text.dart`. Convert the five models to carry `AppMessage` instead of `String`
message fields. Convert the ten services to return keys and arguments. Update providers to pass
them through untouched.

**Step 4 — the two special cases.**
- `lib/services/biometric_service.dart` passes a prompt string to `local_auth`, which needs a
  real `String`. The screen will read the localized text and pass it into the service as a
  parameter, so the service holds no English text.
- `lib/services/history_export_service.dart` builds a PDF report that a user reads. The screen
  will pass in a small object of already-localized labels.

**Step 5 — tests.** Update the listed tests to assert on `AppMessageKey` values instead of
English sentences. Add `test/l10n/app_message_text_test.dart` asserting that every
`AppMessageKey` value resolves to a non-empty string — this is the test that stops a key being
added without text.

**Step 6 — finish.** Run `flutter gen-l10n`, `dart format .`, `flutter analyze` (must be zero
warnings), `flutter test` (all must pass). Write the change log.

## Strings that stay as literals (allowed exceptions)

§8.2 allows these, and I will keep them as plain Dart:

- log and debug messages;
- exception messages never shown on screen;
- technical identifiers: asset paths, route names such as `/settings`, JSON and map keys,
  `SharedPreferences` key names;
- barcode and payload protocol tokens in `lib/services/payload_parser_service.dart` such as
  `BEGIN:VCARD`, `DTSTART:`, `WIFI:` — these are data formats, not text a user reads;
- **CSV and JSON export column headers** in `lib/services/history_export_service.dart`. These are
  an interchange format that the app's own import path reads back. Translating them would break
  importing a file exported by a differently-configured device. The human-readable PDF report is
  localized; the machine-readable CSV and JSON headers stay English. I am calling this out
  because it is a judgement call, not something the guideline states.

## Risks and how I handle them

| Risk | Handling |
|---|---|
| Large diff across about 45 files | Done in the 6 steps above, with `flutter analyze` run between steps, so a break is caught close to its cause |
| A message loses its data (for example the host name in a redirect warning) | `AppMessage` carries arguments; the ARB entries use placeholders; the new resolver test covers every key |
| Behaviour change in safety scoring | Only text moves. Scoring uses `passed` flags and numbers, which are untouched. Existing scoring tests must keep passing unchanged |
| Stored history is affected | `ScanRecord` stores `rawContent`, `category`, and a score — no message text — so stored data and the import path are unaffected |
| Missed literals | Final sweep: search `lib/screens/` for any remaining quoted text inside a widget, and list anything left in the change log with the reason it is allowed |

## Honest note on size

This is the biggest change made to this repo so far: roughly 640 strings across about 45 files,
plus 9 test files. It is mechanical but long. If you would rather see it land in two reviewable
commits — infrastructure and screens first (steps 1–2), services and models second (steps 3–5) —
say so and I will split it. Otherwise I will do it in one pass as agreed, committing once at the
end.

## Verification

- `flutter gen-l10n` runs clean.
- `flutter analyze` reports zero warnings.
- `flutter test` passes, including the new resolver test.
- No file under `lib/services/` imports `AppLocalizations` or `flutter/material.dart` for text.
- No user-visible literal remains in `lib/screens/`, apart from the documented exceptions.
