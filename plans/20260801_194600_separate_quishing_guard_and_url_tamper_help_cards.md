# Plan: Separate Quishing Guard & URL Tamper Checking into Distinct Help Topics

**Status:** Awaiting User Approval

## Summary
The user correctly identified that **Quishing Guard** (Physical QR Sticker Tamper Check) and **URL Tamper Checking** (Digital Link Safety Engine) are two distinct topics that were previously combined into a single Help card. Furthermore, physical QR sticker tamper detection operates 100% offline on-device using computer vision without any internet connectivity.

This plan details separating them into two dedicated Help cards in the Help & Feature Guides section with clear explanations of their offline capabilities.

---

## Files to Modify

1. `lib/screens/settings_screen.dart`
   - Update `Help & Feature Guides` settings card subtitle to list both topics clearly (`AR CodeVision, AirQR, Quishing Guard & URL Safety`).
   - Split the combined help topic in `HelpSettingsScreen` into two separate cards:
     1. **Quishing Guard (Physical QR Sticker Tamper Check)**
     2. **URL Safety & Link Tamper Engine**

2. `test/screens/settings_screen_test.dart`
   - Update widget tests to verify both separate help topic titles in `HelpSettingsScreen`.

---

## Technical Details

### Card 1: Quishing Guard (Physical QR Sticker Tamper Check)
- **Icon**: `Icons.qr_code_scanner`
- **Badge**: `On-Device Computer Vision`
- **Description**: On-device computer vision engine that detects physical QR code sticker tampering, fake code overlays, and print alterations before processing payloads.
- **Key Details**:
  - **100% Offline & Private**: Operates entirely on-device using local camera frame computer vision with zero internet access.
  - **Sticker & Overlay Detection**: Identifies physical stickers pasted over legitimate printed QR codes.
  - **Edge & Alignment Anomaly Analysis**: Checks for suspicious boundaries, cutouts, and alignment discrepancies.
  - **Print Texture & Contrast Verification**: Analyzes visual print artifacts and reflectivity shifts.

### Card 2: URL Safety & Link Tamper Engine
- **Icon**: `Icons.verified_user_outlined`
- **Badge**: `6-Layer Digital Safety`
- **Description**: Comprehensive digital link analysis suite protecting against malicious web links, phishing (Quishing), and URL payload tampering.
- **Key Details**:
  - **Zero-Width Space & Character Tamper Detector**: Detects hidden zero-width spaces, non-printable control characters, or obfuscated payloads embedded in links.
  - **Homograph & IDN Attack Detection**: Identifies spoofed domain names using mixed-script Cyrillic or lookalike Unicode characters.
  - **IP Literal & Userinfo Verification**: Flags suspicious IP address hostnames and dangerous embedded credentials (`user:pass@host`).
  - **Suspicious TLD & Pattern Analysis**: Scans for risky top-level domains, excessive subdomains, and unencrypted HTTP connections.
  - **URL Shortener Unrolling & Redirect Tracing**: Traces shortened links (`bit.ly`, `t.co`) to reveal final destinations (requires active network probing).
  - **Google Safe Browsing Cloud Lookup**: Optional cloud check against Google threat database when configured with an API key.

---

## Verification Plan

### Automated Tests
- Run static analysis: `flutter analyze`
- Run unit & widget tests: `flutter test`

### Manual Verification
- Launch dev build: `flutter run --flavor dev`
- Navigate to `Settings` -> `Help & Feature Guides`.
- Verify 4 distinct cards are visible:
  1. AR CodeVision HUD
  2. AirQR Stream Receiver
  3. Quishing Guard (Physical QR Sticker Tamper Check)
  4. URL Safety & Link Tamper Engine
