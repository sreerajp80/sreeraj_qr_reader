# Change Log: Fix Android Gradle compileSdk in Subprojects and Plugin Evaluation

**Date:** 2026-08-19  
**Plan:** `plans/20260819_204500_fix_gradle_compile_sdk_subprojects.md`

## Summary of Changes

Resolved release APK build failures caused by Android plugins lacking explicit `compileSdk` definitions and corrupted Gradle transformation metadata.

### 1. Root Gradle Build Configuration
- Modified `android/build.gradle`:
  - Added an `afterEvaluate` block under `subprojects` to automatically supply `compileSdkVersion 36` fallback for all subprojects applying Android plugins.
  - Placed the `afterEvaluate` block before `project.evaluationDependsOn(':app')` to ensure all subproject listeners are registered before app evaluation.

### 2. App-Level Gradle Configuration
- Modified `android/app/build.gradle`:
  - Set `compileSdk = flutter.compileSdkVersion` to align with the Flutter SDK platform configuration.

## Verification
- Cleaned stale Gradle daemon processes and corrupted metadata caches.
- Static analysis: `flutter analyze` completed with 0 errors / 0 warnings.
- Test suite: `flutter test` completed with 154/154 passing tests.
- Release APK build: `flutter build apk --flavor prod --release --split-per-abi` succeeded and built all target ABIs (`armeabi-v7a`, `arm64-v8a`, `x86_64`).
