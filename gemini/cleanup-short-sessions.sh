#!/bin/bash
# Gemini 세션 정리: 사용자 질의가 3개 이하인 세션 삭제
# 사용법: bash cleanup-short-sessions-gemini.sh [--dry-run]

DRY_RUN=false
[ "$1" = "--dry-run" ] && DRY_RUN=true

deleted=0
kept=0
total=0

for project_dir in ~/.gemini/tmp/*/; do
  [ -d "$project_dir/chats" ] || continue

  for session_file in "$project_dir"/chats/session-*.json; do
    [ -f "$session_file" ] || continue
    total=$((total + 1))

    user_count=$(python3 -c "
import json, sys
with open(sys.argv[1]) as f:
    data = json.load(f)
print(sum(1 for m in data.get('messages', []) if m.get('type') == 'user'))
" "$session_file" 2>/dev/null)
    user_count=${user_count:-0}

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

  # 프로젝트 디렉토리에 세션이 없으면 정리
  if [ "$DRY_RUN" = false ]; then
    remaining=$(find "$project_dir/chats" -name "session-*.json" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$remaining" = "0" ]; then
      rm -rf "$project_dir"
      echo "DELETED empty project dir: $project_dir"
    fi
  fi
done

echo ""
echo "Gemini | Total: $total | Deleted: $deleted | Kept: $kept"
