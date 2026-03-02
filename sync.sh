#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

"$DOTFILES_DIR/claude/sync-sessions.sh"
"$DOTFILES_DIR/codex/sync-sessions.sh"
"$DOTFILES_DIR/gemini/sync-sessions.sh"

echo "sessions synced."
