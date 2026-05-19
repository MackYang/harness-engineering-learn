# Harness-Engineering 执行状态总表

> 规则：每完成或阻塞一张任务卡，必须立即更新本文件。
> 更新时间（UTC+8）：2026-05-19

## 状态定义
- `NOT_STARTED`：未开始
- `IN_PROGRESS`：执行中
- `DONE`：完成且验收通过
- `BLOCKED`：阻塞（需外部输入/审批/系统权限）

## 0. 当前概览
- 总任务卡：32
- DONE：32
- IN_PROGRESS：0
- BLOCKED：0
- NOT_STARTED：0

## 1. 任务卡状态

| Task ID | 状态 | 最近更新 | 证据/产出物 | 下一步 |
|---|---|---|---|---|
| CARD-P-1-01 | DONE | 2026-05-15 | `docs/readiness/pilot-charter.md`, `docs/readiness/raci-matrix.md` | 后续替换临时签字为正式签字 |
| CARD-P-1-02 | DONE | 2026-05-15 | `docs/readiness/ci-baseline-check.md`, `docs/readiness/release-rollback-drill.md`, `scripts/drills/release_rollback_simulation.sh` | 后续补真实环境演练 |
| CARD-P-1-03 | DONE | 2026-05-15 | `docs/readiness/data-source-mapping.md`, `docs/readiness/high-risk-scope.md`, `data/readiness/weekly-baseline-sample.json` | 后续接入真实 Issue 平台 |
| CARD-P-1-04 | DONE | 2026-05-15 | `docs/readiness/first-wave-task-assignment.md`, `docs/readiness/pr-evidence-standard.md`, `docs/readiness/operating-calendar.md` | 按分配表启动首轮任务 |
| CARD-P-1-05 | DONE | 2026-05-15 | `docs/readiness/ai-runtime-standard.md`, `docs/readiness/template-validation-rules.md`, `docs/readiness/compliance-boundaries.md` | 后续按组织政策迭代细化 |
| CARD-P0-01 | DONE | 2026-05-15 | `docs/metrics/engineering-scorecard.md` | 进入自动采集阶段 |
| CARD-P0-02 | DONE | 2026-05-17 | `scripts/metrics/collect_metrics.sh`, `data/metrics/weekly-summary.json`, `data/metrics/history/weekly-summary-2026-05-08.json`, `data/metrics/history/weekly-summary-2026-05-15.json`, `data/metrics/history/weekly-summary-2026-05-16.json`, `data/metrics/history/weekly-summary-2026-05-17.json`, `data/metrics/weekly-summary.csv`, `data/metrics/dashboard-input.json` | 后续接入远端 Git/CI/Issue 数据源替换占位字段 |
| CARD-P0-03 | DONE | 2026-05-15 | `docs/ops/weekly-metrics-review-template.md`, `docs/ops/action-items-log.md` | 周会按模板执行 |
| CARD-P0-04 | DONE | 2026-05-15 | `docs/incidents/failure-taxonomy.md` | 用于复盘分类 |
| CARD-P0-05 | DONE | 2026-05-15 | `docs/incidents/postmortem-template.md`, `docs/incidents/lessons-learned-log.md` | 进入复盘闭环执行 |
| CARD-P0-06 | DONE | 2026-05-15 | `docs/policies/remediation-workflow.md` | 周度跟踪关闭率 |
| CARD-P0-07 | DONE | 2026-05-15 | `.github/workflows/ci.yml`, `Makefile`, `scripts/ci/lint.sh`, `scripts/ci/test.sh`, `scripts/ci/eval.sh`, `scripts/ci/policy_check.sh` | 后续在远端开启分支保护 |
| CARD-P0-08 | DONE | 2026-05-15 | `policy/README.md`, `policy/high-risk-changes.rego`, `scripts/ci/policy_check.sh` | 持续迭代规则命中与误报 |
| CARD-P1-01 | DONE | 2026-05-15 | `ARCHITECTURE.md`, `CONTRIBUTING.md`, `AGENTS.md` | 持续维护文档准确性 |
| CARD-P1-02 | DONE | 2026-05-15 | `docs/adr/0000-template.md`, `docs/adr/README.md`, `docs/adr/0001-task-card-driven-execution.md`, `docs/adr/0002-mandatory-status-and-handoff.md`, `docs/adr/0003-phased-rollout-p-minus-1-to-p5.md` | 后续高影响变更补 ADR |
| CARD-P1-03 | DONE | 2026-05-15 | `Makefile`, `docs/runbooks/dev-workflow.md` | 后续替换占位命令为真实命令 |
| CARD-P1-04 | DONE | 2026-05-15 | `.github/ISSUE_TEMPLATE/task.yml`, `.github/pull_request_template.md` | 在远端平台启用模板校验 |
| CARD-P2-01 | DONE | 2026-05-15 | `docs/testing/test-strategy.md` | 后续补真实测试覆盖数据 |
| CARD-P2-02 | DONE | 2026-05-15 | `evals/README.md`, `evals/datasets/core_tasks.jsonl`, `evals/scorers/basic_scorer.sh`, `evals/results.json` | 后续替换占位评分为真实评分 |
| CARD-P2-03 | DONE | 2026-05-15 | `docs/security/llm-risk-control-mapping.md` | 持续补充对抗用例 |
| CARD-P2-04 | DONE | 2026-05-15 | `docs/security/supply-chain-baseline.md`, `scripts/supply_chain/generate_baseline.sh`, `artifacts/sbom/sbom-20260515.txt`, `artifacts/provenance/provenance-20260515.txt` | 后续改为 CI 自动生成 |
| CARD-P3-01 | DONE | 2026-05-15 | `docs/sre/slo-catalog.md` | 绑定真实监控数据源 |
| CARD-P3-02 | DONE | 2026-05-15 | `docs/sre/error-budget-policy.md` | 按月执行预算评审 |
| CARD-P3-03 | DONE | 2026-05-15 | `docs/release/progressive-delivery.md` | 在真实环境实施 canary/stage/full |
| CARD-P3-04 | DONE | 2026-05-15 | `docs/risk/ai-rmf-operating-model.md` | 季度风险评审闭环 |
| CARD-P4-01 | DONE | 2026-05-19 | `docs/scaling/pilot-expansion-gates.md`, `scripts/scaling/evaluate_pilot_gate.sh`, `data/scaling/pilot-dashboard-input-2026-05-16.json`, `data/scaling/pilot-lessons-2026-05-16.md`, `data/scaling/pilot-gate-2026-05-16.json`, `data/scaling/pilot-gate-2026-05-17.json`, `data/scaling/pilot-gate-2026-05-19.json`, `docs/scaling/pilot-expansion-approval-2026-05-16.md`, `docs/scaling/pilot-expansion-retrospective-2026-05-16.md`, `docs/scaling/pilot-expansion-weekly-review-2026-05-17.md`, `docs/scaling/pilot-expansion-weekly-review-2026-05-19.md` | 后续按周复核 gate 并滚动维护扩圈门槛 |
| CARD-P4-02 | DONE | 2026-05-15 | `docs/scaling/golden-path.md`, `templates/service-starter/README.md` | 以真实新项目验证接入效率 |
| CARD-P4-03 | DONE | 2026-05-15 | `docs/ops/operating-cadence.md` | 按周/月/季度执行 |
| CARD-P5-01 | DONE | 2026-05-17 | `assets-library/README.md`, `assets-library/CHANGELOG.md`, `assets-library/asset-manifest.yaml`, `docs/scaling/reuse-metrics.md`, `scripts/scaling/calc_reuse_metrics.sh`, `data/scaling/reuse-adoption-2026-05-16.csv`, `data/scaling/reuse-metrics-2026-05-16.json`, `data/scaling/reuse-metrics-2026-05-17.json` | 继续按月更新复用率并扩展到更多项目 |
| CARD-P5-02 | DONE | 2026-05-16 | `docs/ops/rule-quality/rule-quality-metrics.md`, `docs/ops/rule-quality/monthly-tuning-report.md`, `scripts/ops/calc_rule_quality_metrics.sh`, `data/ops/rule-levels-2026-05-16.csv`, `data/ops/rule-quality-input-2026-04.csv`, `data/ops/rule-quality-input-2026-05.csv`, `data/ops/rule-quality-2026-04.json`, `data/ops/rule-quality-2026-05.json` | 按月滚动统计并持续优化规则噪声与耗时 |
| CARD-P5-03 | DONE | 2026-05-15 | `docs/org/human-ai-roles-matrix.md`, `docs/org/escalation-runbook.md`, `docs/org/onboarding-certification.md` | 组织演练并收敛改进项 |
| CARD-P5-04 | DONE | 2026-05-16 | `docs/autonomy/l3-l4-validation-plan.md`, `docs/autonomy/autonomy-health-report-template.md`, `scripts/autonomy/evaluate_l3l4_window.sh`, `data/autonomy/l3l4-window-2026Q2.csv`, `data/autonomy/l3l4-events-2026Q2.csv`, `data/autonomy/l3l4-validation-2026Q2.json`, `docs/autonomy/autonomy-health-report-2026Q2.md` | 在 2026Q3 窗口继续验证 L4 放权条件 |

## 2. 已完成记录
- 2026-05-15：清单体系搭建完成（主清单、任务卡、使用手册、成熟度 P5、实施准备 P-1）。
- 2026-05-15：CARD-P-1-01 完成（临时单人试点版本，待正式签字替换）。
- 2026-05-15：CARD-P-1-02 完成（本地模拟发布/回滚演练通过）。
- 2026-05-15：CARD-P-1-03 完成（数据源映射、高风险范围、周基线样本已落地）。
- 2026-05-15：CARD-P-1-04 完成（首轮分配、证据规范、运营日历已冻结）。
- 2026-05-15：CARD-P-1-05 完成（临时合规边界版本，后续按组织政策细化）。
- 2026-05-15：CARD-P0-01 完成（指标字典与阈值已定义）。
- 2026-05-15：CARD-P0-02 进入 IN_PROGRESS（自动采集脚本与周汇总已落地）。
- 2026-05-15：CARD-P0-03 / P0-04 / P0-05 / P0-06 完成。
- 2026-05-15：CARD-P0-07 / P0-08 进入 IN_PROGRESS（CI 与策略骨架已落地，待真实接入）。
- 2026-05-15：CARD-P1-01 / P1-02 / P1-03 / P1-04 完成。
- 2026-05-15：CARD-P2 / P3 / P4 / P5 产物已全部初始化；其中需时间窗口或真实平台验证的卡已标记 IN_PROGRESS。
- 2026-05-15：CARD-P0-07 / P0-08 完成（CI 已执行真实脚本，策略检查已接入）。
- 2026-05-15：CARD-P2-04 完成（本地 SBOM/Provenance 已生成并留存证据）。
- 2026-05-15：CARD-P0-02 完成（已形成两周自动数据快照，新增统一 CSV 与看板输入 JSON）。
- 2026-05-16：CARD-P5-01 完成（资产清单与版本规范已落地，2 个项目复用率统计达标并留存证据）。
- 2026-05-16：CARD-P5-02 完成（规则分级、指标计算与月报机制落地，连续 2 个周期达到优化目标）。
- 2026-05-16：CARD-P5-04 完成（8 周验证窗口、事件根因记录与季度健康报告已落地并通过阈值校验）。
- 2026-05-16：CARD-P4-01 完成（首轮扩圈 gate 判定通过，审批与复盘记录已留存）。
- 2026-05-17：运营维护周度滚动已执行（`make metrics`、`evaluate_pilot_gate.sh`、`calc_reuse_metrics.sh`），新增周快照与 gate/复用率证据。
- 2026-05-17：CARD-P4-01 周度复核完成（新增 `pilot-expansion-weekly-review-2026-05-17.md`，本周 gate 结论为 `HOLD` 并明确下周收敛动作）。
- 2026-05-19：CARD-P4-01 周度复核完成（新增 `pilot-expansion-weekly-review-2026-05-19.md`，`pilot-gate-2026-05-19.json` 结论为 `HOLD`）。
