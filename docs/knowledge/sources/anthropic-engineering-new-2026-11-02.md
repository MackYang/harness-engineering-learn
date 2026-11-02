# Anthropic Engineering 新知识笔记 (2026-11-02)

> 来源：Anthropic 工程博客 - https://www.anthropic.com/engineering
> 学习日期：2026-11-02
> 对比笔记：2026-10-26 版本 + 索引快照 diff
>
> 结论：**无新文章**（最新仍是 2026-10-13 Scion），但发现 **managed-agents 文章于 2026-10-30 被大幅重写**（`_updatedAt: 2026-10-30T15:51:07Z`，快照基线 10-26 之后）——这是本知识库首次捕获"已发布文章的内容重写"事件。

## 一、文章列表 diff（vs 2026-10-26 快照）

- Featured 轮播 3 篇不变（Scion / long-running-apps / AI-resistant evals）
- Engineering 文章索引：最新仍为 10-13 Scion，无新增条目
- **Antique 专文仍未发布**（连续第三周盯防）
- 解析方法升级：本次通过 `self.__next_f.push` 内嵌 JSON 提取了带 `publishedOn` + `_updatedAt` 的完整文章对象（24 篇 Engineering 类别），快照从"标题+slug"升级为"含更新时间戳"——正是这次升级让 managed-agents 重写事件无处遁形

## 二、重大发现：managed-agents 重写（2026-10-30）

《Scaling Managed Agents: Decoupling the brain from the hands》（首发 2026-04-08，已深读两次：04-08 初读 + 07-20 复读）在 10-30 被系统性重写。已深读新版全文，新旧对比：

### 2.1 新版新增框架（旧版笔记未覆盖）

**A. 开篇新论点：harness 假设会过时（assumptions go stale）**
> "harnesses encode assumptions about what Claude can't do on its own. However, those assumptions need to be frequently questioned because they can go stale as models improve."

**B. 全新实例：context anxiety 的生灭史**
- Claude Sonnet 4.5 会在感知到上下文即将耗尽时**提前收尾任务**（"context anxiety"）
- 当时的解法：在 harness 中加入 context resets
- 换到 Claude Opus 4.5：该行为**消失了**，"The resets had become **dead weight**"
- 这是"harness 组件生命周期"（编码假设→过时→变成死重→移除）的第一个带具体模型版本的公开实证

**C. "programs as yet unthought of" 的 OS 类比被显式化**
- 旧版笔记记录了 OS 思维（process/file 抽象），新版将其上升为全文主旨：Managed Agents = **meta-harness**
- "We're opinionated about the shape of these interfaces, not about what runs behind them"——对接口形状固执，对背后实现自由的表述更精炼

**D. 结构性安全边界的完整叙述**（旧版有要点，新版补充了攻击链推理）
- 耦合设计中，不可信代码与凭证同容器 → prompt injection 只需骗 Claude 读自己的环境变量 → 拿到 token 可**生成新的无限制会话并委派工作**（攻击的放大机制是新洞见）
- Git 模式：用 repo token 在 sandbox 初始化时 clone 并注入 git remote → push/pull 可用但 agent 全程不接触 token
- MCP 模式：OAuth token 存 vault，专用 proxy 按 session 关联 token 取凭证调用，harness 永不接触凭证

### 2.2 与旧版一致的部分（复核无变化）

- session / harness / sandbox 三接口表（getEvents / emitEvent / wake / execute / provision）✅
- pet → cattle 转变、harness 崩溃恢复流程 ✅
- session ≠ context window：session 持久存储 vs harness 任意变换的职责分离 ✅
- Many brains / many hands、p50 TTFT −60%、p95 TTFT −90% ✅
- brain 可把 hand 传给另一个 brain；sandbox 可以是容器、手机或 Pokémon 模拟器 ✅

### 2.3 事件本身的元意义

1. **发布后重写是 Anthropic 工程博客的新常态**：文章不是快照而是活文档，`_updatedAt` 必须纳入每周 diff。本次若只 diff 标题列表将完全漏掉这次重写
2. **managed-agents 重写与 Addy agent-harness-engineering 文形成互证**：两文同周使用 context-anxiety/dead weight 叙事（Addy: "Opus 4.6 largely killed the context-anxiety failure mode"）。注意版本细节差异：Anthropic 新版归因 Opus 4.5，Addy 写 Opus 4.6——以 Anthropic 原文为准
3. 与既有原则闭环：这正是 golden-rules "harness 不缩小只移动"（Addy/Anthropic 双源）的**第三个独立来源**，且首次给出完整生命周期实证

## 三、Ratchet 落地

- 索引快照升级为**含 `_updatedAt` 的版本**，后续每周 diff 两列：新 slug（新文章）+ 变化的 `_updatedAt`（重写文章）
- 本周已将 managed-agents 重写深读成文：`anthropic-managed-agents-rewrite-2026-11-02.md`

## 四、下周盯防

1. Antique 专文（连续第四周）
2. Scion 系列续作
3. 其他文章的 `_updatedAt` 变化（long-running-apps / containment 等重写风险同样存在）
