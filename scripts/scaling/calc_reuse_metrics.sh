#!/usr/bin/env bash
set -euo pipefail

INPUT_CSV="${1:-data/scaling/reuse-adoption-2026-05-16.csv}"
AS_OF_DATE="${2:-$(date '+%Y-%m-%d')}"
OUT_JSON="data/scaling/reuse-metrics-${AS_OF_DATE}.json"
TARGET="0.70"

if [[ ! -f "$INPUT_CSV" ]]; then
  echo "Missing input CSV: $INPUT_CSV" >&2
  exit 1
fi

TOTAL_PROJECTS=0
PROJECTS_MEETING=0

while IFS=',' read -r project template_reuse policy_reuse eval_reuse runbook_reuse; do
  [[ "$project" == "project" ]] && continue
  [[ -z "$project" ]] && continue
  TOTAL_PROJECTS=$((TOTAL_PROJECTS + 1))
  OVERALL=$(awk -v a="$template_reuse" -v b="$policy_reuse" -v c="$eval_reuse" -v d="$runbook_reuse" 'BEGIN {printf "%.2f", (a+b+c+d)/4}')
  if awk -v rate="$OVERALL" -v target="$TARGET" 'BEGIN {exit (rate >= target ? 0 : 1)}'; then
    PROJECTS_MEETING=$((PROJECTS_MEETING + 1))
  fi
done < "$INPUT_CSV"

if [[ "$TOTAL_PROJECTS" -eq 0 ]]; then
  echo "No project data in $INPUT_CSV" >&2
  exit 1
fi

REUSE_PROJECT_RATE=$(awk -v pass="$PROJECTS_MEETING" -v total="$TOTAL_PROJECTS" 'BEGIN {printf "%.2f", pass/total}')

cat > "$OUT_JSON" <<JSON
{
  "as_of": "${AS_OF_DATE}",
  "input": "${INPUT_CSV}",
  "target_reuse_rate": ${TARGET},
  "total_projects": ${TOTAL_PROJECTS},
  "projects_meeting_target": ${PROJECTS_MEETING},
  "reuse_project_rate": ${REUSE_PROJECT_RATE},
  "result": "$([[ "$PROJECTS_MEETING" -ge 2 ]] && echo "PASS" || echo "HOLD")"
}
JSON

echo "Wrote ${OUT_JSON}"
