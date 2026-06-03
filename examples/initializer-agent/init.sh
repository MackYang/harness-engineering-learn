#!/usr/bin/env bash
# init.sh — Initializer Agent 的环境初始化脚本
# 这是 Harness Engineering "双 Agent 架构" 中 Initializer Agent 的核心产物
# 参见：docs/knowledge/patterns/eval-patterns.md
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
echo "=== Initializer Agent: Setting up environment ==="
echo "Project dir: $PROJECT_DIR"

# 1. 创建进度文件
PROGRESS_FILE="$PROJECT_DIR/harness-progress.txt"
if [[ ! -f "$PROGRESS_FILE" ]]; then
  cat > "$PROGRESS_FILE" << 'EOF'
# Harness Progress Log
# 格式：[timestamp] STATUS: feature_id - description
# 状态：STARTED | PASSED | FAILED | BLOCKED

EOF
  echo "[$(date -Iseconds)] INIT: Environment initialized" >> "$PROGRESS_FILE"
  echo "✅ Created harness-progress.txt"
else
  echo "ℹ️  harness-progress.txt already exists"
fi

# 2. 验证 feature_list.json 存在
FEATURE_LIST="$PROJECT_DIR/evals/feature_list.json"
if [[ -f "$FEATURE_LIST" ]]; then
  echo "✅ feature_list.json exists"
  # 统计待完成功能
  total=$(python3 -c "import json; print(len(json.load(open('$FEATURE_LIST'))))" 2>/dev/null || echo "?")
  echo "   Total features: $total"
else
  echo "⚠️  feature_list.json not found — create one with all features set to passes:false"
fi

# 3. 验证必要的脚本可执行
for script in scripts/ci/lint.sh scripts/ci/test.sh scripts/ci/eval.sh; do
  full_path="$PROJECT_DIR/$script"
  if [[ -f "$full_path" ]]; then
    chmod +x "$full_path"
    echo "✅ $script is executable"
  else
    echo "⚠️  $script not found"
  fi
done

# 4. 初始 git commit（如果没有）
if git -C "$PROJECT_DIR" diff --quiet && git -C "$PROJECT_DIR" diff --cached --quiet; then
  echo "ℹ️  Working tree clean"
else
  echo "⚠️  Uncommitted changes detected — consider committing before starting work"
fi

# 5. 检查知识库索引
KB_INDEX="$PROJECT_DIR/docs/knowledge/README.md"
if [[ -f "$KB_INDEX" ]]; then
  echo "✅ Knowledge base index exists"
else
  echo "⚠️  docs/knowledge/README.md missing — Agent won't know where to find info"
fi

echo ""
echo "=== Initialization Complete ==="
echo "Next step: Run Coding Agent to start working on features"
echo "  1. Read harness-progress.txt to see current state"
  echo "  2. Pick the next uncompleted feature from feature_list.json"
  echo "  3. Implement it"
  echo "  4. Run 'make eval' to verify"
  echo "  5. Commit and update progress"
