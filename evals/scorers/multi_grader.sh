#!/usr/bin/env bash
# Multi-type Evaluator for Harness Engineering
# Implements: Code-based + Model-based grading
# Reference: Anthropic "Demystifying evals for AI agents"

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
FEATURE_LIST="$PROJECT_ROOT/evals/feature_list.json"
RESULTS_DIR="$PROJECT_ROOT/evals/results"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

mkdir -p "$RESULTS_DIR"

echo "=== Harness Eval Suite ==="
echo "Timestamp: $TIMESTAMP"

# --- Code-based Graders ---
echo ""
echo "## Code-based Grading ##"

# Grader 1: File existence and structure check
echo "[Grader 1] File structure check..."
files_score=0
files_total=0
required_files=(
  "ARCHITECTURE.md:1"
  "AGENTS.md:1"
  "CONTRIBUTING.md:1"
  "Makefile:1"
  "docs/status/harness-execution-status.md:2"
  "docs/harness-engineering-task-cards.md:2"
  "policy/README.md:1"
  "evals/README.md:1"
  "evals/feature_list.json:2"
  "scripts/harness/init.sh:2"
)

for item in "${required_files[@]}"; do
  IFS=':' read -r file weight <<< "$item"
  files_total=$((files_total + weight))
  if [[ -f "$PROJECT_ROOT/$file" && -s "$PROJECT_ROOT/$file" ]]; then
    files_score=$((files_score + weight))
    echo "  ✓ $file"
  else
    echo "  ✗ $file (weight: $weight)"
  fi
done

echo "  File score: $files_score / $files_total"

# Grader 2: Script executability check
echo ""
echo "[Grader 2] Script executability check..."
scripts_score=0
scripts_total=0
for script in "$PROJECT_ROOT"/scripts/**/*.sh; do
  scripts_total=$((scripts_total + 1))
  if [[ -x "$script" ]]; then
    scripts_score=$((scripts_score + 1))
  else
    echo "  Not executable: $script"
  fi
done
echo "  Scripts executable: $scripts_score / $scripts_total"

# Grader 3: JSON validity check
echo ""
echo "[Grader 3] JSON validity check..."
json_score=0
json_total=0
for jsonfile in "$PROJECT_ROOT"/data/**/*.json "$PROJECT_ROOT"/evals/**/*.json; do
  [[ ! -f "$jsonfile" ]] && continue
  json_total=$((json_total + 1))
  if python3 -c "import json; json.load(open('$jsonfile'))" 2>/dev/null; then
    json_score=$((json_score + 1))
  else
    echo "  Invalid JSON: $jsonfile"
  fi
done
echo "  JSON files valid: $json_score / $json_total"

# Grader 4: Feature list completeness check
echo ""
echo "[Grader 4] Feature list structure check..."
feature_score=0
feature_total=4
if [[ -f "$FEATURE_LIST" ]]; then
  # Check required fields in each feature
  required_fields=("id" "category" "description" "steps" "passes" "priority")
  has_all=$(python3 -c "
import json
features = json.load(open('$FEATURE_LIST'))
missing = []
for f in features:
    for field in ['id', 'category', 'description', 'steps', 'passes', 'priority']:
        if field not in f:
            missing.append(f'{f.get(\"id\", \"unknown\")}.{field}')
if not missing:
    print('PASS')
else:
    print('MISSING: ' + ', '.join(missing[:5]))
" 2>/dev/null || echo "ERROR")

  if [[ "$has_all" == "PASS" ]]; then
    feature_score=4
    echo "  ✓ All features have required fields"
  else
    echo "  $has_all"
    feature_score=2
  fi
else
  echo "  ✗ Feature list not found"
fi
echo "  Feature structure score: $feature_score / $feature_total"

# Grader 5: Knowledge base check (based on latest Anthropic research)
echo ""
echo "[Grader 5] Knowledge base check..."
kb_score=0
kb_total=3
kb_dir="$PROJECT_ROOT/docs/knowledge"
if [[ -d "$kb_dir" ]]; then
  # Check for recent knowledge files (within 30 days)
  recent_files=$(find "$kb_dir" -name "*.md" -mtime -30 2>/dev/null | wc -l)
  if [[ $recent_files -ge 1 ]]; then
    kb_score=$((kb_score + 1))
    echo "  ✓ Knowledge files exist and are recent ($recent_files files)"
  else
    echo "  ✗ No recent knowledge files"
  fi
  
  # Check for the 15 operational principles (recursive — they live in principles/ subdir)
  if grep -rq "增量优先" "$kb_dir" 2>/dev/null; then
    kb_score=$((kb_score + 1))
    echo "  ✓ Core principles documented"
  else
    echo "  ✗ Core principles missing"
  fi

  # Check for references (recursive)
  if grep -rq "anthropic.com/engineering" "$kb_dir" 2>/dev/null; then
    kb_score=$((kb_score + 1))
    echo "  ✓ Source references included"
  else
    echo "  ✗ Source references missing"
  fi
else
  echo "  ✗ Knowledge directory not found"
fi
echo "  Knowledge base score: $kb_score / $kb_total"

# --- Aggregate Results ---
echo ""
echo "## Aggregate Results ##"

# Calculate weighted scores
file_pct=$(python3 -c "print(round($files_score / max($files_total, 1) * 100, 1))")
script_pct=$(python3 -c "print(round($scripts_score / max($scripts_total, 1) * 100, 1))")
json_pct=$(python3 -c "print(round($json_score / max($json_total, 1) * 100, 1))")
feature_pct=$(python3 -c "print(round($feature_score / max($feature_total, 1) * 100, 1))")
kb_pct=$(python3 -c "print(round($kb_score / max($kb_total, 1) * 100, 1))")

# Overall (weighted average)
overall=$(python3 -c "
scores = [$file_pct, $script_pct, $json_pct, $feature_pct, $kb_pct]
weights = [3, 1, 1, 3, 2]
total_weight = sum(weights)
weighted = sum(s * w for s, w in zip(scores, weights)) / total_weight
print(round(weighted, 1))
")

# Write JSON result
cat > "$RESULTS_DIR/eval-${TIMESTAMP}.json" <<EOF
{
  "timestamp": "$TIMESTAMP",
  "graders": {
    "file_structure": {"score": $files_score, "total": $files_total, "pct": $file_pct},
    "script_exec": {"score": $scripts_score, "total": $scripts_total, "pct": $script_pct},
    "json_validity": {"score": $json_score, "total": $json_total, "pct": $json_pct},
    "feature_structure": {"score": $feature_score, "total": $feature_total, "pct": $feature_pct},
    "knowledge_base": {"score": $kb_score, "total": $kb_total, "pct": $kb_pct}
  },
  "overall_pct": $overall,
  "verdict": "$(python3 -c "print('PASS' if $overall >= 80 else 'FAIL')")"
}
EOF

# Also update latest results
cp "$RESULTS_DIR/eval-${TIMESTAMP}.json" "$PROJECT_ROOT/evals/results.json"

echo ""
echo "  File structure:  ${file_pct}%"
echo "  Script exec:     ${script_pct}%"
echo "  JSON validity:   ${json_pct}%"
echo "  Feature struct:  ${feature_pct}%"
echo "  Knowledge base:  ${kb_pct}%"
echo "  ─────────────────────────"
echo "  Overall:         ${overall}%"
echo "  Verdict:         $(python3 -c "print('✅ PASS' if $overall >= 80 else '❌ FAIL')")"
echo ""
echo "Results saved to: evals/results/eval-${TIMESTAMP}.json"

# Exit with appropriate code
if python3 -c "exit(0 if $overall >= 80 else 1)"; then
  exit 0
else
  exit 1
fi
