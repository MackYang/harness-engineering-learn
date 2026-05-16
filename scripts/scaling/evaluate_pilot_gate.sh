#!/usr/bin/env bash
set -euo pipefail

WEEK_DATE="${1:-$(date '+%Y-%m-%d')}"
DASHBOARD_INPUT="${2:-data/metrics/dashboard-input.json}"
LESSONS_FILE="${3:-docs/incidents/lessons-learned-log.md}"
OUT="data/scaling/pilot-gate-${WEEK_DATE}.json"

if [[ ! -f "$DASHBOARD_INPUT" ]]; then
  echo "Missing dashboard input: $DASHBOARD_INPUT" >&2
  exit 1
fi

if [[ ! -f "$LESSONS_FILE" ]]; then
  echo "Missing lessons file: $LESSONS_FILE" >&2
  exit 1
fi

# Two-week gate is green only when the latest 2 weeks are explicitly marked green.
TOTAL_WEEKS=$(grep -E '"week"' "$DASHBOARD_INPUT" | wc -l | tr -d ' ')
LAST_TWO_GREEN=0
if [[ "$TOTAL_WEEKS" -ge 2 ]]; then
  LAST_TWO_GREEN=$(grep -E '"kpi_status"' "$DASHBOARD_INPUT" | tail -n 2 | grep -c '"green"' || true)
  LAST_TWO_GREEN=$(echo "$LAST_TWO_GREEN" | tr -d ' ')
fi
if [[ "$LAST_TWO_GREEN" -eq 2 ]]; then
  TWO_WEEK_CORE_METRICS_GREEN=true
else
  TWO_WEEK_CORE_METRICS_GREEN=false
fi

TOTAL_LESSONS=$(awk 'END {print NR-2}' "$LESSONS_FILE" 2>/dev/null || echo 0)
if [[ "$TOTAL_LESSONS" -lt 0 ]]; then
  TOTAL_LESSONS=0
fi
CLOSED_LESSONS=$(grep -E '\| (DONE|CLOSED) \|' "$LESSONS_FILE" | wc -l | tr -d ' ' || true)

if [[ "$TOTAL_LESSONS" -eq 0 ]]; then
  CLOSURE_RATE=1.00
else
  CLOSURE_RATE=$(awk -v c="$CLOSED_LESSONS" -v t="$TOTAL_LESSONS" 'BEGIN {printf "%.2f", c/t}')
fi

MAJOR_ROLLBACK="${MAJOR_ROLLBACK:-false}"
if [[ "$MAJOR_ROLLBACK" != "true" && "$MAJOR_ROLLBACK" != "false" ]]; then
  echo "MAJOR_ROLLBACK must be true or false" >&2
  exit 1
fi

GATE_RESULT="HOLD"
if [[ "$TWO_WEEK_CORE_METRICS_GREEN" == "true" && "$MAJOR_ROLLBACK" == "false" ]]; then
  if awk -v r="$CLOSURE_RATE" 'BEGIN {exit (r >= 0.80 ? 0 : 1)}'; then
    GATE_RESULT="PASS"
  fi
fi

cat > "$OUT" <<JSON
{
  "week": "${WEEK_DATE}",
  "inputs": {
    "dashboard_input": "${DASHBOARD_INPUT}",
    "lessons_file": "${LESSONS_FILE}",
    "major_rollback": ${MAJOR_ROLLBACK}
  },
  "criteria": {
    "two_week_core_metrics_green": ${TWO_WEEK_CORE_METRICS_GREEN},
    "no_major_rollback": $([[ "$MAJOR_ROLLBACK" == "false" ]] && echo true || echo false),
    "closure_rate": ${CLOSURE_RATE},
    "closure_rate_threshold": 0.80
  },
  "result": "${GATE_RESULT}",
  "fallback_action": "$([[ "$GATE_RESULT" == "PASS" ]] && echo "none" || echo "stay_current_autonomy_level")"
}
JSON

echo "Wrote $OUT"
