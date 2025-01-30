zoxide init fish | source
starship init fish | source

fish_vi_key_bindings

set fish_vi_force_cursor line

# Emulates vim's cursor shape behavior
# Set the normal and visual mode cursors to a block
set fish_cursor_default block 
# Set the insert mode cursor to a line
set fish_cursor_insert line blink 
# Set the replace mode cursor to an underscore
set fish_cursor_replace_one underscore
# The following variable can be used to configure cursor shape in
# visual mode, but due to fish_cursor_default, is redundant here
set fish_cursor_visual block

set -x EDITOR "nvim"
set -x BROWSER "opera-developer"
# set -x TERM "kitty"
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

# Remove fish greeting
set fish_greeting ""

fish_add_path -g /Users/achin/.nvm/versions/node/v19.8.1/bin/

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

# Usage: envsource <path/to/env>

function envsource
  for line in (cat $argv | grep -v '^#')
    set item (string split -m 1 '=' $line)
    set -gx $item[1] $item[2]
    echo "Exported key $item[1]"
  end
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

# Changing ls to exa
alias ls="exa -la --color=always --group-directories-first --icons --no-permissions --no-time --no-user"
alias lt="exa -aT --color=always --group-directories-first --icons"
alias la="exa -l --color=always --group-directories-first --icons"
alias ll="exa -a --color=always --group-directories-first --icons"

# Confirm before overwriting
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"

# atuin
atuin init fish | source

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

alias pdb="sudo cloud-sql-proxy aftershoot-co:us-central1:editing-uploader -p 2345"
alias ddb="sudo cloud-sql-proxy aftershoot-stage:us-central1:aftershoot-stage-db -p 1234"
alias rpdb="sudo cloud-sql-proxy aftershoot-co:us-central1:profile-manager-test -p 2205"

alias plog="gcloud beta run services logs tail --project=aftershoot-co --region=us-central1"
alias slog="gcloud beta run services logs tail --project=aftershoot-stage --region=us-central1"

alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

eval "$(/opt/homebrew/bin/brew shellenv)"

# pnpm
set -gx PNPM_HOME "/Users/achin/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/achin/Downloads/Softwares/google-cloud-sdk/path.fish.inc' ]; . '/Users/achin/Downloads/Softwares/google-cloud-sdk/path.fish.inc'; end
