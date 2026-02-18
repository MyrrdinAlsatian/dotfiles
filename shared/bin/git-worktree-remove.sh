#!/usr/bin/env bash
set -euo pipefail

# --------------------------------------------------
# Generic Git Worktree Remove Script
# --------------------------------------------------

usage() {
  echo "Usage: $0 <branch-name> [--force]"
  echo ""
  echo "Removes a git worktree and cleans up the directory."
  echo ""
  echo "Options:"
  echo "  --force       Force removal even if worktree has uncommitted changes"
  echo ""
  exit 1
}

# --------------------------------------------------
# Argument parsing
# --------------------------------------------------

if [[ $# -lt 1 ]]; then
  usage
fi

BRANCH_NAME="$1"
shift

FORCE_REMOVE=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --force)
      FORCE_REMOVE=true
      ;;
    *)
      usage
      ;;
  esac
  shift
done

# --------------------------------------------------
# Repo resolution
# --------------------------------------------------

REPO_ROOT="$(git rev-parse --show-toplevel)"
REPO_NAME="$(basename "$REPO_ROOT")"
PARENT_DIR="$(dirname "$REPO_ROOT")"

DIR_SUFFIX="${BRANCH_NAME//\//-}"
WORKTREE_PATH="$PARENT_DIR/${REPO_NAME}-${DIR_SUFFIX}"

echo "=== Git Worktree Remove ==="
echo "Repository: $REPO_NAME"
echo "Branch:     $BRANCH_NAME"
echo "Worktree:   $WORKTREE_PATH"
echo ""

# --------------------------------------------------
# Safety checks
# --------------------------------------------------

if [[ ! -d "$WORKTREE_PATH" ]]; then
  echo "❌ Worktree directory does not exist: $WORKTREE_PATH"
  exit 1
fi

cd "$REPO_ROOT"

# Check if this is a valid worktree
if ! git worktree list | grep -q "$WORKTREE_PATH"; then
  echo "❌ Not a valid git worktree: $WORKTREE_PATH"
  echo ""
  echo "Available worktrees:"
  git worktree list
  exit 1
fi

# --------------------------------------------------
# Check for uncommitted changes
# --------------------------------------------------

if ! $FORCE_REMOVE; then
  cd "$WORKTREE_PATH"
  
  if ! git diff-index --quiet HEAD -- 2>/dev/null; then
    echo "❌ Worktree has uncommitted changes."
    echo ""
    echo "Use --force to remove anyway, or commit/stash changes first:"
    echo "  cd $WORKTREE_PATH"
    echo "  git status"
    echo ""
    exit 1
  fi
  
  cd "$REPO_ROOT"
fi

# --------------------------------------------------
# Remove worktree
# --------------------------------------------------

echo "→ Removing worktree..."

if $FORCE_REMOVE; then
  git worktree remove --force "$WORKTREE_PATH"
else
  git worktree remove "$WORKTREE_PATH"
fi

echo "✔ Worktree removed"
echo ""

# --------------------------------------------------
# Clean up directory if it still exists
# --------------------------------------------------

if [[ -d "$WORKTREE_PATH" ]]; then
  echo "→ Cleaning up directory..."
  rm -rf "$WORKTREE_PATH"
  echo "✔ Directory cleaned up"
  echo ""
fi

# --------------------------------------------------
# Prune worktree metadata
# --------------------------------------------------

echo "→ Pruning worktree metadata..."
git worktree prune
echo "✔ Metadata pruned"
echo ""

# --------------------------------------------------
# Done
# --------------------------------------------------

echo "=== Removal Complete ==="
echo "Worktree removed: $WORKTREE_PATH"
echo ""
echo "Remaining worktrees:"
git worktree list
echo ""
