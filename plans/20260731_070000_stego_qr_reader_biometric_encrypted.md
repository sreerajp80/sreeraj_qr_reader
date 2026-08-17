# Plan: Biometric-Locked Encrypted Steganographic QR Reader (StegoQR)

**Status:** Approved — In Execution

## Summary
Implement StegoQR reading capability in Sreeraj QR Reader. StegoQR is a dual-layer QR system where standard scanners see an innocent decoy payload, while Sreeraj QR Reader detects the hidden AES-256 encrypted payload header (`STEGOQR:v1:` or `--STEGOQR--`), prompts for biometric authentication (`local_auth`) or passphrase fallback, and seamlessly decrypts and presents the secret contents.

## Objective & Rules Alignment
- **Open Source & Privacy**: Uses open-source `local_auth` and `encrypt` packages. All decryption happens locally on-device. Zero network leaks of decrypted payload.
- **Offline-First**: AES-256 decryption and biometric checks run completely offline.
- **Architecture**:
  - `models/stego_qr_data.dart` (Tier 1 model layer)
  - `services/stego_qr_service.dart`, `services/biometric_service.dart` (Tier 1 service layer)
  - `providers/scan_provider.dart` (Tier 1 provider layer)
  - `screens/result_screen.dart` (Tier 1 UI layer)
- **Formatting & Analysis**: Run `dart format .`, `flutter analyze`, and `flutter test` upon implementation.

---

## Targeted Files

### 1. Dependencies & Manifests
- [pubspec.yaml](../pubspec.yaml): Add `local_auth: ^2.3.0` and `encrypt: ^5.0.3`.
- [android/app/src/main/kotlin/in/sreerajp/qr_reader/MainActivity.kt](../android/app/src/main/kotlin/in/sreerajp/qr_reader/MainActivity.kt): Extend `FlutterFragmentActivity` instead of `FlutterActivity` for biometric prompt compatibility.
- [android/app/src/main/AndroidManifest.xml](../android/app/src/main/AndroidManifest.xml): Declare `android.permission.USE_BIOMETRIC`.

### 2. New Models & Services
- [NEW] [lib/models/stego_qr_data.dart](../lib/models/stego_qr_data.dart): Immutable model representing decoy text, salt, IV, ciphertext, unlock state, decrypted payload, and error message.
- [NEW] [lib/services/stego_qr_service.dart](../lib/services/stego_qr_service.dart): Pure service for StegoQR signature detection, parsing, PBKDF2 key derivation, and AES-256 decryption.
- [NEW] [lib/services/biometric_service.dart](../lib/services/biometric_service.dart): Wrapper service for `local_auth` device capability checking and biometric prompt execution.

### 3. State Management & Screens
- [lib/providers/scan_provider.dart](../lib/providers/scan_provider.dart): Add StegoQR state variables, detection during `setScanResult()`, biometric/passphrase `unlockStegoPayload()` method, and cleanup in `clearScan()`.
- [lib/screens/result_screen.dart](../lib/screens/result_screen.dart): Add StegoQR card component showing Decoy message, Biometric Unlock button, Passphrase dialog fallback, and protected decrypted payload card with visibility toggle and copy actions.

### 4. Testing
- [NEW] [test/services/stego_qr_service_test.dart](../test/services/stego_qr_service_test.dart): Unit tests for StegoQR detection, parsing, AES-256 decryption, and error conditions.
- [NEW] [test/providers/scan_provider_stego_test.dart](../test/providers/scan_provider_stego_test.dart): Unit tests for `ScanProvider` StegoQR state flow and unlock operations.

---

## Verification Plan
1. `flutter pub get` to fetch dependencies.
2. `flutter test` to execute all unit tests, including new StegoQR unit tests.
3. `flutter analyze` to ensure 0 lint errors/warnings.
4. `dart format .` to format codebase.
