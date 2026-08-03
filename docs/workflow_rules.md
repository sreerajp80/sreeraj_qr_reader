# Workflow Rules — Sreeraj P QR Reader

This document defines the mandatory workflow rules for developing, modifying, and maintaining the Sreeraj P QR Reader application. Read this before making any code or configuration changes.

**Read first:**
- [CLAUDE.md](../CLAUDE.md)
- [GUIDELINES_MANIFEST.md](GUIDELINES_MANIFEST.md)
- [guidelines/flutter_project_engineering_standard.md](guidelines/flutter_project_engineering_standard.md)

---

## 1. Plan Before Changing

Before making any non-trivial change, refactoring, or feature addition, write a detailed plan to a new file under `plans/`.

- Naming format: `plans/yyyymmdd_hhMMss_<short-slug>.md`
- The plan must state:
  - Header with `**Status:** Draft`
  - The problem or goal statement
  - Files to be modified, created, or deleted
  - Architectural impact and testing strategy

---

## 2. Explicit User Approval Gate

> **STOP:** You must stop and wait for explicit approval from the user before modifying, creating, or deleting any project file (other than the plan file itself).

- A question, suggestion, or ambiguous response from the user does **not** constitute approval.
- Once approved, update the plan's status line to `**Status:** Approved` before implementing.

---

## 3. Log After Changing

After completing implementation and verifying changes:

- Write a change log entry under `change_log/`.
- Naming format: `change_log/yyyymmdd_hhMMss_<short-slug>.md`
- Include:
  - Reference to the corresponding plan file
  - Detailed summary of changes made
  - Verification results (`flutter analyze`, `flutter test`)
