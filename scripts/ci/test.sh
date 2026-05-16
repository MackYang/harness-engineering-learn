#!/usr/bin/env bash
set -euo pipefail

./scripts/drills/release_rollback_simulation.sh >/tmp/release_rollback_output.txt

if ! grep -q "RECOVERY_STATE=stable" /tmp/release_rollback_output.txt; then
  echo "Test failed: release rollback simulation did not recover"
  exit 1
fi

./scripts/metrics/collect_metrics.sh >/tmp/metrics_output.txt
if [[ ! -s data/metrics/weekly-summary.json ]]; then
  echo "Test failed: metrics output missing"
  exit 1
fi

echo "Integration tests passed"
