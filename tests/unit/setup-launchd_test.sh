#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

HOME_DIR="$TMP_DIR/home"
LAUNCH_AGENTS_DIR="$TMP_DIR/LaunchAgents"
mkdir -p "$HOME_DIR/.claude/scripts" "$LAUNCH_AGENTS_DIR"

HOME="$HOME_DIR" LAUNCH_AGENTS_DIR="$LAUNCH_AGENTS_DIR" LAUNCHD_SKIP_BOOTSTRAP=1 \
  "$ROOT_DIR/setup-launchd.sh"

assert_contains() {
  local file="$1"
  local expected="$2"
  grep -F "$expected" "$file" >/dev/null
}

assert_minute() {
  local file="$1"
  local minute="$2"
  python3 - "$file" "$minute" <<'PY'
import plistlib
import sys

with open(sys.argv[1], "rb") as f:
    data = plistlib.load(f)

s = data["StartCalendarInterval"]
assert s["Hour"] == 0, s
assert s["Minute"] == int(sys.argv[2]), s
PY
}

assert_plist() {
  local label="$1"
  local minute="$2"
  local script_path="$3"
  local plist_path="$LAUNCH_AGENTS_DIR/$label.plist"

  [ -f "$plist_path" ]
  plutil -lint "$plist_path" >/dev/null
  assert_contains "$plist_path" "<string>$label</string>"
  assert_contains "$plist_path" "<string>/bin/bash</string>"
  assert_contains "$plist_path" "<string>$ROOT_DIR/run-once-per-day.sh</string>"
  assert_contains "$plist_path" "<string>$label</string>"
  assert_contains "$plist_path" "<string>$HOME_DIR/.local/state/dotfiles-launchd</string>"
  assert_contains "$plist_path" "<string>$script_path</string>"
  assert_contains "$plist_path" "<true/>"
  assert_contains "$plist_path" "<string>$HOME_DIR/.claude/scripts/cleanup.log</string>"
  assert_minute "$plist_path" "$minute"
}

assert_plist "com.juniq.dotfiles.claude-cleanup" "0" "$ROOT_DIR/claude/cleanup-short-sessions.sh"
assert_plist "com.juniq.dotfiles.codex-cleanup" "1" "$ROOT_DIR/codex/cleanup-short-sessions.sh"
assert_plist "com.juniq.dotfiles.gemini-cleanup" "2" "$ROOT_DIR/gemini/cleanup-short-sessions.sh"
assert_plist "com.juniq.dotfiles.sync" "3" "$ROOT_DIR/sync.sh"

echo "unit ok"
