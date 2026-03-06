#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# dotfiles 변경사항 push
cd "$DOTFILES_DIR"
git add -A
git diff --cached --quiet || git commit -m "sync dotfiles $(date +%Y-%m-%d)"
git pull --rebase --autostash
git push

# sessions sync
"$DOTFILES_DIR/claude/sync-sessions.sh"
"$DOTFILES_DIR/codex/sync-sessions.sh"
"$DOTFILES_DIR/gemini/sync-sessions.sh"

echo "synced."
