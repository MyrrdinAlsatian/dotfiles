.PHONY: help link unlink update install clean

# Default target
help:
	@echo "Dotfiles Management with GNU Stow"
	@echo ""
	@echo "Available targets:"
	@echo "  help     - Show this help message"
	@echo "  install  - Install all dotfiles (symlink to home directory)"
	@echo "  link     - Alias for install"
	@echo "  unlink   - Remove all symlinks"
	@echo "  update   - Update dotfiles from repository"
	@echo "  clean    - Remove broken symlinks"
	@echo ""
	@echo "Individual package targets:"
	@echo "  link-git       - Install git configuration"
	@echo "  link-zsh       - Install zsh configuration"
	@echo "  link-tmux      - Install tmux configuration"
	@echo "  link-starship  - Install starship configuration"
	@echo "  link-ssh       - Install ssh configuration"
	@echo ""
	@echo "Usage examples:"
	@echo "  make install          # Install all configurations"
	@echo "  make link-git         # Install only git config"
	@echo "  make unlink           # Remove all symlinks"
	@echo "  make update           # Pull latest changes and reinstall"

# Install all packages
install: link

link:
	@echo "Installing dotfiles..."
	@stow -v -t ${HOME} git
	@stow -v -t ${HOME} zsh
	@stow -v -t ${HOME} tmux
	@stow -v -t ${HOME} starship
	@mkdir -p ${HOME}/.ssh
	@stow -v -t ${HOME}/.ssh ssh
	@chmod 600 ${HOME}/.ssh/config 2>/dev/null || true
	@echo "✓ Dotfiles installed successfully!"

# Uninstall all packages
unlink:
	@echo "Removing dotfiles..."
	@stow -v -D -t ${HOME} git 2>/dev/null || true
	@stow -v -D -t ${HOME} zsh 2>/dev/null || true
	@stow -v -D -t ${HOME} tmux 2>/dev/null || true
	@stow -v -D -t ${HOME} starship 2>/dev/null || true
	@stow -v -D -t ${HOME}/.ssh ssh 2>/dev/null || true
	@echo "✓ Dotfiles removed successfully!"

# Update dotfiles from repository
update:
	@echo "Updating dotfiles from repository..."
	@git pull origin main
	@echo "Re-installing dotfiles..."
	@$(MAKE) unlink
	@$(MAKE) link
	@echo "✓ Dotfiles updated successfully!"

# Clean broken symlinks
clean:
	@echo "Cleaning broken symlinks in home directory..."
	@find ${HOME} -maxdepth 1 -type l ! -exec test -e {} \; -delete 2>/dev/null || true
	@echo "✓ Cleanup complete!"

# Individual package targets
link-git:
	@stow -v -t ${HOME} git
	@echo "✓ Git configuration installed!"

link-zsh:
	@stow -v -t ${HOME} zsh
	@echo "✓ Zsh configuration installed!"

link-tmux:
	@stow -v -t ${HOME} tmux
	@echo "✓ Tmux configuration installed!"

link-starship:
	@stow -v -t ${HOME} starship
	@echo "✓ Starship configuration installed!"

link-ssh:
	@mkdir -p ${HOME}/.ssh
	@stow -v -t ${HOME}/.ssh ssh
	@chmod 600 ${HOME}/.ssh/config 2>/dev/null || true
	@echo "✓ SSH configuration installed!"

unlink-git:
	@stow -v -D -t ${HOME} git
	@echo "✓ Git configuration removed!"

unlink-zsh:
	@stow -v -D -t ${HOME} zsh
	@echo "✓ Zsh configuration removed!"

unlink-tmux:
	@stow -v -D -t ${HOME} tmux
	@echo "✓ Tmux configuration removed!"

unlink-starship:
	@stow -v -D -t ${HOME} starship
	@echo "✓ Starship configuration removed!"

unlink-ssh:
	@stow -v -D -t ${HOME}/.ssh ssh
	@echo "✓ SSH configuration removed!"
