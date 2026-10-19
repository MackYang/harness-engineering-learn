# Addy Osmani Agent Harness Engineering 审视笔记 (2026-10-19)

> 来源：https://addyosmani.com/blog/agent-harness-engineering/
> 学习日期：2026-10-19
> 对比笔记：2026-10-12版本
>
> 结论：文章内容无变化，连续十周稳定，本次未发现新要点。

## 一、审视确认

正文核心概念全部复核无变化：

- **Agent = Model + Harness**（Viv Trivedy）；Terminal Bench 2.0 Top 30 → Top 5 仅靠换 harness
- **Ratchet 棘轮**：每个错误变成永久规则；AGENTS.md 60 行以内、earned each line
- **Context Rot 四技术**：Compaction / Tool-call offloading / Skills 渐进披露 / Full context resets
- **长时程执行**：Ralph Loop、plan 文件、planner/generator/evaluator 分离、sprint contract
- **Hooks 执法层**：success is silent, failures are verbose
- **Harness 不缩小只移动**；**模型-harness 训练耦合**；**HaaS**

## 二、本周交叉印证

Scion 文章为本文两个论点提供了最新实证：

1. **"Harnesses don't shrink, they move"** 在基础设施层再现：模型能力暴涨 → 瓶颈从编码移动到版本控制/CI → 基础设施层需要全新的"脚手架"（Scion 六原则）。移动的不只是 agent 内的 harness，还有 agent 脚下的开发平台。
2. **"告诉 Claude 不"**（Scion 教训 2）呼应本文的 failure-history/ratchet 思维：Agent 违反系统约束的模式一旦被发现，就变成工程约束（目录权限、语义审批约束）编码进系统。

## 三、引用清单状态复核

- 引用 ①：Böckeler 用户侧综述 —— 已精读闭环（2026-09-21）✅
- 引用 ②：Fareed Khan Claude Code 架构解构 —— 维持"插图级参考"
- 其余引用（Viv Trivedy、HumanLayer、Simon Willison、Dex Horthy）：核心论点已通过本文转述收录

## 四、建议

维持每两周一次审视频率。
