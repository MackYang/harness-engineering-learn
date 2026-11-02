# Addy Osmani Agent Harness Engineering 审视笔记 (2026-10-26)

> 来源：https://addyosmani.com/blog/agent-harness-engineering/
> 学习日期：2026-10-26
> 对比笔记：2026-10-19版本
>
> 结论：文章内容无变化，连续十一周稳定，本次未发现新要点。

## 一、审视确认

正文核心概念全部复核无变化：

- **Agent = Model + Harness**（Viv Trivedy）；Terminal Bench 2.0 Top 30 → Top 5 仅靠换 harness
- **Ratchet 棘轮**：每个错误变成永久规则；AGENTS.md 60 行以内、earned each line
- **Context Rot 四技术**：Compaction / Tool-call offloading / Skills 渐进披露 / Full context resets
- **长时程执行**：Ralph Loop、plan 文件、planner/generator/evaluator 分离、sprint contract
- **Hooks 执法层**：success is silent, failures are verbose
- **Harness 不缩小只移动**；**模型-harness 训练耦合**；**HaaS**

## 二、本周实践应用

本文的 Ratchet 原则（"every mistake becomes a rule"）在本周学习流程中得到一次小型应用：
- **发现的摩擦**：Anthropic engineering 页面是 JS 渲染，`web_fetch` 拿不到文章列表，每周都要临时用 curl + 正则解析 Next.js 内嵌 JSON
- **Ratchet 动作**：把解析出的完整 54 篇文章索引固化成快照文件入库（`anthropic-engineering-index-snapshot-2026-10-26.md`），未来每周 diff 快照即可，重复摩擦一次性消除
- 这正是"agent 卡住的点 → 沉淀成 repo 里的永久资产"的标准棘轮操作

## 三、建议

本篇已连续十一周无变化，建议降频为每月深读。
