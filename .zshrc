# =============================================================================
# ~/.zshrc
# =============================================================================

# -----------------------------------------------------------------------------
# Homebrew
# -----------------------------------------------------------------------------
eval "$(/opt/homebrew/bin/brew shellenv)"

# -----------------------------------------------------------------------------
# Completions (must be before compinit)
# -----------------------------------------------------------------------------
fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
autoload -Uz compinit && compinit

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}=A-Z'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' description format '%F{yellow}-- %d --%f'

# -----------------------------------------------------------------------------
# vite-plus (node, pnpm, bun)
# -----------------------------------------------------------------------------
export VITE_PLUS_HOME="$HOME/.local/share/vite-plus"
export PATH="$VITE_PLUS_HOME/bin:$PATH"

# -----------------------------------------------------------------------------
# pnpm
# -----------------------------------------------------------------------------
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# -----------------------------------------------------------------------------
# uv (python)
# -----------------------------------------------------------------------------
export PATH="$HOME/.local/bin:$PATH"

# -----------------------------------------------------------------------------
# go
# -----------------------------------------------------------------------------
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

# -----------------------------------------------------------------------------
# History
# -----------------------------------------------------------------------------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

# -----------------------------------------------------------------------------
# Shell plugins (via homebrew)
# -----------------------------------------------------------------------------
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# -----------------------------------------------------------------------------
# FZF Shell Integration & Keybindings
# -----------------------------------------------------------------------------
source <(fzf --zsh)

# Use ripgrep for default file listing
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"

# Enable bat preview ONLY for file search (Ctrl+T)
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}'"

# Disable preview for history search (Ctrl+R) to avoid the missing file error
export FZF_CTRL_R_OPTS="--no-preview"

# -----------------------------------------------------------------------------
# FZF Helper Functions
# -----------------------------------------------------------------------------

# fcd: Fuzzy find and cd into directories (uses fast 'fd' if available)
fcd() {
  local dir
  if command -v fd >/dev/null 2>&1; then
    dir=$(fd --type d --hidden --exclude .git "${1:-.}" 2>/dev/null | fzf --prompt="📁 Jump to > ")
  else
    dir=$(find "${1:-.}" -path '*/.*' -prune -o -type d -print 2>/dev/null | fzf --prompt="📁 Jump to > ")
  fi
  [[ -n "$dir" ]] && cd "$dir"
}

# fif: Find In Files (searches content with ripgrep, previews with bat, opens in editor at line)
fif() {
  if [ "$#" -eq 0 ]; then
    echo "Usage: fif <search-pattern>"
    return 1
  fi
  local match
  match=$(rg --color=always --line-number --no-heading --smart-case "$@" 2>/dev/null | \
    fzf --ansi \
        --color "hl:-1:underline,hl+:-1:underline:reverse" \
        --delimiter : \
        --preview 'bat --color=always {1} --highlight-line {2}' \
        --preview-window 'right:60%:+{2}-/2' \
        --prompt="🔍 Matches > ")

  if [[ -n "$match" ]]; then
    local file line
    file=$(echo "$match" | cut -d: -f1)
    line=$(echo "$match" | cut -d: -f2)
    ${EDITOR:-vim} "+$line" "$file"
  fi
}

# -----------------------------------------------------------------------------
# Aliases
# -----------------------------------------------------------------------------
alias ll="ls -lh"
alias la="ls -lah"
alias s="fzf"
alias vs='vim $(fzf)'

# -----------------------------------------------------------------------------
# 1Password
# -----------------------------------------------------------------------------
export ARTIFACTORY_TOKEN=$(op read "op://Employee/Artifactory Token/credential")

# -----------------------------------------------------------------------------
# Starship prompt (keep last)
# -----------------------------------------------------------------------------
eval "$(starship init zsh)"
