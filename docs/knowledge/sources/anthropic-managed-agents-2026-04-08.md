# Anthropic Engineering 知识笔记：Scaling Managed Agents

> 来源：[Scaling Managed Agents: Decoupling the brain from the hands](https://www.anthropic.com/engineering/managed-agents)
> 作者：Lance Martin, Gabe Cemaj, Michael Cohen
> 发表：2026-04-08
> 学习日期：2026-06-23

## 核心问题

随着 Agent 工作时间拉长（数小时到数天），早期把 session / harness / sandbox 塞进同一个容器的设计暴露三大问题：

1. **容器成了"宠物"（pet）** — 失败即丢会话；调试要进容器但容器里有用户数据，等于无法调试
2. **harness 假设资源都在容器旁** — 客户要连自己 VPC 时被迫对等网络或本地跑 harness
3. **凭证和不可信代码同处** — prompt injection 只要骗 Claude 读环境变量即可拿 token

## 核心抽象：Meta-Harness

借鉴操作系统的 `process` / `file` 抽象（虚拟化硬件，让"尚未发明的程序"也能跑），Managed Agents 把 Agent 虚拟化成三个接口：

| 接口 | 职责 | 关键操作 |
|------|------|----------|
| **session** | 追加日志，活在 Claude 上下文窗口之外 | `getEvents(id)` / `emitEvent(id, event)` |
| **harness** | 调用 Claude 并路由工具调用的循环 | `wake(sessionId)` — 无状态可重建 |
| **sandbox** | Claude 跑代码、改文件的执行环境 | `execute(name, input) → string` / `provision({resources})` |

**只对接口形状固执，不对接口背后跑什么固执。** 同一个接口能跑容器、手机、Pokémon 模拟器。

## 三大解耦决策

### 1. Brain 离开 container

harness 不再住进容器。它像调用工具一样调用 sandbox：`execute(name, input) → string`。容器死了 → harness 捕获为 tool-call 错误 → Claude 决定重试 → 新容器按标准 recipe 重建。**容器从 pet 变 cattle**。

### 2. Harness 也变成 cattle

session 日志在 harness 外面。harness 崩溃 → 新 harness 用 `wake(sessionId)` 重启 → `getSession(id)` 拿回事件流 → 从最后一个事件续。loop 中通过 `emitEvent` 持续写盘。

### 3. Session ≠ Claude 的 context window

长任务超过上下文窗口时，传统方案（compaction / memory / trimming）都要做不可逆的"留什么"决策。Managed Agents 把这个决策推给 harness：

- **session 只负责持久** — 全量事件流追加存储，可切片回放
- **harness 负责变换** — 用 `getEvents()` 取片段后做 compaction、prompt cache 优化、context engineering

> "我们分离了 session 的可恢复存储和 harness 的任意上下文管理，因为无法预测未来模型需要什么具体的上下文工程。"

## 安全边界：凭证永不进 sandbox

两种模式确保 token 不可达：

- **Git** — 用 repo 自己的 access token 在 sandbox 初始化时 clone 并配到本地 remote。`push` / `pull` 在 sandbox 内直接跑，Agent 永远不碰 token
- **自定义工具** — 支持 MCP，OAuth token 存 sandbox 外的 vault。Claude 通过专用 proxy 调用 MCP 工具，proxy 用 sessionId 关联的 token 从 vault 取凭证发起调用

**harness 永远不知道任何凭证。**

## Many brains, many hands

- **多 brain** — harness 离开容器后，多 brain 只是起多个无状态 harness；只在需要时才 provision 容器。p50 TTFT −60%，p95 TTFT −90%
- **多 hand** — 每个 hand 是 `execute(name, input) → string` 工具；brain 可以把 hand 传给另一个 brain

## 对 Harness Engineering 的启示

1. **接口先于实现** — 把 session / harness / sandbox 当作稳定接口设计，实现可以随时换（OS 思维）
2. **cattle 优于 pet** — 任何组件失败都应该能从持久态恢复，而不是"养病"
3. **凭证边界是结构性的，不是 prompt 约束** — 用 vault + proxy 让 token 物理上不可达，而不是"请不要外泄"
4. **session 与 context window 是两件事** — 持久化（session）和上下文工程（harness）必须解耦，因为未来模型的上下文需求不可预测
5. **TTFT 是用户体感的核心指标** — p50/p95 双指标跟踪；只为需要的 session provision 容器

## 与项目原则的映射

- 原则 7（脑手分离）→ 本文给出了具体的接口原语（`execute` / `wake` / `getEvents` / `emitEvent`）
- 原则 8（安全纵深）→ vault + proxy 是结构性实现
- 原则 2（外部记忆）→ session 作为 Claude 上下文窗口之外的持久对象

---

*参考链接：*
- *[Scaling Managed Agents: Decoupling the brain from the hands](https://www.anthropic.com/engineering/managed-agents)* — 2026-04-08
