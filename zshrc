# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

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

# Paths
PATH="$PATH:/home/achintya/.local/bin"

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
