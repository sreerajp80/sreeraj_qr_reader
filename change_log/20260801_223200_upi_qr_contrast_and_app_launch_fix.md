# Change Log: Smart QR Payload Opening & Contrast Fixes

**Date:** 2026-08-01 22:32:00 IST  
**Plan Reference:** [plans/20260801_222100_upi_qr_contrast_and_app_launch_fix.md](../plans/20260801_222100_upi_qr_contrast_and_app_launch_fix.md)

## Summary of Changes

Resolved dark mode text contrast readability issues across Smart Action Cards and fixed 1-tap app intent opening for UPI payments, Wi-Fi, Contacts, Google Maps, Calendar events, and 2FA TOTP authenticator apps.

### 1. Android Manifest Query Registration
- Added intent queries to [android/app/src/main/AndroidManifest.xml](../android/app/src/main/AndroidManifest.xml) for custom deep-link schemes: `upi`, `tel`, `mailto`, `geo`, and `otpauth`.
- Enables package visibility compliance on Android 11+ (API 30+) for discovering installed handler applications (Google Pay, PhonePe, Paytm, BHIM, Contacts, Google Maps, Calendar, Authenticator).

### 2. Payload Action Service Enhancements
- Updated [lib/services/payload_action_service.dart](../lib/services/payload_action_service.dart) to attempt `launchUrl` in `LaunchMode.externalApplication` with graceful try/catch fallbacks, returning boolean execution status to caller UI components.

### 3. Payment Action Card (UPI / SEPA / Crypto)
- Modified [lib/screens/widgets/payment_action_card.dart](../lib/screens/widgets/payment_action_card.dart):
  - Theme-aware container background (`surfaceContainerHighest`) and text styling (`onSurface`) in dark mode, fixing the unreadable light text issue on UPI VPA (`9629297111@okbizaxis`).
  - Added a 1-tap **"Copy"** button next to the VPA / UPI ID.
  - Added SnackBar error feedback when clicking "Pay via App" if no UPI app is installed on the user's device.

### 4. Smart Action Cards Dark Theme & Feedback
- Updated [lib/screens/widgets/wifi_action_card.dart](../lib/screens/widgets/wifi_action_card.dart) with theme-aware password box container styling and SnackBar feedback.
- Updated [lib/screens/widgets/contact_action_card.dart](../lib/screens/widgets/contact_action_card.dart) for dark mode address text contrast and SnackBar feedback on call/email/contacts launch failures.
- Updated [lib/screens/widgets/geo_action_card.dart](../lib/screens/widgets/geo_action_card.dart) for map preview banner contrast in dark theme and launch feedback.
- Updated [lib/screens/widgets/calendar_action_card.dart](../lib/screens/widgets/calendar_action_card.dart) for time container theme contrast and launch feedback.
- Updated [lib/screens/widgets/totp_action_card.dart](../lib/screens/widgets/totp_action_card.dart) for secret key container contrast in dark mode and launch feedback.

### 5. Result Screen Action Button Labels
- Updated [lib/screens/result_screen.dart](../lib/screens/result_screen.dart) to display clean **"Copy Text"** and **"Share Text"** labels for regular QR codes, reserving "Copy Decoy Text" / "Share Decoy Text" specifically for dual-layer StegoQR scans.

## Verification
- `flutter analyze`: Clean (0 errors, 0 warnings).
- `flutter test`: 150/150 unit & widget tests passed cleanly.
