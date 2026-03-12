#!/usr/bin/env bash
# _wt-lib.sh — Shared library for wt scripts.
# Source this file in wt scripts: source "$(dirname "$0")/_wt-lib.sh"

# --------------------------------------------------
# Colors (only when stdout is a terminal)
# --------------------------------------------------

if [[ -t 1 ]]; then
  RED=$(tput setaf 1 2>/dev/null || printf '')
  GREEN=$(tput setaf 2 2>/dev/null || printf '')
  YELLOW=$(tput setaf 3 2>/dev/null || printf '')
  BLUE=$(tput setaf 4 2>/dev/null || printf '')
  BOLD=$(tput bold 2>/dev/null || printf '')
  RESET=$(tput sgr0 2>/dev/null || printf '')
else
  RED='' GREEN='' YELLOW='' BLUE='' BOLD='' RESET=''
fi

# --------------------------------------------------
# Logging helpers
# --------------------------------------------------

info()    { echo "${BLUE}INFO${RESET}    $*"; }
success() { echo "${GREEN}SUCCESS${RESET} $*"; }
warn()    { echo "${YELLOW}WARNING${RESET} $*"; }
error()   { echo "${RED}ERROR${RESET}   $*" >&2; }
step()    { echo "${BOLD}→${RESET} $*"; }

# --------------------------------------------------
# Git helpers
# --------------------------------------------------

# Print the repository root or exit with an error.
get_repo_root() {
  local root
  root=$(git rev-parse --show-toplevel 2>/dev/null) || {
    error "Not inside a git repository."
    exit 1
  }
  echo "$root"
}

# Resolve the worktree path for a given branch name.
# Worktrees live in <repo-root>/.worktrees/<branch-safe-name>
# so that they stay close to the project without polluting the parent dir.
get_worktree_path() {
  local branch_name="$1"
  local repo_root="$2"
  local safe="${branch_name//\//-}"
  echo "$repo_root/.worktrees/$safe"
}

# Ensure .worktrees/ is excluded from git tracking via .git/info/exclude.
ensure_worktrees_excluded() {
  local repo_root="$1"
  local exclude_file="$repo_root/.git/info/exclude"
  if [[ -f "$exclude_file" ]] && ! grep -qxF '.worktrees/' "$exclude_file"; then
    echo '.worktrees/' >> "$exclude_file"
  fi
}

# Check whether a branch exists locally.
branch_exists_locally() {
  git show-ref --verify --quiet "refs/heads/$1"
}

# Check whether a branch exists on origin.
branch_exists_on_origin() {
  git ls-remote --exit-code --heads origin "$1" &>/dev/null
}

# Return the default branch (main or master).
get_default_branch() {
  if git show-ref --verify --quiet refs/heads/main; then
    echo "main"
  elif git show-ref --verify --quiet refs/heads/master; then
    echo "master"
  else
    git rev-parse --abbrev-ref HEAD
  fi
}
