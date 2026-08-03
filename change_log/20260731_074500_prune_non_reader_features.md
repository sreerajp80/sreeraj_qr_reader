# Change Log: Removed Non-Valid (Generator/Sender) Features from Roadmap

**Date:** 2026-07-31  
**Plan:** `plans/20260731_074500_prune_non_reader_features.md`

## Summary of Changes
Updated `docs/feature_analysis_and_roadmap.md` to align strictly with the app's scope as a dedicated **QR Reader Application**:

1. **Removed QR Creation Gap:** Removed `QR Creation` missing capability row from the Technical & Feature Gaps table.
2. **StegoQR Reader Focus:** Updated StegoQR section and matrices to strictly specify the **StegoQR Reader Engine** (reading/decryption) and removed references to QR generation.
3. **AirQR Stream Receiver:** Refactored AirQR feature to **AirQR Stream Reader** (optical receiver mode for decoding animated QR streams). Removed "Sender Mode" (which generates animated QR streams on screen).
4. **Phased Roadmap Clean-up:** Removed Phase 3 generator items (`QR Studio` and `Custom QR Styling`). Re-aligned Phases 3 & 4 to focus strictly on reader capabilities (**AR CodeVision HUD** and **AirQR Stream Receiver**).
