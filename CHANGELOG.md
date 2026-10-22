# Changelog

All notable changes to this project are documented here.
Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), versions follow [SemVer](https://semver.org/).
Still in development: everything sits under Unreleased until the first `vX.Y.Z` tag.

## [Unreleased]

### Added

- `AGENTS.md` (English, default) and `AGENTS.zh-CN.md` (Simplified Chinese): one ruleset in two languages, sections kept in sync — core points, environment and skills, workflow, session startup and memory, permissions and commits, design principles, code principles, database, naming and structure, comments and formatting, documents, frontend, data and config and security, logging and observability, verification and testing, language and expression, pre-commit checklist.
- Rule routing: universal rules in `AGENTS.md`, project rules in the project's `PROJECT.md`, machine-local notes in `AGENTS.local.md`; a third-party skill's steps lose to these rules, and a skill that writes `AGENTS.md` or `CLAUDE.md` writes `PROJECT.md`.
- `install.sh`: clones this repo into a project as `.agent-kit` and links `AGENTS.md` to the rules file matching the language, so Codex, Claude Code and DeepSeek Harness load the same rules. `--link` symlinks this checkout instead of cloning, `--submodule` installs as a submodule, plus `--url`, `--lang en|zh-CN`, `--dry-run` and `--force`. Creates `PROJECT.md` from the template and adds `.agent-kit/` and `*.local.md` to the project's `.gitignore`.
- `templates/PROJECT.md`: skeleton for project-specific rules.
- `templates/PLAN.md`: single plan file for larger changes (draft, confirm, tick off item by item, fold into docs and delete).
- `Makefile`: single entry point — `install`, `install-local`, `install-submodule`, `install-dry`, `pull`, `tag`, `clean`.
