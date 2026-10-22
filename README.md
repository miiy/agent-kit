# agent-kit

[English](README.md) | [简体中文](README.zh-CN.md)

General-purpose engineering rules as a toolkit: one `AGENTS.md`, cloned into a project and read by Codex, Claude Code and DeepSeek Harness.

## What it does

- A single ruleset in `AGENTS.md`, written as short imperative bullets.
- `install.sh` clones this repo into the project as `.agent-kit` and links `AGENTS.md`, so all three tools load it.
- Project-specific rules go to `PROJECT.md`; machine-local notes go to `AGENTS.local.md`.

## Quick start

```bash
git clone https://github.com/miiy/agent-kit.git agent-kit && cd agent-kit

make install DIR=/path/to/project              # clone into the project's .agent-kit, url from origin
make install DIR=/path/to/project URL=https://github.com/miiy/agent-kit.git   # explicit url
make install DIR=/path/to/project LANG=zh-CN   # Chinese rules (English by default)
make install-dry DIR=/path/to/project          # preview only
make install-local DIR=/path/to/project        # symlink to this checkout, no clone
```

After install the project contains:

```
my-project/
├── .agent-kit/     (not committed)
├── AGENTS.md       (symlink)
├── PROJECT.md
└── .gitignore
```

Then commit:

```bash
git add AGENTS.md PROJECT.md .gitignore
git commit -m "feat: add agent-kit rules"
```

## Updating the rules

```bash
make pull DIR=/path/to/project     # same as git -C /path/to/project/.agent-kit pull
```

## Rules language

The install selects the symlink target by language; the file in the project is always `AGENTS.md`:

- `--lang en` -> links `.agent-kit/AGENTS.md` (English, default)
- `--lang zh-CN` -> links `.agent-kit/AGENTS.zh-CN.md` (Chinese)
- Without the flag, `LC_ALL`/`LANG` decides: `zh*` picks Chinese, otherwise English

Keep both files in sync.

## Layout

```
AGENTS.md                     rules source (English, default)
AGENTS.zh-CN.md               rules source (Simplified Chinese)
install.sh                    install into a project (clone, symlink, PROJECT.md, .gitignore)
templates/PROJECT.md          project-specific rules skeleton
templates/PLAN.md             plan template for larger changes
README.md / README.zh-CN.md / LICENSE / CHANGELOG.md / Makefile
```

## Contributing

1. Universal rules go to `AGENTS.md`, both language files together; project-only rules go to that project's `PROJECT.md`, not here.
2. One bullet per rule: what to do plus its boundary. No rationale, no history.
3. Title the PR per Conventional Commits, e.g. `docs(rules): reference the conventional-branch skill for branch naming`.
4. Branch as `chore/<description>` or `docs/<description>`; when the change affects installation, update `README` and `CHANGELOG` too.

**Note**: the project's `AGENTS.md` is a symlink into `.agent-kit`; editing it changes the shared rules. Put project content in `PROJECT.md`.

## License

MIT - see [LICENSE](LICENSE).
