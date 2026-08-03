# Change Log: Make the in-app App Description list the full feature set

**Date:** 2026-08-02 22:15:00
**Plan:** [plans/20260802_221253_inclusive_app_description.md](../plans/20260802_221253_inclusive_app_description.md)

## What changed

The short "App Description" text shown on the About screen only mentioned
QR/barcode scanning and the URL safety check. It left out most of what
makes this app different from a plain scanner.

- `assets/config/app_config.json` — `description` field updated to name
  the full feature set: link safety checks, sandboxed page preview,
  quishing (physical tamper) detection, StegoQR hidden content, smart
  actions (Wi-Fi/contacts/payments/2FA), encrypted scan history, and
  offline AirQR data transfer.
- `pubspec.yaml` — top-level `description:` field updated to match the
  same idea in a shorter form (this field is not shown to end users but
  should stay consistent with the app's real feature set).

No code logic changed — text only.

## Verification

- `flutter analyze` — clean, no issues.
