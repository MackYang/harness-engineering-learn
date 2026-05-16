#!/usr/bin/env bash
set -euo pipefail

INPUT_CSV="${1:-}"
PERIOD="${2:-}"

if [[ -z "$INPUT_CSV" || -z "$PERIOD" ]]; then
  echo "Usage: $0 <input_csv> <period:YYYY-MM>" >&2
  exit 1
fi

if [[ ! -f "$INPUT_CSV" ]]; then
  echo "Missing input CSV: $INPUT_CSV" >&2
  exit 1
fi

OUT_JSON="data/ops/rule-quality-${PERIOD}.json"
TARGET_FALSE_POSITIVE="0.15"
TARGET_PIPELINE_SECONDS="300"
TARGET_BLOCK_VALUE_RATIO="0.60"

TOTAL_HITS=0
TOTAL_FALSE_POSITIVE=0
TOTAL_ACTIONABLE_BLOCKS=0
RULE_COUNT=0
PIPELINE_SECONDS_SUM=0

while IFS=',' read -r rule_id level total_hits false_positive_hits avg_pipeline_seconds actionable_blocks; do
  [[ "$rule_id" == "rule_id" ]] && continue
  [[ -z "$rule_id" ]] && continue

  RULE_COUNT=$((RULE_COUNT + 1))
  TOTAL_HITS=$((TOTAL_HITS + total_hits))
  TOTAL_FALSE_POSITIVE=$((TOTAL_FALSE_POSITIVE + false_positive_hits))
  TOTAL_ACTIONABLE_BLOCKS=$((TOTAL_ACTIONABLE_BLOCKS + actionable_blocks))
  PIPELINE_SECONDS_SUM=$((PIPELINE_SECONDS_SUM + avg_pipeline_seconds))
done < "$INPUT_CSV"

if [[ "$RULE_COUNT" -eq 0 || "$TOTAL_HITS" -eq 0 ]]; then
  echo "Invalid input dataset: rule_count=$RULE_COUNT total_hits=$TOTAL_HITS" >&2
  exit 1
fi

FALSE_POSITIVE_RATE=$(awk -v fp="$TOTAL_FALSE_POSITIVE" -v hits="$TOTAL_HITS" 'BEGIN {printf "%.4f", fp/hits}')
AVG_PIPELINE_SECONDS=$(awk -v sum="$PIPELINE_SECONDS_SUM" -v n="$RULE_COUNT" 'BEGIN {printf "%.2f", sum/n}')
BLOCK_VALUE_RATIO=$(awk -v action="$TOTAL_ACTIONABLE_BLOCKS" -v block="$TOTAL_HITS" 'BEGIN {printf "%.4f", action/block}')

FALSE_POSITIVE_OK=false
PIPELINE_OK=false
BLOCK_VALUE_OK=false

if awk -v x="$FALSE_POSITIVE_RATE" -v t="$TARGET_FALSE_POSITIVE" 'BEGIN {exit (x <= t ? 0 : 1)}'; then
  FALSE_POSITIVE_OK=true
fi
if awk -v x="$AVG_PIPELINE_SECONDS" -v t="$TARGET_PIPELINE_SECONDS" 'BEGIN {exit (x <= t ? 0 : 1)}'; then
  PIPELINE_OK=true
fi
if awk -v x="$BLOCK_VALUE_RATIO" -v t="$TARGET_BLOCK_VALUE_RATIO" 'BEGIN {exit (x >= t ? 0 : 1)}'; then
  BLOCK_VALUE_OK=true
fi

RESULT="HOLD"
if [[ "$FALSE_POSITIVE_OK" == "true" && "$PIPELINE_OK" == "true" && "$BLOCK_VALUE_OK" == "true" ]]; then
  RESULT="PASS"
fi

cat > "$OUT_JSON" <<JSON
{
  "period": "${PERIOD}",
  "input": "${INPUT_CSV}",
  "targets": {
    "false_positive_rate_le": ${TARGET_FALSE_POSITIVE},
    "avg_pipeline_seconds_le": ${TARGET_PIPELINE_SECONDS},
    "block_value_ratio_ge": ${TARGET_BLOCK_VALUE_RATIO}
  },
  "metrics": {
    "rule_count": ${RULE_COUNT},
    "total_hits": ${TOTAL_HITS},
    "false_positive_hits": ${TOTAL_FALSE_POSITIVE},
    "false_positive_rate": ${FALSE_POSITIVE_RATE},
    "avg_pipeline_seconds": ${AVG_PIPELINE_SECONDS},
    "actionable_blocks": ${TOTAL_ACTIONABLE_BLOCKS},
    "block_value_ratio": ${BLOCK_VALUE_RATIO}
  },
  "checks": {
    "false_positive_ok": ${FALSE_POSITIVE_OK},
    "pipeline_ok": ${PIPELINE_OK},
    "block_value_ok": ${BLOCK_VALUE_OK}
  },
  "result": "${RESULT}"
}
JSON

echo "Wrote $OUT_JSON"
