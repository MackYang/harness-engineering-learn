# Loop Engineering — Addy Osmani (2026-06-07)

> 来源: https://addyosmani.com/blog/loop-engineering/
> 作者: Addy Osmani (Google Chrome 团队核心成员)
> 日期: 2026 年 6 月 7 日
> 定位: 首次正式命名、系统化定义 Loop Engineering，将行业零散的"自主 Agent 循环实践"提炼为独立工程范式。

## 核心定义

> Loop engineering is the practice of designing systems that autonomously prompt AI agents, rather than manually writing prompts yourself.
> 循环工程：设计一套自主驱动 Agent 的闭环系统，替代人类手动逐轮输入提示词。

Peter Steinberger: "You shouldn't be prompting coding agents anymore. You should be designing loops that prompt your agents."
Boris Cherny (Claude Code 负责人, Anthropic): "I don't prompt Claude anymore. I have loops running that prompt Claude and figuring out what to do. My job is to write loops."

## 与 Harness Engineering 的关系

Addy 明确定义了层级关系：

- **Harness Engineering** — 单个 Agent 的运行环境（scaffold、skills、约束）
- **Loop Engineering** — 在 Harness 之上，加了**调度、循环和自主决策**，让系统"自己在定时器上跑"

> Loop engineering sits one floor above the harness. The harness but it runs on a timer, it spawns little helpers, and it feeds itself.

## Loop 的五大构件 + 一个记忆

### 1. Automations（自动化调度）— 心跳

让 loop 成为真正的 loop，而不是一次性运行。包括：
- 定时发现 + 分诊（daily triage, CI failure summarization, bug hunting）
- `/loop` 按间隔重跑
- `/goal` 持续运行直到条件满足，由**独立小模型**判断完成（maker/checker 分离）
- Cron tasks, hooks, GitHub Actions

### 2. Worktrees（工作树隔离）

多 agent 并行不冲突。git worktree 提供独立工作目录 + 独立分支，共享仓库历史。

> Two agents writing the same file is the exact same headache as two engineers committing to the same lines.

### 3. Skills（技能）— 项目知识编码

避免每次循环都重新解释项目。SKILL.md 格式，包含指令和元数据。将意图（intent）固化，防止 agent 每次冷启动时空洞猜测。

> Without skills the loop re-derives your whole project from zero every cycle, with skills it kind of compounds.

### 4. Plugins & Connectors（连接器）

通过 MCP 让 loop 接入真实工具（Linear、Slack、数据库、Staging API）。没有连接器的 loop 只是文件系统级别的，有了连接器才能"自己开 PR、更新 ticket、CI 通过后 ping 频道"。

### 5. Sub-agents（子 agent）

**生成者与验证者分离**（maker/checker split）——写代码的 agent 不能自己批改自己的作业。

> The model that wrote the code is way too nice grading its own homework.

通常拆分为：Explorer → Implementer → Verifier

### 6. State（状态记忆）

模型会忘，仓库不会。用 Markdown 或 Linear board 持久化已完成/待办事项。

> The agent forgets, the repo doesn't.

## 一个完整的 Loop 实例

```
自动化每天早上运行 → 调用 triage skill（读 CI failures, open issues, recent commits）
→ 发现写入 state file → 为每个发现打开隔离 worktree
→ 子 agent 起草修复 → 第二个子 agent 审查（对照 skills + 测试）
→ Connector 开 PR + 更新 ticket → 无法处理的进入 triage inbox
→ State file 记录进度，明天从今天停下的地方继续
```

**关键洞察：你设计一次，之后不再手动 prompt 任何步骤。**

## Loop 不替你做的事（风险与局限）

1. **验证仍在人类身上** — "done" 是声明，不是证明。必须确认代码真正可用。
2. **理解力萎缩（Comprehension Debt）** — loop 越快，你不理解的代码越多。必须主动阅读 loop 产出的代码。
3. **认知投降（Cognitive Surrender）** — 最危险的姿态是"设计好 loop 就躺平"。同一个 loop，一个人用来加速理解，另一个人用来逃避理解。Loop 不知道区别，你知不知道。

## 与 Ralph Wiggum Loop 的关系

- **Ralph Wiggum Loop** (Geoffrey Huntley, 2025中) — 前身/民间实践，本质是 `while :; do cat PROMPT.md | claude-code ; done`
- **Loop Engineering** (Addy Osmani, 2026-06-07) — 正式命名 + 系统化，从 bash 技巧升级为五大构件的完整工程范式

Ralph 是 Loop Engineering 的"原始形态"，Addy 把它提炼成了行业通用标准术语。

## 相关概念（Addy Osmani 系列）

- [Agent Harness Engineering](https://addyosmani.com/blog/agent-harness-engineering/) — Agent = Model + Harness
- [Agent Skills](https://addyosmani.com/blog/agent-skills/) — 技能编码模式
- [Factory Model](https://addyosmani.com/blog/factory-model/) — 构建软件的系统
- [Long-running Agents](https://addyosmani.com/blog/long-running-agents/) — 长运行 agent 记忆管理
- [Code Agent Orchestra](https://addyosmani.com/blog/code-agent-orchestra/) — 多 agent 协作
- [Adversarial Code Review](https://addyosmani.com/blog/adversarial-code-review/) — 对抗性代码审查
- [Orchestration Tax](https://addyosmani.com/blog/orchestration-tax/) — 编排成本
- [Intent Debt](https://addyosmani.com/blog/intent-debt/) — 意图债务
- [Comprehension Debt](https://addyosmani.com/blog/comprehension-debt/) — 理解力债务
- [Cognitive Surrender](https://addyosmani.com/blog/cognitive-surrender/) — 认知投降
