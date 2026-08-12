# Plan — Update docs/features.md to reflect all app features accurately

**Status:** Proposed

## Problem / Issue
`docs/features.md` contains several minor inaccuracies, missing feature details, and outdated metadata when compared against the codebase in `lib/`, `pubspec.yaml`, and `assets/config/app_config.json`:
1. **AirQR Transmitter Clarification**: Line 19 states the app is strictly a "reader, not a generator or sender app". However, the app includes an AirQR Optical Data Stream Transmitter (`AirQrTransmitterScreen`, route `/air_qr_transmitter`), which generates animated QR code sequences (5–25 FPS) to transmit optical data to receiving devices.
2. **Package ID Typo**: In the Technical Facts table (line 262), the package ID is listed as `in.sreeraj.qr_reader`, whereas the actual package ID is `in.sreerajp.qr_reader`.
3. **Payload & Action Engine Details**: Missing explicit mention of MeCard contact format, EPC QR / SEPA bank transfer standards, and detailed 2FA TOTP configuration options (issuer, secret, algorithm, period, digits).
4. **AR CodeVision Multi-Select Batch Actions**: Does not explicitly list batch selection capabilities (batch save to history, batch copy).
5. **App Metadata & Version Alignment**: Version in `pubspec.yaml` and `app_config.json` is `2.6.11+18` (with AI tools and India attribution in About screen footer).

## Proposed Changes

### Documentation
#### [MODIFY] [features.md](file:///l:/Android/sreeraj_qr_reader/docs/features.md)
- Clarify AirQR transmitter/generator functionality alongside scanner capabilities.
- Fix package ID typo to `in.sreerajp.qr_reader`.
- Elaborate smart payload details (MeCard, EPC SEPA, 2FA parameters).
- Add details for AR CodeVision multi-select batch operations.
- Update metadata, version reference, and last-reviewed date to 2026-08-12.

## Verification Plan
### Automated Tests
- Run `flutter analyze` to ensure documentation changes have no syntax or formatting issues.

### Manual Verification
- Review `docs/features.md` to ensure all features in `lib/` are fully accounted for, structured clearly, and accurate.
