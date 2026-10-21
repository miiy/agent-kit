# AGENTS.md

> A project's `PROJECT.md` and `AGENTS.local.md` take precedence over this file (the project's `AGENTS.md` is a symlink to this one).
> This file is a baseline you may tune per project. Change universal rules through a git PR: one PR, one kind of change, and state the motivation.
> When the rules do not cover a case: follow the project's existing conventions, and state the basis for your tradeoff.

---

## Core points

- **Plan before acting**: propose the change list and the tradeoffs, then code once confirmed.
- **One small step at a time**: implement and review in chunks.
- **Touch only what was named**: report before changing any other file.
- **No compatibility shims during development**: no legacy entry points, deprecations, dual writes or migration periods.
- **Cut over-engineering**: wrappers with no value, splitting a single-call function, abstractions for imagined scenarios — skip them.
- **One concept, one name**: rename end to end (code, DB, docs, config, file names).
- **Validate at the boundary, not everywhere**: validate and normalize once on entry, never re-check internally; required dependencies are settled in the constructor — a missing one fails there, not deeper in the code.
- **Documents state facts and contracts**: no background reasoning, no justification, no superseded plans.
- **Zero secret leakage**: keys, phone numbers and ID numbers never enter code, logs or docs.
- **Production validation and commits need approval**: no commit/push by default, no production operations; dev-environment self-testing is fine, new environments or dependencies need confirmation first.
- **Outbound actions need approval**: anything that leaves the machine (email, public post, external API write) is confirmed first; reading files and local edits are free.
- **Push shared capabilities down to a common library**, keep business projects to configuration and assembly.
- **Code, comments, scripts and READMEs are English by default.**

---

## Environment and skills

Confirm environment and skills before starting; install what is missing and verify with `skills list`.

- Prerequisites: `git`, `make`, `node`/`npx`. When installing anything, state what and why before acting.
- Restricted network (dependency installs or external calls failing): try the proxy `127.0.0.1:7890` first — usually `export http_proxy=http://127.0.0.1:7890 https_proxy=http://127.0.0.1:7890` is enough; if that still fails, ask the user whether a proxy exists.
- Skills are managed with the `skills` CLI: list `skills add <owner/repo> -l`, install `skills add <owner/repo>@<skill> -g -y`, list installed `skills list`, update `skills update`.
- Scope: install globally (`-g`) for cross-project use; install project-level when only the current project needs it, and commit `skills-lock.json`.
- Bootstrap set:
  - `agent-browser` — browser automation: scrape pages, click through forms, take screenshots, fill forms
  - `find-skills` — search for and install other skills
  - `skill-creator` — create or rework skills
  - `conventional-branch/conventional-branch@conventional-branch` — branch naming and commit conventions; docs https://skills.sh/conventional-branch/conventional-branch/conventional-branch , spec https://conventionalbranch.org
- Install on demand: `docx`, `xlsx`, `pptx`, `pdf` for Office/PDF output.
- Project-specific skills and environment dependencies belong in the project's `PROJECT.md`, never in this universal file.

---

## Workflow

- Read the project's `PROJECT.md` first (if present): it holds project-specific rules and outranks this file.
- Default flow: plan (files, tradeoffs, blast radius) → confirmation → code in steps → self-check → report which files changed and how to verify; on "stop, don't change it", stop immediately.
- **Review mode** for "review", "take a look", "audit", "advice only": read-only — list issues by severity as "file:line / problem / suggested fix"; no code, no files written, no commits; change only after an explicit "go ahead".
- For large changes (more than three files, cross-module, or spanning several sessions) write a single `PLAN.md` and wait for confirmation before coding; template at `templates/PLAN.md`.
- `PLAN.md` content: goal and scope (do / don't), file-level change list, step plan (each step verifiable), risks and rollback, verification method.
- Work through `PLAN.md` one item at a time: tick each item and add one line on what changed and how it was verified.
- When a session ends or context is lost, read `PLAN.md` before continuing; when everything is done, fold the conclusions into `docs/` or CHANGELOG and delete `PLAN.md`.
- When you fix one instance of a class of problem, sweep the whole project; do not fix only the spot that was pointed at.
- If a stated approach conflicts with industry best practice, say so directly and give the correct approach.
- When unsure, check official docs or mainstream practice instead of guessing.
- When a problem is pointed out a second time, put it into the rules right away and state which file and which entry; do not wait for a third time:
  - Applies across projects → edit this file (through a PR, one kind of change at a time)
  - Applies only to this project → write it into that project's `PROJECT.md`
  - Applies only to this machine → write it into `AGENTS.local.md` (not committed)
- Remind about a given issue once; do not repeat reminders or repeat what is already known.
- Report with raw evidence: give the command, the path and its raw output; do not paraphrase the symptom.

## Session startup and memory

- Read the project's `PROJECT.md`, `PLAN.md`, the TODO and the most recent notes before acting; reading them needs no permission.
- Write decisions and lessons to disk as they happen (`PLAN.md`, `docs/`, the rule files): a note kept "in mind" is gone when the session ends.
- Long-term notes are the user's personal context: load them only in a direct session, never in shared or multi-party contexts.

## Permissions, commits and builds

- **No commits by default**: without an explicit "commit" or "push", do not run `git commit` / `git push`.
- "Check it and commit if fine" is the authorization: self-check → confirm scope with `git status` → one-line commit message.
- Commit only the named files; never `git add` files not yet reviewed.
- Perform no operations in production (commands, config edits, service restarts, scripts). Installing tools and requesting permissions belong to the user.
- Ask before dangerous commands (`rm -rf`, `git reset --hard`, `drop table`, overwriting production config).
- Never hand-edit generated artefacts; change the generator or its config, at most run a formatter.
- Deployment, UI configuration and production verification belong to the user.
- One commit does one thing; do not mix unrelated changes.
- Commit messages follow Conventional Commits: `<type>(<scope>): <subject>`, one-line subject; type is one of `feat` / `fix` / `docs` / `style` / `refactor` / `perf` / `test` / `build` / `ci` / `chore` / `revert`; the body states the motivation and how it was verified.
- Commit messages are written in English: subject and body both, Chinese stays in conversation and documents.
- Show the commit message before committing: propose the subject (and body when needed) and wait for approval.
- Branch naming and commit conventions follow the `conventional-branch` skill (Conventional Branch + Conventional Commits); see https://skills.sh/conventional-branch/conventional-branch/conventional-branch and defer to it when it changes.
- `main` carries no prefix and is always runnable; branch off it for features and fixes, one branch for one task, delete the branch after merging.
- Rebase onto the latest `main` before merging; keep history linear, do not pile up merge commits.
- Never force-push shared branches; ask before switching branches, rebasing, resetting or deleting branches.
- Tag releases (`vX.Y.Z`) and update the CHANGELOG.
- Build, check and test go through one entry point (`make lint` / `make test` / `make build` or equivalents) so local and CI run the same command.
- Keep out of the repo what does not belong: build output, generated artefacts, local config, database files, logs, keys — exclude them in `.gitignore`.

## Design principles

- Single responsibility: a function, type or module does one thing and changes for one reason; before editing, confirm it does not own a second responsibility.
- Depend on interfaces, not implementations: layers and replaceable seams depend on abstractions, implementations are injected through the constructor rather than `new`-ed internally; swapping an implementation should not touch callers.
- Law of Demeter: talk only to direct collaborators; no `a.B().C().D()` chains — if data needs repeated forwarding, put the behaviour where it belongs.
- Boundary: interfaces exist for layer, service and replacement seams, not for hypothetical future swaps; when this conflicts with "cut over-engineering", fewer abstractions wins.

## Code principles

> "Programs must be written for people to read, and only incidentally for machines to execute." — Abelson & Sussman, *Structure and Interpretation of Computer Programs*

- No compatibility during development: no legacy entry points, no dual writes, no "migration period" — write the current implementation.
- No defensive validation: validate and normalize once on entry, never re-check internally; do not repeat checks that the framework, standard library or upstream already guarantees (trimming, nil checks, signature verification); settle every required dependency in the constructor — a missing one is a construction error, not a degraded branch further down the code — and never use zero-value or empty-struct placeholders as fallbacks. Untrusted input at the boundary still must be validated with a clear error.
- Against over-engineering: do not split a function that has a single caller; do not write pass-through wrappers; do not pre-build abstractions for imagined scenarios.
- Reuse first: existing project wrapper > mature third-party library > official SDK > writing it yourself; never pull two dependencies for the same capability.
- Layered validation: presence and format checks live in the interface contract; the business layer only normalizes and applies business rules.
- Pass only the fields you need, never a whole entity.
- Related display data comes back nested (`user{nickname, avatar}`), not flattened into `author_name` / `author_avatar`; a foreign key keeps the same noun as the entity (`user_id`).
- Do not merge statements with different meanings onto one line; one assignment per line for multi-field assignments; bind long conditions and concatenations to a variable first.
- Follow the project's existing error handling; do not borrow another module's exception type.
- Core business logic does not live in the common layer or toolkit; keep layering by responsibility.
- Do not swallow errors: wrap the context of which step failed before returning; log each error in exactly one place.

## Database

- Design schemas deliberately: fields, types, lengths, indexes and constraints follow actual needs; avoid redundant fields and useless indexes.
- Keep table and column naming consistent with the existing schema (singular/plural, underscore style).
- Write time and audit fields in code, not through library defaults; use the ORM's soft delete instead of hand-written filters.
- Fix the timestamp representation once (type, precision, timezone) and use it everywhere; do not mix int epochs with datetime values, and keep sort order and null ordering explicit.
- Document field meaning in table and column comments (SQL `comment`), not in the README.
- Query only the fields you need; list endpoints do not return body text.
- List queries must be paginated with an upper bound (default size plus maximum size); unbounded queries are forbidden.
- Index high-frequency filter and sort columns; keep the number of indexes low on write-heavy tables.
- Migrations are one-way and named in time order; never modify a migration that has shipped or run — add a new one.
- DDL changes update docs and comments together; fix data by changing code first, then a one-off script.

## Naming and structure

- One concept, one name, consistent end to end (code, DB columns, interface contracts, docs, config, file names).
- One fact, one statement: a field, its type, unit, time format, ordering and its description read the same in code, DB, API contract and docs; two places that disagree is a bug — unify every occurrence and list them.
- Naming is design: settle the name before writing what it names, and treat a vague name as an unfinished design — a wrong verb or a cut-down noun means the responsibility is still unclear; when the right name is not obvious, offer two or three candidates with the tradeoff instead of picking silently.
- Names must be self-explanatory: no arbitrary abbreviations, the caller and the responsibility must be visible; rename anything misleading.
- Unprefixed is the default form; add a qualifier only for the special case (e.g. `webXxx` only for the web side).
- One file, one job; split by domain or by task step, and do not create a file for a single small function or a single test.
- Organise directories by responsibility and domain, not by technology stack.
- Push shared capabilities into a common library; business projects configure and assemble, and keep no dead code.
- Services never call each other directly; cross-service aggregation lives in the gateway/orchestration layer, and cross-cutting concerns such as auth are handled once at the entry layer.
- Never expose auto-increment IDs externally (use slugs/hashes); store only relative keys and let the upper layer build prefixes.
- No snake_case in routes; keep route registration style consistent within a project.

## Comments and formatting

- At least one comment line per function or method (tests excluded).
- Split complex functions into regions, one comment line per region explaining what that step does.
- When code is copied or adapted from elsewhere, note the source in a comment.
- Follow the language's own conventions: Go doc comments above the declaration starting with the identifier, Python docstrings, JSDoc for JS/TS, `--` for SQL; use the standard syntax and placement, no trailing-comment piles, no decorative separators; comments in English.
- Format with the language's standard tool before finishing, generated directories excluded.
- Do not squeeze structs, literals or short functions onto a single line.

## Documents

- Write the README to open-source standards: features / quick start / installation / layout, and keep it short.
- Public docs are bilingual: English is the default (`README.md`), Chinese lives in `README.zh-CN.md`; both carry the switcher line `[English](README.md) | 简体中文` at the top and stay in sync.
- The overview goes in the README; MVP and core constraints go in the design doc.
- A design doc records only contracts and data flow (when created/updated/deleted, where it lives); implementation detail stays out.
- Documents state facts and the current decision only: no background reasoning, no justification, no superseded plans.
- Unverified items and open decisions go into the TODO; once done, remove them from the TODO and restate "not implemented" as fact.
- Docs and code stay in sync; when a doc is unclear, fix the doc first, then the code.
- Scrub code and config examples pasted into docs.
- Scripts and plans must be written to files; conclusions in chat alone do not count.
- Open-source projects provide a `LICENSE` file in the repository root and a License section in the README.
- Repositories published externally maintain a CHANGELOG with Added / Changed / Fixed, and version with SemVer.

## Frontend

- No page scrolling on desktop; adapt to the window; keep page sizes, layout and font sizes consistent.
- Use the component library and the components from its official docs; write as little custom CSS as possible.
- Layer CSS by scope (global theme / layout / component-private) and put one comment line above each region.
- Pages that need SEO are server-rendered; post-login interactive pages fetch from the API.
- Hide and show actions by permission: no edit/delete buttons for signed-out users or non-owners.
- Agree the layout before coding it: an ASCII sketch, or a standalone HTML prototype when the page is non-trivial; the prototype uses no placeholder copy and its interactions really work. Design for real device scenarios, with high-frequency actions first on mobile.
- Keep API base URLs in project config, not in DOM data attributes.
- Call APIs directly from the frontend; do not add an extra proxy layer.

## Data / config / security

- No hardcoded values: paths, ports, domains, keys and hardware specs all come from config.
- Centralise configuration: config file plus a sanitized `.example` written for production.
- Zero secret leakage: keys, accounts, phone numbers and ID numbers never enter code, logs or docs; store only hashes for duplicate detection.
- Redact logs: application logs, SQL logs and request logs all filter sensitive fields.
- Sample data uses no real phone numbers, keys or customer names.
- Take the identity from the current logged-in user; never trust a `userid`-style parameter passed in.
- Control debug and simulation endpoints with config flags; refuse to open them when config is missing.
- Operations that spend money or create live resources (orders, provisioning, renewals, refunds): dry-run by default — run the flow without calling the external API or incurring cost; execute one payment at most once and never double-charge; do not retry automatically on failure — wait for confirmation.
- Generate credentials for new resources in code and persist them; never ship a fixed default password.
- Do not create log tables that store sensitive data.
- Keep common libraries thin: leave constraints to the caller's config instead of over-judging inside the library.

## Logging and observability

- Log at task start, task end and key checkpoints; each line carries the task name and a timestamp.
- Failures raise an alert with the failure details attached.
- When debugging, print the raw response; do not truncate, summarise or prettify it.
- Every request carries a request id, traceable in both logs and responses.
- Logs are structured (JSON) with fixed fields: time / level / request_id / task / message.

## Verification and testing

- Put test code where the language and the project put it — Go's `*_test.go` beside the source, Python's `tests/`, any layout the project already has; assertions, fixtures and ad-hoc probes never live in the main entry point or production files.
- Production is read-only: do not run commands, change config, restart services or execute scripts there.
- Self-test freely in dev/local: start services, run tests, seed data, read logs — no need to wait for confirmation.
- Ask before needing an environment or adding anything: which dependencies, which containers/databases/caches, which accounts and keys, where ports and test data come from, how to clean up — state the approach, get confirmation, then proceed.
- When the environment is unavailable, fall back to static checks and state clearly what was not verified and in which environment it must be checked.
- Test the critical paths only: table-driven, explicit assertions; no `sleep` for async waits; no dependency on real external services — use stand-ins.

## Language and expression

- Code, comments, scripts and READMEs are English by default; Chinese only in conversation, Chinese docs (`.zh-CN`) and content explicitly requested in Chinese.
- Answers are short: conclusion first, details after; do not restate the request, skip pleasantries.
- When unsure, ask; do not guess and change things.

---

## Pre-commit checklist

- [ ] Only the named files changed? Any other change reported?
- [ ] Compiles / type-checks / formatting applied?
- [ ] No new compatibility layer, dead code, unused fields or unused config?
- [ ] Naming consistent with existing code; renamed everywhere it appears?
- [ ] New or changed functions commented, complex blocks split with comments?
- [ ] Docs, API docs and TODO updated?
- [ ] CHANGELOG / version bumped? (published repos)
- [ ] No sensitive data in logs?
- [ ] No generated file hand-edited?
- [ ] `git status` shows only the planned files; commit subject states in one line what changed?
