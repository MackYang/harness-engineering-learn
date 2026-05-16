# Reuse Metrics（CARD-P5-01）

更新时间：2026-05-16（UTC+8）

## 1. 统计目标
- 资产复用率阈值：`>= 70%`
- 完成定义：至少 2 个项目达到复用阈值并留存证据

## 2. 口径定义
- 单项目复用率公式：
  - `overall_reuse_rate = (template_reuse + policy_reuse + eval_reuse + runbook_reuse) / 4`
- 跨项目达标率公式：
  - `reuse_project_rate = projects_meeting_target / total_projects`

## 3. 数据源
- 输入：`data/scaling/reuse-adoption-YYYY-MM-DD.csv`
- 计算脚本：`scripts/scaling/calc_reuse_metrics.sh`
- 输出：`data/scaling/reuse-metrics-YYYY-MM-DD.json`

命令示例：
```bash
./scripts/scaling/calc_reuse_metrics.sh data/scaling/reuse-adoption-2026-05-16.csv 2026-05-16
```

## 4. 当前结果（2026-05-16）
- 输入项目数：2
- 达标项目数：2
- 跨项目达标率：1.00
- 结论：`PASS`

证据：
- `data/scaling/reuse-adoption-2026-05-16.csv`
- `data/scaling/reuse-metrics-2026-05-16.json`
