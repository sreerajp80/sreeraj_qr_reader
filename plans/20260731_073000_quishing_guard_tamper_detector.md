# QuishingGuard — Physical Print & Sticker Tamper Detector

**Status:** Proposed

## Problem / Goal
Implement on-device computer vision engine `QuishingGuard` to detect physical sticker overlays ("Quishing" / QR Phishing) over legitimate public posters, parking meters, or restaurant menus by analyzing edge reflection profiles, boundary depth discontinuities, print DPI micro-patterns, dot density variance, and chromatic aberration.

## Proposed Changes

1. `lib/models/quishing_analysis_result.dart`
   - Data class and enum for Quishing risk scores (🟢 Authentic, 🟡 Wear & Tear, 🔴 High Warning overlay sticker), sub-scores, and detected forensic signals.

2. `lib/services/quishing_guard_service.dart`
   - On-device CV service for analyzing edge discontinuities (double edges, micro-shadows) and texture/print grain (DPI micro-patterns, dot density, chromatic noise).

3. `lib/providers/scan_provider.dart`
   - Integrate `QuishingGuardService` into state management to analyze scans and store result.

4. `lib/screens/widgets/quishing_risk_bar_widget.dart`
   - Real-time / Scan result risk bar widget with 3-tier color coding and detailed forensic signal breakdown.

5. `lib/screens/result_screen.dart`
   - Display `QuishingRiskBarWidget` card in scan result view.

6. `test/services/quishing_guard_service_test.dart` & `test/providers/scan_provider_quishing_test.dart`
   - Automated unit tests covering authentic, worn, and physical sticker overlay tamper cases.

## Verification
- `flutter analyze`
- `flutter test`
