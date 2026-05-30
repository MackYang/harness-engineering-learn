#!/usr/bin/env bash
set -euo pipefail

# Use multi-grader for comprehensive evaluation
./evals/scorers/multi_grader.sh

echo "Eval checks passed"
