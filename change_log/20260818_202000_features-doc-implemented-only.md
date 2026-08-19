# Change log — `docs/features.md` now lists only implemented features

Date: 2026-08-18

Implements: `plans/20260818_201500_features-doc-implemented-only.md`

---

## Why

`docs/features.md` is shared with other people and assistants as the record of what
this app does today. A check of every section against the code found seven statements
that claimed behaviour the app does not have. Nothing in the code was wrong — only the
document.

## What changed

Only `docs/features.md` was edited. No code, test, or asset file was touched.

1. **StegoQR unlock corrected (three places).** The document said the hidden content
   was locked by fingerprint/face unlock "or a password if biometrics aren't
   available". In the code the passphrase is always required — the AES-256 key is
   derived from it with PBKDF2-HMAC-SHA256 — and the fingerprint check is an optional
   extra step on top, never a replacement. Fixed in the intro paragraph, the
   "StegoQR" section, and the "Security and privacy" section.

2. **Wi-Fi action described accurately.** The "Connect to Wi-Fi" button copies the
   password and opens the Android Wi-Fi settings screen. The app does not join the
   network itself. The document now says so.

3. **Location card no longer claims a map preview.** The card draws a location banner
   on the device showing the coordinates. No map tiles are downloaded, so the wording
   "map preview" was replaced.

4. **AR CodeVision batch actions trimmed to the real one.** The document listed
   "Save Selected to History" and "Copy All Scanned Barcodes". Only "Batch Copy" of the
   selected codes exists, in Warehouse mode. The AR view does not write to history.
   The removed items were removed, not renamed.

5. **Scan sound named correctly.** It is the system click tone, not a beep.

6. **Target SDK row corrected.** The Android build follows the Flutter SDK default for
   `targetSdk` rather than pinning 35. `minSdk 24` and `compileSdk 37` were already
   correct and are unchanged.

7. **Footer date** updated to 2026-08-18.

## What stayed

Every other feature listed in the file was checked against the code and confirmed as
implemented: the ten barcode formats, the 1.0x–8.0x zoom, the four scan overlay styles,
gallery/PDF/share-sheet scanning, all six URL safety checks with private mode by
default, the sandboxed page preview with RDAP domain age and open-redirect detection,
the three Quishing Guard risk levels, all smart payload types (vCard and MeCard,
geo, iCalendar, UPI/SEPA/crypto, TOTP), the history fields and CSV/JSON/TXT/PDF export,
the `.sreerajqr` encrypted backup, AES-256 field encryption of the history database,
AirQR transmit at 5–25 FPS with fountain-code frame recovery, the Warehouse and Safety
AR modes, the four theme options with Material You, the Help and Permissions screens,
version 2.6.11 build 18, and "no deep links".

## Verification

- Each changed line was traced back to the source file that defines the behaviour.
- `flutter analyze` — no issues found. No Dart file changed, so the test suite is
  unaffected.
