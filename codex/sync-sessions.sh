#!/bin/bash

SESSIONS_DIR="$HOME/.codex/sessions"
REMOTE="git@github.com:juniqlim/codex-sessions.git"

mkdir -p "$SESSIONS_DIR"
cd "$SESSIONS_DIR"

# init repo if not exists, preserving existing files
if [ ! -d ".git" ]; then
  git init
  git remote add origin "$REMOTE"
  git fetch origin
  git checkout -b main
  git add -A
  git commit -m "init local sessions" 2>/dev/null
  git merge origin/main --allow-unrelated-histories --no-edit 2>/dev/null
  git push -u origin main
fi

# pull remote sessions
git pull --rebase 2>/dev/null

# push local sessions
git add -A
if ! git diff --cached --quiet; then
  git commit -m "sync sessions $(date +%Y-%m-%d)"
  git push
  echo "Codex sessions synced and pushed."
else
  echo "No new codex sessions to sync."
fi
