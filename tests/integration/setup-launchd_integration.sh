#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

grep -F '"$DOTFILES_DIR/setup-launchd.sh"' "$ROOT_DIR/install.sh" >/dev/null
grep -F 'launchctl bootout "gui/$USER_ID/$label"' "$ROOT_DIR/setup-launchd.sh" >/dev/null
grep -F 'launchctl bootout "gui/$USER_ID"' "$ROOT_DIR/setup-launchd.sh" >/dev/null
grep -F 'launchctl bootstrap "gui/$USER_ID"' "$ROOT_DIR/setup-launchd.sh" >/dev/null
grep -F 'launchctl enable "gui/$USER_ID/$label"' "$ROOT_DIR/setup-launchd.sh" >/dev/null
grep -F 'run-once-per-day.sh' "$ROOT_DIR/setup-launchd.sh" >/dev/null
grep -F '<key>RunAtLoad</key>' "$ROOT_DIR/setup-launchd.sh" >/dev/null

echo "integration ok"
