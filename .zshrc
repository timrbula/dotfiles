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
# fzf
# -----------------------------------------------------------------------------
source <(fzf --zsh)
export FZF_DEFAULT_COMMAND='rg --files'
export FZF_DEFAULT_OPTS="--preview '[ -f {} ] && bat --style=numbers --color=always --line-range :500 {} || echo {}'"

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
