# Changelog

All notable changes to this project are documented here.
Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), versions follow [SemVer](https://semver.org/).

## [Unreleased]

### Added

- Templates are English-only (`templates/PROJECT.md`, `templates/PLAN.md`).
- Two rules files: `AGENTS.md` (English, default) and `AGENTS.zh-CN.md` (Simplified Chinese), kept in sync.
- `install.sh --lang en|zh-CN`: picks the symlink target; without the flag it reads `LC_ALL`/`LANG`.
- `install.sh`: installs this repo into a project as a git submodule (`.agent-kit`), links `AGENTS.md` to it, creates `PROJECT.md` from the template, and ignores `*.local.md`. Supports `--link` (local symlink install), `--url`, `--dry-run`, `--force`.
- `templates/PROJECT.md`: project-specific rules skeleton, replacing `templates/project-AGENTS.md`.
- `templates/PLAN.md`: single plan file for larger changes (draft, confirm, tick off item by item, delete when done).
- `AGENTS.md`: section on environment prerequisites and bootstrap skills.
- `AGENTS.md`: rule routing for repeated mistakes — universal rules here, project rules in `PROJECT.md`, machine-local notes in `AGENTS.local.md`.

### Changed

- Rules ship per project as a clone instead of a global file: each project keeps its own copy under `.agent-kit` (git-ignored) and updates with `make pull`.
- Dropped the global sync script and its targets; `install.sh` is the only entry point.
- `AGENTS.md`: project content now goes to `PROJECT.md` (the project's `AGENTS.md` is a symlink to the rules source).

## [1.0.0] - 2026-10-21

### Added

- Single-source `AGENTS.md` covering workflow, permissions, commits and branches, design principles, code, database, naming, comments, docs, frontend, security, observability, verification, language.
