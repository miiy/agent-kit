# Changelog

All notable changes to this project are documented here.
Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), versions follow [SemVer](https://semver.org/).
Still in development: everything sits under Unreleased until the first `vX.Y.Z` tag.

## [Unreleased]

### Added

- `AGENTS.md` (English, default) and `AGENTS.zh-CN.md` (Simplified Chinese): one ruleset in two languages, sections kept in sync — core points, environment and skills, workflow, session startup and memory, permissions and commits, design principles, code principles, database, naming and structure, comments and formatting, documents, frontend, data and config and security, logging and observability, verification and testing, language and expression, before-reporting checklist.
- Rule routing: universal rules in `AGENTS.md`, project rules in the project's `PROJECT.md`, machine-local notes in `AGENTS.local.md`; a third-party skill's steps lose to these rules, and a skill that writes `AGENTS.md` or `CLAUDE.md` writes `PROJECT.md`.
- `install.sh`: clones this repo into a project as `.agent-kit` and links `AGENTS.md` to the rules file matching the language, so Codex, Claude Code and DeepSeek Harness load the same rules. `--link` symlinks this checkout instead of cloning, `--submodule` installs as a submodule, plus `--url`, `--lang en|zh-CN`, `--dry-run` and `--force`. Creates `PROJECT.md` from the template and adds `.agent-kit/` and `*.local.md` to the project's `.gitignore`.
- Pushes are the gate: push, PRs, tags and rewrites of pushed history wait for an explicit go-ahead — per action or once as a listed plan covering the task and its subagents — and the series is reviewed with `git log` and `git diff <base>...HEAD` before every push, after local commits are squashed or reworded into logical ones.
- `templates/PROJECT.md`: skeleton for project-specific rules — overview with stack, directories, ports and the proxy in use; `Agent skills` with the issue tracker, triage labels and domain-doc layout a skill asks you to record, since `AGENTS.md` is a symlink into `.agent-kit` and an edit there is lost on the next pull; `Skills` for the pack that does not apply and any standing git policy; plus forbidden paths and verification commands.
- `templates/PLAN.md`: single plan file for larger changes — session scratch holding the file-level change list, worked through one item at a time and deleted once the work lands, while what outlives the session goes to the spec and its tickets.
- `Makefile`: single entry point — `install`, `install-local`, `install-submodule`, `install-dry`, `pull`, `tag`, `clean`.

### Changed

- The rules route to the skills instead of restating them: review mode splits into a change, handed to `code-review` from the fixed point the user names, and an area or repo, listed by severity as `file:line`; a large change writes `PLAN.md` as session scratch while the spec and its tickets own behaviour and carry no file paths; a wide mechanical change runs expand, migrate, contract.
- "No compatibility code" states its premise and its single exception: while nothing is deployed with users or data, write the current implementation; a change that cannot land in one step, because it spans live data or its blast radius reaches every call site, runs expand → migrate → contract with the system working after each step.
- Proxy guidance takes the address from `AGENTS.local.md` or `PROJECT.md` and applies it as `export http_proxy=<address>`, with `127.0.0.1:7890` only as a fallback when nothing is recorded.
- One home per rule: the compatibility rule, `PLAN.md` and the machine-local note are each stated once, and `AGENTS.local.md` is marked machine-local and not committed in the header where the routing lives.
- `to-spec` / `to-tickets` / `code-review` are now deferred to by name, so a change in those skills propagates without editing this file.

### Fixed

- `skills add <owner/repo>@<skill> -y` never selected a skill: `@` is parsed as a git ref, which the CLI reports as `Source: https://github.com/mattpocock/skills.git @tdd`. Installing one skill is `skills add <owner/repo> -s <skill> -y`.
