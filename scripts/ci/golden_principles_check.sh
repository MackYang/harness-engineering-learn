#!/usr/bin/env bash
set -uo pipefail
# 注意：不用 set -e，手动处理退出码

# Golden Principles Check — 品味自动扫描
# OpenAI Harness Engineering: "On a regular cadence, background Codex tasks scan
# for deviations, update quality grades, and open targeted refactoring PRs."
#
# 本脚本检查仓库是否偏离 golden principles，输出结构化报告。
# 用法：./scripts/ci/golden_principles_check.sh [--json]
# 可集成到 CI 或 cron job 中定期运行。

REPO_ROOT="$(git -C "$(dirname "$0")/.." rev-parse --show-toplevel)"
JSON_MODE=false
VIOLATIONS=0
CHECKS=0
PASSED=0

for arg in "$@"; do
  case "$arg" in
    --json) JSON_MODE=true ;;
  esac
done

declare -a RESULTS=()

log_pass() {
  local name="$1"
  ((CHECKS++)) || true
  ((PASSED++)) || true
  RESULTS+=("{\"name\":\"$name\",\"status\":\"PASS\"}")
  [[ "$JSON_MODE" != true ]] && echo "PASS [$name]"
}

log_fail() {
  local name="$1"
  local desc="$2"
  local fix="$3"
  ((CHECKS++)) || true
  ((VIOLATIONS++)) || true
  RESULTS+=("{\"name\":\"$name\",\"status\":\"FAIL\",\"description\":\"$desc\",\"fix\":\"$fix\"}")
  [[ "$JSON_MODE" != true ]] && { echo "FAIL [$name] $desc"; echo "  FIX: $fix"; }
}

if [[ "$JSON_MODE" != true ]]; then
  echo "=== Golden Principles Check ==="
  echo "Repository: $REPO_ROOT"
  echo ""
fi

# GP-01: AGENTS.md 是地图不是百科
agents_lines=$(wc -l < "$REPO_ROOT/AGENTS.md")
if (( agents_lines <= 200 )); then
  log_pass "GP-01"
else
  log_fail "GP-01" "AGENTS.md too long (${agents_lines} lines, max 200)" "Split into smaller files in docs/. Keep AGENTS.md as map only."
fi

# GP-02: AGENTS.md 必须指向 docs/
if grep -q 'docs/' "$REPO_ROOT/AGENTS.md"; then
  log_pass "GP-02"
else
  log_fail "GP-02" "AGENTS.md has no docs/ references" "Add links to docs/ subdirectories for progressive disclosure."
fi

# GP-03: 知识库有索引
if [[ -s "$REPO_ROOT/docs/knowledge/README.md" ]]; then
  log_pass "GP-03"
else
  log_fail "GP-03" "Knowledge base index missing" "Create docs/knowledge/README.md listing all knowledge files."
fi

# GP-04: feature_list.json 有效且 >= 10 个
if python3 -c "import json; d=json.load(open('$REPO_ROOT/evals/feature_list.json')); assert len(d) >= 10" 2>/dev/null; then
  log_pass "GP-04"
else
  log_fail "GP-04" "feature_list.json invalid or too few features" "Fix evals/feature_list.json. Must be valid JSON with >= 10 features."
fi

# GP-05: 架构文档存在
if [[ -s "$REPO_ROOT/ARCHITECTURE.md" ]]; then
  log_pass "GP-05"
else
  log_fail "GP-05" "ARCHITECTURE.md missing" "Create ARCHITECTURE.md describing system layers and dependencies."
fi

# GP-06: 脚本中无波浪号路径
tilde_files=$(grep -rE '(~|\$HOME)/' "$REPO_ROOT/scripts/" --include='*.sh' -l 2>/dev/null || true)
if [[ -z "$tilde_files" ]]; then
  log_pass "GP-06"
else
  log_fail "GP-06" "Shell scripts contain tilde/\$HOME paths: $tilde_files" "Replace ~ with absolute paths. Tilde breaks in isolated environments."
fi

# GP-07: 脚本有 set -euo pipefail
no_strict=$(grep -rL 'set -euo pipefail' "$REPO_ROOT/scripts/" --include='*.sh' 2>/dev/null || true)
if [[ -z "$no_strict" ]]; then
  log_pass "GP-07"
else
  log_fail "GP-07" "Scripts missing 'set -euo pipefail': $no_strict" "Add 'set -euo pipefail' after shebang in all shell scripts."
fi

# GP-08: 知识笔记文件名有日期
if ls "$REPO_ROOT/docs/knowledge/sources/"*.md 2>/dev/null | grep -qE '[0-9]{4}-[0-9]{2}-[0-9]{2}'; then
  log_pass "GP-08"
else
  log_fail "GP-08" "Knowledge source files not date-stamped" "Rename notes with format: {source}-YYYY-MM-DD.md"
fi

# GP-09: 没有超过 500 行的 Markdown（navigation 类）
# OpenAI 原则针对的是 navigation 文件（"给地图不给说明书"），不是 reference 文件。
# 因此：默认检查 docs/ 下所有 .md；但允许通过文件顶部标记 <!-- gp-09-exempt: <reason> --> 显式豁免。
oversized=""
while IFS= read -r -d '' f; do
  lines=$(wc -l < "$f")
  if (( lines > 500 )); then
    # 检查前 20 行是否有豁免标记
    if ! head -20 "$f" | grep -q 'gp-09-exempt'; then
      oversized="$oversized $f"
    fi
  fi
done < <(find "$REPO_ROOT/docs" -name '*.md' -print0 2>/dev/null)
if [[ -z "${oversized// /}" ]]; then
  log_pass "GP-09"
else
  log_fail "GP-09" "Oversized docs (>500 lines without gp-09-exempt marker):$oversized" "Split large files, OR add '<!-- gp-09-exempt: <reason> -->' to the top of the file if it's a legitimate reference doc (not navigation)."
fi

# GP-10: 文档新鲜度（60 天内更新过）
total_docs=$(find "$REPO_ROOT/docs" -name '*.md' | wc -l)
fresh_docs=$(find "$REPO_ROOT/docs" -name '*.md' -newermt '60 days ago' | wc -l)
if (( total_docs == 0 )) || (( fresh_docs * 100 / total_docs >= 50 )); then
  log_pass "GP-10"
else
  log_fail "GP-10" "Only ${fresh_docs}/${total_docs} docs updated in last 60 days" "Run 'make garden' and update stale documentation."
fi

# GP-11: Lint 包含修复指令（OpenAI Encode Taste）
if grep -q 'FIX:' "$REPO_ROOT/scripts/ci/lint.sh"; then
  log_pass "GP-11"
else
  log_fail "GP-11" "Lint script lacks fix instructions" "Add 'FIX:' lines to every error in lint.sh. OpenAI: agents need to know how to fix."
fi

# GP-12: README 标注权威知识来源
if grep -q 'OpenAI' "$REPO_ROOT/README.md" && grep -q 'Anthropic' "$REPO_ROOT/README.md"; then
  log_pass "GP-12"
else
  log_fail "GP-12" "README does not declare authoritative knowledge sources" "Add OpenAI + Anthropic as authoritative sources in README."
fi

# Summary
if [[ "$JSON_MODE" == true ]]; then
  echo "["
  for i in "${!RESULTS[@]}"; do
    (( i > 0 )) && echo ","
    echo -n "  ${RESULTS[$i]}"
  done
  echo ""
  echo "]"
else
  echo ""
  echo "=== Summary ==="
  echo "Checks: ${CHECKS} | Passed: ${PASSED} | Violations: ${VIOLATIONS}"
  echo ""
  if (( VIOLATIONS == 0 )); then
    echo "PASS: All golden principles satisfied!"
  else
    echo "FAIL: ${VIOLATIONS} principle(s) violated. See FIX instructions above."
    echo ""
    echo "OpenAI: 'Background tasks scan for deviations, update quality grades,"
    echo "and open targeted refactoring PRs.'"
  fi
fi

exit $VIOLATIONS
