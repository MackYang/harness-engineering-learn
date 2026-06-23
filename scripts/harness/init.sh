#!/usr/bin/env bash
# Harness Initialization Script
# Sets up the environment for a long-running agent session
# Reference: Anthropic "Effective harnesses for long-running agents"

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# 注：init.sh 位于 scripts/harness/，需要上两级才到仓库根。
# 原实现只上一级（指向 scripts/），导致所有 PROJECT_ROOT/* 路径错误并在 scripts/ 下创建 stray 文件。
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
PROGRESS_FILE="$PROJECT_ROOT/harness-progress.txt"
FEATURE_LIST="$PROJECT_ROOT/evals/feature_list.json"

echo "=== Harness Environment Initialization ==="
echo "Working directory: $(pwd)"
echo "Project root: $PROJECT_ROOT"
echo ""

# 1. Verify core files exist
echo "[1/5] Verifying core files..."
required_files=(
  "ARCHITECTURE.md"
  "AGENTS.md"
  "CONTRIBUTING.md"
  "Makefile"
  "docs/harness-engineering-task-cards.md"
  "docs/status/harness-execution-status.md"
)
for f in "${required_files[@]}"; do
  if [[ -f "$PROJECT_ROOT/$f" ]]; then
    echo "  ✓ $f"
  else
    echo "  ✗ $f MISSING"
  fi
done

# 2. Read git history
echo ""
echo "[2/5] Recent git history (last 10 commits):"
cd "$PROJECT_ROOT"
git log --oneline -10 2>/dev/null || echo "  No git history"

# 3. Initialize progress file if not exists
echo ""
echo "[3/5] Progress file..."
if [[ -f "$PROGRESS_FILE" ]]; then
  echo "  Progress file exists, last 5 entries:"
  tail -5 "$PROGRESS_FILE"
else
  echo "  Creating new progress file..."
  cat > "$PROGRESS_FILE" <<EOF
# Harness Progress Log
# Format: [TIMESTAMP] [SESSION_ID] [STATUS] [FEATURE_ID] [DESCRIPTION]
# Initialized: $(date -Iseconds)
EOF
  echo "  ✓ Created harness-progress.txt"
fi

# 4. Feature list status
echo ""
echo "[4/5] Feature list status..."
if [[ -f "$FEATURE_LIST" ]]; then
  total=$(python3 -c "import json; d=json.load(open('$FEATURE_LIST')); print(len(d))" 2>/dev/null || echo "?")
  passed=$(python3 -c "import json; d=json.load(open('$FEATURE_LIST')); print(sum(1 for f in d if f.get('passes')))" 2>/dev/null || echo "?")
  echo "  Total features: $total"
  echo "  Passed: $passed"
  echo "  Remaining: $(python3 -c "import json; d=json.load(open('$FEATURE_LIST')); print(sum(1 for f in d if not f.get('passes')))" 2>/dev/null || echo "?")"
else
  echo "  ✗ Feature list not found at $FEATURE_LIST"
fi

# 5. Verify build/test/lint commands
echo ""
echo "[5/5] Build system check..."
cd "$PROJECT_ROOT"
if make lint 2>/dev/null; then
  echo "  ✓ Lint passed"
else
  echo "  ✗ Lint failed (run 'make lint' for details)"
fi

echo ""
echo "=== Initialization Complete ==="
echo "Next: Read harness-progress.txt, pick next feature from feature_list.json"
