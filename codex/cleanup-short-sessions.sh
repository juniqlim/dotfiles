#!/bin/bash
# Codex 세션 정리: 사용자 질의가 3개 이하인 세션 삭제
# 사용법: bash cleanup-short-sessions-codex.sh [--dry-run]

DRY_RUN=false
[ "$1" = "--dry-run" ] && DRY_RUN=true

deleted=0
kept=0
total=0

for session_file in $(find ~/.codex/sessions -name "*.jsonl" 2>/dev/null); do
  total=$((total + 1))
  user_count=$(grep -c '"role":"user"' "$session_file" 2>/dev/null)
  user_count=$(echo "${user_count:-0}" | tail -1)

  if [ "$user_count" -le 3 ]; then
    if [ "$DRY_RUN" = true ]; then
      echo "[DRY-RUN] DELETE $session_file ($user_count queries)"
    else
      rm -f "$session_file"
      echo "DELETED $session_file ($user_count queries)"
    fi
    deleted=$((deleted + 1))
  else
    kept=$((kept + 1))
  fi
done

echo ""
echo "Codex | Total: $total | Deleted: $deleted | Kept: $kept"
