# Plan: AirQR — High-Speed Optical Air-Gap Stream Reader

**Status:** Proposed

## Overview
Implement **AirQR**, an offline optical data receiving and transmitting engine that captures and reassembles text blocks, contact lists, or file backups from continuous animated QR code streams (Fountain Codes / Reed-Solomon / LT systematic frame decoding) without Wi-Fi, Bluetooth, or cellular data.

## Issue / Requirement
Implement Feature 3.3 (AirQR):
- Optical Stream Receiver Mode: point camera at animated QR stream.
- Frame Decoding & Reassembly: capture 256-byte chunks in any sequence order, apply forward error correction (Fountain / LT code decoding) to recover missing frames, and automatically reassemble payload offline.
- Air-Gap Security: offline optical phone-to-phone data transfer without wireless pairing.

## Architecture & Layering
- **Models (`lib/models/`)**:
  - `air_qr_frame.dart`: Demarcates sequence number, degree, chunk payload, checksum, and stream ID.
  - `air_qr_progress.dart`: State model tracking blocks captured, missing count, FPS, progress %, and payload reassembly status.
- **Service (`lib/services/`)**:
  - `air_qr_service.dart`: High-performance Fountain / LT systematic stream encoder and decoder. Solves linear equation frames / XOR parity frames continuously as frames arrive via camera stream.
- **Provider (`lib/providers/`)**:
  - `air_qr_provider.dart`: State management for optical stream decoding, frame rate tracking, and reassembled payload output.
- **Screens (`lib/screens/`)**:
  - `air_qr_screen.dart`: Receiver HUD with live stream progress, chunk matrix visualization, and reassembled payload inspector.
  - `air_qr_transmitter_screen.dart`: Transmitter broadcasting screen that converts payload into animated QR streams for cross-device testing.
- **Scanner Integration (`lib/screens/scanner_screen.dart`)**:
  - Adds AirQR stream receiver mode action button to main camera scanner screen.
- **App Main (`lib/main.dart`)**:
  - Register `AirQRProvider` in `MultiProvider` and set up `/air_qr` and `/air_qr_transmitter` routes.

## Files to Create
- `lib/models/air_qr_frame.dart`
- `lib/models/air_qr_progress.dart`
- `lib/services/air_qr_service.dart`
- `lib/providers/air_qr_provider.dart`
- `lib/screens/air_qr_screen.dart`
- `lib/screens/air_qr_transmitter_screen.dart`
- `test/services/air_qr_service_test.dart`
- `test/providers/air_qr_provider_test.dart`

## Files to Modify
- `lib/main.dart`
- `lib/screens/scanner_screen.dart`

## Verification Plan
1. Run `flutter analyze` to ensure clean zero-warning build.
2. Run `flutter test` including new unit tests for `AirQRService` (encoding, decoding out of order frames, recovering from missing frames via Fountain FEC, checksum validation).
