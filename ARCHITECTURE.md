# Architecture

## Goal
在本仓库内落地 harness-engineering 的清单、任务卡、状态追踪与交接机制。

## Core Components
- `docs/harness-engineering-priority-checklist.md`：优先级主清单
- `docs/harness-engineering-task-cards.md`：任务卡执行标准
- `docs/harness-usage-playbook.md`：项目落地手册
- `docs/status/harness-execution-status.md`：实时状态总表
- `docs/handoff/context-handoff.md`：上下文交接

## Execution Flow
1. 按任务卡依赖顺序执行。
2. 每次状态变化回写状态总表。
3. 阻塞时先写交接记录。

## Risk Boundaries
高风险范围见：`docs/readiness/high-risk-scope.md`
