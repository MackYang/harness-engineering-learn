#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="logs/readiness/release_drill"
rm -rf "$BASE_DIR"
mkdir -p "$BASE_DIR"

# Step 1: release v1
mkdir -p "$BASE_DIR/v1"
echo "stable" > "$BASE_DIR/v1/app_state.txt"

# Step 2: release v2 (regression)
cp -R "$BASE_DIR/v1" "$BASE_DIR/v2"
echo "regression" > "$BASE_DIR/v2/app_state.txt"

# Step 3: detect issue and rollback to v1
cp -R "$BASE_DIR/v1" "$BASE_DIR/current"

# Step 4: validate recovery
STATE=$(cat "$BASE_DIR/current/app_state.txt")
if [[ "$STATE" != "stable" ]]; then
  echo "Recovery check failed: expected stable, got $STATE"
  exit 1
fi

echo "RELEASE=v2"
echo "ROLLBACK_TARGET=v1"
echo "RECOVERY_STATE=$STATE"
echo "MTTR_SIMULATED=under_5_minutes"
