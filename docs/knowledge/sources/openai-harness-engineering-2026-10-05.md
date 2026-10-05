# OpenAI Harness Engineering 审视笔记 (2026-10-05)

> 来源：https://openai.com/index/harness-engineering/
> 学习日期：2026-10-05
> 对比笔记：2026-09-28版本
>
> 结论：文章内容无变化，本次重新审视未发现新要点。

---

## 一、审视确认

全文与 2026-09-28 版本逐段比对一致，连续八周（07-27 起）确认稳定。

关键结构复核（对照历史要点清单）：

- **零手动代码哲学**：人类只在提示层交互，所有代码/CI/文档/工具链由 Codex 产出 ✅（06-29 起已记录）
- **AGENTS.md 目录化**（约 100 行地图 + docs/ 结构化知识库 + doc-gardening agent）✅ 已记录
- **固定层级架构**（Types → Config → Repo → Service → Runtime → UI，跨切面经 Providers，custom linter 机械执行）✅ 已记录
- **per-worktree 可观测性**（app per worktree、CDP、LogQL/PromQL）✅ 已记录
- **垃圾回收式偿债**（golden principles + 后台 Codex 清扫任务，替代人工 20% 周五清理）✅ 已记录
- **端到端自主性清单**（复现 bug → 录视频 → 修复 → 验证 → PR → 响应反馈 → 合并）✅ 已记录
- **最小阻塞门控**（短命 PR、flake 用重跑而非阻塞）✅ 已记录

数据点抽检维持上周结论：1,500 PR / 3→7 人 / 3.5 PR/人/天 / 百万行 / 6 小时单任务 / Aardvark，历史笔记均已覆盖，无遗漏。

## 二、本周无新增关联进展

引用清单维持稳定：Böckeler 综述已闭环（09-21），Fareed Khan 架构解构维持"插图级参考"定位。

## 三、建议

维持每两周一次审视频率。
