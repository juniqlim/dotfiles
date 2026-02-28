#!/bin/bash
# Claude 세션 정리 cron 등록
# 매일 자정에 질의 3개 이하 세션 삭제

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CRON_JOB="0 0 * * * bash $SCRIPT_DIR/cleanup-short-sessions.sh >> ~/.claude/scripts/cleanup.log 2>&1"

(crontab -l 2>/dev/null | grep -v "claude/cleanup-short-sessions"; echo "$CRON_JOB") | crontab -

echo "Claude cron 등록 완료:"
crontab -l | grep "claude/cleanup-short-sessions"
