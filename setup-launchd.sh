#!/bin/bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
USER_ID="$(id -u)"
LAUNCH_AGENTS_DIR="${LAUNCH_AGENTS_DIR:-$HOME/Library/LaunchAgents}"
LOG_DIR="$HOME/.claude/scripts"
LOG_PATH="$LOG_DIR/cleanup.log"
STATE_DIR="$HOME/.local/state/dotfiles-launchd"
SKIP_BOOTSTRAP="${LAUNCHD_SKIP_BOOTSTRAP:-0}"

mkdir -p "$LAUNCH_AGENTS_DIR" "$LOG_DIR" "$STATE_DIR"

write_plist() {
  local label="$1"
  local minute="$2"
  local script_path="$3"
  local plist_path="$LAUNCH_AGENTS_DIR/$label.plist"

  cat > "$plist_path" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>$label</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/bash</string>
    <string>$DOTFILES_DIR/run-once-per-day.sh</string>
    <string>$label</string>
    <string>$STATE_DIR</string>
    <string>$script_path</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>StartCalendarInterval</key>
  <dict>
    <key>Hour</key>
    <integer>0</integer>
    <key>Minute</key>
    <integer>$minute</integer>
  </dict>
  <key>StandardOutPath</key>
  <string>$LOG_PATH</string>
  <key>StandardErrorPath</key>
  <string>$LOG_PATH</string>
</dict>
</plist>
EOF

  plutil -lint "$plist_path" >/dev/null
}

load_plist() {
  local label="$1"
  local plist_path="$LAUNCH_AGENTS_DIR/$label.plist"

  if [ "$SKIP_BOOTSTRAP" = "1" ]; then
    return
  fi

  launchctl bootout "gui/$USER_ID" "$plist_path" >/dev/null 2>&1 || true
  launchctl bootstrap "gui/$USER_ID" "$plist_path"
  launchctl enable "gui/$USER_ID/$label"
}

write_plist "com.juniq.dotfiles.claude-cleanup" "0" "$DOTFILES_DIR/claude/cleanup-short-sessions.sh"
write_plist "com.juniq.dotfiles.codex-cleanup" "1" "$DOTFILES_DIR/codex/cleanup-short-sessions.sh"
write_plist "com.juniq.dotfiles.gemini-cleanup" "2" "$DOTFILES_DIR/gemini/cleanup-short-sessions.sh"
write_plist "com.juniq.dotfiles.sync" "3" "$DOTFILES_DIR/sync.sh"

load_plist "com.juniq.dotfiles.claude-cleanup"
load_plist "com.juniq.dotfiles.codex-cleanup"
load_plist "com.juniq.dotfiles.gemini-cleanup"
load_plist "com.juniq.dotfiles.sync"

echo "launchd jobs registered:"
echo "- com.juniq.dotfiles.claude-cleanup"
echo "- com.juniq.dotfiles.codex-cleanup"
echo "- com.juniq.dotfiles.gemini-cleanup"
echo "- com.juniq.dotfiles.sync"
