# OpenAI Harness Engineering 审视笔记 (2026-10-26)

> 来源：https://openai.com/index/harness-engineering/
> 学习日期：2026-10-26
> 对比笔记：2026-10-19版本
>
> 结论：文章内容无变化，连续十一周（07-27 起）确认稳定，本次未发现新要点。

## 一、审视确认

- 数据点（1,500 PR / 3→7 人 / 3.5 PR/人/天 / 百万行 / 1/10 时间 / 6 小时单任务 / Aardvark）：均已覆盖 ✅
- 九大要点清单（零手动代码、AGENTS.md 目录化、固定层级架构、per-worktree 可观测性、GC 式偿债、端到端自主、最小阻塞门控、Ralph Loop、枯燥技术）：均已覆盖 ✅
- 补充细节 A-H（Ralph Wiggum Loop、per-worktree boot、6 小时、品味编码例、枯燥技术例、端到端清单、周五清理日进化、Parse-don't-validate）：均已覆盖 ✅

## 二、本周实践应用

本次学习将 OpenAI 的"repository knowledge as system of record"原则反哺到本项目：
- 为 Anthropic 来源建立了**完整文章索引快照**（见 `anthropic-engineering-index-snapshot-2026-10-26.md`），后续每周对比从"凭记忆/翻旧笔记"升级为"diff 快照"，这正是文中"知识库可机械校验（coverage / freshness / cross-links）"思想的落地
- 索引快照 = 文中 docs/ 目录的"catalogued and indexed"实践

## 三、建议

本篇已连续十一周无变化。建议改为**每月深读一次 + 每周仅核对标题与修改日期**，把每周 token 预算让给变化更频繁的来源（Anthropic 博客、Addy 新文）。
