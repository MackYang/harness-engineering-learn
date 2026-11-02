# Anthropic Engineering 新知识笔记 (2026-10-26)

> 来源：Anthropic 工程博客 - https://www.anthropic.com/engineering
> 学习日期：2026-10-26
> 对比笔记：2026-10-19版本
>
> 结论：**无新文章**。最新文章仍是 2026-10-13 的《Redesigning source control at Anthropic》（上周已深读，见 `anthropic-source-control-scion-2026-10-19.md`）。

## 一、文章列表对比

### Featured 轮播（3 篇，与上周一致）

| 文章 | 日期 | 状态 |
|------|------|------|
| Redesigning source control at Anthropic | 2026-10-13 | ✅ 已深读（10-19） |
| Harness design for long-running application development | 2026-03-24 | ✅ 已深读 |
| Designing AI-resistant technical evaluations | 2026-01-21 | ⚠️ 未深读（评估主题，与 harness 相关度中等） |

### 列表核对

本次通过页面内嵌 JSON 提取了**完整文章索引（54 篇）**并固化成快照：
→ 见 `anthropic-engineering-index-snapshot-2026-10-26.md`

与 2026-10-19 记录对比：
- 无新文章（最新仍为 10-13 Scion）
- 无 Featured 替换
- 上周重点盯防的 **Antique 专文尚未发布**（Scion 文中的预告），下周继续

## 二、持续观察

- 07-06 至 10-12：连续十一周无新文章
- 10-19：Scion 重磅文章打破沉默（已完成深读）
- 10-26（本次）：恢复平静，Scion 之后暂无跟进
- **发文节奏规律**：Anthropic 工程博客约每 4-6 周一篇重磅，10-13 刚发过，短期（1-3 周）内出新文概率低；但 Antique 专文与 Scion 系列续作（git 平台响应、迁移复盘）是两个高概率方向

## 三、基础设施改进（本次新增）

本次解决了长期摩擦：engineering 页面为 Next.js SSR + 客户端水合，`web_fetch` 只能取到页脚模板。本次用 `curl` 直取 HTML 并解析 `self.__next_f.push` 内嵌 JSON，首次获得完整、带日期的权威文章清单。该清单已快照入库，后续每周对比只需 diff 快照，不再重复解析。

## 四、后续跟进候选

1. **Antique 专文**（代码评审工具）——Scion 文中明确预告，最高优先级盯防
2. Scion 文中"6-12 个月内这类问题会变常见"的预判 → 跟踪 GitHub/GitLab 的 agent 规模响应
3. `designing-ai-resistant-technical-evaluations`（2026-01-21）：唯一未深读的 Featured 文章，主题与 eval-patterns.md 相关，候选补读
