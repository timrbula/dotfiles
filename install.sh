#!/usr/bin/env bash
# =============================================================================
# Dotfiles install script — symlinks dotfiles into $HOME
# =============================================================================

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

symlink() {
  local src="$DOTFILES_DIR/$1"
  local dest="$HOME/$1"

  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    echo "Backing up existing $dest -> ${dest}.bak"
    mv "$dest" "${dest}.bak"
  fi

  ln -sf "$src" "$dest"
  echo "Linked $dest -> $src"
}

symlink .zshrc
symlink .tmux.conf
symlink .vimrc
symlink .vim_runtime

echo "Dotfiles installed."
