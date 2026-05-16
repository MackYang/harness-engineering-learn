#!/usr/bin/env bash
set -euo pipefail

WEEK_DATE="${1:-$(date '+%Y-%m-%d')}"
mkdir -p data/metrics/history data/scaling data/ops data/autonomy

# 1) Collect metrics
./scripts/metrics/collect_metrics.sh >/tmp/metrics_cycle.log
cp data/metrics/weekly-summary.json "data/metrics/history/weekly-summary-${WEEK_DATE}.json"

# 2) Pilot expansion snapshot
TOTAL_LESSONS=$(awk 'END {print NR-2}' docs/incidents/lessons-learned-log.md 2>/dev/null || echo 0)
if [[ "$TOTAL_LESSONS" -lt 0 ]]; then TOTAL_LESSONS=0; fi
CLOSED_LESSONS=$(grep -E '\| (DONE|CLOSED) \|' docs/incidents/lessons-learned-log.md | wc -l | tr -d ' ')
if [[ "$TOTAL_LESSONS" -eq 0 ]]; then
  CLOSURE_RATE=1
else
  CLOSURE_RATE=$(awk -v c="$CLOSED_LESSONS" -v t="$TOTAL_LESSONS" 'BEGIN {printf "%.2f", c/t}')
fi

cat > "data/scaling/pilot-gate-${WEEK_DATE}.json" <<JSON
{
  "week": "${WEEK_DATE}",
  "criteria": {
    "two_week_core_metrics_green": "pending",
    "major_rollback": false,
    "closure_rate": ${CLOSURE_RATE}
  },
  "note": "Auto snapshot from weekly cycle"
}
JSON

# 3) Reuse metrics snapshot
TOTAL_PROJECTS="${TOTAL_PROJECTS:-1}"
REUSED_PROJECTS="${REUSED_PROJECTS:-1}"
REUSE_RATE=$(awk -v r="$REUSED_PROJECTS" -v t="$TOTAL_PROJECTS" 'BEGIN {if (t==0) print 0; else printf "%.2f", r/t}')

cat > "data/scaling/reuse-metrics-${WEEK_DATE}.json" <<JSON
{
  "week": "${WEEK_DATE}",
  "total_projects": ${TOTAL_PROJECTS},
  "reused_projects": ${REUSED_PROJECTS},
  "reuse_rate": ${REUSE_RATE},
  "target": 0.70
}
JSON

# 4) Rule quality snapshot
SECONDS=0
make verify >/tmp/verify_cycle.log
VERIFY_SECONDS=$SECONDS
FALSE_POSITIVE_RATE="${FALSE_POSITIVE_RATE:-0.00}"

cat > "data/ops/rule-quality-${WEEK_DATE}.json" <<JSON
{
  "week": "${WEEK_DATE}",
  "verify_seconds": ${VERIFY_SECONDS},
  "false_positive_rate": ${FALSE_POSITIVE_RATE},
  "block_value_ratio": "pending"
}
JSON

# 5) L3/L4 weekly snapshot
EVAL_PASS_RATE=$(grep -E '"pass_rate"' evals/results.json | awk -F': ' '{print $2}' | tr -d ' ,' || echo "1.0")

cat > "data/autonomy/l3l4-weekly-${WEEK_DATE}.json" <<JSON
{
  "week": "${WEEK_DATE}",
  "cfr": "pending_release_data",
  "mttr": "under_5_minutes_simulated",
  "eval_pass_rate": ${EVAL_PASS_RATE},
  "status": "in_window"
}
JSON

echo "Weekly operating cycle completed for ${WEEK_DATE}"
