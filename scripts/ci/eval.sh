#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(git -C "$(dirname "$0")/.." rev-parse --show-toplevel)"

# 1. Schema validation (Generator ≠ Evaluator: 验证数据完整性)
"$REPO_ROOT/scripts/ci/validate_schema.sh"

# 2. Multi-grader evaluation
"$REPO_ROOT/evals/scorers/multi_grader.sh"

echo "Eval checks passed"
