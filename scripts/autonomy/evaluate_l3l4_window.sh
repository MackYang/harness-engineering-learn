#!/usr/bin/env bash
set -euo pipefail

INPUT_CSV="${1:-}"
WINDOW_ID="${2:-}"

if [[ -z "$INPUT_CSV" || -z "$WINDOW_ID" ]]; then
  echo "Usage: $0 <input_csv> <window_id>" >&2
  exit 1
fi
if [[ ! -f "$INPUT_CSV" ]]; then
  echo "Missing input CSV: $INPUT_CSV" >&2
  exit 1
fi

OUT_JSON="data/autonomy/l3l4-validation-${WINDOW_ID}.json"
MIN_WEEKS=8

WEEK_COUNT=0
CFR_SUM=0
MTTR_SUM=0
EVAL_SUM=0

DEGRADE_CFR=0
DEGRADE_MTTR=0
DEGRADE_EVAL=0
ROLLBACK_EVENTS=0

while IFS=',' read -r week cfr mttr_minutes eval_pass_rate event_id event_type root_cause action; do
  [[ "$week" == "week" ]] && continue
  [[ -z "$week" ]] && continue

  WEEK_COUNT=$((WEEK_COUNT + 1))
  CFR_SUM=$(awk -v a="$CFR_SUM" -v b="$cfr" 'BEGIN {printf "%.4f", a+b}')
  MTTR_SUM=$(awk -v a="$MTTR_SUM" -v b="$mttr_minutes" 'BEGIN {printf "%.4f", a+b}')
  EVAL_SUM=$(awk -v a="$EVAL_SUM" -v b="$eval_pass_rate" 'BEGIN {printf "%.4f", a+b}')

  if awk -v x="$cfr" 'BEGIN {exit (x > 0.10 ? 0 : 1)}'; then
    DEGRADE_CFR=$((DEGRADE_CFR + 1))
  fi
  if awk -v x="$mttr_minutes" 'BEGIN {exit (x > 60 ? 0 : 1)}'; then
    DEGRADE_MTTR=$((DEGRADE_MTTR + 1))
  fi
  if awk -v x="$eval_pass_rate" 'BEGIN {exit (x < 0.85 ? 0 : 1)}'; then
    DEGRADE_EVAL=$((DEGRADE_EVAL + 1))
  fi

  if [[ "$event_type" == "ROLLBACK" ]]; then
    ROLLBACK_EVENTS=$((ROLLBACK_EVENTS + 1))
  fi
done < "$INPUT_CSV"

if [[ "$WEEK_COUNT" -lt "$MIN_WEEKS" ]]; then
  echo "Need at least ${MIN_WEEKS} weeks of data, got ${WEEK_COUNT}" >&2
  exit 1
fi

AVG_CFR=$(awk -v s="$CFR_SUM" -v n="$WEEK_COUNT" 'BEGIN {printf "%.4f", s/n}')
AVG_MTTR=$(awk -v s="$MTTR_SUM" -v n="$WEEK_COUNT" 'BEGIN {printf "%.2f", s/n}')
AVG_EVAL=$(awk -v s="$EVAL_SUM" -v n="$WEEK_COUNT" 'BEGIN {printf "%.4f", s/n}')

CFR_OK=false
MTTR_OK=false
EVAL_OK=false
ROLLBACK_OK=false

if awk -v x="$AVG_CFR" 'BEGIN {exit (x <= 0.10 ? 0 : 1)}'; then CFR_OK=true; fi
if awk -v x="$AVG_MTTR" 'BEGIN {exit (x <= 60 ? 0 : 1)}'; then MTTR_OK=true; fi
if awk -v x="$AVG_EVAL" 'BEGIN {exit (x >= 0.85 ? 0 : 1)}'; then EVAL_OK=true; fi
if [[ "$ROLLBACK_EVENTS" -le 1 ]]; then ROLLBACK_OK=true; fi

RESULT="HOLD"
if [[ "$CFR_OK" == "true" && "$MTTR_OK" == "true" && "$EVAL_OK" == "true" && "$ROLLBACK_OK" == "true" ]]; then
  RESULT="PASS"
fi

cat > "$OUT_JSON" <<JSON
{
  "window_id": "${WINDOW_ID}",
  "input": "${INPUT_CSV}",
  "weeks": ${WEEK_COUNT},
  "thresholds": {
    "cfr_le": 0.10,
    "mttr_minutes_le": 60,
    "eval_pass_rate_ge": 0.85,
    "rollback_events_le": 1
  },
  "metrics": {
    "avg_cfr": ${AVG_CFR},
    "avg_mttr_minutes": ${AVG_MTTR},
    "avg_eval_pass_rate": ${AVG_EVAL},
    "rollback_events": ${ROLLBACK_EVENTS},
    "weeks_cfr_degraded": ${DEGRADE_CFR},
    "weeks_mttr_degraded": ${DEGRADE_MTTR},
    "weeks_eval_degraded": ${DEGRADE_EVAL}
  },
  "checks": {
    "cfr_ok": ${CFR_OK},
    "mttr_ok": ${MTTR_OK},
    "eval_ok": ${EVAL_OK},
    "rollback_ok": ${ROLLBACK_OK}
  },
  "result": "${RESULT}",
  "fallback_action": "$([[ "$RESULT" == "PASS" ]] && echo "none" || echo "auto-downgrade-and-freeze-delegation")"
}
JSON

echo "Wrote $OUT_JSON"
