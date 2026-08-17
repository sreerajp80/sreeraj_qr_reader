# Implementation Plan: Smart QR Payload Opening & Contrast Fixes

**Status:** Approved

Comprehensive plan to fix dark mode text contrast across all Smart Action Cards (UPI Payment, Wi-Fi, Contact, Geo Location, Calendar Event, and TOTP 2FA) and enable 1-tap app opening for each scanned QR code content type.

## User Review Required

> [!IMPORTANT]
> - **Android 11+ Package Visibility**: Android requires declaring intent schemes (`upi`, `tel`, `mailto`, `geo`, `otpauth`) in `android/app/src/main/AndroidManifest.xml` under `<queries>` so `canLaunchUrl` and `launchUrl` can discover external apps (Google Pay, PhonePe, Paytm, Phone/Contacts, Google Maps, Calendar, Authenticator).
> - **Action Feedback & Fallback**: If an action fails (e.g. no UPI or Maps app installed), the card will show a friendly SnackBar message and provide direct copy actions for the payload data.
> - **Dark Mode Contrast**: Fix hardcoded light container backgrounds (`Colors.grey[100]`) across action cards so text is crisp and legible in both dark and light modes.
> - **Button Phrasing**: Clean up "Copy Public Text" and "Share Public Text" labels to standard "Copy Text" and "Share Text".

## Open Questions

None. All 6 payload types and action implementations are mapped.

## Proposed Changes

### Android Configuration

#### [MODIFY] [AndroidManifest.xml](../android/app/src/main/AndroidManifest.xml)
- Add `<intent><action android:name="android.intent.action.VIEW" /><data android:scheme="upi" /></intent>`, `tel`, `mailto`, `geo`, and `otpauth` under `<queries>` to grant package visibility for external app intents.

---

### Core Action Service

#### [MODIFY] [payload_action_service.dart](../lib/services/payload_action_service.dart)
- Update action execution methods (`payViaApp`, `openGoogleMaps`, `saveContact`, `addToCalendar`, `openWifiSettings`, `importToAuthenticator`) to attempt `LaunchMode.externalApplication` gracefully with try/catch fallback, returning boolean status to caller widgets.

---

### Smart Action Card Widgets

#### [MODIFY] [payment_action_card.dart](../lib/screens/widgets/payment_action_card.dart)
- **Payment Code (`upi://pay`, SEPA, Crypto)**:
  - Fix VPA/UPI ID container background (`surfaceContainerHighest`) and text color (`onSurface`) for crystal-clear readability in dark theme.
  - Add visual SnackBar feedback when clicking "Pay via App (GPay / PhonePe / Paytm)".
  - Add a 1-tap "Copy UPI ID" action button.

#### [MODIFY] [wifi_action_card.dart](../lib/screens/widgets/wifi_action_card.dart)
- **Wi-Fi Network (`WIFI:S:SSID...`)**:
  - Make password box container background theme-aware.
  - Show SnackBar feedback when launching Wi-Fi settings.

#### [MODIFY] [contact_action_card.dart](../lib/screens/widgets/contact_action_card.dart)
- **Contact Card (vCard / MeCard)**:
  - Add SnackBar feedback and fallback handling for 1-tap phone calls (`tel:`), emails (`mailto:`), and saving contacts.
  - Ensure address text uses theme-aware text colors in dark mode.

#### [MODIFY] [geo_action_card.dart](../lib/screens/widgets/geo_action_card.dart)
- **Geographic Location (`geo:lat,lng`)**:
  - Add map snippet container styling compatible with dark theme.
  - Show SnackBar feedback if Google Maps navigation cannot be launched.

#### [MODIFY] [calendar_action_card.dart](../lib/screens/widgets/calendar_action_card.dart)
- **Calendar Event (`BEGIN:VEVENT`)**:
  - Ensure date/time box container background is theme-aware.
  - Show SnackBar feedback when adding event to calendar.

#### [MODIFY] [totp_action_card.dart](../lib/screens/widgets/totp_action_card.dart)
- **Two-Factor Authentication (`otpauth://totp`)**:
  - Make secret key container background theme-aware.
  - Show SnackBar feedback when importing TOTP key to Authenticator app.

#### [MODIFY] [result_screen.dart](../lib/screens/result_screen.dart)
- Update action button labels from "Copy Public Text" / "Share Public Text" to clean "Copy Text" / "Share Text".

## Verification Plan

### Automated Tests
- Run `flutter analyze` to verify zero warnings or errors.
- Run `flutter test` to ensure all tests pass.

### Manual Verification
- Test all 6 scanned payload cards in Light and Dark themes to verify zero contrast issues.
- Click action buttons on each card to verify native app opening and fallback SnackBar error handling.
