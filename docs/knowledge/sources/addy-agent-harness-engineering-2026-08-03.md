# Addy Osmani Agent Harness Engineering 审视笔记 (2026-08-03)

> 来源：https://addyosmani.com/blog/agent-harness-engineering/
> 学习日期：2026-08-03
> 对比笔记：2026-07-27版本
>
> 结论：文章内容无变化，本次重新审视未发现新要点。

---

## 一、审视确认

文章内容与 2026-07-27 版本完全一致，无新增段落或数据变更。

### 重新确认的 Harness 构件清单

```
Harness 包含：
├── 系统提示词（CLAUDE.md, AGENTS.md, skill files, subagent prompts）
├── 工具（skills, MCP servers, descriptions）
├── 基础设施（filesystem, sandbox, browser）
├── 编排逻辑（subagent spawning, handoffs, model routing）
├── Hooks 和中间件（compaction, continuation, lint checks）
└── 可观测性（logs, traces, cost & latency metering）
```

### 重新确认的核心原则

**1. "Skill issue" 框架**
- 大多数代理失败是配置问题，不是模型问题
- Viv 团队仅通过改变 harness 就从 Top 30 跳到 Top 5
- Terminal Bench 2.0：同一模型在 Claude Code 中得分远低于自定义 harness

**2. Ratchet 原则**
- 每个错误都应成为永久规则
- 每条 AGENTS.md 规则都应可追溯到具体的失败案例
- 只在看到真实失败时添加约束，只在能力模型证明其冗余时移除

**3. 从行为反向推导 Harness**
- 从想要的行为出发，推导需要什么 harness 组件
- 如果不能命名一个组件存在的行为目的，它就不应该在那里

**4. "Harnesses don't shrink, they move"**
- 更好的模型不使 harness 过时，只是移动了关注点
- 每个组件编码了一个"模型不能独立完成什么"的假设
- 模型改进时，某些组件变得空载；模型解锁新能力时，需要新脚手架

**5. Model-Harness 训练循环**
- 当前代理产品在训练时就包含了 harness
- 模型会过拟合到训练时的 harness
- 这就是为什么 Opus 4.6 在 Claude Code 内和外行为不同

### Context Rot 的四项技术

1. **Compaction**: 窗口接近满时智能总结和卸载旧上下文
2. **Tool-call offloading**: 大工具输出只保留头尾，完整输出存文件系统
3. **Skills with progressive disclosure**: 只在任务需要时揭示工具和指令
4. **Full context resets**: 长任务时完全重建 session（Anthropic 的创新）

## 二、与本次其他来源的交叉思考

### 结合 Anthropic Postmortem 的深度洞察

Anthropic 的三个 bug 完美展示了 "skill issue" 框架的现实应用：

1. **缓存 bug** → 这是 Harness 中的 Context Rot 管理失败。clear_thinking header 的错误使用等同于对 context 做了不当的 compaction，导致 reasoning 丢失。Addy 说的 "battling context rot" 在这里是字面意义的 battle。

2. **系统提示词 bug** → 一行 "≤25 words" 造成 3% 智能下降。这完美印证了 "Every line in a good AGENTS.md should be traceable back to a specific thing that went wrong" 的反面：**每一行不恰当的约束都有可测量的代价**。

3. **Effort 默认值** → 这不是 AGENTS.md 的问题，而是产品配置层面的问题。但从 Harness 视角看，这展示了** Harness 配置层级的复杂性**：系统提示词、产品默认值、用户偏好、模型能力，这些层级的交互产生了不可预期的结果。

### "Terminal Bench 2.0" 数据的新解读

结合 Anthropic 的 postmortem，我们可以说：
- Viv 的 Top 30 → Top 5 跳跃证明了自定义 harness 的优势
- Anthropic 的 postmortem 证明了即使是官方 harness 也有严重缺陷
- **结论**：Harness Engineering 的核心能力是**为自己的代码库和用例设计 harness**，而不是选择"最好的"官方 harness

这与 Addy 说的 "The 'best' harness isn't necessarily the one the model was trained inside; it's the one designed for your task" 完全一致。
