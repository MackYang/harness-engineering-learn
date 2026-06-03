# Coding Agent 示例

> 展示 Coding Agent 的工作方式 — 增量式实现，一次一个 feature

## 工作流程

```
Coding Agent 每次启动
  ├── 1. 读取 git log --oneline -20 → 了解最近变更
  ├── 2. 读取 harness-progress.txt → 了解整体进度
  ├── 3. 读取 feature_list.json → 找到下一个 passes:false 的 feature
  ├── 4. 实现该 feature（只做一个）
  ├── 5. 运行 make eval → 验证
  ├── 6. 如果通过 → git commit + 更新 progress
  └── 7. 如果失败 → 记录失败原因，等待下一次 session
```

## 伪代码

```python
# coding_agent.py (伪代码，展示逻辑)
import json, subprocess

def run():
    # Step 1: 了解当前状态
    git_log = run_cmd("git log --oneline -20")
    progress = read_file("harness-progress.txt")
    
    # Step 2: 找到下一个待完成的 feature
    features = json.load(open("evals/feature_list.json"))
    next_feature = next(
        (f for f in features if not f["passes"]), 
        None
    )
    
    if not next_feature:
        print("All features done! 🎉")
        return
    
    # Step 3: 实现该 feature（关键：只做一个）
    print(f"Working on: {next_feature['id']} - {next_feature['description']}")
    implement(next_feature)
    
    # Step 4: 验证
    result = run_cmd("make eval")
    
    # Step 5: 根据结果更新
    if result.success:
        next_feature["passes"] = True
        json.dump(features, open("evals/feature_list.json", "w"), indent=2)
        run_cmd("git add -A && git commit -m 'feat: complete {next_feature[\"id\"]}'")
        append_to_progress(f"PASSED: {next_feature['id']}")
    else:
        append_to_progress(f"FAILED: {next_feature['id']} - {result.error}")
```

## 关键原则

- **增量优先**：一次只做一个 feature
- **外部记忆**：所有状态写在文件里
- **独立验证**：实现后必须用 make eval 验证
- **JSON > Markdown**：feature list 用 JSON（模型更不容易篡改）

## 参考

- `docs/knowledge/patterns/eval-patterns.md` — 评估模式
- `docs/knowledge/principles/golden-rules.md` — 黄金原则
