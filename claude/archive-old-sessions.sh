#!/bin/bash
# 7일 이전 Claude 세션을 backup 디렉터리로 이동
# 사용법: bash archive-old-sessions.sh [--dry-run]

DRY_RUN=false
if [ "$1" = "--dry-run" ]; then
  DRY_RUN=true
fi

SESSIONS_DIR="$HOME/.claude/projects"
BACKUP_DIR="$SESSIONS_DIR/backup"

mkdir -p "$BACKUP_DIR"

moved=0
kept=0

for session_file in "$SESSIONS_DIR"/*/[0-9a-f]*.jsonl; do
  [ -f "$session_file" ] || continue
  project_dir=$(dirname "$session_file")
  project_name=$(basename "$project_dir")

  # backup 디렉터리는 건너뜀
  [ "$project_name" = "backup" ] && continue

  # 7일(604800초) 이전 파일만 대상
  if [ "$(uname)" = "Darwin" ]; then
    file_age=$(( $(date +%s) - $(stat -f %m "$session_file") ))
  else
    file_age=$(( $(date +%s) - $(stat -c %Y "$session_file") ))
  fi
  [ "$file_age" -lt 604800 ] && { kept=$((kept + 1)); continue; }

  session_id=$(basename "$session_file" .jsonl)
  session_dir="$project_dir/$session_id"
  backup_project_dir="$BACKUP_DIR/$project_name"
  mkdir -p "$backup_project_dir"

  if [ "$DRY_RUN" = true ]; then
    echo "[DRY-RUN] MOVE $session_file -> $backup_project_dir/"
  else
    mv "$session_file" "$backup_project_dir/"
    [ -d "$session_dir" ] && mv "$session_dir" "$backup_project_dir/"
    echo "MOVED $session_file"
  fi
  moved=$((moved + 1))
done

echo ""
echo "Moved: $moved | Kept: $kept"
