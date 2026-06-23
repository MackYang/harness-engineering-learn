# Architecture

> 本仓库是 Harness Engineering 的学习/实践仓库，不是 shipping product。
> 本文档澄清两个并存的"架构"概念：**本仓库的知识架构** 与 **目标分层架构**。

## 1. 本仓库的知识架构（实际结构）

按"给地图不给说明书"原则组织：

```
入口层    AGENTS.md                              ← Agent 入口（~110 行地图）
知识层    docs/knowledge/                        ← 权威知识笔记
          ├─ principles/                         ← 项目操作原则 + 来源原则
          ├─ patterns/                           ← Agent 工作流和架构模式
          └─ sources/                            ← 原始学习笔记（按日期归档）
状态层    docs/status/harness-execution-status.md ← 任务卡实时状态
          docs/handoff/context-handoff.md        ← 上下文交接日志
          harness-progress.txt                   ← 跨 session 进度（根目录）
执行层    docs/harness-engineering-task-cards.md
          docs/harness-engineering-priority-checklist.md
治理层    policy/                                 ← Policy-as-Code（Rego）
          scripts/ci/                            ← Lint/Eval/Garden/Principles
评估层    evals/                                  ← Feature list + scorers + results
```

**依赖方向**：调用方都通过 `AGENTS.md` 进入；知识层和状态层互相独立；执行层和治理层引用知识层；评估层独立测所有上面层。

## 2. 目标分层架构（学习对象，不在本仓库实现）

`docs/knowledge/principles/golden-rules.md` 描述 OpenAI Harness Engineering 的目标架构 — 每个业务域内严格单向依赖：

```
Types → Config → Repo → Service → Runtime → UI
```

横切关注点（认证、连接器、遥测、特性标志）通过单一显式接口 `Providers` 进入。本仓库本身不实现这套分层（没有业务代码），仅记录它供业务项目接入时参考。详见 `docs/GUIDE_APPLY_TO_PROJECT.md`。

## 3. Harness 三组件（Anthropic Meta-Harness 接口）

来自 `docs/knowledge/sources/anthropic-managed-agents-2026-04-08.md`：

| 组件 | 职责 | 接口 |
|------|------|------|
| **session** | 追加事件日志，活在 Claude 上下文窗口之外 | `getEvents(id)` / `emitEvent(id, event)` |
| **harness** | 调用 Claude 并路由工具调用的循环 | `wake(sessionId)` — 无状态可重建 |
| **sandbox** | Claude 跑代码、改文件的执行环境 | `execute(name, input) → string` |

本仓库的学习笔记记录这些接口原语；具体实现见 Anthropic Managed Agents 服务。

## 4. 执行流（本仓库日常）

1. 按任务卡依赖顺序执行（`docs/harness-engineering-task-cards.md`）
2. 每次状态变化回写 `docs/status/harness-execution-status.md`
3. 阻塞或跨 session 时写 `docs/handoff/context-handoff.md`
4. 实现后必须跑 `make verify`（lint+test+eval+policy 必过；garden+principles advisory）
5. 完成后必须 commit + 追加 `harness-progress.txt`

## 5. 治理边界

- **Policy-as-Code**：`policy/high-risk-changes.rego` + `scripts/ci/policy_check.sh`
- **风险范围**：`docs/readiness/high-risk-scope.md`
- **架构 linter**：`scripts/ci/lint.sh`（错误信息含 FIX 指令）
- **品味扫描**：`scripts/ci/golden_principles_check.sh`（advisory）

## 6. 相关 ADR

- `docs/adr/0001-task-card-driven-execution.md`
- `docs/adr/0002-mandatory-status-and-handoff.md`
- `docs/adr/0003-phased-rollout-p-minus-1-to-p5.md`
- `docs/adr/0004-decouple-task-done-from-feature-passes.md`（2026-06-23 新增）
