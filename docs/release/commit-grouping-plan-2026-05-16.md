# Commit Grouping Plan（2026-05-16）

目标：将当前工作按主题拆分为可审阅、可回滚的提交组。

## 分组原则
- 每组只覆盖一个主题域。
- 每组提交前执行最小验证（至少 `make verify` 一次）。
- 优先提交“基础设施/脚本”再提交“文档/证据”。

## 推荐分组

### Group 1: Metrics Pipeline & Dashboard Input
- 路径：
  - `scripts/metrics/collect_metrics.sh`
  - `data/metrics/weekly-summary.json`
  - `data/metrics/weekly-summary.csv`
  - `data/metrics/dashboard-input.json`
  - `data/metrics/history/weekly-summary-2026-05-08.json`
  - `data/metrics/history/weekly-summary-2026-05-15.json`
- 建议提交信息：
  - `feat(metrics): finalize weekly collection outputs and dashboard input (CARD-P0-02)`

### Group 2: Pilot Expansion Gate Completion
- 路径：
  - `scripts/scaling/evaluate_pilot_gate.sh`
  - `docs/scaling/pilot-expansion-gates.md`
  - `docs/scaling/pilot-expansion-approval-2026-05-16.md`
  - `docs/scaling/pilot-expansion-retrospective-2026-05-16.md`
  - `data/scaling/pilot-dashboard-input-2026-05-16.json`
  - `data/scaling/pilot-lessons-2026-05-16.md`
  - `data/scaling/pilot-gate-2026-05-16.json`
- 建议提交信息：
  - `feat(scaling): complete pilot expansion gate with approval and retrospective (CARD-P4-01)`

### Group 3: Reuse Library & Adoption Metrics
- 路径：
  - `assets-library/**`
  - `scripts/scaling/calc_reuse_metrics.sh`
  - `docs/scaling/reuse-metrics.md`
  - `data/scaling/reuse-adoption-2026-05-16.csv`
  - `data/scaling/reuse-metrics-2026-05-16.json`
- 建议提交信息：
  - `feat(assets): establish reusable asset library and adoption metrics (CARD-P5-01)`

### Group 4: Rule Quality Optimization
- 路径：
  - `scripts/ops/calc_rule_quality_metrics.sh`
  - `docs/ops/rule-quality/rule-quality-metrics.md`
  - `docs/ops/rule-quality/monthly-tuning-report.md`
  - `data/ops/rule-levels-2026-05-16.csv`
  - `data/ops/rule-quality-input-2026-04.csv`
  - `data/ops/rule-quality-input-2026-05.csv`
  - `data/ops/rule-quality-2026-04.json`
  - `data/ops/rule-quality-2026-05.json`
- 建议提交信息：
  - `feat(ops): implement rule quality metrics and two-cycle tuning report (CARD-P5-02)`

### Group 5: L3/L4 Autonomy Validation Window
- 路径：
  - `scripts/autonomy/evaluate_l3l4_window.sh`
  - `docs/autonomy/l3-l4-validation-plan.md`
  - `docs/autonomy/autonomy-health-report-template.md`
  - `docs/autonomy/autonomy-health-report-2026Q2.md`
  - `data/autonomy/l3l4-window-2026Q2.csv`
  - `data/autonomy/l3l4-events-2026Q2.csv`
  - `data/autonomy/l3l4-validation-2026Q2.json`
- 建议提交信息：
  - `feat(autonomy): complete L3/L4 validation window and health report (CARD-P5-04)`

### Group 6: Governance State & Handoff Finalization
- 路径：
  - `docs/status/harness-execution-status.md`
  - `docs/handoff/context-handoff.md`
  - `docs/release/harness-final-release-note-2026-05-16.md`
  - `docs/release/commit-grouping-plan-2026-05-16.md`
- 建议提交信息：
  - `docs(governance): finalize status board, handoff baseline, and release notes`

## 可执行命令模板
```bash
# 1) 按组暂存（示例：Group 2）
git add scripts/scaling/evaluate_pilot_gate.sh \
        docs/scaling/pilot-expansion-gates.md \
        docs/scaling/pilot-expansion-approval-2026-05-16.md \
        docs/scaling/pilot-expansion-retrospective-2026-05-16.md \
        data/scaling/pilot-dashboard-input-2026-05-16.json \
        data/scaling/pilot-lessons-2026-05-16.md \
        data/scaling/pilot-gate-2026-05-16.json

# 2) 提交
git commit -m "feat(scaling): complete pilot expansion gate with approval and retrospective (CARD-P4-01)"

# 3) 验证与继续下一组
make verify
```

## 风险提示
- 若仓库存在历史未跟踪文件，先用 `git status --short` 逐组确认，避免跨组混提。
- 数据快照文件属于证据链，建议与对应脚本和文档同组提交。
