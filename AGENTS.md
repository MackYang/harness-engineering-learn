# AGENTS Entry Point

> 这是 Agent 的入口地图，不是百科全书。按需深入，不要一次全部加载。
> 核心理念：人类掌舵，Agent 执行。上下文是稀缺资源。

## Quick Start（新 Agent 上手）

1. 读本文件（你正在做）
2. 检查当前状态：`docs/status/harness-execution-status.md`
3. 查看任务卡：`docs/harness-engineering-task-cards.md`
4. 查看功能清单：`evals/feature_list.json`
5. 检查进度文件：`harness-progress.txt`（如果存在）

## Navigation Map（按场景导航）

### 场景：开始新任务
1. 读取 `docs/status/harness-execution-status.md` → 找到下一个未完成任务
2. 读取对应的任务卡细节 → 理解目标和验收标准
3. 检查依赖是否满足 → 查 `docs/harness-engineering-priority-checklist.md`
4. 执行 → 验证 → 提交

### 场景：写代码/实现功能
1. 先读 `ARCHITECTURE.md` → 理解系统分层和依赖方向
2. 读 `CONTRIBUTING.md` → 理解提交规范和 PR 流程
3. 参考 `docs/knowledge/principles/operational-principles.md` → 项目操作原则（15 条执行纪律）
4. 实现后运行 `make verify` 验证

### 场景：上下文不足/会话中断
1. 读 `docs/handoff/context-handoff.md` → 交接记录
2. 填写交接模板 → 确保下一个 session 能无缝接续

### 场景：学习 Harness Engineering 知识
1. 入门：`docs/knowledge/README.md` → 知识库索引
2. 项目操作原则：`docs/knowledge/principles/operational-principles.md` → 15 条执行纪律
3. 来源原则：`docs/knowledge/principles/golden-rules.md` → OpenAI/Anthropic 提炼的 15 条原理
4. 实战模式：`docs/knowledge/patterns/` → Agent 工作流和架构模式
5. 权威来源笔记：`docs/knowledge/sources/` → 原始学习笔记（按日期归档）

### 场景：评估/验证
1. 运行 `make eval` → 执行评估
2. 查看评分器：`evals/scorers/multi_grader.sh`
3. 查看结果：`evals/results/`
4. 评估标准：`docs/knowledge/patterns/eval-patterns.md`

## Mandatory Rules（必须遵守）

- **一次只执行一张任务卡** — 增量优先，禁止 one-shot
- **状态变化必须回写** → `docs/status/harness-execution-status.md`
- **上下文不足必须交接** → `docs/handoff/context-handoff.md`
- **实现后必须验证** → `make eval`
- **完成后必须提交** → `git commit` + 更新 `harness-progress.txt`
- **Generator ≠ Evaluator** — 实现和评估必须分离

## Context Engineering Guidelines

- 上下文是稀缺资源（Context window is RAM）— 每个 token 花在噪音上就少了推理空间
- Just-in-Time 检索 — 维护路径引用，运行时按需加载，不要预加载全部
- Progressive Disclosure — 从小而稳定的切入点开始，按需深入
- 绝对路径 — 所有文件操作使用绝对路径
- 给地图不给说明书 — 不要写巨大的指令文件

## Agent Workflows（OpenAI 最佳实践）

### Ralph Wiggum Loop（审查闭环）
Agent 完成任务的标准流程：
1. 本地自审变更 → 发现问题立即修复
2. 请求其他 Agent 审查（本地+云端）→ 收集反馈
3. 响应人类/Agent 反馈 → 迭代修复
4. 循环直到所有审查者满意 → 合并

> 人类审查是可选的，不是必须的。审查工作应尽量推向 Agent-to-Agent。

### 品味编码（Encode Taste）
人类审查反馈必须转化为代码规则，而非口头提醒：
- 反复出现的问题 → 加到 lint 规则
- Lint 错误信息必须包含修复指令 → Agent 看到就知道怎么修
- 架构偏好 → 编码为分层 linter 机械执行
- 每次人类 review 发现的新问题 → 更新 golden principles

### 垃圾回收（Continuous GC）
- 运行 `make principles` 检测 golden principles 偏差
- 运行 `make garden` 检测过时文档
- 偏差发现后立即修复，不要让技术债累积

### 计划即工件（Plans as Artifacts）
- 小变更：轻量临时计划
- 复杂工作：正式执行计划（含进度和决策日志）
- 所有计划版本化存放在仓库中
- Agent 不依赖外部上下文，一切从仓库获取

## Architecture Layers

```
Types → Config → Repo → Service → Runtime → UI
```
依赖方向严格单向。详见 `ARCHITECTURE.md`。

## Key Files Index

| 文件 | 用途 |
|------|------|
| `docs/status/harness-execution-status.md` | 实时状态总表 |
| `docs/harness-engineering-task-cards.md` | 任务卡执行标准 |
| `docs/harness-engineering-priority-checklist.md` | 优先级主清单 |
| `docs/handoff/context-handoff.md` | 上下文交接 |
| `docs/knowledge/README.md` | 知识库索引 |
| `evals/feature_list.json` | 功能清单和验证状态 |
| `ARCHITECTURE.md` | 系统架构 |
| `CONTRIBUTING.md` | 贡献规范 |

## Current Phase

参考 `docs/status/harness-execution-status.md`
