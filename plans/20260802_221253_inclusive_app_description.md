# Plan: Make the in-app "App Description" list the full feature set

**Status:** completed

## Files to be changed

- `assets/config/app_config.json` — the `description` field only.
- `pubspec.yaml` — the top-level `description:` field (same text is used by
  Flutter/store tooling, so it should match).

No code files change. No new files.

## The issue

The app shows a short description on the About screen, read from
`assets/config/app_config.json`. Today it says:

> "A comprehensive QR and Barcode scanner application with 6-layer URL
> safety analysis."

This is the text a real user reads inside the app. It only mentions QR/
barcode scanning and the URL safety check. It leaves out most of what makes
this app different from a plain QR scanner:

- StegoQR (hidden, locked QR content)
- Quishing Guard (physical tamper detection)
- Smart payload actions (Wi-Fi, contacts, payments, calendar, 2FA)
- Zero-trust sandboxed link preview
- AirQR (offline optical data transfer)
- AR CodeVision (multi-code live tracking)
- Encrypted local history with export/backup

`docs/features.md` (the full feature doc) already describes all of this
well. Only the short in-app description is out of date.

## The fix

Update the `description` field in `assets/config/app_config.json` to a
single short paragraph that names the main feature groups, while staying
short enough to read well on the About screen (a few lines of body text,
not a wall of text). Proposed new text:

> "A privacy-first QR and barcode scanner with 6-layer link safety
> checks, sandboxed page preview, physical tamper (quishing) detection,
> hidden StegoQR content, smart actions for Wi-Fi/contacts/payments/2FA,
> encrypted scan history, and offline AirQR data transfer."

Update `pubspec.yaml`'s `description:` field to the same text (trimmed if
needed to fit pub's 60–180 character convention — pubspec description is
not shown to end users, so it can stay closer to the original short form,
but should still mention the safety/privacy angle and the extra tools, not
just "QR and Barcode scanner").

No other file changes. This is a text-only, no-logic change.

## Verification

- `flutter analyze` — confirm still clean (no code touched, so this should
  be unaffected).
- Manually check the About screen text still fits/wraps cleanly (visual
  check only, since this is a string change).
