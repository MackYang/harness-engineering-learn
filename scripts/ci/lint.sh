#!/usr/bin/env bash
set -euo pipefail

# Enhanced Lint — 品味编码（Encode Taste）
# OpenAI Harness Engineering: "将人类审查反馈转化为文档更新或直接编码到 linter/工具中"
# 核心理念：每个 lint 错误信息必须包含修复指令，让 Agent 看到错误就知道怎么修
# 来源：OpenAI — "Lint errors include fix instructions so agents know what to do"

REPO_ROOT="$(git -C "$(dirname "$0")/.." rev-parse --show-toplevel)"
ERRORS=0
WARNINGS=0
AUTO_FIXABLE=0

# 颜色定义（如果终端支持）
if [[ -t 1 ]]; then
  RED='\033[0;31m'
  YELLOW='\033[0;33m'
  GREEN='\033[0;32m'
  CYAN='\033[0;36m'
  NC='\033[0m'
else
  RED=''
  YELLOW=''
  GREEN=''
  CYAN=''
  NC=''
fi

# 辅助函数：带修复指令的错误输出
error_with_fix() {
  local check_name="$1"
  local details="$2"
  local fix_instruction="$3"
  echo -e "${RED}FAIL${NC} [${check_name}] ${details}"
  echo -e "${CYAN}  FIX: ${fix_instruction}${NC}"
  ((ERRORS++))
}

warning_with_fix() {
  local check_name="$1"
  local details="$2"
  local fix_instruction="$3"
  echo -e "${YELLOW}WARN${NC} [${check_name}] ${details}"
  echo -e "${CYAN}  FIX: ${fix_instruction}${NC}"
  ((WARNINGS++))
}

echo "=== Enhanced Lint Check (Encode Taste v2) ==="

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
    error_with_fix "RequiredFile" "Missing or empty: $f" "Create $f with appropriate content. See CONTRIBUTING.md for template."
  else
    echo -e "${GREEN}PASS${NC} Required file: $f"
  fi
done

if [[ ! -f "$REPO_ROOT/.github/workflows/ci.yml" ]]; then
  error_with_fix "CIWorkflow" ".github/workflows/ci.yml missing" "Create CI workflow that runs 'make verify' on push/PR. See examples/ci-workflow.yml for template."
fi

# ===== AGENTS.md 质量检查 =====
echo ""
echo "--- AGENTS.md Quality ---"
agents_file="$REPO_ROOT/AGENTS.md"
agents_lines=$(wc -l < "$agents_file")

# 必须包含导航/索引关键字
for keyword in "Quick Start" "Navigation" "Mandatory Rules"; do
  if ! grep -qi "$keyword" "$agents_file"; then
    warning_with_fix "AGENTS.mdStructure" "Missing section: $keyword" "Add a '## $keyword' section to AGENTS.md. OpenAI recommends AGENTS.md as a navigation map (~100 lines)."
  fi
done

# 必须有指向 docs/ 的链接
if ! grep -q 'docs/' "$agents_file"; then
  error_with_fix "AGENTS.mdLinks" "No links to docs/ directory" "Add references like 'See docs/knowledge/README.md for knowledge base index.' OpenAI: AGENTS.md should point to deeper sources."
else
  echo -e "${GREEN}PASS${NC} AGENTS.md has docs/ references"
fi

# 不能太长（OpenAI 说 ~100 行）
if (( agents_lines > 200 )); then
  error_with_fix "AGENTS.mdSize" "Too long: ${agents_lines} lines (max 200)" "Split into smaller files in docs/. AGENTS.md should be ~100 lines as a map, not an encyclopedia. Move details to docs/knowledge/ or docs/guides/."
else
  echo -e "${GREEN}PASS${NC} AGENTS.md length: ${agents_lines} lines"
fi

# ===== 状态文件一致性 =====
echo ""
echo "--- Status Consistency ---"
status_file="$REPO_ROOT/docs/status/harness-execution-status.md"
if [[ -f "$status_file" ]]; then
  done_count=$(grep -c '| DONE |' "$status_file" || true)
  total_count=$(grep -cE '\| (DONE|IN_PROGRESS|TODO) \|' "$status_file" || true)
  if (( total_count > 0 )); then
    echo -e "${GREEN}PASS${NC} Status file: ${done_count}/${total_count} tasks DONE"
  else
    warning_with_fix "StatusFormat" "No task entries found in status file" "Add task rows with format: | TODO | task-id | description | "
  fi
else
  error_with_fix "StatusFile" "Status file missing: docs/status/harness-execution-status.md" "Create the file with task status tracking. See docs/status/ for template."
fi

# ===== 任务卡格式检查 =====
echo ""
echo "--- Task Card Format ---"
task_cards="$REPO_ROOT/docs/harness-engineering-task-cards.md"
if [[ -f "$task_cards" ]]; then
  # 每个任务卡应该有 Task ID
  card_count=$(grep -c 'Task ID:' "$task_cards" || true)
  if (( card_count > 0 )); then
    echo -e "${GREEN}PASS${NC} ${card_count} task cards with Task ID"
  else
    warning_with_fix "TaskCardFormat" "No task cards with 'Task ID:' found" "Add 'Task ID: TASK-XXX' to each task card. Format: ## Task\nTask ID: TASK-001"
  fi

  # 每个任务卡应该有验收标准
  verify_count=$(grep -c '验收标准' "$task_cards" || true)
  if (( verify_count > 0 )); then
    echo -e "${GREEN}PASS${NC} ${verify_count} task cards with 验收标准"
  else
    warning_with_fix "TaskCardAcceptance" "No task cards with 验收标准 found" "Add '### 验收标准' section to each task card with measurable criteria. OpenAI: Sprint Contract — agree on completion criteria before implementing."
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
