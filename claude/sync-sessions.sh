#!/bin/bash

SESSIONS_DIR="$HOME/.claude/projects"

# init or clone into sessions dir
if [ ! -d "$SESSIONS_DIR/.git" ]; then
  git clone https://github.com/juniqlim/claude-sessions.git "$SESSIONS_DIR"
fi

cd "$SESSIONS_DIR"

# pull remote sessions
git pull --rebase 2>/dev/null

# push local sessions
git add -A
if ! git diff --cached --quiet; then
  git commit -m "sync sessions $(date +%Y-%m-%d)"
  git push
  echo "Sessions synced and pushed."
else
  echo "No new sessions to sync."
fi
