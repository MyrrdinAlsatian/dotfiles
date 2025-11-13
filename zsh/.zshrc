# Path to your oh-my-zsh installation.
# export ZSH="$HOME/.oh-my-zsh"

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# Completion system
autoload -Uz compinit
compinit

# Enable colors
autoload -U colors && colors

# Load shared configuration (aliases, exports, functions)
if [ -f ~/.dotfiles/shared/.env.sh ]; then
    source ~/.dotfiles/shared/.env.sh
elif [ -f ~/dotfiles/shared/.env.sh ]; then
    source ~/dotfiles/shared/.env.sh
fi

# Load Starship prompt if available
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# Load additional configurations if they exist
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
