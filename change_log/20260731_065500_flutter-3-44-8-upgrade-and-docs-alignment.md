# Change Log: Flutter 3.44.8 SDK Upgrade & Guidelines Alignment

**Plan Reference:** `plans/20260731_065500_flutter-3-44-8-upgrade-and-docs-alignment.md`

## Overview
Successfully upgraded the project to **Flutter 3.44.8** (Dart **3.12.2**) and brought the codebase, assets, and documentation into 100% strict compliance with the shared Flutter guidelines in `@docs/guidelines/` (`guideline.md` & `flutter_project_engineering_standard.md`).

## Summary of Changes

### 1. Guideline Structure & About-Screen Implementation
- **Asset Creation**: Created `assets/config/app_config.json` containing `appName`, `description`, `version`, `build`, and `details` map as the single source of truth for About screen data (`guideline.md` §1.2).
- **Asset Registration**: Added `- assets/config/` under `flutter: assets:` in `pubspec.yaml` (`guideline.md` §1.3).
- **Core Config Model**: Created `lib/core/config/app_config.dart` implementing the immutable `AppConfig` class with per-field `fromJson` fallback and safe `static const AppConfig fallback` (`guideline.md` §1.4).
- **Config Service Loader**: Created `lib/core/config/config_service.dart` implementing `ConfigService` with `load()`, `loadAndVerify()`, and debug version mismatch logging (`guideline.md` §1.5).
- **Technical Constants**: Created `lib/core/constants/app_constants.dart` for technical constants.
- **Legacy Cleanup**: Removed non-compliant `lib/config/build_config.dart`.
- **Data-Driven About UI**: Refactored `AboutScreen` (`lib/screens/about_screen.dart`) to load `AppConfig` via `ConfigService` and dynamically loop over `config.details.entries` with `mailto` handler for email entries (`guideline.md` §1.6).
- **Mirroring Test Suite**: Created `test/core/config/app_config_test.dart` testing `AppConfig.fromJson`, fallback behavior, version verification, and `ConfigService`.

### 2. SDK Version Upgrade & Config Locks
- **`pubspec.yaml`**: Updated `environment.sdk` to `'>=3.12.2 <4.0.0'` and `environment.flutter` to `'>=3.44.8'`.
- **`CLAUDE.md`**: Updated identity table to Flutter SDK `>=3.44.8`, Dart SDK `>=3.12.2 <4.0.0`, and Tier 1 structure reference.
- **`README.md`**: Updated technical specifications to Flutter `3.44.8` / Dart `3.12.2` and updated directory tree diagram.

### 3. Living Documentation (`docs/`)
- **`docs/architecture.md`**: Updated directory layout tree to include `assets/config/app_config.json`, `lib/core/config/`, and updated ownership table.
- **`docs/project_structure.md`**: Updated tree diagram and path responsibilities for `lib/core/config/` and `assets/config/app_config.json`.
- **`docs/release_process.md`**: Added checklist item to verify `assets/config/app_config.json` version alignment with `pubspec.yaml`.

## Verification Results
- **`flutter pub get`**: Succeeded cleanly.
- **`flutter analyze`**: 0 errors, 0 warnings.
- **`flutter test`**: All 53 unit/widget tests passed (100% pass rate).
