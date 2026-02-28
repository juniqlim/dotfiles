#!/bin/bash
# Claude Code 세션 정리: 사용자 질의가 3개 이하인 세션 삭제
# 사용법: bash ~/.claude/scripts/cleanup-short-sessions.sh [--dry-run]

DRY_RUN=false
if [ "$1" = "--dry-run" ]; then
  DRY_RUN=true
fi

deleted=0
kept=0
total=0

for session_file in ~/.claude/projects/*/[0-9a-f]*.jsonl; do
  [ -f "$session_file" ] || continue
  total=$((total + 1))

  user_count=$(grep -c '"type":"user"' "$session_file" 2>/dev/null)
  user_count=${user_count:-0}
  # Sanitize: take only last line if multiline
  user_count=$(echo "$user_count" | tail -1)

  if [ "$user_count" -le 3 ]; then
    session_id=$(basename "$session_file" .jsonl)
    session_dir=$(dirname "$session_file")/$session_id

    if [ "$DRY_RUN" = true ]; then
      echo "[DRY-RUN] DELETE $session_file ($user_count queries)"
    else
      rm -f "$session_file"
      rm -rf "$session_dir" 2>/dev/null
      echo "DELETED $session_file ($user_count queries)"
    fi
    deleted=$((deleted + 1))
  else
    kept=$((kept + 1))
  fi
done

echo ""
echo "Total: $total | Deleted: $deleted | Kept: $kept"
