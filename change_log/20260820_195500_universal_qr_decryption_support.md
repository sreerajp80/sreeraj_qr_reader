# Change Log: Universal Encrypted QR Code Auto-Detection & Manual Decryption

**Plan:** [plans/20260820_195500_universal_qr_decryption_support.md](../plans/20260820_195500_universal_qr_decryption_support.md)

## Summary of Changes
Added full multi-protocol encrypted QR code support and an on-demand manual decryption tool to the application:

1. **AirQR Protocol Support (Compatible with TextApp):**
   - Automatically detects `textdataqr://` frames (manifest & data frames).
   - Unlocks payloads using the session code (e.g. `ABC-DEF`), PBKDF2-HMAC-SHA256 (200,000 iterations), AES-256-GCM unsealing, Gzip decompression, SHA-256 integrity verification, and JSON payload envelope extraction.

2. **Multi-Protocol & JSON Container Detection:**
   - Detects StegoQR (`STEGOQR:v1:` / `--STEGOQR--`).
   - Detects standard JSON crypto containers (`iv`, `salt`, `ciphertext`).
   - Detects PGP armored message blocks.

3. **Manual Decryption Modal Tool:**
   - Added a "Decrypt Payload" action button on the scan result screen for any scanned text or raw ciphertext.
   - Allows users to select cipher mode (Auto-detect, AES-256-GCM, AES-256-CBC), input passphrase/key, specify custom salt/IV, and preview decrypted content directly.

4. **Localization & Testing:**
   - Added all user-facing strings to `lib/l10n/app_en.arb` with descriptive metadata.
   - Added comprehensive unit tests in `test/services/encrypted_payload_service_test.dart` verifying AirQR, StegoQR, JSON envelopes, and manual cipher decryption modes.

---

## Files Created & Modified
- `lib/models/encrypted_payload_data.dart` (New model for encrypted container representation)
- `lib/services/encrypted_payload_service.dart` (New service for protocol detection and cryptographic decryption)
- `lib/providers/scan_provider.dart` (Integrated encrypted payload detection and decryption methods)
- `lib/screens/result_screen.dart` (Updated result card and added manual decryption modal)
- `lib/l10n/app_en.arb` (Added localization strings and descriptions)
- `test/services/encrypted_payload_service_test.dart` (Added unit tests)
