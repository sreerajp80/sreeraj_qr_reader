# Change Log: Separated Quishing Guard & URL Tamper Help Topics

**Plan Reference:** [plans/20260801_194600_separate_quishing_guard_and_url_tamper_help_cards.md](../plans/20260801_194600_separate_quishing_guard_and_url_tamper_help_cards.md)

---

## Summary of Changes

Separated **Quishing Guard (Physical QR Sticker Tamper Check)** and **URL Safety & Link Tamper Engine** into two distinct Help cards in the Help & Feature Guides section. Clarified that physical QR code sticker tamper checking runs 100% offline using on-device computer vision with zero internet access.

---

## Files Modified

- `lib/screens/settings_screen.dart`
  - Updated `Help & Feature Guides` settings card subtext to `'AR CodeVision, AirQR, Quishing Guard & URL Safety'`.
  - Split single combined help topic into two dedicated Help cards:
    1. **Quishing Guard (Physical QR Sticker Tamper Check)**: Detailing on-device computer vision, physical sticker/overlay detection, edge/alignment analysis, and 100% offline privacy guarantee.
    2. **URL Safety & Link Tamper Engine**: Detailing zero-width space tamper detection, homograph attack checks, IP host validation, suspicious TLD analysis, redirect unrolling, and optional Google Safe Browsing API lookup.

- `test/screens/settings_screen_test.dart`
  - Updated widget test expectations to verify presence of both new Help card titles.

---

## Verification Results

- `flutter analyze`: Clean (0 issues)
- `flutter test`: Passed all unit & widget tests.
