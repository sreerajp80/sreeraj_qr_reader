# Change Log — Update docs/features.md with accurate feature documentation

**Plan reference:** [`plans/20260812_200706_update_docs_features_md.md`](file:///l:/Android/sreeraj_qr_reader/plans/20260812_200706_update_docs_features_md.md)

## Summary of Changes
Updated [`docs/features.md`](file:///l:/Android/sreeraj_qr_reader/docs/features.md) to ensure 100% complete and accurate coverage of all features in the app codebase:

1. **AirQR Transmitter Clarification**: Updated section "What this app is" and "AirQR — optical data transfer" to clarify that while the app is primarily a scanner, it includes `AirQrTransmitterScreen` (`/air_qr_transmitter`) for encoding text/data into animated QR code sequences (5–25 FPS) for optical transmission.
2. **Package ID Fix**: Fixed package ID typo in the Technical Facts table from `in.sreeraj.qr_reader` to `in.sreerajp.qr_reader`.
3. **Smart Payload Actions**: Added explicit details for MeCard contact card format, EPC SEPA bank transfer standards, geo location parameters, and live 2FA TOTP code calculations.
4. **AR CodeVision HUD**: Documented multi-code batch selection capabilities (e.g. batch save to history, batch copy).
5. **Metadata Sync**: Updated version to `2.6.11` (build `18`), compile SDK to `37`, added missing packages (`crypto`, `package_info_plus`), and updated last-generated date to `2026-08-12`.

## Files Changed
- [`docs/features.md`](file:///l:/Android/sreeraj_qr_reader/docs/features.md)

## Verification
- Checked file content against `lib/`, `pubspec.yaml`, and `assets/config/app_config.json`.
- Ran `flutter analyze` clean.
