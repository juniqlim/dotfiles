#!/bin/bash
# Codex 세션 정리 cron 등록
# 매일 자정에 질의 3개 이하 세션 삭제

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CRON_JOB="1 0 * * * bash $SCRIPT_DIR/cleanup-short-sessions.sh >> ~/.claude/scripts/cleanup.log 2>&1"

(crontab -l 2>/dev/null | grep -v "codex/cleanup-short-sessions"; echo "$CRON_JOB") | crontab -

echo "Codex cron 등록 완료:"
crontab -l | grep "codex/cleanup-short-sessions"
