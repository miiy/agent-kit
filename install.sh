#!/usr/bin/env bash
# Install agent-kit into a project as a plain clone, symlink AGENTS.md to it, and keep it out of git.
#
# What it does, in order:
#   1. git clone <url> <project>/.agent-kit
#   2. links <project>/AGENTS.md -> .agent-kit/AGENTS.md (loaded by Codex, Claude Code, DSH)
#   3. creates <project>/PROJECT.md from templates/PROJECT.md when missing
#   4. appends .agent-kit/ and *.local.md to <project>/.gitignore
#
# Usage:
#   ./install.sh /path/to/project                     # clone mode, url from this repo's origin
#   ./install.sh --url <git-url> /path/to/project
#   ./install.sh --link /path/to/project              # symlink to this checkout instead of cloning
#   ./install.sh --submodule /path/to/project         # git submodule instead of a plain clone
#   ./install.sh --lang zh-CN /path/to/project        # rules language (en | zh-CN)
#   ./install.sh --dry-run [dir] / --force [dir]
#
# Language: --lang wins, otherwise detected from LC_ALL/LANG (zh* -> zh-CN), default en.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODE="clone"
URL=""
LANG_OPT=""
DRY=0
FORCE=0
TARGET=""

while [ $# -gt 0 ]; do
  case "$1" in
    --url) URL="${2:-}"; shift 2 ;;
    --lang) LANG_OPT="${2:-}"; shift 2 ;;
    --clone) MODE="clone"; shift ;;
    --link) MODE="link"; shift ;;
    --submodule) MODE="submodule"; shift ;;
    --dry-run) DRY=1; shift ;;
    --force) FORCE=1; shift ;;
    -*) echo "unknown option: $1" >&2; exit 2 ;;
    *) TARGET="$1"; shift ;;
  esac
done
TARGET="${TARGET:-$PWD}"
[ -d "$TARGET" ] || { echo "target is not a directory: $TARGET" >&2; exit 1; }
TARGET="$(cd "$TARGET" && pwd)"

# resolve rules language: --lang, else environment, else en
if [ -z "$LANG_OPT" ]; then
  case "${LC_ALL:-${LANG:-}}" in
    zh*|*zh_CN*|*zh-CN*) LANG_OPT="zh-CN" ;;
    *) LANG_OPT="en" ;;
  esac
fi
case "$LANG_OPT" in
  en) RULES="AGENTS.md" ;;
  zh-CN|zh-cn|zh) LANG_OPT="zh-CN"; RULES="AGENTS.zh-CN.md" ;;
  *) echo "unsupported language: $LANG_OPT (use en or zh-CN)" >&2; exit 2 ;;
esac

KIT="$TARGET/.agent-kit"
AGENTS="$TARGET/AGENTS.md"
PROJECT="$TARGET/PROJECT.md"
GITIGNORE="$TARGET/.gitignore"

run() {
  if [ "$DRY" -eq 1 ]; then echo "[dry-run] $*"; else eval "$@"; fi
}
say() {
  if [ "$DRY" -eq 1 ]; then echo "[dry-run] $*"; else echo "$*"; fi
}

echo "kind:   $MODE"
echo "lang:   $LANG_OPT ($RULES)"
echo "target: $TARGET"
echo

if [ -z "$URL" ]; then
  URL="$(git -C "$REPO_DIR" remote get-url origin 2>/dev/null || true)"
fi

# 1) bring the kit in
case "$MODE" in
  clone)
    if [ -d "$KIT/.git" ]; then
      say "skip: .agent-kit already cloned"
    elif [ -e "$KIT" ]; then
      echo "error: $KIT exists and is not a git clone" >&2; exit 1
    else
      [ -n "$URL" ] || { echo "error: no url; pass --url <git-url> or add an origin remote to $REPO_DIR" >&2; exit 1; }
      echo "url:    $URL"
      run "git clone -q '$URL' '$KIT'"
      say "cloned: .agent-kit <- $URL"
    fi
    ;;
  submodule)
    [ -d "$TARGET/.git" ] || { echo "error: $TARGET is not a git repo; a submodule needs one" >&2; exit 1; }
    if git -C "$TARGET" submodule status .agent-kit >/dev/null 2>&1; then
      say "skip: submodule .agent-kit already present"
    else
      [ -n "$URL" ] || { echo "error: no url; pass --url <git-url> or add an origin remote to $REPO_DIR" >&2; exit 1; }
      echo "url:    $URL"
      if [ "${URL#/}" != "$URL" ] || [ "${URL#file:}" != "$URL" ]; then
        run "git -C '$TARGET' -c protocol.file.allow=always submodule add -q '$URL' .agent-kit"
      else
        run "git -C '$TARGET' submodule add -q '$URL' .agent-kit"
      fi
      say "added:  .agent-kit (submodule)"
    fi
    ;;
  link)
    if [ -L "$KIT" ]; then
      if [ "$(readlink "$KIT")" = "$REPO_DIR" ]; then say "skip: .agent-kit already linked"
      else run "rm '$KIT'"; run "ln -s '$REPO_DIR' '$KIT'"; say "relinked: .agent-kit"; fi
    elif [ -e "$KIT" ]; then
      echo "error: $KIT exists and is not a symlink" >&2; exit 1
    else
      run "ln -s '$REPO_DIR' '$KIT'"; say "linked: .agent-kit -> $REPO_DIR"
    fi
    ;;
esac

# 2) link AGENTS.md
if [ -L "$AGENTS" ]; then
  if [ "$(readlink "$AGENTS")" = ".agent-kit/$RULES" ]; then
    say "skip: AGENTS.md already linked"
  else
    run "rm '$AGENTS'"; run "ln -s '.agent-kit/$RULES' '$AGENTS'"; say "relinked: AGENTS.md -> .agent-kit/$RULES"
  fi
elif [ -e "$AGENTS" ]; then
  if [ "$FORCE" -eq 1 ]; then
    backup="$AGENTS.bak.$(date +%Y%m%d-%H%M%S)"
    say "backup: AGENTS.md -> $(basename "$backup")"
    run "mv '$AGENTS' '$backup'"
    run "ln -s '.agent-kit/$RULES' '$AGENTS'"
    say "note:   merge the backed-up rules into PROJECT.md"
  else
    echo "warn:   AGENTS.md exists as a real file, left untouched."
    echo "        move project rules into PROJECT.md, then re-run with --force."
  fi
else
  run "ln -s '.agent-kit/$RULES' '$AGENTS'"
  say "linked: AGENTS.md -> .agent-kit/$RULES"
fi

# 3) PROJECT.md
if [ -e "$PROJECT" ]; then
  say "skip: PROJECT.md exists"
else
  run "cp '$REPO_DIR/templates/PROJECT.md' '$PROJECT'"
  say "created: PROJECT.md"
fi

# 4) .gitignore
if [ "$MODE" = "clone" ]; then
  entries=(".agent-kit/" "AGENTS.local.md" "CLAUDE.local.md")
else
  entries=("AGENTS.local.md" "CLAUDE.local.md")
fi
if [ "$DRY" -eq 1 ]; then
  echo "[dry-run] would append to .gitignore: ${entries[*]}"
else
  touch "$GITIGNORE"
  for e in "${entries[@]}"; do
    grep -qxF "$e" "$GITIGNORE" || printf '%s\n' "$e" >> "$GITIGNORE"
  done
  echo "gitignore: ${entries[*]}"
fi

echo
echo "next:"
if [ "$MODE" = "clone" ]; then
  echo "  commit AGENTS.md PROJECT.md .gitignore   (never add .agent-kit)"
  echo "  update later: git -C .agent-kit pull"
elif [ "$MODE" = "submodule" ]; then
  echo "  git add .gitmodules .agent-kit AGENTS.md PROJECT.md .gitignore && git commit"
else
  echo "  commit AGENTS.md PROJECT.md .gitignore"
fi
echo
echo "note: AGENTS.md is a symlink into .agent-kit. Edit PROJECT.md, never AGENTS.md,"
echo "      or you will modify the shared rules for every project."
