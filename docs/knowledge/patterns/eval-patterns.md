# 评估模式（Eval Patterns）

> 核心原则：Generator ≠ Evaluator — 实现和评估必须分离
> 来源：Anthropic + OpenAI Harness Engineering

## 为什么需要独立评估？

1. **Self-Evaluation Bias**：Agent 对自己的工作过于自信
2. **Context Anxiety**：接近上下文限制时会过早结束并声称完成
3. **缺乏真正验证**：没有真实工具的评估只是"自以为完成了"

## 三种评分器类型

### 1. Code-Based Grader（代码评分器）
- 运行单元测试、集成测试
- 检查 JSON schema、文件存在性
- 确定性，可重复

### 2. Model-Based Grader（模型评分器）
- LLM 评估代码质量、设计一致性
- 按维度评分（设计质量、原创性、工艺、功能性）
- 适合主观评估

### 3. Human Grader（人工评分器）
- 最终仲裁者
- 审查 Agent 无法判断的领域
- 随着系统成熟，逐步减少

## Sprint Contract 机制

Generator 和 Evaluator 在实现前先协商"完成标准"：
- 避免因规格高层模糊导致的实现偏差
- 两个 Agent 迭代直到达成一致
- 完成标准写进 feature_list.json 的 steps 字段

## 双 Agent 架构（Anthropic 方案）

```
Initializer Agent（首次运行）
  ├── 创建 init.sh
  ├── 创建 progress file
  ├── 创建 feature_list.json（全部为 failing）
  └── 初始 git commit

Coding Agent（后续每次 session）
  ├── 读取 git log + progress file
  ├── 一次只做一个 feature
  ├── 测试验证后才标记 passes
  └── session 结束前 commit + 更新 progress
```

## 三 Agent GAN 架构（进阶方案）

```
Planner → Generator → Evaluator → Generator → ...
              ↑                           │
              └───────────────────────────┘
```

- **Planner**：将简单 prompt 扩展为完整产品规格
- **Generator**：按 sprint 实现功能
- **Evaluator**：像用户一样测试，按多维度评分

## 评估维度示例

| 维度 | 说明 |
|------|------|
| Design Quality | 是统一整体而非零件拼凑 |
| Originality | 有定制决策，不是默认模板 |
| Craft | 排版层级、间距、色彩一致性 |
| Functionality | 用户能否理解并完成操作 |

## 实践建议

- Feature list 用 JSON（模型更不容易篡改）
- 给 Agent 真正的测试工具（Puppeteer/Playwright）
- 评估结果持久化存储，便于追踪趋势
- 运行 `make eval` 集成到 CI

---

*最后更新：2026-06-04*
