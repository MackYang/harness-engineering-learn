# Anthropic Engineering 完整文章索引快照 (2026-11-02)

> 提取方式：curl 直取 HTML → 解析 `self.__next_f.push` 内嵌 JSON → 提取 article 对象（含 `publishedOn` + `_updatedAt`）
> 对比基线：`anthropic-engineering-index-snapshot-2026-10-26.md`
> ⚠️ v2 格式：本版起含 `_updatedAt` 字段，可检测**已发布文章的重写**（v1 仅标题+日期，漏掉了 managed-agents 10-30 重写）

## 深读闭环统计

- Featured 3 篇：已读 2，候选补读 1（AI-resistant evals）
- harness 强相关文章：均已深读（含 managed-agents 重写版，见 `anthropic-managed-agents-rewrite-2026-11-02.md`）

## Engineering 文章索引（publishedOn 降序，含 _updatedAt）

### 2026
- 2026-10-13 redesigning-source-control — Redesigning source control at Anthropic ✅（updated 2026-10-20T03:28:40Z）
- 2026-05-25 how-we-contain-claude ✅（updated 2026-10-18T21:26:24Z）
- 2026-04-23 april-23-postmortem ✅（updated 2026-10-18T21:26:26Z）
- 2026-04-08 managed-agents ✅✅ **重写**（updated **2026-10-30T15:51:07Z**，首发 04-08，重写版深读 11-02）
- 2026-03-25 claude-code-auto-mode ✅（updated 2026-10-18T21:26:28Z）
- 2026-03-24 harness-design-long-running-apps ✅（updated 2026-10-18T19:57:16Z）
- 2026-03-06 eval-awareness-browsecomp ➖（updated 2026-10-18T21:26:35Z）
- 2026-02-05 building-c-compiler ✅（updated 2026-10-18T21:26:18Z）
- 2026-02-05 infrastructure-noise ➖ 中相关候选补读（updated 2026-10-18T21:26:37Z）
- 2026-01-21 AI-resistant-technical-evaluations ⚠️ Featured 未深读候选（updated 2026-10-18T19:58:11Z）
- 2026-01-09 demystifying-evals-for-ai-agents ➖（updated 2026-10-18T21:26:21Z）

### 2025
- 2025-11-26 effective-harnesses-for-long-running-agents ✅（updated 2026-10-18T21:26:39Z）
- 2025-11-24 advanced-tool-use ➖（updated 2026-10-18T21:26:47Z）
- 2025-11-04 code-execution-with-mcp ➖ 中相关候选补读（updated 2026-10-18T21:26:15Z）
- 2025-10-20 claude-code-sandboxing ✅（updated 2026-10-18T21:26:55Z）
- 2025-10-16 equipping-agents-for-the-real-world-with-agent-skills ➖（updated 2026-10-18T21:26:58Z）
- 2025-09-29 effective-context-engineering-for-ai-agents ✅（updated 2026-10-18T21:28:08Z）
- 2025-09-17 a-postmortem-of-three-recent-issues ✅（updated 2026-10-18T21:27:52Z）
- 2025-09-11 writing-tools-for-agents ➖（updated 2025-10-13T18:18:21Z）
- 2025-06-26 desktop-extensions ➖（updated 2025-10-13T18:13:32Z）
- 其余更早文章：与 10-26 快照一致，无变化

### 非工程类别（弱相关，略）
最新：claude-opus-5（2026-07-24）等，见 v1 快照附录

## 本周 diff（vs 2026-10-26 快照）

| 检测项 | 结果 |
|--------|------|
| 新文章 slug | ❌ 无（最新仍为 10-13 Scion） |
| `_updatedAt` 变化 | ⚠️ **managed-agents → 2026-10-30T15:51:07Z**（首次捕获重写事件，已深读） |
| Featured 替换 | ❌ 无 |
| Antique 专文 | ❌ 仍未发布（连续第三周盯防） |

## 下周盯防

1. Antique 专文（Scion 预告的代码评审工具文章）
2. 其余文章的 `_updatedAt` 变化（long-running-apps / containment 重写风险同样存在）
3. Scion 系列续作（git 平台响应、迁移复盘）
