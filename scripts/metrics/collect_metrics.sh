#!/usr/bin/env bash
set -euo pipefail

OUT="data/metrics/weekly-summary.json"
HISTORY_DIR="data/metrics/history"
CSV_OUT="data/metrics/weekly-summary.csv"
DASHBOARD_OUT="data/metrics/dashboard-input.json"
DATE="${METRICS_DATE:-$(date '+%Y-%m-%d')}"
SOURCE="${METRICS_SOURCE:-local}"

mkdir -p "$(dirname "$OUT")" "$HISTORY_DIR"

GIT_COMMITS=0
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  GIT_COMMITS=$(git rev-list --count HEAD 2>/dev/null || echo 0)
fi

cat > "$OUT" <<JSON
{
  "date": "$DATE",
  "source": "$SOURCE",
  "dora": {
    "lead_time": "pending_remote_pr_data",
    "deploy_frequency": "pending_release_data",
    "change_failure_rate": "pending_release_data",
    "mttr": "under_5_minutes_simulated"
  },
  "space": {
    "satisfaction": "pending_survey",
    "collaboration_efficiency": "pending_pr_data",
    "flow_efficiency": "pending_task_data"
  },
  "quality": {
    "eval_pass_rate": "pending_p2_02",
    "regression_failure_rate": "pending_test_data",
    "manual_rework_rate": "pending_task_data"
  },
  "telemetry": {
    "git_commits": $GIT_COMMITS
  }
}
JSON

cp "$OUT" "$HISTORY_DIR/weekly-summary-${DATE}.json"

TMP_CSV="$(mktemp "${CSV_OUT}.XXXXXX")"
{
  echo "date,source,git_commits,lead_time,deploy_frequency,change_failure_rate,mttr,satisfaction,collaboration_efficiency,flow_efficiency,eval_pass_rate,regression_failure_rate,manual_rework_rate"
  for f in $(ls "$HISTORY_DIR"/weekly-summary-*.json 2>/dev/null | sort); do
    awk '
      /"date":/ {date=$2; gsub(/"|,/, "", date)}
      /"source":/ {source=$2; gsub(/"|,/, "", source)}
      /"lead_time":/ {lead_time=$2; gsub(/"|,/, "", lead_time)}
      /"deploy_frequency":/ {deploy_frequency=$2; gsub(/"|,/, "", deploy_frequency)}
      /"change_failure_rate":/ {change_failure_rate=$2; gsub(/"|,/, "", change_failure_rate)}
      /"mttr":/ {mttr=$2; gsub(/"|,/, "", mttr)}
      /"satisfaction":/ {satisfaction=$2; gsub(/"|,/, "", satisfaction)}
      /"collaboration_efficiency":/ {collaboration_efficiency=$2; gsub(/"|,/, "", collaboration_efficiency)}
      /"flow_efficiency":/ {flow_efficiency=$2; gsub(/"|,/, "", flow_efficiency)}
      /"eval_pass_rate":/ {eval_pass_rate=$2; gsub(/"|,/, "", eval_pass_rate)}
      /"regression_failure_rate":/ {regression_failure_rate=$2; gsub(/"|,/, "", regression_failure_rate)}
      /"manual_rework_rate":/ {manual_rework_rate=$2; gsub(/"|,/, "", manual_rework_rate)}
      /"git_commits":/ {git_commits=$2; gsub(/,/, "", git_commits)}
      END {
        if (git_commits == "") git_commits=0;
        print date "," source "," git_commits "," lead_time "," deploy_frequency "," change_failure_rate "," mttr "," satisfaction "," collaboration_efficiency "," flow_efficiency "," eval_pass_rate "," regression_failure_rate "," manual_rework_rate
      }
    ' "$f"
  done
} > "$TMP_CSV"
mv "$TMP_CSV" "$CSV_OUT"
chmod 644 "$CSV_OUT"

TMP_DASHBOARD="$(mktemp "${DASHBOARD_OUT}.XXXXXX")"
mkdir -p "$(dirname "$DASHBOARD_OUT")"
{
  echo "{"
  echo "  \"generated_at\": \"${DATE}\","
  echo "  \"window_weeks\": 4,"
  echo "  \"trend\": ["

  rows_file="$(mktemp)"
  tail -n +2 "$CSV_OUT" | tail -n 4 > "$rows_file"
  total_rows=$(wc -l < "$rows_file" | tr -d ' ')
  row_index=0
  while IFS= read -r row; do
    IFS=',' read -r row_date row_source row_git_commits row_lead_time row_deploy_frequency row_cfr row_mttr row_satisfaction row_collaboration row_flow row_eval row_regression row_rework <<< "$row"
    comma=","
    if [[ "$row_index" -eq "$((total_rows-1))" ]]; then
      comma=""
    fi
    cat <<JSON
    {
      "week": "${row_date}",
      "source": "${row_source}",
      "telemetry": {
        "git_commits": ${row_git_commits}
      },
      "dora": {
        "lead_time": "${row_lead_time}",
        "deploy_frequency": "${row_deploy_frequency}",
        "change_failure_rate": "${row_cfr}",
        "mttr": "${row_mttr}"
      },
      "space": {
        "satisfaction": "${row_satisfaction}",
        "collaboration_efficiency": "${row_collaboration}",
        "flow_efficiency": "${row_flow}"
      },
      "quality": {
        "eval_pass_rate": "${row_eval}",
        "regression_failure_rate": "${row_regression}",
        "manual_rework_rate": "${row_rework}"
      },
      "kpi_status": "pending_threshold_eval"
    }${comma}
JSON
    row_index=$((row_index + 1))
  done < "$rows_file"
  rm -f "$rows_file"

  echo "  ],"
  echo "  \"note\": \"Dashboard input generated from metrics history\""
  echo "}"
} > "$TMP_DASHBOARD"
mv "$TMP_DASHBOARD" "$DASHBOARD_OUT"
chmod 644 "$DASHBOARD_OUT"

echo "Wrote $OUT"
echo "Wrote $CSV_OUT"
echo "Wrote $DASHBOARD_OUT"
