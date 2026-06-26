# Agent Harness Engineering — Addy Osmani (2026-06-26)

> 来源: https://addyosmani.com/blog/agent-harness-engineering/
> 作者: Addy Osmani (Google Chrome 团队核心成员)
> 日期: 2026 年 6 月
> 定位: 系统化定义 Agent Harness Engineering，将 Viv Trivedy、HumanLayer、Anthropic、Dex Horthy 等多方观点融合为一篇综合指南。

## 核心定义

> Agent = Model + Harness. If you're not the model, you're the harness.
> — Viv Trivedy

Harness 是模型之外的所有东西：prompts、tools、context policies、hooks、sandboxes、subagents、feedback loops、recovery paths。

> A decent model with a great harness beats a great model with a bad harness.

## Harness 的具体组成部分

1. **System prompts, CLAUDE.md, AGENTS.md, skill files, subagent prompts**
2. **Tools, skills, MCP servers, and their descriptions**
3. **Bundled infrastructure** (filesystem, sandbox, browser)
4. **Orchestration logic** (subagent spawning, handoffs, model routing)
5. **Hooks and middleware** (compaction, continuation, lint checks)
6. **Observability** (logs, traces, cost and latency metering)

## "Skill Issue" 重构

> "it's not a model problem. It's a configuration problem."

- Agent 表现差 → 不要怪模型，去修 harness
- 没有知道约定 → 加到 AGENTS.md
- 执行了破坏性命令 → 加 hook 阻止
- 40 步任务迷失 → 拆成 planner + executor
- 反复"完成"坏代码 → 接入 typecheck 回压信号

**关键数据点**: Claude Opus 4.6 在 Claude Code 内跑 Terminal Bench 2.0 得分远低于同一模型在定制 harness 中的得分。Viv 团队仅通过改 harness，将 coding agent 从 Top 30 提升到 Top 5。

> The gap between what today's models can do and what you see them doing is largely a harness gap.

## The Ratchet: 每个错误变成规则

最核心的习惯：把 Agent 错误视为**永久信号**，不是一次性故事。

示例流程：
1. Agent 发了一个有注释掉测试的 PR → 合入了
2. 下版 AGENTS.md 加 "never comment out tests; delete them or fix them"
3. 下版 pre-commit hook grep `.skip(` 和 `xit(`
4. 下版 reviewer subagent 标记注释掉测试为 blocker

> You only add constraints when you've seen a real failure. You only remove them when a capable model has made them redundant. Every line in a good AGENTS.md should be traceable back to a specific thing that went wrong.

**核心洞察**: Harness engineering 是一门**学科**（discipline），不是框架。正确的 harness 由你的失败历史塑造，不能下载。

## 从行为反向推导（Working backwards from behaviour）

Viv 的设计模式：`目标行为 → harness 组件设计`

每个组件都必须有明确的职责。如果无法命名一个组件存在的具体行为目标，它就不应该在那里。

### Filesystem + Git: 持久状态

文件系统是最基础的原语，常被低估。给 Agent 工作空间读写数据、中间结果卸载、多 Agent+人类协调。Git 提供版本控制。

### Bash + 代码执行: 通用工具

ReAct 循环是主流。与其预建所有工具，不如给 Agent bash 让它按需构建。

### Sandboxes: 安全执行

隔离环境，allow-list 命令，网络隔离，按需创建和销毁。好的沙箱自带默认工具：语言运行时、Git、test CLI、headless browser。

### Memory + Search: 持续学习

模型只有权重 + 当前上下文。AGENTS.md 注入机制实现"粗但有效"的持续学习。Web search + MCP (如 Context7) 弥补知识截止日期。

### 对抗上下文腐烂（Battling Context Rot）

三种技术反复出现：
1. **Compaction**: 智能摘要旧上下文
2. **Tool-call offloading**: 大输出只保留 head + tail，全文存文件系统
3. **Skills with progressive disclosure**: 按需加载工具和指令

Anthropic 额外技术：**Full context resets** — 完全重建 session，从紧凑的 hand-off 文件开始。

### 长期执行: Ralph Loops, 规划, 验证

- **Ralph Loop**: hook 拦截模型退出尝试，重新注入 prompt 到新上下文窗口
- **Planning**: 将目标分解为步骤序列，存入 plan file
- **Planner / Generator / Evaluator splits**: 分离生成和评估优于自评估。> "It's GANs for prose."
- **Sprint Contract**: 生成器和评估器在写代码前先协商"done"的定义。写下来完成条件比任何 prompt 改变更能防 scope drift。

### Hooks: 执行层

> Success is silent, failures are verbose. — HumanLayer

typecheck 通过 → Agent 什么都不听。typecheck 失败 → 错误文本注入循环，Agent 自纠。

Hook 时机：tool call 前、file edit 后、commit 前、session 启动时。

### AGENTS.md: 最高杠杆配置点

两条硬经验：
1. **保持简短**: HumanLayer 控制在 60 行以下。每行都在争注意力。Pilot's checklist, not style guide。
2. **每行都挣来的**: 规则应追溯到具体失败事件。Ratchet; don't brainstorm。

工具同理：10 个专注工具 > 50 个重叠工具。

**安全警告**: 工具描述会被注入 prompt，MCP 服务器 = Agent 信任文本。恶意的 MCP 可以在用户输入前就 prompt-inject Agent。

## Harnesses don't shrink, they move

> "every component in a harness encodes an assumption about what the model can't do on its own." — Anthropic

- 模型在某方面变强 → 对应组件变成 dead code，应移除
- 模型解锁新能力 → 需要新脚手架到达新天花板
- Opus 4.6 杀死了 context-anxiety → 但解锁了需要多日记忆策略、三 Agent 协调等新需求

## 模型-Harness 训练循环

- Agent 产品在 post-training 时 harness 在场
- 模型在 harness 设计者认为重要的操作上变强：文件系统、bash、规划、子 agent 派发
- **Co-training 导致过度拟合**: Opus 4.6 在 Claude Code 和其他 harness 中表现不同
- 实践意义：harness 是**活系统**，不是一次配置。最好的 harness 不一定是训练时用的那个，而是为你的任务设计的那个。

## Harness-as-a-Service (HaaS)

Viv 的贡献：从 LLM API（给 completion）→ Harness API（给 runtime）。

Claude Agent SDK、Codex SDK、OpenAI Agents SDK 都是 HaaS 方向。提供 loop、tools、context management、hooks、sandbox 原语，你只需定制。

> "good agent building is an exercise in iteration. You can't do iterations if you don't have a v0.1."

## 行业融合趋势

Claude Code、Codex、Cursor、Aider、Cline 都是 harness。底层模型可能相同，但用户体验由 harness 决定。

---

*相关来源笔记:*
- `sources/addy-loop-engineering-2026-06-07.md` — Loop Engineering（在 Harness 之上加调度循环）
- `sources/anthropic-long-running-apps-2026-03-24.md` — Anthropic 长期应用 Harness 设计
- `sources/anthropic-managed-agents-2026-04-08.md` — 脑手分离架构

*最后更新：2026-06-26*
