# Release Process

## 1. Release Scope

- App: Sreeraj P QR Reader
- Release profile: not yet shipping (personal/internal use)
- Supported release platforms:
  - Android
- Engineering standard profiles in force:
  - `Core Baseline`

## 2. Roles And Responsibilities

| Role | Responsibility | Owner |
|------|----------------|-------|
| Release owner | All release decisions and final sign-off | Sreeraj P |
| Engineering | Code, fixes, and validation | Sreeraj P |

## 3. Versioning Policy

- Version format: `MAJOR.MINOR.PATCH+BUILD`
- Source of truth: `pubspec.yaml`
- Build-number increment rule: Increment build number for every release artifact; increment patch for bug fixes; increment minor for new features; increment major for breaking changes
- Current version: 1.2.0+1
- Git tag format: `vX.Y.Z`

## 4. Branch And Merge Policy

- Release branch strategy: main only (single developer)
- Hotfix strategy: commit directly to main; build and distribute updated APK
- Required checks before merge:
  - `flutter analyze` clean
  - `flutter test` passing
  - `dart format` no changes required

## 5. Environment And Flavor Matrix

No build flavors. Single build variant.

| Mode | Purpose | Command |
|------|---------|---------|
| `debug` | Development and device testing | `flutter run` |
| `release` | Direct APK distribution | `flutter build apk --release --split-per-abi` |
| `release` | Play Store App Bundle | `flutter build appbundle --release` |

## 6. Signing And Secret Handling

- Signing config location: `android/key.properties` (not in source control; covered by `.gitignore`)
- Keystore location: `android/keystore.jks` (not in source control; covered by `.gitignore`)
- Keystore ownership: Sreeraj P
- Secret rotation: Generate a new keystore only if the existing one is compromised. Note that Play Store apps cannot change their signing key after first publication without creating a new app listing.
- Rules:
  - `android/key.properties` must never be committed
  - `android/keystore.jks` must never be committed
  - CI logs must not print signing secrets
  - Keystore must be backed up in a password manager

## 7. Release Checklist

### Code And Quality

- [ ] `flutter pub get` succeeds
- [ ] `dart format --output=none --set-exit-if-changed .` passes
- [ ] `flutter analyze` clean
- [ ] `flutter test` passing
- [ ] No known regressions

### Product And Documentation

- [ ] Version in `pubspec.yaml` updated
- [ ] Build number incremented
- [ ] `pubspec.lock` committed
- [ ] README reflects current state if behaviour changed

### Security And Compliance

- [ ] `android:allowBackup="false"` confirmed in `AndroidManifest.xml`
- [ ] Release build uses production keystore (not debug signing)
- [ ] No secrets in source control

### Artifact Validation

- [ ] Release APK builds without error
- [ ] APK installs and launches on a physical device
- [ ] Version name and build number match `pubspec.yaml` (visible in About screen)
- [ ] URL safety checks function correctly on the release build

## 8. Android Release Steps

1. Pull the latest commit from main.
2. Verify the version in `pubspec.yaml`.
3. Confirm `android/key.properties` and `android/keystore.jks` are in place.
4. Run quality checks:

```bash
flutter pub get
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

5. Build split APKs for direct distribution:

```bash
flutter build apk --release --split-per-abi
```

6. Or build an App Bundle for Play Store:

```bash
flutter build appbundle --release
```

7. Install and verify on a physical device:

```bash
adb install build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
```

8. Tag the release in git:

```bash
git tag v1.2.0
git push origin v1.2.0
```

## 9. Distribution Channels

| Channel | Artifact | Audience | Notes |
|---------|----------|----------|-------|
| Direct APK | `app-arm64-v8a-release.apk` | Personal use | Install via `adb` or direct file transfer |
| Google Play | `.aab` (App Bundle) | Public (if published) | Not yet published |

## 10. Rollback And Hotfix Process

- Rollback trigger: Critical crash or data loss discovered post-release
- Rollback method: Install the previous APK on the affected device; publish a hotfix release as soon as practical
- Hotfix branch naming: N/A (main only for single developer)
- Verification after hotfix: Re-run the full release checklist

## 11. Release Evidence

Not formally tracked for personal use. Once published to Play Store:

- CI run: link to GitHub Actions run
- Built artifact: `build/app/outputs/flutter-apk/`
- Release notes: update this document
- Release tag: `vX.Y.Z` in git

## 12. Post-Release Checks

- [ ] App launches correctly from a fresh install
- [ ] Version shown in About screen matches the release
- [ ] URL safety checks function correctly
- [ ] Release tag created in git
- [ ] Keystore backup confirmed safe
