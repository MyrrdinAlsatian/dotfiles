# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# export DOTFILES="$HOME/dotfiles"
# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

plugins=(git nvm symfony6)

source $ZSH/oh-my-zsh.sh
source <(docker completion zsh)
source ~/.nvm/nvm.sh

# if [ -d "$DOTFILES/zsh/completion" ]; then
#     # Charger le fichier de complétion de Scalingo
#     source "$DOTFILES/zsh/completion/scalingo_complete.zsh"
# else
#     echo "Le répertoire de complétion Scalingo n'a pas été trouvé."
# fi

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
