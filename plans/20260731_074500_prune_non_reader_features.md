# Plan: Remove Non-Valid (Generator/Sender) Features from Roadmap

**Status:** Proposed

## Target File
- `docs/feature_analysis_and_roadmap.md`

## Problem & Context
The project **Sreeraj P QR Reader** is strictly a **QR reader/scanner app**.
The roadmap document `docs/feature_analysis_and_roadmap.md` currently contains several feature proposals related to **QR code generation/creation**, custom QR styling, and QR stream sending (Sender Mode).
These features are invalid for a dedicated QR reader application and must be removed or updated.

## Key Changes
1. **Section 1.2 (Identified Gaps Table):**
   - Remove the `QR Creation` gap row (since generator functionality is explicitly out of scope for a reader-only app).

2. **Section 3.1 (StegoQR):**
   - Update text to focus exclusively on **StegoQR Reader Engine** (reading and decrypting steganographic QR payloads). Remove references to "QR generator" and "generation engine".

3. **Section 3.3 (AirQR):**
   - Refactor AirQR to **AirQR Stream Reader Mode** (receiving/scanning optical fountain-code animated QR streams). Remove "Sender Mode" which generates animated QR streams on screen.

4. **Section 4 (Comparison Table):**
   - Update AirQR description row to reflect "AirQR Stream Reader (Optical Fountain-Code Receiver)".

5. **Section 5 (Phased Roadmap):**
   - Remove **Phase 3 generator items**: `QR Studio (Create QRs)` and `Custom QR Styling`.
   - Re-align remaining valid reader features into streamlined roadmap phases focused purely on scanning, UX, camera controls, history, AR CodeVision, and AirQR Receiver.

6. **Section 6 (Conclusion):**
   - Emphasize QR reader security, scanner UX, and privacy leadership.

## Verification
- Review updated `docs/feature_analysis_and_roadmap.md` to ensure all remaining features are 100% valid for a QR reader-only app.
