# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Editor
export EDITOR=nvim
export VISUAL=nvim

# Prompt
PROMPT="%F{blue}%n%f %F{cyan}%~%f %F{magenta}❯%f "

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

# Add in snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# Keybindings
bindkey -e
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
bindkey '^[w' kill-region
bindkey '^ ' autosuggest-accept

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no

# Alias
alias du='dust'
alias cat='bat'
alias ip='ip -c'
alias l='lsd -1'
alias ls='lsd --group-directories-first'
alias ll='lsd -l --group-directories-first'
alias la='lsd -la --group-directories-first'
alias vim='nvim'
alias nvi='nvim'
alias nivm='nvim'
alias c='clear'
alias bt="bluetuith"
alias gitl='git log --oneline --graph --all --decorate --color'
alias xc='xclip -selection clipboard'
alias c2c='~/.config/scripts/code2clip.sh'
alias q='exit'
alias :q='exit'
alias kys='dotnet'
alias kms='dotnet-test-sorted'
alias dcu='docker-compose up'
alias dcd='docker-compose down'
alias de='docker exec'
alias dp='docker ps'

dotnet-test-sorted() {
  local output=$(dotnet test 2>&1)
  
  local sorted_tests=$(echo "$output" | grep -E '\[xUnit\.net' | \
    perl -e 'print sort { ($a =~ /T(\d+)_/)[0] <=> ($b =~ /T(\d+)_/)[0] } <>')
  
  if [[ -n "$sorted_tests" ]]; then
    echo "$sorted_tests" | bat -l log --paging=never
  fi
  
  echo "$output" | grep -E 'Test Run|Passed:|Failed:|Skipped:|Total tests:' | tail -5
}

nmtui() {
  (unset COLORTERM; TERM=xterm-old command nmtui "$@")
}

# Shell integrations
eval "$(zoxide init --cmd cd zsh)"
. "/home/nomi/.deno/env"

# Disable microshit telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1

