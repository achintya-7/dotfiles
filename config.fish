fish_vi_key_bindings

set fish_vi_force_cursor line

set fish_cursor_default block 
set fish_cursor_insert line blink 
set fish_cursor_replace_one underscore
set fish_cursor_visual block

set -x EDITOR "nvim"
set -x BROWSER "opera-developer"
# set -x TERM "kitty"
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

# Remove fish greeting
set fish_greeting ""

fish_add_path -m ~/.local/bin


# Functions needed for !! and !$
function __history_previous_command
  switch (commandline -t)
  case "!"
    commandline -t $history[1]; commandline -f repaint
  case "*"
    commandline -i !
  end
end

function __history_previous_command_arguments
  switch (commandline -t)
  case "!"
    commandline -t ""
    commandline -f history-token-search-backward
  case "*"
    commandline -i '$'
  end
end

# The bindings for !! and !$
if [ $fish_key_bindings = fish_vi_key_bindings ];
  bind -Minsert ! __history_previous_command
  bind -Minsert '$' __history_previous_command_arguments
else
  bind ! __history_previous_command
  bind '$' __history_previous_command_arguments
end

# Start su with fish instead of bash
function su
   command su --shell=/usr/bin/fish $argv
end

function fuckapple
  command xattr -dr com.apple.quarantine $argv
end

function f
    set -l SIGINT_RECEIVED 0
    function handle_sigint --on-signal SIGINT
        set SIGINT_RECEIVED 1
        echo "Exiting..."
    end
    set file (fzf)
    if test $SIGINT_RECEIVED -eq 0
        open $file
    end
end

# Some cusotm commands for the lols

# Changing ls to eza
alias ls="eza -la --color=always --group-directories-first --icons --no-permissions --no-time --no-user"
alias lt="eza -aT --color=always --group-directories-first --icons"
alias la="eza -l --color=always --group-directories-first --icons"
alias ll="eza -a --color=always --group-directories-first --icons"

# Confirm before overwriting
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"


# cd shortcuts
alias cd="z"
alias ..="z .."
alias ...="z ../.."
alias .4="z ../../.."
alias .5="z ../../../.."

alias snaproot="snapper -c root"
alias snaphome="snapper -c home"

# ssh
alias ssh="kitty +kitten ssh"

# Extra flags
alias tree="exa --tree"
alias vim="nvim"
alias neofetch="neofetch --source $HOME/.config/neofetch/logo.txt"
alias tl="tldr -s"

alias pdb="cloud-sql-proxy aftershoot-co:us-central1:editing-uploader -p 2345"
alias ddb="cloud-sql-proxy aftershoot-stage:us-central1:aftershoot-stage-db -p 1234"
alias rpdb="cloud-sql-proxy aftershoot-co:us-central1:profile-manager-test -p 2205"

alias plog="gcloud beta run services logs tail --project=aftershoot-co --region=us-central1"
alias slog="gcloud beta run services logs tail --project=aftershoot-stage --region=us-central1"

alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

# pnpm
set -gx PNPM_HOME "/Users/achin/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# go stuff
set -x -U GOPATH $HOME/go
fish_add_path -g ~/go/bin

# npm stuff
fish_add_path -g /Users/achintya/.nvm/versions/node/v18.16.1/bin

# softwares 
atuin init fish | source
zoxide init fish | source
starship init fish | source

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/achintya/Downloads/google-cloud-sdk/path.fish.inc' ]; . '/Users/achintya/Downloads/google-cloud-sdk/path.fish.inc'; end
