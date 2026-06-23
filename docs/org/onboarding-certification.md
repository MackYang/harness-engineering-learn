# Onboarding & Certification（CARD-P5-03）

> 新成员上手清单 + 认证门禁。
> 状态：骨架（业务接入时按组织实际角色和工具调整）

## 阅读清单（按顺序）

| 顺序 | 文档 | 目的 |
|------|------|------|
| 1 | `README.md` | 项目定位与十五大原则 |
| 2 | `AGENTS.md` | Agent 入口导航 |
| 3 | `docs/knowledge/principles/operational-principles.md` | 15 条执行纪律 |
| 4 | `docs/knowledge/principles/golden-rules.md` | OpenAI/Anthropic 来源原则 |
| 5 | `ARCHITECTURE.md` | 知识架构 vs 目标架构 |
| 6 | `CONTRIBUTING.md` | 工作流与 PR 标准 |
| 7 | `docs/adr/` | 历史决策上下文 |
| 8 | `docs/status/harness-execution-status.md` | 当前任务卡状态（注意双轨语义澄清） |

## 操作清单（必须在沙箱内完成一次）

- [ ] 跑 `make init` 通过
- [ ] 跑 `make verify` 通过（含 advisory 段）
- [ ] 读 `evals/feature_list.json`，理解 `passes` 字段含义
- [ ] 读一份 `docs/handoff/context-handoff.md` 历史条目
- [ ] 用 `harness-progress.txt` 追加一条练习记录（之后回滚）

## 认证门禁

新成员首次提交 PR 前，必须由现有成员确认：

1. 能区分"任务卡 DONE" vs "feature 通过"（见 ADR-0004）
2. 能解释为什么 garden/principles 是 advisory 而非 gating
3. 能在 PR 描述中正确贴出 `make verify` 尾部输出
4. 知道何时该写新 ADR（见 `CONTRIBUTING.md` 高影响变更段）

## 持续认证

每季度复核：
- 是否读过最近 4 周 `docs/knowledge/sources/` 新增笔记
- 是否参与过至少 1 次 incident 复盘（`docs/incidents/`）
- 是否更新过至少 1 条 `harness-progress.txt`

## 相关

- 角色矩阵：`docs/org/human-ai-roles-matrix.md`
- 升级流程：`docs/org/escalation-runbook.md`
- 运营节奏：`docs/ops/operating-cadence.md`
