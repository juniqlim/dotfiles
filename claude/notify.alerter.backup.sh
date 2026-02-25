#!/bin/bash
input=$(cat)
transcript_path=$(echo "$input" | jq -r '.transcript_path')
# 마지막 assistant 메시지에서 텍스트 추출 (최대 50자, 중복 제거)
last_msg=$(tail -20 "$transcript_path" 2>/dev/null | grep -o '"text":"[^"]*"' | tail -1 | sed 's/"text":"//;s/"$//' | cut -c1-50 | head -1)
if [ -z "$last_msg" ]; then
  last_msg="완료"
fi
timeout 60 /usr/local/bin/alerter -message "$last_msg" -title "Claude Code" &
