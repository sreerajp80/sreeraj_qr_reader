# Change Log: Replicate Appearance, Features, and Help Cards under Settings

**Plan Reference:** `plans/20260820_065200_appearance_features_help_settings.md`
**Date:** 2026-08-20

## Summary
Replicated and aligned the **Appearance**, **Features**, and **Help** cards and screens under Settings to match the modern design and architecture patterns from ContactSphere.

## Changes Made
1. **Localization**:
   - `lib/l10n/app_en.arb`: Added all user-visible strings and `@key` descriptions for Appearance, Features, and Help Center screens, categories, and guides.
2. **Settings Screen**:
   - `lib/screens/settings_screen.dart`: Upgraded settings cards to 20px rounded cards with 48x48 icon badge containers, primary color tint background, bold typography, and chevron indicators. Replaced inline appearance and help implementations with dedicated hub navigations.
3. **Appearance Hub & Settings Screens**:
   - `lib/screens/appearance_screen.dart`: Created Appearance preferences hub linking to modular settings.
   - `lib/screens/appearance/theme_mode_settings_screen.dart`: Dedicated Theme Mode selector with Light, Dark, True OLED Pure Black, and System mode.
   - `lib/screens/appearance/scan_overlay_settings_screen.dart`: Dedicated Scan Overlay style selector (Laser line, Pulsing corners, Cybernetic grid, Dot matrix).
   - `lib/screens/appearance/accent_color_settings_screen.dart`: Material You Dynamic Colors (Monet) switch, live preview badge, and preset details.
   - `lib/screens/appearance/typography_settings_screen.dart`: Live sample preview and text scale factor slider.
4. **Features Showcase Screen**:
   - `lib/screens/features_screen.dart`: Rich categorized feature showcase with a gradient hero header card, 5 category sections (Core Scanning, 6-Layer URL Safety, QuishingGuard AI Vision, Smart Payloads, and History Privacy Vault), feature tiles with icons, descriptions, and highlight chip badges.
5. **Help Center Hub & User Guides**:
   - `lib/screens/help/help_home_screen.dart`: Help Center hub with top gradient hero card and 3 categorized sections.
   - Created 9 comprehensive user guide screens under `lib/screens/help/`:
     - `barcode_scanning_help_screen.dart` (Live camera, gallery photos, and multi-page PDF scanning)
     - `ar_codevision_help_screen.dart` (AR spatial multi-code HUD and batch actions)
     - `air_qr_help_screen.dart` (AirQR offline animated optical data streaming)
     - `url_safety_help_screen.dart` (6-layer URL safety engine breakdown)
     - `quishing_guard_help_screen.dart` (On-device computer vision physical sticker tamper analysis)
     - `safe_browsing_help_screen.dart` (Google Safe Browsing setup and hardware keystore storage)
     - `smart_payloads_help_screen.dart` (Wi-Fi connect, UPI/crypto payments, TOTP 2FA, vCards, and calendar events)
     - `history_privacy_help_screen.dart` (Offline SQLite database, JSON/CSV backups, biometrics, and screenshot guard)
     - `faq_troubleshooting_help_screen.dart` (Frequently asked questions, camera focus advice, and permissions)
6. **Tests & Verification**:
   - `test/screens/settings_screen_test.dart`: Updated widget tests to verify rendering and navigation for Appearance hub, Features showcase, and Help Center hub screens.
   - Static analysis (`flutter analyze`) clean with 0 warnings.
   - Test suite (`flutter test`) passed (155/155 tests).
