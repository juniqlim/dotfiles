#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# zshrc
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

# ghostty
mkdir -p "$HOME/Library/Application Support/com.mitchellh.ghostty"
ln -sf "$DOTFILES_DIR/ghostty/config" "$HOME/Library/Application Support/com.mitchellh.ghostty/config"

echo "dotfiles linked."
