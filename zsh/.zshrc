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

# Aliases
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gco='git checkout'

# Load Starship prompt if available
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# Load additional configurations if they exist
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
