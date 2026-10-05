# Addy Osmani Agent Harness Engineering 审视笔记 (2026-10-05)

> 来源：https://addyosmani.com/blog/agent-harness-engineering/
> 学习日期：2026-10-05
> 对比笔记：2026-09-28版本
>
> 结论：文章内容无变化，连续八周稳定。

---

## 一、审视确认

正文核心概念全部复核无变化：

- **Agent = Model + Harness**（Viv Trivedy），"如果你不是模型，你就是 harness"
- **skill issue 重构**：失败通常是可辨识的配置问题而非模型问题；Terminal Bench 2.0 上同一模型 Top 30 → Top 5 仅靠换 harness
- **Ratchet 棘轮**：每个错误变成永久规则；AGENTS.md 每行可追溯到具体失败；60 行以内、 earned each line
- **Context Rot 四技术**：Compaction / Tool-call offloading / Skills 渐进披露 / Full context resets
- **长时程执行**：Ralph Loop、plan 文件、planner/generator/evaluator 分离（GANs for prose）、sprint contract
- **Hooks 执法层**：success is silent, failures are verbose
- **Harness 不缩小只移动**：组件编码着"模型不能自己做"的假设，模型进步则旧脚手架变成死代码、新天花板需要新脚手架
- **模型-harness 训练耦合** 与 **HaaS**（Claude Agent SDK / Codex SDK / OpenAI Agents SDK）

## 二、引用清单状态复核

- 引用 ①：Böckeler 用户侧综述 —— 已精读闭环（2026-09-21）✅
- 引用 ②：Fareed Khan Claude Code 架构解构 —— 维持"插图级参考"，暂不安排精读
- 其余引用（Viv Trivedy、HumanLayer、Simon Willison、Dex Horthy）：核心论点已通过本文转述收录，独立精读暂无必要

尾部完整性：HaaS 及后续段落继续被历史笔记完整覆盖，无需补记。

## 三、建议

维持每两周一次审视频率。
