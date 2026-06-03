#!/bin/sh
input=$(cat)
cwd=$(echo "$input" | jq -r '.cwd // empty')
branch=$(git -c core.useBuiltinFSMonitor=false -c core.fsmonitor=false branch --show-current 2>/dev/null || echo '')
model_full=$(echo "$input" | jq -r '.model.display_name // empty')
model=$(echo "$model_full" | sed 's/Claude //;s/Opus \([0-9.]*\)/O\1/;s/Sonnet \([0-9.]*\)/S\1/;s/Haiku \([0-9.]*\)/H\1/;s/ *(1M context)/ 1M/')
effort=$(echo "$input" | jq -r '.effort.level // empty')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
five=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
out=""
[ -n "$cwd" ] && out="$out$(basename "$cwd") "
[ -n "$branch" ] && out="$out[$branch] "
[ -n "$model" ] && out="$out$model"
[ -n "$effort" ] && out="$out:$effort"
parts=""
[ -n "$used" ] && parts="ctx:$(printf '%.0f' "$used")%"
[ -n "$five" ] && parts="$parts 5h:$(printf '%.0f' "$five")%"
[ -n "$week" ] && parts="$parts 7d:$(printf '%.0f' "$week")%"
[ -n "$parts" ] && out="${out} | ${parts}"
echo "$out"
