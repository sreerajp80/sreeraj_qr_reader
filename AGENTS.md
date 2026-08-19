# AGENTS.md — SreerajP QR Reader

This file is read by AI agents and LLM coding assistants (Gemini, Antigravity, Cursor, Windsurf, Codex, and others) at the start of every session in this repository.
Read it before making any change. See the docs table below for full detail.

> `CLAUDE.md` holds the same rules for Claude Code. Keep the two files in step — if you change a rule, a command, or the identity table here, make the same change there.

---

## Project identity

| Field            | Value                                                                                           |
| ---------------- | ----------------------------------------------------------------------------------------------- |
| App name         | SreerajP QR Reader                                                                             |
| Type             | Flutter Android application for scanning QR codes & barcodes with 6-layer URL safety analysis   |
| Platform(s)      | Android only (minSdk 24, targetSdk 35)                                                          |
| Package / org id | `in.sreeraj.qr_reader`                                                                          |
| Flutter SDK      | `>=3.44.8`                                                                                      |
| Dart SDK         | `>=3.12.2 <4.0.0`                                                                               |
| State management | Provider (`ChangeNotifier`)                                                                     |
| Navigation       | Named routes (`Navigator 1.0`)                                                                  |
| Database         | None (`shared_preferences` for counters, `flutter_secure_storage` for API keys)                 |
| Orientation      | Portrait only                                                                                   |
| Connectivity     | Offline-first / online optional (URL safety checks work offline; Google Safe Browsing optional) |

---

## Read these docs before working

| Document                                                                                                           | Read when                                                  |
| ------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------- |
| [docs/architecture.md](docs/architecture.md)                                                                       | Changing structure, screens, state, services, models       |
| [docs/security.md](docs/security.md)                                                                               | Touching permissions, logging, storage, API keys, manifest |
| [docs/release_process.md](docs/release_process.md)                                                                 | Building a release, versioning, signing, release checklist |
| [docs/workflow_rules.md](docs/workflow_rules.md)                                                                   | Planning changes, approval gate, writing change logs       |
| [docs/dependencies.md](docs/dependencies.md)                                                                       | Package constraints, adding dependencies                   |
| [docs/project_structure.md](docs/project_structure.md)                                                             | Orienting on directory layout and file responsibilities    |
| [docs/guidelines/flutter_project_engineering_standard.md](docs/guidelines/flutter_project_engineering_standard.md) | Any code change — layers, naming, testing rules            |
| [docs/guidelines/flutter_build_flavors_guide.md](docs/guidelines/flutter_build_flavors_guide.md)                   | Build flavors, Gradle, signing configuration               |
| [docs/guidelines/AGENTS_MD_GUIDELINE.md](docs/guidelines/AGENTS_MD_GUIDELINE.md)                                   | Editing this file                                          |
| [docs/guidelines/CLAUDE_MD_GUIDELINE.md](docs/guidelines/CLAUDE_MD_GUIDELINE.md)                                   | Editing `CLAUDE.md`                                        |
| [docs/guidelines/DOCS_FOLDER_GUIDELINE.md](docs/guidelines/DOCS_FOLDER_GUIDELINE.md)                               | Adding or renaming a file in `docs/`                       |
| [docs/GUIDELINES_MANIFEST.md](docs/GUIDELINES_MANIFEST.md)                                                         | The shared Flutter guidelines index                        |

---

## Hard rules (must follow — these override convenience)

1. Open source packages only. Check package licenses before adding dependencies.
2. Offline-first scanning. Scanned barcode analysis must work offline; online Safe Browsing API check is optional and opt-in.
3. Scoped storage and camera permission on-demand. Request camera permission only when scanning.
4. Never crash on malformed inputs or unparseable barcodes. Return a safe, friendly error state.
5. Never expose or log sensitive data (such as the Google Safe Browsing API key).

---

## Architecture rules

- Tier 1 layer-first structure under `lib/`: `core/config/` (`app_config.dart`, `config_service.dart`), `core/constants/` (`app_constants.dart`), `models/`, `providers/`, `screens/`, `services/`, `main.dart`. `assets/config/app_config.json` is the single source of truth for About metadata (`guideline.md` §1). Do not restructure without instruction.
- Layer boundaries: Widgets must not make HTTP calls, access secure storage, or perform URL analysis directly. Services must not depend on `BuildContext`, UI strings, or navigation routes.
- Dependency direction: `screens → providers → services → models`.
- Models are immutable (`const` constructors). Never mutate domain objects in place.

---

## Build & run commands

```bash
flutter pub get                        # install dependencies
flutter run --flavor dev               # daily development (dev flavor)
flutter run --flavor prod              # production build with debug tooling
flutter analyze                        # static analysis (must be clean)
flutter test                           # run all unit tests
dart format .                          # format code before committing

# Production release APK (split per ABI)
flutter build apk --flavor prod --release \
  --obfuscate --split-debug-info=build/symbols/android-prod-1.4.3+1/ --split-per-abi

# Production Play Store bundle
./tool/build_release.sh appbundle      # or: flutter build appbundle --flavor prod --release
```

---

## Build flavors

| Flavor | App ID                      | Display name        | Signing                                     |
| ------ | --------------------------- | ------------------- | ------------------------------------------- |
| `dev`  | `in.sreeraj.qr_reader.dev`  | QR Reader Dev       | Debug keystore (automatic)                  |
| `prod` | `in.sreeraj.qr_reader`      | SreerajP QR Reader | Release keystore (`android/key.properties`) |

> Flutter sets `FLUTTER_APP_FLAVOR` automatically. Read it with `String.fromEnvironment('FLUTTER_APP_FLAVOR')`.

---

## Signing / keystore

- Release signing uses `android/key.properties` pointing to `android/keystore.jks`.
- `android/key.properties` and `*.jks` are gitignored — never commit them.

---

## Security rules

- Never log secrets, API keys, or decrypted data in debug or production builds.
- Store sensitive keys in `flutter_secure_storage`; never in `SharedPreferences`.
- Maintain `android:allowBackup="false"` in `AndroidManifest.xml`.
- Request camera permission at point of use.

---

## Localization rules

- All user-visible text comes from `lib/l10n/*.arb` through `AppLocalizations` — never a raw string literal in a widget. This applies even though the app ships English only.
- `l10n.yaml` (project root) and `lib/l10n/app_en.arb` must exist. Run `flutter gen-l10n` after editing any `.arb` file.
- Every ARB key needs an `@key` description entry, so a future translator has context.
- Services must not hold user-visible text. They return an `AppMessage` (a key plus arguments); the screen turns it into text through `AppLocalizations`.
- Literals are allowed only for logs, non-UI exception messages, asset paths, route names, map/JSON keys, barcode protocol tokens (`BEGIN:VCARD`, `WIFI:`), and the CSV/JSON export headers that the import path reads back.

---

## Code style / naming

- Files `snake_case.dart`; classes `PascalCase`; variables/methods `camelCase`; providers `camelCase` + `Provider` suffix.
- Use `package:` imports (`package:sreeraj_qr_reader/...`), not relative imports.
- Prefer `const` constructors, `final` locals, and single quotes.
- Run `dart format .` and keep `flutter analyze` clean (0 warnings) before every commit.

---

## Testing rules

- Mirror `lib/` structure in `test/` (e.g. `test/providers/`, `test/services/`).
- Critical coverage areas: URL pattern checks, homograph attack detection, rate limiting, and `ScanProvider` state transitions.
- Mock network calls with `MockClient` from `package:http/testing.dart`.

---

## Dependency constraints

- Blocked dependencies: Analytics, crash reporting, ads, heavy state frameworks (Riverpod, Redux).
- Provider (`provider`) is the sole state management solution.
- Before adding any package: verify license, check transitive dependencies, and confirm offline friendliness.

---

## Where things live

```
CLAUDE.md            # project rules
AGENTS.md            # project rules (this file)
docs/                # project documentation & guidelines submodule
plans/               # change plans (plan-before-changing)
change_log/          # change logs (log-after-changing)
lib/                 # app source code (Tier 1 layer-first)
test/                # unit & widget test suite
tool/                # release & build scripts
```

---

## Workflow rules (mandatory — from global rules)

Every change follows plan-before-changing and log-after-changing:

1. **Plan before changing.** Write a full plan to `plans/` named `yyyymmdd_hhMMss_<short-slug>.md` with a `**Status:**` line, the files to change, the issue, and the fix. Then **STOP and get explicit approval** before editing/creating/deleting any project file (other than the plan). A question or ambiguous reply is not approval.
2. **Log after changing.** After implementing, write a change log to `change_log/` named `yyyymmdd_hhMMss_<short-slug>.md` describing what changed and referencing its plan.
3. **Relative paths & privacy only.** `plans/` and `change_log/` files are committed and may become public on the internet. They MUST use relative repository paths only (never absolute system paths with a drive letter, and never `file:///` links). They MUST NOT contain any **local system details** — OS user name, computer/host name, home or drive-letter paths, network share names, LAN/internal IP addresses, local server URLs with ports, device serial numbers, personal email addresses — or any secret (API keys, tokens, passwords, keystore passphrases, credentials, PII). Write them as if a stranger will read them; nothing should reveal the machine they came from.

Create `plans/` and `change_log/` if they do not exist.

---

## Communication rules

- **Always use simple English.** Write all responses, plans, change logs, and explanations in plain, simple English. Short sentences, common words. Explain any jargon you must use.

---

## What AI agents must always / never do

**Always:**
- Read `AGENTS.md` first before starting work.
- State the target layer (`models`, `providers`, `services`, `screens`) before adding a class.
- Run `flutter analyze` and `flutter test` after changes.
- Keep `main.dart` thin (initialization, Provider setup, routes only).

**Never:**
- Hard-code user-visible text in a widget — it belongs in `lib/l10n/app_en.arb`.
- Put business logic or HTTP calls in widgets.
- Store sensitive keys in `SharedPreferences`.
- Add blocked dependencies or alternative state management packages.
- Log API keys or sensitive data.
