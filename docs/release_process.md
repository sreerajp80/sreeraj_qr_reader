# Release Process — SreerajP QR Reader

This document provides the step-by-step release runbook, signing instructions, versioning rules, build commands, and release checklist for SreerajP QR Reader. Read this before building or distributing a release artifact.

**Read first:**
- [CLAUDE.md](../CLAUDE.md)
- [architecture.md](architecture.md)
- [security.md](security.md)
- [guidelines/release_process.md](guidelines/release_process.md)

---

## 1. Secrets Warning

> **CRITICAL:** `android/key.properties` and `android/keystore.jks` contain release signing keys and must **NEVER** be committed to source control. Ensure both are listed in `.gitignore`.

---

## 2. Release Scope

- App: SreerajP QR Reader
- Release profiles: Personal / Production distribution
- Supported platforms: Android (minSdk 24, targetSdk 35)
- Current version: `1.4.3+1`

---

## 3. Roles And Responsibilities

| Role | Responsibility | Owner |
|------|----------------|-------|
| Release owner | All release decisions and final sign-off | Sreeraj P |
| Engineering | Code, fixes, and validation | Sreeraj P |

---

## 4. Versioning Policy

- Version format: `MAJOR.MINOR.PATCH+BUILD`
- Source of truth: `pubspec.yaml`
- Current version: `1.4.3+1`
- Git tag format: `vX.Y.Z`

---

## 5. Build Flavors Matrix

| Flavor | Purpose | Command |
|--------|---------|---------|
| `dev` | Daily development and testing | `flutter run --flavor dev` |
| `prod` | Production release APK (split per ABI) | `flutter build apk --flavor prod --release --split-per-abi` |
| `prod` | Production Play Store App Bundle | `./tool/build_release.sh appbundle` or `flutter build appbundle --flavor prod --release` |

---

## 6. Signing And Secret Handling

- Secrets location: `android/key.properties`
- Keystore location: `android/keystore.jks` (or path specified in `key.properties`)
- Rules:
  - `android/key.properties` must never be committed
  - `android/keystore.jks` must never be committed
  - Keystore must be backed up in an offline password manager

---

## 7. Release Checklist

### Quality & Standards
- [ ] `flutter pub get` succeeds
- [ ] `dart format --output=none --set-exit-if-changed .` passes
- [ ] `flutter analyze` clean (0 warnings)
- [ ] `flutter test` passing (100% pass rate)

### Versioning & Config
- [ ] Version in `pubspec.yaml` incremented
- [ ] `assets/config/app_config.json` version and build match `pubspec.yaml`
- [ ] `android/key.properties` configured for prod release
- [ ] `pubspec.lock` committed

### Verification
- [ ] Prod release APK built and verified on device
- [ ] Camera scanning, URL safety engine, and settings functional
- [ ] Git release tag created (`vX.Y.Z`)
