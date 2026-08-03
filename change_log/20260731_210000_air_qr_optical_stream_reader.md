# Change Log: AirQR — High-Speed Optical Air-Gap Stream Reader

**Plan Reference:** [plans/20260731_210000_air_qr_optical_stream_reader.md](file:///l:/Android/sreeraj_qr_reader/plans/20260731_210000_air_qr_optical_stream_reader.md)

## Summary of Changes
Implemented **AirQR — High-Speed Optical Air-Gap Stream Reader** (Feature 3.3). This offline optical data transmission and reception engine enables phone-to-phone air-gapped data ingestion from continuous animated QR code streams using Forward Error Correction (Fountain / LT codes) without needing Wi-Fi, Bluetooth, NFC, or cellular connectivity.

## Files Created
- `lib/models/air_qr_frame.dart`: Data model representing parsed optical stream frames (systematic `v1` frames and LT Fountain `LT1` parity frames).
- `lib/models/air_qr_progress.dart`: State model tracking block count, captured indices, FPS, progress %, and payload reassembly status.
- `lib/services/air_qr_service.dart`: High-performance systematic & Fountain stream decoder and encoder engine with CRC32 checksum verification.
- `lib/providers/air_qr_provider.dart`: State management provider for optical stream reception, progress notifications, and scan history recording.
- `lib/screens/air_qr_screen.dart`: Dedicated Receiver HUD screen with live capture speed (FPS), real-time block matrix grid, progress bar, and reassembled payload modal.
- `lib/screens/air_qr_transmitter_screen.dart`: Optical Stream Transmitter broadcasting screen that converts payload strings into animated QR code streams (5–25 FPS).
- `test/services/air_qr_service_test.dart`: Unit tests covering frame parsing out-of-order decoding, Fountain error correction recovery, CRC32 checksums, and encoding.
- `test/providers/air_qr_provider_test.dart`: Unit tests covering provider state transitions and scan record generation.

## Files Modified
- `lib/screens/scanner_screen.dart`: Added AirQR Stream Reader shortcut button to the top action bar.
- `lib/main.dart`: Registered `AirQrProvider` in `MultiProvider` and added routes `/air_qr` and `/air_qr_transmitter`.

## Verification Results
- `flutter analyze`: Clean (0 errors, 0 warnings, 0 lints).
- `flutter test`: 132 tests passed (100% pass rate).
