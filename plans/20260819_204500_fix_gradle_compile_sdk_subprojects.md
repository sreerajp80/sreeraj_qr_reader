# Plan: Fix Android Gradle compileSdk in Subprojects and Plugin Evaluation

**Status:** Completed

## Problem / Background
When running `flutter build apk --flavor prod --release --split-per-abi`, the build fails during the configuration of the `:flutter_plugin_android_lifecycle` project with the following error:
```
Android Gradle Plugin: project ':flutter_plugin_android_lifecycle' does not specify `compileSdk` in build.gradle.kts
```
Additionally, corrupted Kotlin DSL accessors metadata in the Gradle cache caused null pointer exceptions during evaluation listener notification.

Because Flutter plugins such as `flutter_plugin_android_lifecycle` use Kotlin DSL or may omit an explicit `compileSdk` definition, the root Gradle project must inject a fallback `compileSdkVersion` (e.g., 37) in an `afterEvaluate` block across all subprojects that have the Android plugin applied.

## Proposed Changes

### `android/`

#### [MODIFY] [build.gradle](android/build.gradle)
- Add a `subprojects` block with `afterEvaluate` to ensure all subprojects with the Android plugin have `compileSdkVersion` set (falling back to `37` if not specified):
```groovy
subprojects {
    afterEvaluate { project ->
        if (project.hasProperty('android')) {
            project.android {
                if (compileSdkVersion == null) {
                    compileSdkVersion 37
                }
            }
        }
    }
}
```

## Verification Plan

### Automated / Build Verification
- Run `flutter clean` to clear stale and corrupted build and Gradle cache artifacts.
- Run `flutter pub get` to restore dependencies.
- Run `flutter analyze` to ensure clean static analysis.
- Run `flutter build apk --flavor prod --release --split-per-abi` to verify that release APKs build successfully.
- Run `flutter test` to ensure all unit and widget tests pass.

### Manual Verification
- Confirm release APK artifacts are generated without Gradle evaluation failures.
