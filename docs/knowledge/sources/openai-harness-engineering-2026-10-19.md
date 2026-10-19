# OpenAI Harness Engineering 审视笔记 (2026-10-19)

> 来源：https://openai.com/index/harness-engineering/
> 学习日期：2026-10-19
> 对比笔记：2026-10-12版本
>
> 结论：文章内容无变化，连续十周（07-27 起）确认稳定，本次未发现新要点。

## 一、审视确认

- 数据点（1,500 PR / 3→7 人 / 3.5 PR/人/天 / 百万行 / 1/10 时间 / 6 小时单任务 / Aardvark）：均已覆盖 ✅
- 九大要点清单（零手动代码、AGENTS.md 目录化、固定层级架构、per-worktree 可观测性、GC 式偿债、端到端自主、最小阻塞门控、Ralph Loop、枯燥技术）：均已覆盖 ✅
- 补充细节 A-H（Ralph Wiggum Loop、per-worktree boot、6 小时、品味编码例、枯燥技术例、端到端清单、周五清理日进化、Parse-don't-validate）：均已覆盖 ✅

## 二、本周交叉印证

Anthropic 新发布的 Scion 文章（见 `anthropic-source-control-scion-2026-10-19.md`）为 OpenAI 原则 8（吞吐量改变合并哲学）提供了**第二家独立数据印证**：
- OpenAI：最小阻塞门控、PR 短生命周期、flaky 用后续运行解决
- Anthropic：merge queue 在 agent 规模无意义 → post-merge + pre-deploy 自动化测试，冲突靠 Claude 修复

两大权威在"agent 吞吐下合并策略必须重构"上收敛，该原则的可信度显著提升。

## 三、建议

维持每两周一次审视频率。
