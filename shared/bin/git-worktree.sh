#!/usr/bin/env bash
set -euo pipefail

# --------------------------------------------------
# Generic Git Worktree Setup Script
# --------------------------------------------------

usage() {
  echo "Usage: $0 <branch-name> [--new] [--no-install]"
  echo ""
  echo "Creates a git worktree and optionally installs dependencies."
  echo ""
  echo "Options:"
  echo "  --new         Create a new branch from current HEAD"
  echo "  --no-install  Skip dependency installation"
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

NEW_BRANCH=false
INSTALL_DEPS=true

while [[ $# -gt 0 ]]; do
  case "$1" in
    --new)
      NEW_BRANCH=true
      ;;
    --no-install)
      INSTALL_DEPS=false
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

echo "=== Git Worktree Setup ==="
echo "Repository: $REPO_NAME"
echo "Branch:     $BRANCH_NAME"
echo "Worktree:   $WORKTREE_PATH"
echo ""

# --------------------------------------------------
# Safety checks
# --------------------------------------------------

if [[ -d "$WORKTREE_PATH" ]]; then
  echo "❌ Directory already exists: $WORKTREE_PATH"
  exit 1
fi

cd "$REPO_ROOT"

# --------------------------------------------------
# Create worktree
# --------------------------------------------------

echo "→ Creating worktree..."

if $NEW_BRANCH; then
  git worktree add -b "$BRANCH_NAME" "$WORKTREE_PATH"
else
  git worktree add "$WORKTREE_PATH" "$BRANCH_NAME"
fi

echo "✔ Worktree created"
echo ""

cd "$WORKTREE_PATH"

# --------------------------------------------------
# Install dependencies (auto-detect)
# --------------------------------------------------

if $INSTALL_DEPS; then
  echo "→ Installing dependencies..."

  if [[ -f "pnpm-lock.yaml" ]]; then
    pnpm install
  elif [[ -f "yarn.lock" ]]; then
    yarn install
  elif [[ -f "package-lock.json" ]]; then
    npm install
  elif [[ -f "composer.json" ]]; then
    composer install
  elif [[ -f "go.mod" ]]; then
    go mod download
  else
    echo "⚠ No known dependency manager detected."
  fi

  echo "✔ Dependencies installed"
  echo ""
fi

# --------------------------------------------------
# Auto copy .env.example files
# --------------------------------------------------

echo "→ Setting up environment files..."

find . -type f -name ".env.example" | while read -r file; do
  target="${file%.example}"
  if [[ ! -f "$target" ]]; then
    cp "$file" "$target"
    echo "  ✔ Created $target"
  fi
done

echo ""

# --------------------------------------------------
# Optional project hook
# `docker compose up -b`, ...
# --------------------------------------------------

if [[ -f ".worktree-setup.sh" ]]; then
  echo "→ Running project hook (.worktree-setup.sh)"
  bash .worktree-setup.sh
  echo ""
fi

# --------------------------------------------------
# Done
# --------------------------------------------------

echo "=== Setup Complete ==="
echo "Worktree ready at:"
echo "  $WORKTREE_PATH"
echo ""
echo "Next:"
echo "  cd $WORKTREE_PATH"
echo ""
