# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="gnzh"

plugins=(
  git 
  zsh-syntax-highlighting 
  zsh-autosuggestions
  zsh-vi-mode
)

source $ZSH/oh-my-zsh.sh

# Example aliases
alias la="eza -la --color=always --group-directories-first --icons --no-permissions --no-time --no-user"
alias lt="eza -aT --color=always --group-directories-first --icons"
alias ls="eza -l --color=always --group-directories-first --icons"
alias ll="eza --color=always --group-directories-first --icons" 

alias ddb="cloud-sql-proxy aftershoot-co:us-central1:profile-manager-test -p 1234"
alias pdb="cloud-sql-proxy aftershoot-co:us-central1:editing-uploader -p 2345"

# Paths
PATH="$PATH:/home/achintya/.local/bin"
PATH="$PATH:/home/achintya/go/bin"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
eval "$(atuin init zsh)"
export PATH="/home/achintya/Downloads:$PATH"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
