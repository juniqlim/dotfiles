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
ln -sf "$DOTFILES_DIR/claude/sync-sessions.sh" "$HOME/.claude/sync-sessions.sh"

# codex
mkdir -p "$HOME/.codex"
ln -sf "$DOTFILES_DIR/codex/sync-sessions.sh" "$HOME/.codex/sync-sessions.sh"

# gemini
mkdir -p "$HOME/.gemini"
ln -sf "$DOTFILES_DIR/gemini/sync-sessions.sh" "$HOME/.gemini/sync-sessions.sh"

# shortcut
ln -sf "$HOME/develop/code/juniqlim" "$HOME/j"

echo "dotfiles linked."
