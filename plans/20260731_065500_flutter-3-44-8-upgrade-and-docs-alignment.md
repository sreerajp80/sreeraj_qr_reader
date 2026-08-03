# Change Plan: Full Project Alignment with Guidelines & Flutter SDK 3.44.8 Upgrade

**Status:** Approved

## Problem / Goal Statement
The user requested:
1. Ensure the project follows the guideline documents in `@docs` (specifically `guideline.md` and `flutter_project_engineering_standard.md`) **exactly**, including the project structure.
2. Follow `CLAUDE.md` rules.
3. Upgrade Flutter SDK configuration to Flutter `3.44.8` (channel stable, Framework revision `058e0af2c2`, Engine `13ffd72b2f9a5ca4db2a74ea52d5353ec2e8f939`, Dart `3.12.2`, DevTools `2.57.0`) and update all relevant project documentation.

## Audit Findings & Gaps Identified
Following a comprehensive audit against `docs/guidelines/guideline.md`, `docs/guidelines/flutter_project_engineering_standard.md`, and `CLAUDE.md`, the following structural and document gaps were found:

1. **Project Folder Structure (`guideline.md` §3 & `engineering_standard.md` §3.1 Tier 1 layout)**:
   - Guideline mandates `lib/core/config/` containing `app_config.dart` (`AppConfig` model) and `config_service.dart` (`ConfigService` loader).
   - Guideline mandates `lib/core/constants/` containing `app_constants.dart` for technical constants.
   - Current codebase places constants in `lib/config/build_config.dart` without `lib/core/` namespace.
2. **About-Screen Data Source of Truth (`guideline.md` §1)**:
   - Missing required asset `assets/config/app_config.json` containing `appName`, `description`, `version`, `build`, and `details` map.
   - Missing required asset registration `- assets/config/` under `flutter: assets:` in `pubspec.yaml`.
   - `AboutScreen` (`lib/screens/about_screen.dart`) currently hardcodes strings and reads from `build_config.dart` instead of dynamically iterating over `AppConfig.details` via `ConfigService`.
3. **SDK Version Locking**:
   - `pubspec.yaml` currently specifies `flutter: '>=3.41.4'` and `sdk: '>=3.11.1 <4.0.0'`.
   - `CLAUDE.md` identity table specifies Flutter `>=3.41.4`.
   - `README.md` lists `Flutter Version 3.41.4+`.
4. **Test Suite Layout (`guideline.md` & `CLAUDE.md`)**:
   - Test folder must mirror `lib/` structure. `test/core/config/app_config_test.dart` is needed to verify `AppConfig` parsing, fallback safety, and version verification.
5. **Living Documentation Alignment (`docs/`)**:
   - `docs/architecture.md`, `docs/project_structure.md`, `docs/release_process.md`, `docs/dependencies.md`, `docs/security.md` require updates to reflect `lib/core/config/`, `assets/config/app_config.json`, and Flutter `3.44.8` / Dart `3.12.2`.

---

## Proposed Changes

### 1. Guideline Structure & About-Screen Implementation

#### Assets & Config File
- **`[NEW] assets/config/app_config.json`**:
  Create JSON file with required top-level fields (`appName`, `description`, `version`, `build`) and `details` map as per `guideline.md` §1.2.

#### Codebase Structure (`lib/core/`)
- **`[NEW] lib/core/config/app_config.dart`**:
  Implement `AppConfig` data class with `fromJson` (per-field fallbacks), `static const AppConfig fallback`, and `details` map parsing (`guideline.md` §1.4).
- **`[NEW] lib/core/config/config_service.dart`**:
  Implement `ConfigService` with `load()`, `loadAndVerify()`, injectable asset loader, and debug warning on version mismatch (`guideline.md` §1.5).
- **`[NEW] lib/core/constants/app_constants.dart`**:
  Create technical constants class `AppConstants` for `buildDate` (`guideline.md` §1.6 & §3).
- **`[DELETE] lib/config/build_config.dart`**:
  Remove legacy non-compliant configuration file.

#### Screen Refactoring
- **`[MODIFY] lib/screens/about_screen.dart`**:
  Refactor `AboutScreen` to be data-driven using `ConfigService` and `AppConfig`. Loop over `config.details.entries` dynamically (with email mailto handler) per `guideline.md` §1.6.

#### Test Suite Mirroring
- **`[NEW] test/core/config/app_config_test.dart`**:
  Add unit tests mirroring `lib/core/config/` for JSON decoding, field-level fallback, `ConfigService` loading, and version mismatch checks.

---

### 2. Configuration & Dependencies

#### [MODIFY] [pubspec.yaml](file:///l:/Android/sreeraj_qr_reader/pubspec.yaml)
- Update `environment.sdk` to `'>=3.12.2 <4.0.0'`.
- Update `environment.flutter` to `'>=3.44.8'`.
- Add `- assets/config/` to `flutter: assets:`.

---

### 3. Primary Instructions & Documentation

#### [MODIFY] [CLAUDE.md](file:///l:/Android/sreeraj_qr_reader/CLAUDE.md)
- Update Project identity table:
  - Flutter SDK: `>=3.44.8`
  - Dart SDK: `>=3.12.2 <4.0.0`
- Update structure reference to include `lib/core/config/` and `assets/config/app_config.json`.

#### [MODIFY] [README.md](file:///l:/Android/sreeraj_qr_reader/README.md)
- Update Technical Specifications to Flutter `3.44.8` / Dart `3.12.2`.
- Update Project Structure diagram to reflect `lib/core/config/` and `assets/config/app_config.json`.

---

### 4. Living Documentation (`docs/`)

#### [MODIFY] [docs/architecture.md](file:///l:/Android/sreeraj_qr_reader/docs/architecture.md)
- Update directory structure tree to include `lib/core/config/` and `assets/config/app_config.json`.
- Update SDK version references to Flutter `3.44.8` / Dart `3.12.2`.

#### [MODIFY] [docs/project_structure.md](file:///l:/Android/sreeraj_qr_reader/docs/project_structure.md)
- Update full repository tree and path responsibilities table for `lib/core/config/`, `lib/core/constants/`, and `assets/config/app_config.json`.

#### [MODIFY] [docs/release_process.md](file:///l:/Android/sreeraj_qr_reader/docs/release_process.md)
- Update release checklist to include checking `assets/config/app_config.json` version alignment with `pubspec.yaml`.
- Update Flutter/Dart SDK references.

#### [MODIFY] [docs/dependencies.md](file:///l:/Android/sreeraj_qr_reader/docs/dependencies.md)
- Confirm package constraints align with Flutter 3.44.8.

#### [MODIFY] [docs/security.md](file:///l:/Android/sreeraj_qr_reader/docs/security.md)
- Verify security blueprint alignment.

---

## Verification Plan

### Automated Verification
1. Run `flutter pub get` to lock dependencies.
2. Run `flutter analyze` — MUST pass with 0 errors and 0 warnings.
3. Run `flutter test` — MUST pass 100% across all unit tests (existing 47 tests + new `app_config_test` tests).

### Manual Verification
1. Verify `assets/config/app_config.json` exists and is valid JSON.
2. Confirm `AboutScreen` renders app name, description, version, and dynamic details directly from `app_config.json`.
3. Check `git status` to verify clean directory layout strictly following `guideline.md`.
