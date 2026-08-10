# Addy Osmani Agent Harness Engineering 审视笔记 (2026-08-10)

> 来源：https://addyosmani.com/blog/agent-harness-engineering/
> 学习日期：2026-08-10
> 对比笔记：2026-08-03版本
>
> 结论：文章内容无变化，本次重新审视未发现新要点。

---

## 一、审视确认

文章内容与 2026-08-03 版本完全一致。注意：本文超长（>20,000 字符），web_fetch 截断发生在同一位置（HaaS 段落之后 "Where this is going" 段落开头），与之前截断位置一致。

### 重新确认的核心框架

**定义**：Agent = Model + Harness。如果你不是模型，你就是 Harness。

**Harness 构件清单**：
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
- Viv 团队仅通过改变 harness 从 Top 30 到 Top 5

**2. Ratchet 原则**
- 每个错误成为永久规则
- 只在真实失败时添加，只在能力模型证明冗余时移除

**3. 从行为反向推导**
- 行为 → harness 设计
- 无法命名的组件不应存在

**4. Context Rot 四项技术**
- Compaction / Tool-call offloading / Progressive disclosure / Full context resets

**5. "Harnesses don't shrink, they move"**
- 模型改进时关注点移动，不缩小

**6. Model-Harness 训练循环**
- 后训练过拟合到 harness
- Opus 4.6 在 Claude Code 内外行为不同

**7. Harness-as-a-Service (HaaS)**
- 从 LLM API（completion）到 Harness API（runtime）
- 四个支柱配置：系统提示词、工具、上下文、子代理

**8. Hooks: 执行层**
- "成功沉默，失败冗余"原则
- typecheck 通过→静默；失败→错误注入循环

## 二、持续审视观察

连续三周（07-27、08-03、08-10）文章无变化。Agent Harness Engineering 是 Addy 的核心综合文章，已趋于稳定。

**截断问题备注**：本文超过 web_fetch 的 20,000 字符限制，截断发生在 "Where this is going" 段落。之前版本（07-23 之前）已学习完整内容，后续版本的补充笔记已覆盖截断之后的内容（包括 HaaS 框架完整概念、行业收敛趋势、三个开放问题、Sprint Contract 等）。

**建议**：后续审视可关注 Addy 是否发布新文章，而非重复检查此文的完整内容。
