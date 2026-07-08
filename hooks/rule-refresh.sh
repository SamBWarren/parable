#!/bin/bash
# Periodic rule refresh: emits a short reminder at most once per 300s per
# session; silent otherwise. Wired to PostToolUse so long-running agents
# (subagents included) get the rules re-planted mid-run instead of only at
# session start.
inp=$(cat)
sid=$(printf '%s' "$inp" | sed -n 's/.*"session_id" *: *"\([^"]*\)".*/\1/p')
[ -z "$sid" ] && sid="global"
f="${TMPDIR:-/tmp}/claude-rulecard-$sid"
now=$(date +%s)
last=$(cat "$f" 2>/dev/null || echo 0)
if [ $((now - last)) -gt 300 ]; then
  echo "$now" > "$f"
  printf '%s' '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"RULE REFRESH (auto, periodic): conclusions in the channel, cognition in the thoughts file - visible text is verdict + next step only, a few lines max; no wait/actually/maybe, no narrated deliberation. Directors: report each [DONE Pn] the moment it lands. Before declaring done, VERIFY with commands and paste the artifact (never claim): the build check AND a real runtime run, probe/test evidence for every behavior, docs regenerated, any standing logs appended."}}'
fi
exit 0
