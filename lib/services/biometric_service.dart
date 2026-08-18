import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

/// Biometric Service - Tier 1 Service Layer
/// Wraps local_auth to provide biometric authentication (Fingerprint / Face Unlock).
class BiometricService {
  final LocalAuthentication _auth;

  BiometricService({LocalAuthentication? auth})
    : _auth = auth ?? LocalAuthentication();

  /// Checks whether hardware biometrics or device passcode authentication is available.
  Future<bool> isBiometricAvailable() async {
    try {
      final bool canCheck = await _auth.canCheckBiometrics;
      final bool isSupported = await _auth.isDeviceSupported();
      return canCheck || isSupported;
    } catch (_) {
      return false;
    }
  }

  /// Prompts the user for biometric authentication (or device passcode
  /// fallback).
  ///
  /// [localizedReason] is shown by the system dialog, so the caller must pass
  /// text it has already localized. The service holds no UI strings itself.
  Future<bool> authenticate({required String localizedReason}) async {
    try {
      return await _auth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(stickyAuth: true),
      );
    } on PlatformException {
      return false;
    } catch (_) {
      return false;
    }
  }
}
