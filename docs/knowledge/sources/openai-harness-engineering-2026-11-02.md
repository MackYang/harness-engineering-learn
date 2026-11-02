# OpenAI Harness Engineering 审视笔记 (2026-11-02)

> 来源：https://openai.com/index/harness-engineering/
> 学习日期：2026-11-02
> 对比笔记：2026-10-26 版本
>
> 结论：文章正文无变化（连续十二周稳定）。按上周建议降频为"每周核对 + 每月深读"，本次细读发现 2 个此前遗漏的细节，已补录。

## 一、审视确认

- 数据点（1,500 PR / 3→7 人 / 3.5 PR/人/天 / 百万行 / 1/10 时间 / 6 小时单任务 / Aardvark）：均已覆盖 ✅
- 九大要点清单 + 补充细节 A-I：均已覆盖 ✅

## 二、本次新发现的遗漏细节（2 项）

### 1. "Attractive nuisance"（吸引性滋扰）——AGENTS.md 失败四联征的第 4 条完整表述
原文描述单一巨型 AGENTS.md 失败方式的第 3-4 点：
- "It rots instantly. A monolithic manual turns into a graveyard of stale rules. Agents can't tell what's still true, humans stop maintaining it, and the file quietly becomes **an attractive nuisance**."
- 此前笔记记录了"rot instantly / graveyard of stale rules"，但 **attractive nuisance**（法律术语借喻：像无护栏泳池一样吸引人靠近却又危险的资产——过时规则反而诱导 agent 做错事）这个精确概念未被捕获
- 已补入 golden-rules.md 补充细节 K（含完整四联征）

### 2. 性能目标 prompt 示例的具体数值
- "ensure service startup completes in **under 800ms**"
- "no span in these four critical user journeys exceeds **two seconds**"
- 此前记录了"性能目标可被 prompt 化"的思想，但未记录这两个具体示例数值。它们的价值：展示了 observability 接入 agent 后，SLO 语言直接变成 agent 可执行的验证条件——即"验收标准从人类散文变为机器可查询的指标查询"
- 已补入 golden-rules.md 补充细节 L

## 三、维护纪律说明

- 本文自 07-27 起连续十二周内容稳定。2026-11 月起执行"每周核对标题与结构 + 每月（下一个 11 月周）全文细读"的降频策略
- 本次细读恰好证明降频≠不看：稳定文章仍有增量细节可挖，但挖掘成本 > 增量价值时，应把预算还给高变动来源（本周 Anthropic managed-agents 重写即是例证）

## 四、后续跟进

- Aardvark 独立产品页（/index/introducing-aardvark）未单独深读，列为候选
- execution plans cookbook（cookbook.openai.com/articles/codex_exec_plans）未单独深读，列为候选
