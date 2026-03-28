#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

STAMP_DIR="$TMP_DIR/stamps"
COUNTER_FILE="$TMP_DIR/counter"
COMMAND_SCRIPT="$TMP_DIR/command.sh"

cat > "$COMMAND_SCRIPT" <<EOF
#!/bin/bash
count=0
if [ -f "$COUNTER_FILE" ]; then
  count=\$(cat "$COUNTER_FILE")
fi
count=\$((count + 1))
echo "\$count" > "$COUNTER_FILE"
EOF
chmod +x "$COMMAND_SCRIPT"

WRAPPER="$ROOT_DIR/run-once-per-day.sh"

bash "$WRAPPER" "sync" "$STAMP_DIR" "$COMMAND_SCRIPT"
[ "$(cat "$COUNTER_FILE")" = "1" ]

bash "$WRAPPER" "sync" "$STAMP_DIR" "$COMMAND_SCRIPT"
[ "$(cat "$COUNTER_FILE")" = "1" ]

YESTERDAY="$(date -v-1d +%F)"
mkdir -p "$STAMP_DIR"
echo "$YESTERDAY" > "$STAMP_DIR/sync.last-run"

bash "$WRAPPER" "sync" "$STAMP_DIR" "$COMMAND_SCRIPT"
[ "$(cat "$COUNTER_FILE")" = "2" ]

echo "run-once-per-day ok"
