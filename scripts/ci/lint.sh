#!/usr/bin/env bash
set -euo pipefail

required=(
  "ARCHITECTURE.md"
  "CONTRIBUTING.md"
  "AGENTS.md"
  "docs/harness-engineering-task-cards.md"
  "docs/status/harness-execution-status.md"
)

for f in "${required[@]}"; do
  if [[ ! -s "$f" ]]; then
    echo "Lint failed: required file missing or empty -> $f"
    exit 1
  fi
done

if [[ ! -f ".github/workflows/ci.yml" ]]; then
  echo "Lint failed: .github/workflows/ci.yml missing"
  exit 1
fi

echo "Lint checks passed"
