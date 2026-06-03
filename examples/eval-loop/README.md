# Eval Loop 示例

> 展示 Generator-Evaluator 评估循环 — Harness Engineering 的核心机制
> 核心原则：Generator ≠ Evaluator

## 工作流程

```
┌─────────────┐     ┌─────────────┐
│  Generator  │────→│  Evaluator  │
│  (实现功能)  │     │  (验证功能)  │
└──────┬──────┘     └──────┬──────┘
       │                   │
       │    ┌─────────┐    │
       │    │ Passed? │    │
       │    └────┬────┘    │
       │    No ──┤── Yes   │
       │         │         │
       │    反馈  │    标记 passes=true
       │←────────┘         │
       │                   ▼
       └──→ 修改实现   commit + update
```

## 三种评分器

### Code-Based（确定性）
```bash
# 示例：检查 feature_list.json 中的 feature 是否真的完成
validate_feature() {
  local feature_id=$1
  # 运行对应的测试
  case $feature_id in
    FEAT-001)
      [[ -x init.sh ]] && [[ -f harness-progress.txt ]] && git log --oneline | grep -q "init"
      ;;
    FEAT-002)
      # 验证 Agent 能读取状态
      [[ -f harness-progress.txt ]] && [[ -f evals/feature_list.json ]]
      ;;
  esac
}
```

### Model-Based（LLM 评估）
```python
# 伪代码：用 LLM 评估代码质量
def model_evaluate(code, feature_description):
    prompt = f"""
    Evaluate this implementation against the feature description.
    
    Feature: {feature_description}
    Code: {code}
    
    Score on these dimensions (1-5):
    - Correctness: Does it do what's described?
    - Quality: Is the code clean and maintainable?
    - Completeness: Are edge cases handled?
    """
    return llm.call(prompt)
```

### Human（人工评估）
```markdown
## 人工评估清单
- [ ] 功能符合预期描述
- [ ] 代码风格与项目一致
- [ ] 边界情况已处理
- [ ] 文档已更新
```

## Sprint Contract 示例

在实现前，Generator 和 Evaluator 协商完成标准：

```json
{
  "feature_id": "FEAT-001",
  "sprint_contract": {
    "generator_commits": [
      "init.sh exists and is executable",
      "harness-progress.txt created",
      "Initial git commit exists"
    ],
    "evaluator_verifies": [
      "File exists check: test -x init.sh",
      "File exists check: test -f harness-progress.txt",
      "Git log check: git log --oneline | head -1"
    ],
    "done_when": "ALL evaluator checks pass"
  }
}
```

## 关键原则

- **独立验证**：评估者不是实现者
- **真实工具**：用真正可运行的测试，不要只看代码
- **Sprint Contract**：先协商标准，再实现
- **多维度评分**：代码评分 + 模型评分 + 人工评分

## 参考

- `docs/knowledge/patterns/eval-patterns.md` — 完整评估模式说明
- `evals/scorers/multi_grader.sh` — 实际评分器
