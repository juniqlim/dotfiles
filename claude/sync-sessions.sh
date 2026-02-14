#!/bin/bash

SESSIONS_DIR="$HOME/.claude/projects"
REPO_DIR="$HOME/j/claude-sessions"

# clone if not exists
if [ ! -d "$REPO_DIR" ]; then
  git clone https://github.com/juniqlim/claude-sessions.git "$REPO_DIR"
fi

# pull latest from remote
cd "$REPO_DIR"
git pull --rebase 2>/dev/null

# sync: local -> repo
rsync -a --ignore-existing "$SESSIONS_DIR/" "$REPO_DIR/" --exclude=".git"

# sync: repo -> local
rsync -a --ignore-existing "$REPO_DIR/" "$SESSIONS_DIR/" --exclude=".git"

# push if there are changes
cd "$REPO_DIR"
git add -A
if ! git diff --cached --quiet; then
  git commit -m "sync sessions $(date +%Y-%m-%d)"
  git push
  echo "Sessions synced and pushed."
else
  echo "No new sessions to sync."
fi
