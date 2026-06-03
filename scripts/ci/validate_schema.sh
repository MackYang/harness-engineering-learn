#!/usr/bin/env bash
# validate_schema.sh — 验证 JSON 文件的 schema 完整性
# OpenAI Harness Engineering 核心原则：Generator ≠ Evaluator
set -euo pipefail

REPO_ROOT="$(git -C "$(dirname "$0")/.." rev-parse --show-toplevel)"
ERRORS=0

echo "=== Schema Validation ==="

# 1. 验证 feature_list.json
FL="$REPO_ROOT/evals/feature_list.json"
if [[ -f "$FL" ]]; then
  echo "Checking feature_list.json..."
  python3 -c "
import json, sys

with open('$FL') as f:
    data = json.load(f)

errors = []
required_fields = ['id', 'category', 'description', 'steps', 'passes', 'priority']
valid_priorities = ['P0', 'P1', 'P2', 'P3', 'P4', 'P5']

for i, feat in enumerate(data):
    for field in required_fields:
        if field not in feat:
            errors.append(f'  FEAT-{i}: missing field \"{field}\"')
        elif field == 'steps' and not isinstance(feat['steps'], list):
            errors.append(f'  {feat.get(\"id\", \"?\")}: steps must be a list')
        elif field == 'passes' and not isinstance(feat['passes'], bool):
            errors.append(f'  {feat.get(\"id\", \"?\")}: passes must be boolean')
        elif field == 'priority' and feat['priority'] not in valid_priorities:
            errors.append(f'  {feat.get(\"id\", \"?\")}: invalid priority \"{feat[\"priority\"]}\"')

if errors:
    for e in errors:
        print(f'❌ {e}')
    sys.exit(1)
else:
    print(f'✅ All {len(data)} features have valid schema')
"
else
  echo "❌ feature_list.json not found"
  ((ERRORS++))
fi

# 2. 验证 harness-execution-status.md 格式
STATUS="$REPO_ROOT/docs/status/harness-execution-status.md"
if [[ -f "$STATUS" ]]; then
  echo "Checking harness-execution-status.md..."
  if grep -qE '\| (DONE|IN_PROGRESS|BLOCKED|NOT_STARTED) \|' "$STATUS"; then
    done_count=$(grep -c '| DONE |' "$STATUS" || true)
    echo "✅ Status file has valid entries (${done_count} DONE tasks)"
  else
    echo "❌ Status file has no valid task status entries"
    ((ERRORS++))
  fi
else
  echo "❌ harness-execution-status.md not found"
  ((ERRORS++))
fi

# 3. 验证知识库索引
KB_INDEX="$REPO_ROOT/docs/knowledge/README.md"
if [[ -f "$KB_INDEX" ]]; then
  echo "✅ Knowledge base index exists"
else
  echo "❌ docs/knowledge/README.md missing"
  ((ERRORS++))
fi

# 4. 验证交接文件存在且内容不为空
HANDOFF="$REPO_ROOT/docs/handoff/context-handoff.md"
if [[ -s "$HANDOFF" ]]; then
  echo "✅ Handoff file exists and has content"
else
  echo "⚠️  Handoff file is empty or missing"
  ((ERRORS++))
fi

echo ""
if (( ERRORS == 0 )); then
  echo "✅ All schema validations passed"
  exit 0
else
  echo "❌ ${ERRORS} schema validation error(s) found"
  exit 1
fi
