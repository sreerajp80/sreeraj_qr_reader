# Plan: Add Permissions and Help Cards to Settings Screen

**Status:** Completed

## Files to Change
1. `lib/screens/settings_screen.dart` - Add Permissions and Help cards to SettingsScreen and implement `PermissionsSettingsScreen` and `HelpSettingsScreen` detail screens.
2. `test/screens/settings_screen_test.dart` - Add widget tests for Permissions and Help cards rendering and navigation.

## Issue
The Settings screen is missing dedicated cards for Permissions and Help topics.
- Users need clear visibility into all explicit permissions (Camera, Biometric), implicit/system permissions (Internet, Vibration, Scoped Storage Photo Picker), and setting-dependent permissions (Active Online Probing HTTP requests, Google Safe Browsing API calls, Scan Feedback Haptics).
- Users also need accessible in-app help documentation covering key core features: AR CodeVision HUD, AirQR Stream Receiver, and URL Tamper Checking / Quishing Guard safety analysis.

## Fix
1. Modify `lib/screens/settings_screen.dart`:
   - Add a **Permissions** settings card with icon `Icons.admin_panel_settings_outlined`, titling "Permissions", subtitling "Explicit, implicit & setting-dependent details", navigating to `PermissionsSettingsScreen`.
   - Add a **Help & Feature Guides** settings card with icon `Icons.help_outline`, titling "Help & Feature Guides", subtitling "AR CodeVision, AirQR Stream Receiver & URL Tamper Checking", navigating to `HelpSettingsScreen`.
   - Implement `PermissionsSettingsScreen`:
     - Explicit permissions section: Camera (`CAMERA`), Biometric Auth (`USE_BIOMETRIC`).
     - Implicit & System permissions section: Internet (`INTERNET`), Vibration & Haptics (`VIBRATE`), Scoped Media Storage Picker.
     - Setting-dependent permissions section: Active Online Probing (HTTP requests), Google Safe Browsing API (Cloud lookup), Scan Feedback Vibrations.
   - Implement `HelpSettingsScreen`:
     - **AR CodeVision HUD** guide: Multi-barcode camera overlay, spatial floating chips, AR action sheet, camera HUD controls.
     - **AirQR Stream Receiver** guide: High-speed optical QR stream payload transfer, live progress tracking, camera/file stream input modes.
     - **URL Tamper Checking & Quishing Guard** guide: 6-layer URL safety engine (Homograph/Punycode attack detection, zero-width space tamper detection, IP literal & userinfo checks, suspicious TLD analysis, URL shorteners unrolling, Google Safe Browsing), privacy-first offline analysis.
2. Modify `test/screens/settings_screen_test.dart`:
   - Add widget tests verifying that 'Permissions' and 'Help & Feature Guides' cards are present on `SettingsScreen`.
   - Add widget tests verifying that tapping 'Permissions' navigates to `PermissionsSettingsScreen` and tapping 'Help & Feature Guides' navigates to `HelpSettingsScreen`.
