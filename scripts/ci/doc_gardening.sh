#!/usr/bin/env bash
# doc-gardening.sh — 检查文档新鲜度和质量
# 灵感来源：OpenAI Harness Engineering 的 "doc-gardening" Agent
# 用法：./scripts/ci/doc_gardening.sh [--stale-days 30] [--fix]
set -euo pipefail

STALE_DAYS="${STALE_DAYS:-30}"
FIX_MODE=false
REPO_ROOT="$(git -C "$(dirname "$0")/.." rev-parse --show-toplevel)"
STALE_FILES=()
ISSUES=0

for arg in "$@"; do
  case "$arg" in
    --stale-days=*) STALE_DAYS="${arg#*=}" ;;
    --fix) FIX_MODE=true ;;
  esac
done

echo "=== Doc Gardening Report ==="
echo "Stale threshold: ${STALE_DAYS} days"
echo "Repository: ${REPO_ROOT}"
echo ""

# 1. 检查文档新鲜度
echo "--- Freshness Check ---"
while IFS= read -r -d '' file; do
  # 使用 %ct（Unix 时间戳）而非 %ci + date -d，跨 macOS/Linux 可移植
  # 注：原实现用 GNU date -d 在 macOS（BSD date）下失败，导致所有文件都显示 56 年 stale
  last_commit_ts=$(git -C "$REPO_ROOT" log -1 --format="%ct" -- "$file" 2>/dev/null)
  if [[ -z "$last_commit_ts" ]]; then
    # 未跟踪文件或无 git 历史 — 视为新鲜（刚创建）
    continue
  fi
  days_since=$(( ( $(date +%s) - last_commit_ts ) / 86400 ))
  last_commit_date=$(git -C "$REPO_ROOT" log -1 --format="%ci" -- "$file" 2>/dev/null)
  if (( days_since > STALE_DAYS )); then
    echo "⚠️  STALE (${days_since}d): $file (last updated: ${last_commit_date:0:10})"
    STALE_FILES+=("$file")
    ((ISSUES++)) || true
  fi
done < <(find "$REPO_ROOT/docs" -name "*.md" -print0 2>/dev/null)

if (( ${#STALE_FILES[@]} == 0 )); then
  echo "✅ All docs are fresh (within ${STALE_DAYS} days)"
fi
echo ""

# 2. 检查关键文件存在性
echo "--- Required Files Check ---"
REQUIRED_FILES=(
  "AGENTS.md"
  "ARCHITECTURE.md"
  "CONTRIBUTING.md"
  "docs/status/harness-execution-status.md"
  "docs/handoff/context-handoff.md"
  "evals/feature_list.json"
)
for f in "${REQUIRED_FILES[@]}"; do
  if [[ ! -s "$REPO_ROOT/$f" ]]; then
    echo "❌ MISSING or empty: $f"
    ((ISSUES++))
  else
    echo "✅ $f"
  fi
done
echo ""

# 3. 检查 AGENTS.md 大小（OpenAI 推荐 ~100 行）
echo "--- AGENTS.md Size Check ---"
agents_lines=$(wc -l < "$REPO_ROOT/AGENTS.md" 2>/dev/null || echo 0)
if (( agents_lines < 30 )); then
  echo "⚠️  AGENTS.md is too short (${agents_lines} lines). Target: ~80-120 lines as navigation map."
  ((ISSUES++))
elif (( agents_lines > 200 )); then
  echo "⚠️  AGENTS.md is too long (${agents_lines} lines). Should be ~100 lines, not an encyclopedia."
  ((ISSUES++))
else
  echo "✅ AGENTS.md size OK (${agents_lines} lines)"
fi
echo ""

# 4. 检查知识库索引
echo "--- Knowledge Base Index Check ---"
KB_INDEX="$REPO_ROOT/docs/knowledge/README.md"
if [[ -f "$KB_INDEX" ]]; then
  echo "✅ Knowledge base index exists"
else
  echo "⚠️  Missing docs/knowledge/README.md — knowledge base index"
  ((ISSUES++))
fi
echo ""

# 5. 检查文档交叉链接（简单检查：docs/ 下的 md 文件应至少有一个相对链接）
echo "--- Cross-Link Check (sample) ---"
checked=0
no_links=0
while IFS= read -r -d '' file; do
  has_links=$(grep -cE '\[.*\]\(.*\.(md|json|sh)' "$file" 2>/dev/null || true)
  if [[ -z "$has_links" ]] || [[ "$has_links" == "0" ]]; then
    basename_f=$(basename "$file")
    # 排除一些天然不需要链接的文件
    if [[ "$basename_f" != "README.md" ]] && [[ "$basename_f" != *"-template"* ]]; then
      echo "  INFO: No cross-links found: $file"
      ((no_links++))
    fi
  fi
  ((checked++))
  if (( checked >= 15 )); then break; fi  # 抽样检查
done < <(find "$REPO_ROOT/docs" -name "*.md" -print0 2>/dev/null | sort -z) || true
if (( no_links == 0 )); then
  echo "OK: Sampled ${checked} docs, all have cross-links"
fi
if (( checked == 0 )); then
  echo "OK: No docs to sample"
fi
echo ""

# 6. 检查 feature_list.json 格式
echo "--- Feature List Integrity ---"
FL="$REPO_ROOT/evals/feature_list.json"
if [[ -f "$FL" ]]; then
  if python3 -c "import json; json.load(open('$FL'))" 2>/dev/null; then
    total=$(python3 -c "import json; d=json.load(open('$FL')); print(len(d))")
    passes=$(python3 -c "import json; d=json.load(open('$FL')); print(sum(1 for x in d if x.get('passes')))")
    echo "✅ feature_list.json valid: ${total} features, ${passes} passing"
  else
    echo "❌ feature_list.json is not valid JSON"
    ((ISSUES++))
  fi
else
  echo "⚠️  feature_list.json not found"
  ((ISSUES++))
fi
echo ""

# Summary
echo "=== Summary ==="
if (( ISSUES == 0 )); then
  echo "✅ All checks passed — docs are healthy!"
  exit 0
else
  echo "WARN: Found ${ISSUES} issue(s)"
  if [[ "${FIX_MODE}" == true ]]; then
    echo ""
    echo "Stale docs that need attention:"
    printf '  - %s\n' "${STALE_FILES[@]}"
    echo ""
    echo "Run doc-gardening periodically to keep the knowledge base healthy."
  fi
  exit 1
fi
