#!/usr/bin/env bash
set -euo pipefail

SIM_DATE="${1:-$(date -v-7d '+%Y-%m-%d' 2>/dev/null || date '+%Y-%m-%d')}"
mkdir -p data/metrics/history data/scaling data/ops data/autonomy

cat > "data/metrics/history/weekly-summary-${SIM_DATE}.json" <<JSON
{
  "date": "${SIM_DATE}",
  "source": "simulated",
  "dora": {
    "lead_time": "simulated_pending",
    "deploy_frequency": "simulated_pending",
    "change_failure_rate": "simulated_pending",
    "mttr": "under_5_minutes_simulated"
  },
  "space": {
    "satisfaction": "simulated_pending",
    "collaboration_efficiency": "simulated_pending",
    "flow_efficiency": "simulated_pending"
  },
  "quality": {
    "eval_pass_rate": "simulated_pending",
    "regression_failure_rate": "simulated_pending",
    "manual_rework_rate": "simulated_pending"
  },
  "note": "Dry-run simulation data, not real production telemetry"
}
JSON

echo "Simulated weekly baseline created for ${SIM_DATE}"
