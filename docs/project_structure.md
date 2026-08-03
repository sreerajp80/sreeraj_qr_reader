# Project Structure — Sreeraj P QR Reader

This document describes the directory tree layout and responsibility mapping of the Sreeraj P QR Reader repository. Read this for quick orientation on file locations.

**Read first:**
- [CLAUDE.md](../CLAUDE.md)
- [architecture.md](architecture.md)

---

## 1. Directory Tree Layout

```text
sreeraj_qr_reader/
|-- .github/
|   `-- workflows/
|       `-- ci.yml                   # GitHub Actions CI workflow
|-- android/                         # Android native project files
|   |-- app/
|   |   |-- build.gradle             # App-level build config (flavors: dev, prod)
|   |   `-- src/
|   |       |-- dev/                 # Dev flavor manifest and resources
|   |       |-- main/                # Main Android manifest and resources
|   |       `-- prod/                # Prod flavor manifest and resources
|   |-- build.gradle                 # Project-level build config
|   `-- key.properties               # Release signing keys (gitignored)
|-- assets/                          # App branding and static assets
|   |-- config/
|   |   `-- app_config.json          # About screen data (single source of truth)
|   `-- app_icon.png
|-- change_log/                      # Completed change log records
|-- docs/                            # Project baseline & living documentation
|   |-- guidelines/                  # Shared Flutter Guidelines (Git Submodule)
|   |-- architecture.md              # Technical design and architecture
|   |-- dependencies.md              # Approved baseline packages and constraints
|   |-- GUIDELINES_MANIFEST.md       # Shared guidelines manifest
|   |-- implementation_plan.md       # Build roadmap (point-in-time)
|   |-- implementation_progress.md   # Live status checklist (point-in-time)
|   |-- project_structure.md         # File tree layout and responsibilities
|   |-- release_process.md           # Keystore signing and release runbook
|   |-- security.md                  # Threat model, permissions, and security
|   `-- workflow_rules.md            # Plan, approval, and log workflow rules
|-- lib/                             # Application Dart source (Tier 1 layer-first)
|   |-- core/
|   |   |-- config/
|   |   |   |-- app_config.dart      # AppConfig model & fallback
|   |   |   `-- config_service.dart  # Config asset loader
|   |   `-- constants/
|   |       `-- app_constants.dart   # Technical constants
|   |-- models/
|   |   `-- safety_check_result.dart # Immutable domain models
|   |-- providers/
|   |   `-- scan_provider.dart       # Scan state & workflow coordination
|   |-- screens/
|   |   |-- about_screen.dart        # Data-driven About app & feature screen
|   |   |-- result_screen.dart       # Scan outcome & actions screen
|   |   |-- scanner_screen.dart      # Live camera scanner screen
|   |   `-- settings_screen.dart     # Safe Browsing API key settings
|   |-- services/
|   |   `-- url_safety_service.dart  # 6-check URL safety algorithms
|   `-- main.dart                    # Entry point (Provider tree, theme, routes)
|-- plans/                           # Change plans (plan-before-changing)
|-- test/                            # Unit tests mirroring lib/ structure
|   |-- core/
|   |   `-- config/
|   |       `-- app_config_test.dart
|   |-- providers/
|   |   `-- scan_provider_test.dart
|   `-- services/
|       `-- url_safety_service_test.dart
|-- tool/                            # Build helper scripts
|   `-- build_release.sh
|-- CLAUDE.md                        # Primary Claude Code project instructions
|-- pubspec.yaml                     # Flutter package manifest
`-- README.md                        # Repository overview & user guide
```

---

## 2. Directory Responsibilities

| Path | Responsibility |
|------|----------------|
| `assets/config/` | JSON source of truth for About screen metadata |
| `lib/core/config/` | `AppConfig` domain model and `ConfigService` asset loader |
| `lib/core/constants/` | Constant configurations and technical constants |
| `lib/models/` | Immutable value objects |
| `lib/providers/` | `ChangeNotifier` state handlers bridging UI and service logic |
| `lib/screens/` | Presentational UI screens |
| `lib/services/` | Stateless business logic and external integrations |
| `test/` | Automated unit and widget test suites mirroring `lib/` |
| `docs/` | Comprehensive baseline and living documentation |
