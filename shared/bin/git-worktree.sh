#!/usr/bin/env bash
# git-worktree.sh — Legacy wrapper. Use 'wt-create' or 'wt create' instead.
# Kept for backward compatibility.
# The --new flag is accepted but ignored (wt-create auto-detects branch state).

set -euo pipefail

usage() {
  echo "Usage: $0 <branch-name> [--new] [--no-install]"
  echo ""
  echo "Deprecated: use 'wt-create <branch> [--no-install]' instead."
  echo "The --new flag is no longer needed; branches are auto-detected."
  echo ""
  exit 1
}

if [[ $# -lt 1 ]]; then
  usage
fi

BRANCH_NAME="$1"
shift

FORWARD_ARGS=("$BRANCH_NAME")

while [[ $# -gt 0 ]]; do
  case "$1" in
    --new)        ;;   # silently ignored; wt-create auto-detects
    --no-install) FORWARD_ARGS+=(--no-install) ;;
    *)            usage ;;
  esac
  shift
done

exec "$(dirname "$0")/wt-create" "${FORWARD_ARGS[@]}"
