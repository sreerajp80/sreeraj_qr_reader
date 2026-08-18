# Change log — full localization of the app

Implements plan: `plans/20260817_220900_l10n-full-externalization.md`

The app now meets the mandatory §8.2 rule in the engineering standard: every
user-visible string comes from `lib/l10n/app_en.arb` through `AppLocalizations`,
even though the app still ships English only.

## What changed

### Infrastructure

- `pubspec.yaml` — added `flutter_localizations` (SDK), `intl`, and `generate: true`.
- `l10n.yaml` — new. Generated code goes to `lib/l10n/gen/` and is committed, so
  `flutter analyze` in CI needs no extra generation step.
- `lib/l10n/app_en.arb` — new. **527 keys**, every one with an `@key` description.
- `lib/main.dart` — `localizationsDelegates`, `supportedLocales`, and
  `onGenerateTitle`, so even the task-switcher title is localized.

### Screens and widgets

All 23 files under `lib/screens/` were converted — 7 screens and 16 widgets.
The largest were `settings_screen.dart` (about 190 strings) and
`result_screen.dart` (about 70).

`history_card.dart` also stopped formatting dates by hand. It had a hard-coded
English month list and AM/PM marker; it now uses `intl` `DateFormat` with the
reader's locale, so dates follow the device language.

### Services stop holding UI text

This also fixes a rule the project was already breaking. `CLAUDE.md` says
*"Services must not depend on `BuildContext`, UI strings, or navigation routes"*,
yet services carried English sentences.

New pieces:

- `lib/models/app_message.dart` — `AppMessageKey` (one value per message a
  service can produce) and `AppMessage` (a key plus arguments).
- `lib/l10n/app_message_text.dart` — the only place that joins keys to words.
- `lib/models/backup_exception.dart` — a typed error carrying a message key,
  replacing `FormatException` with English text.
- `lib/models/history_report_labels.dart` — already-localized wording that the
  screen hands to the report builders.

Flow: `service → AppMessage → provider → screen → AppLocalizations → text`.

Converted services: `url_safety_service`, `quishing_guard_service`,
`dom_sandbox_service`, `stego_qr_service`, `air_qr_service`, `media_scan_service`,
`ar_spatial_service`, `history_export_service`, `biometric_service`,
`payload_parser_service`.

Models that carried text now carry `AppMessage`: `safety_check_result`,
`quishing_analysis_result`, `dom_sandbox_result`, `stego_qr_data`,
`air_qr_progress`, `ar_code_target`, and `MediaScanResult`.

### Two behaviour fixes that fell out of the refactor

1. **`ScanProvider.hasNetworkError`** used to decide whether to offer a re-check
   by matching the words `Unable to|Error|network|timeout` in the message with a
   regular expression. Any wording change would have silently broken it, and it
   could never have worked in another language. It now compares message keys
   against a named set.
2. **The biometric prompt** is no longer built inside `BiometricService`.
   `local_auth` needs a real string, so the screen passes the localized reason in.
   Neither the service nor the provider holds the text.

### Tests

- New `test/l10n/app_message_text_test.dart` walks **every** `AppMessageKey` and
  fails if one resolves to empty text — so a key can never be added without
  wording. It also checks that arguments reach the final string and that a
  missing argument does not throw.
- Updated to assert on keys instead of English sentences:
  `url_safety_service_test`, `quishing_guard_service_test`,
  `dom_sandbox_service_test`, `stego_qr_service_test`, `media_scan_service_test`,
  `history_export_service_test`, `ar_spatial_service_test`,
  `scan_provider_quishing_test`, and `settings_screen_test` (which needed the
  localization delegates installed).

## Verification

- `flutter analyze` — no issues, across `lib/` and `test/`.
- `flutter test` — **154 tests pass** (150 before, plus 4 new).
- `dart format .` — clean.
- No file under `lib/services/`, `lib/providers/`, or `lib/models/` imports
  `AppLocalizations`, checked by search.
- Every ARB key has an `@key` description, checked by script.

## Deliberate exceptions, and why

These stay as plain Dart, per §8.2 and the plan:

- log and debug messages, and exception text never shown on screen;
- technical identifiers: asset paths, route names, `SharedPreferences` keys,
  JSON field names, file names such as `Sreeraj_QR_History.pdf`;
- barcode and payload protocol tokens in `payload_parser_service.dart`
  (`BEGIN:VCARD`, `WIFI:`, `IBAN:`, and so on) and the TOTP algorithm names;
- **CSV and JSON export headers.** These are an interchange format that the
  app's own import path reads back. Translating them would break importing a
  file exported by a differently-configured device. The human-readable PDF and
  text reports *are* localized. This was flagged as a judgement call in the plan.
- `HistoryProvider.errorMessage`, which is only logged and never shown.
- `ContactField.label` (`'Phone'`, `'Email'`), which classifies parsed data and
  is not displayed.

## Small wording changes worth knowing

- In private mode the sandboxed page preview no longer invents English page
  text. It carries only facts taken from the URL, and the screen supplies the
  wording for empty fields. A test that asserted on `'Host: example.com'` now
  asserts on `'example.com'`.
- Empty parsed fields (Wi-Fi name, 2FA account, payee, event title, contact
  name) no longer get an English fallback inside the parser. The card supplies a
  localized fallback instead, so the words live in one place.
- The PDF page footer changed from `Page 1 of 3` to `1 / 3`, avoiding a phrase
  that does not translate cleanly through a two-number placeholder.
- Notes stored with a saved scan (for example the PDF page note) keep the
  language they were saved in. Changing language later does not rewrite history.

## Deviation from the approved plan

`l10n.yaml` does not set `synthetic-package: false`. Flutter 3.44.8 reports that
option as removed and ignores it. Generated code still lands in `lib/l10n/gen/`
through `output-dir`, which was the point of the setting, so the outcome matches
the plan.
