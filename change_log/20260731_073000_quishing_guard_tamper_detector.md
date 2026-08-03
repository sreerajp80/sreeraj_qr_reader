# Change Log - QuishingGuard Physical Print & Sticker Tamper Detector

**Plan Reference:** `plans/20260731_073000_quishing_guard_tamper_detector.md`  
**Date:** 2026-07-31  

## Changes Made

1. **Created `lib/models/quishing_analysis_result.dart`**:
   - `QuishingRiskLevel` enum: `authentic` (🟢), `wearAndTear` (🟡), `highWarning` (🔴).
   - `QuishingAnalysisResult` data class storing overall risk score, sub-scores (edge discontinuity, texture print grain), forensic signals, and human-readable label formatters.

2. **Created `lib/services/quishing_guard_service.dart`**:
   - Implemented computer vision algorithms for Edge & Boundary Discontinuity Analysis (double edges and micro-shadow depth step lines).
   - Implemented Texture & Print Grain Analysis (sub-pixel halftone dot density variance, mismatching inkjet/thermal noise, and chromatic aberration).
   - Fallback payload signature analysis for deterministic offline baseline evaluation.

3. **Updated `lib/providers/scan_provider.dart`**:
   - Injected `QuishingGuardService`.
   - Exposed `quishingResult` getter.
   - Evaluates QuishingGuard automatically in `setScanResult(...)` and provides `runQuishingAnalysis(...)` method.
   - Reset state in `clearScan()`.

4. **Created `lib/screens/widgets/quishing_risk_bar_widget.dart`**:
   - Added real-time 3-level alert index widget displaying green, amber, and red risk statuses.
   - Progress bar displaying score percentage.
   - Expandable breakdown for metric scores and detected forensic signals.

5. **Updated `lib/screens/result_screen.dart`**:
   - Embedded `QuishingRiskBarWidget` in scan result screen.

6. **Added Unit Tests**:
   - `test/services/quishing_guard_service_test.dart`
   - `test/providers/scan_provider_quishing_test.dart`

## Verification
- Executed `flutter analyze` — Clean (0 issues).
- Executed `flutter test` — 84/84 tests passed.
