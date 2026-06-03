#!/usr/bin/env bash
set -euo pipefail

# Enhanced Lint — 品味编码（Encode Taste）
# OpenAI Harness Engineering: "当文档不够完善时，将规则转化为代码"
# 这个 linter 机械地强制执行文档和代码质量规则

REPO_ROOT="$(git -C "$(dirname "$0")/.." rev-parse --show-toplevel)"
ERRORS=0
WARNINGS=0

echo "=== Enhanced Lint Check ==="

# ===== 基础文件存在性检查 =====
echo "--- Required Files ---"
required=(
  "ARCHITECTURE.md"
  "CONTRIBUTING.md"
  "AGENTS.md"
  "docs/harness-engineering-task-cards.md"
  "docs/status/harness-execution-status.md"
)

for f in "${required[@]}"; do
  if [[ ! -s "$REPO_ROOT/$f" ]]; then
    echo "❌ Required file missing or empty -> $f"
    ((ERRORS++))
  else
    echo "✅ $f"
  fi
done

if [[ ! -f "$REPO_ROOT/.github/workflows/ci.yml" ]]; then
  echo "❌ .github/workflows/ci.yml missing"
  ((ERRORS++))
fi

# ===== AGENTS.md 质量检查 =====
echo ""
echo "--- AGENTS.md Quality ---"
agents_file="$REPO_ROOT/AGENTS.md"
agents_lines=$(wc -l < "$agents_file")

# 必须包含导航/索引关键字
for keyword in "Quick Start" "Navigation" "Mandatory Rules"; do
  if ! grep -qi "$keyword" "$agents_file"; then
    echo "⚠️  AGENTS.md missing section: $keyword"
    ((WARNINGS++))
  fi
done

# 必须有指向 docs/ 的链接
if ! grep -q 'docs/' "$agents_file"; then
  echo "❌ AGENTS.md has no links to docs/ directory"
  ((ERRORS++))
else
  echo "✅ AGENTS.md has docs/ references"
fi

# 不能太长（OpenAI 说 ~100 行）
if (( agents_lines > 200 )); then
  echo "❌ AGENTS.md is too long (${agents_lines} lines, max 200)"
  ((ERRORS++))
else
  echo "✅ AGENTS.md length OK (${agents_lines} lines)"
fi

# ===== 状态文件一致性 =====
echo ""
echo "--- Status Consistency ---"
status_file="$REPO_ROOT/docs/status/harness-execution-status.md"
if [[ -f "$status_file" ]]; then
  done_count=$(grep -c '| DONE |' "$status_file" || true)
  echo "OK: Status file has ${done_count} DONE entries"
fi

# ===== 任务卡格式检查 =====
echo ""
echo "--- Task Card Format ---"
task_cards="$REPO_ROOT/docs/harness-engineering-task-cards.md"
if [[ -f "$task_cards" ]]; then
  # 每个任务卡应该有 Task ID
  card_count=$(grep -c 'Task ID:' "$task_cards" || true)
  if (( card_count > 0 )); then
    echo "✅ Found ${card_count} task cards with Task ID"
  else
    echo "⚠️  No task cards with 'Task ID:' found"
    ((WARNINGS++))
  fi

  # 每个任务卡应该有验收标准
  verify_count=$(grep -c '验收标准' "$task_cards" || true)
  if (( verify_count > 0 )); then
    echo "✅ Found ${verify_count} task cards with 验收标准"
  else
    echo "⚠️  No task cards with 验收标准 found"
    ((WARNINGS++))
  fi
fi

# ===== Markdown 质量检查 =====
echo ""
echo "--- Markdown Quality ---"
bad_md_count=0
while IFS= read -r -d '' file; do
  # 检查常见问题：trailing whitespace, 没有 newline at EOF
  if grep -qP '\s+$' "$file" 2>/dev/null; then
    echo "ℹ️  Trailing whitespace: $file"
    ((bad_md_count++))
  fi
done < <(find "$REPO_ROOT/docs" -name "*.md" -print0 2>/dev/null | head -20 -z)

if (( bad_md_count == 0 )); then
  echo "✅ No trailing whitespace issues (sampled)"
fi

# ===== Summary =====
echo ""
echo "=== Lint Summary ==="
echo "Errors: ${ERRORS}"
echo "Warnings: ${WARNINGS}"

if (( ERRORS > 0 )); then
  echo "❌ Lint failed with ${ERRORS} error(s)"
  exit 1
else
  if (( WARNINGS > 0 )); then
    echo "⚠️  Lint passed with ${WARNINGS} warning(s)"
  else
    echo "✅ All lint checks passed"
  fi
  exit 0
fi
