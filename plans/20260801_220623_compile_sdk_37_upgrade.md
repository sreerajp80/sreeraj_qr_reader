# Plan: Upgrade compileSdk to Android SDK 37

**Status:** Completed

## Problem / Background
The build for release APK (`flutter build apk --flavor prod --release --split-per-abi`) fails because the `receive_sharing_intent` plugin requires Android SDK 37 (or higher), while `android/app/build.gradle` is set to `compileSdk = flutter.compileSdkVersion` (which evaluates to Android SDK 36).
During the build, Gradle threw the following error:
```
Could not determine the dependencies of task ':receive_sharing_intent:compileReleaseJavaWithJavac'.
> Failed to find target with hash string 'android-37' in: E:\Android\SDK
```
Android SDK 37 platform files have now been installed into `E:\Android\SDK\platforms\android-37.0`. Updating `compileSdk` to 37 in `android/app/build.gradle` will resolve the build dependency mismatch.

## Proposed Changes

### `android/app/`

#### [MODIFY] [build.gradle](file:///L:/Android/sreeraj_qr_reader/android/app/build.gradle)
- Change `compileSdk = flutter.compileSdkVersion` to `compileSdk = 37` in the `android { ... }` block.

## Verification Plan

### Automated Tests
- Run `flutter analyze` to ensure clean static analysis.
- Run `flutter build apk --flavor prod --release --split-per-abi` to verify that the release APK builds successfully with `compileSdk = 37`.
- Run `flutter test` to ensure unit tests continue passing.

### Manual Verification
- Confirm release binaries are successfully generated without Gradle compile SDK errors.
