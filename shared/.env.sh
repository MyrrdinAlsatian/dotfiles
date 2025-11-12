#!/bin/bash
# Main environment loader - sources all shared configuration files
# Source this file from your .bashrc or .zshrc

# Get the directory where this script is located
SHARED_DIR="${HOME}/.dotfiles/shared"

# Alternative: If dotfiles are symlinked, find the real path
if [ -L "${BASH_SOURCE[0]:-${(%):-%x}}" ]; then
    SHARED_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]:-${(%):-%x}}")")"
fi

# Function to safely source a file if it exists
source_if_exists() {
    if [ -f "$1" ]; then
        # shellcheck disable=SC1090
        source "$1"
    fi
}

# Load exports first (environment variables)
source_if_exists "$SHARED_DIR/.exports"

# Load functions next (may be used in aliases)
source_if_exists "$SHARED_DIR/.functions"

# Load aliases last
source_if_exists "$SHARED_DIR/.aliases"

# Load local overrides if they exist (not tracked by git)
source_if_exists "$SHARED_DIR/.local"

# Make shared directory available for other scripts
export DOTFILES_SHARED_DIR="$SHARED_DIR"
