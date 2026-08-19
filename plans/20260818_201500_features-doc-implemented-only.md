# Plan — Make `docs/features.md` list only implemented features

**Status:** completed

Date: 2026-08-18

---

## Files to be changed

- `docs/features.md` (only this file)

---

## What the issue is

`docs/features.md` is meant to describe exactly what the app does today. I checked
every section against the code in `lib/`, `pubspec.yaml`, `android/app/build.gradle`,
and `android/app/src/main/AndroidManifest.xml`.

Most of the file is correct. Seven statements claim behaviour the code does not have:

1. **StegoQR unlock is described wrongly.** The doc says the hidden content is
   "locked behind the phone's fingerprint/face unlock, or a password if biometrics
   aren't available". In the code the passphrase is *always* required —
   `StegoQrService.decryptPayload` derives the AES key from the passphrase with
   PBKDF2 (`lib/services/stego_qr_service.dart`), and the result screen offers two
   buttons: "Biometric Unlock" (biometric **plus** passphrase) and "Passphrase"
   (passphrase only). There is no biometric-only path and no
   "biometrics unavailable" fallback.

2. **Wi-Fi "Connect to Wi-Fi" button does not connect.**
   `PayloadActionService.openWifiSettings()` copies the password and opens the
   Android Wi-Fi settings page; the on-screen hint says the user must connect
   themselves. The doc reads as if the app joins the network.

3. **Location card has no map preview.** The doc says it "shows a map preview".
   `lib/screens/widgets/geo_action_card.dart` draws a stylised banner (a map icon,
   a pin, and the coordinates). No map tiles are fetched or rendered.

4. **AR CodeVision batch actions are overstated.** The doc lists
   "Save Selected to History" and "Copy All Scanned Barcodes". The screen has only
   one batch action — "Batch Copy" of the selected codes (`arBatchCopy`). Nothing in
   the AR screen writes to history, and there is no copy-all.

5. **Scan sound is not a beep.** The code calls
   `SystemSound.play(SystemSoundType.click)` — the system click sound.

6. **StegoQR security bullet repeats issue 1.** The "Security and privacy" section
   says unlocking "requires the phone's fingerprint/face unlock (or a password
   fallback)". Same correction needed.

7. **`targetSdk 35` is stated as a fact.** `android/app/build.gradle` sets
   `targetSdk = flutter.targetSdkVersion`, so it follows the Flutter SDK default
   rather than a pinned number. (`minSdk 24` and `compileSdk 37` in the doc are
   correct.)

Everything else I checked was accurate and stays as it is: the 10 barcode formats,
1.0x–8.0x zoom, 4 overlay styles, gallery/PDF/share-sheet scanning, the 6 URL safety
checks, private-mode default, the DOM sandbox preview with RDAP domain age and open
redirect detection, the 3 Quishing risk levels, all smart payload types (vCard/MeCard,
geo, iCalendar, UPI/SEPA/crypto, TOTP), history fields and CSV/JSON/TXT/PDF export,
the `.sreerajqr` encrypted backup, AES-256 field encryption of the history database,
AirQR 5–25 FPS transmit with fountain/parity frame recovery, the Warehouse/Safety AR
modes, the 4 theme options with Material You, the Help and Permissions screens, version
2.6.11+18, and "no deep links".

---

## The plan for the fix

Edit only the wrong sentences in `docs/features.md`; leave the correct content alone.

1. **"StegoQR — hidden, locked QR content" section** — replace the two unlock bullets
   with an accurate pair: the hidden content is encrypted with AES-256 using a key
   derived from a passphrase (PBKDF2), the passphrase is always required, and the user
   can optionally add a fingerprint/face check on top of it before decryption.

2. **"Smart payload actions" → Wi-Fi bullet** — say the button copies the password and
   opens the Android Wi-Fi settings screen so the user can join the network; the app
   does not join it directly.

3. **"Smart payload actions" → Location bullet** — replace "shows a map preview" with
   "shows the coordinates on a location banner", keeping the "Open in Google Maps"
   button.

4. **"AR CodeVision" section** — replace the batch-actions bullet with the one action
   that exists: select several codes and copy them all to the clipboard in one go.
   Drop "Save Selected to History" and "Copy All Scanned Barcodes".

5. **"Core scanning" → feedback bullet** — change "Sound (beep)" to "Sound (the system
   click tone)".

6. **"Security and privacy" → StegoQR bullet** — match the wording from change 1
   (passphrase always required, optional biometric check).

7. **"Key technical facts" table** — change the SDK row to
   `minSdk 24 / compileSdk 37 / targetSdk follows the Flutter default
   (flutter.targetSdkVersion)`.

8. **Intro paragraph** — the summary says the hidden format is "unlocked by fingerprint
   or password". Change it to "unlocked by a passphrase, with an optional fingerprint
   check" so the intro matches the section body.

9. Update the "Last generated" date at the bottom to 2026-08-18.

No code changes. No new features are added and no correct feature is removed.

---

## How it will be checked

- Re-read `docs/features.md` after the edit and confirm every changed line matches the
  code file named in the issue list above.
- No Dart files change, so `flutter analyze` and `flutter test` results are unaffected;
  I will still run `flutter analyze` to confirm the tree is clean.

---

## After implementing

Write a change log to `change_log/` named
`yyyymmdd_hhMMss_features-doc-implemented-only.md` referencing this plan, and set the
`Status:` line above to `completed`.
