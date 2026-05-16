#!/usr/bin/env bash
set -euo pipefail

./evals/scorers/basic_scorer.sh > evals/results.json

if ! grep -q '"pass_rate": 1.0' evals/results.json; then
  echo "Eval failed: pass_rate != 1.0"
  cat evals/results.json
  exit 1
fi

echo "Eval checks passed"
