# Anthropic Managed Agents 重写深读笔记 (2026-11-02)

> 来源：https://www.anthropic.com/engineering/managed-agents
> 《Scaling Managed Agents: Decoupling the brain from the hands》
> 作者：Lance Martin, Gabe Cemaj, Michael Cohen
> 首发：2026-04-08 ｜ **重写：2026-10-30**（`_updatedAt: 2026-10-30T15:51:07Z`）
> 学习日期：2026-11-02
> 前序笔记：`anthropic-managed-agents-2026-04-08.md`（初读）、`anthropic-managed-agents-2026-07-20.md`（复读）
> 本笔记聚焦：**重写版新增内容**

## 一、为什么这次重写重要

首发版讲的是**架构**（brain/hands/session 解耦的三接口设计），重写版补上了**架构之上的一层认知**：harness 组件的生命周期管理。新增的开篇框架让这篇文章从"一份好的架构案例"升级为"meta-harness 的设计哲学宣言"。

## 二、新增框架 1：Harness 假设会过时（全文新主旨）

> "A common thread across this work is that harnesses encode assumptions about what Claude can't do on its own. However, those assumptions need to be frequently questioned because they can go stale as models improve."

三段论：
1. 每个 harness 组件都是一条"模型做不到 X"的假设的编码
2. 模型进步 → 假设失效
3. 因此 harness 需要**主动质询与拆除机制**，而不是只做加法

这与 Addy "Harnesses don't shrink, they move" 形成第三家独立印证（OpenAI 的 doc-gardening / GC 式偿债也是同题变奏）。

## 三、新增框架 2：Context Anxiety 实证（首个带模型版本的组件生灭案例）

| 阶段 | 模型 | 行为 | harness 对策 |
|------|------|------|--------------|
| 曾经 | Sonnet 4.5 | 感知上下文将尽 → **提前收尾**（context anxiety） | harness 加 context resets |
| 现在 | Opus 4.5 | 该行为消失 | "The resets had become **dead weight**" |

关键点：
- 这是"假设→脚手架→死重→移除"生命周期的**完整公开实证**，且精确到模型版本
- 启示：harness 组件应该带"存在理由"元数据（它编码的是哪条假设），模型升级时逐条质询——本项目 feature_list 的 source 字段即是这个思想的弱形式
- 与 Addy 文的版本表述差异：Addy 写 "Opus 4.6 largely killed..."，Anthropic 原文是 Opus 4.5。**以 Anthropic 为准**（Addy 为二手转述）

## 四、新增框架 3："Programs as yet unthought of" 显式化为 meta-harness 主旨

重写版把 OS 类比从脚注提升为全文骨架：

- OS 之所以长存：把硬件虚拟化成 process/file 等抽象，抽象比硬件活得久——`read()` 不关心底层是 1970s 磁盘组还是现代 SSD
- Managed Agents 同构：虚拟化 agent 组件为 **session（追加日志）/ harness（循环）/ sandbox（执行环境）** 三接口
- 精炼表述：**"We're opinionated about the shape of these interfaces, not about what runs behind them."**
- 结论句："Managed Agents is a **meta-harness**"——不预设未来 Claude 需要什么 harness，只保证状态操纵（session）与计算执行（sandbox）的接口可靠、安全、可长时程运行

## 五、新增细节：安全攻击链的放大机制

重写版把"凭证与不可信代码分离"的理由写得更完整：

- 耦合设计下，prompt injection 只需骗 Claude 读自己的环境变量
- **拿到 token 的后果不是泄密本身，而是攻击者可以 spawn 全新的、无限制的会话并委派工作**——攻击以代理规模放大
- "Narrow scoping is an obvious mitigation, but this encodes an assumption about what Claude can't do with a limited token—and Claude is getting increasingly smart"：连"缩小权限"也是一条会过时的假设！结构性修复（token 物理不可达）才是唯一不过时的对策

两类模式（复核+补充）：
- **Git**：repo token 只在 sandbox 初始化时用于 clone + 注入 remote → push/pull 正常，agent 零接触 token
- **自定义工具**：OAuth token 入 vault；专用 proxy 按 session 关联的 token 从 vault 取凭证发起调用；harness 全程无凭证

## 六、复核确认（与旧版一致，未变化）

- 三接口操作表：`getEvents(id)` / `emitEvent(id, event)` / `wake(sessionId)` / `execute(name, input) → string` / `provision({resources})` ✅
- pet vs cattle：容器失败 = tool-call error，Claude 决定重试即重建 ✅
- harness 崩溃恢复：session log 在外 → 新 harness `wake(sessionId)` → 从最后事件续跑 ✅
- session ≠ context window：session 只保证持久可问询（positional slices、可回退重读），context engineering 全部推给 harness 层 ✅
- Many brains（p50 TTFT −60% / p95 −90%）/ many hands（sandbox 可以是容器、手机、Pokémon 模拟器；brain 间可传递 hands）✅

## 七、知识库闭环动作

1. golden-rules.md "harness 不缩小只移动"原则升级为**三源印证**（Addy / Anthropic long-running / Anthropic managed-agents 重写版），补充 context-anxiety 实证 → 见补充细节 M
2. 新增 FEAT-075：harness 组件生命周期管理（assumption tagging + 定期质询）
3. 学习流程 ratchet：索引快照升级为含 `_updatedAt` 字段，每周 diff 重写检测
