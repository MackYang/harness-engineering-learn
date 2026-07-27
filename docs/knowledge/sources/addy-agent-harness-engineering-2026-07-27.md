# Addy Osmani Agent Harness Engineering 审视笔记 (2026-07-27)

> 来源：https://addyosmani.com/blog/agent-harness-engineering/
> 学习日期：2026-07-27
> 对比笔记：2026-07-23版本
>
> 结论：文章内容无变化，本次重新审视未发现新要点。

---

## 一、审视确认

文章内容与 2026-07-23 版本完全一致（包括之前截断的 HaaS 部分）。无新增段落或数据变更。

### 重新确认的核心框架

**Harness 的定义**：Agent = Model + Harness

**核心构件清单**：
- System prompts, CLAUDE.md, AGENTS.md, skill files, subagent prompts
- Tools, skills, MCP servers, descriptions
- Bundled infrastructure (filesystem, sandbox, browser)
- Orchestration logic (subagent spawning, handoffs, model routing)
- Hooks and middleware (compaction, continuation, lint checks)
- Observability (logs, traces, cost and latency metering)

**"Skill Issue" 重构**：
- Claude Opus 4.6 在 Claude Code 内 vs 自定义 Harness 的表现差距
- Viv 的团队仅改 Harness，同一模型从 Top 30 → Top 5

**Ratchet 模式**：每个错误成为一条规则，每条规则可追溯到具体失败

**HaaS (Harness-as-a-Service)**：
- 从 LLM API（completion）→ Harness API（runtime）
- Claude Agent SDK, Codex SDK, OpenAI Agents SDK

**Harness 不缩小，而是移动**：
- Opus 4.6 消灭了 context-anxiety → 相关脚手架变成死代码
- 但新能力带来新失败模式 → 需要新脚手架

## 二、无新内容的说明

本次审视确认该文章在 2026-07-23 至 2026-07-27 期间未更新。如未来文章更新，应关注：

- HaaS 三个 SDK 的最新 API 变化
- Viv 的 Terminal Bench 数据的后续更新
- 动态工具/上下文组装的实践案例
- 自我诊断 Harness 的进展