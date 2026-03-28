#!/bin/bash

set -euo pipefail

if [ "$#" -lt 3 ]; then
  echo "usage: $0 <job-name> <stamp-dir> <command> [args...]" >&2
  exit 1
fi

JOB_NAME="$1"
STAMP_DIR="$2"
shift 2

mkdir -p "$STAMP_DIR"

STAMP_FILE="$STAMP_DIR/$JOB_NAME.last-run"
TODAY="$(date +%F)"

if [ -f "$STAMP_FILE" ] && [ "$(cat "$STAMP_FILE")" = "$TODAY" ]; then
  exit 0
fi

"$@"
echo "$TODAY" > "$STAMP_FILE"
