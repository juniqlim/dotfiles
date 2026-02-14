#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# zshrc
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

# ghostty
mkdir -p "$HOME/Library/Application Support/com.mitchellh.ghostty"
ln -sf "$DOTFILES_DIR/ghostty/config" "$HOME/Library/Application Support/com.mitchellh.ghostty/config"

# claude code
mkdir -p "$HOME/.claude"
ln -sf "$DOTFILES_DIR/claude/settings.json" "$HOME/.claude/settings.json"

# shortcut
ln -sf "$HOME/develop/code/juniqlim" "$HOME/j"

echo "dotfiles linked."
