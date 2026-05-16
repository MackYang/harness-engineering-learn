# Rule Quality Metrics（CARD-P5-02）

更新时间：2026-05-16（UTC+8）

## 1. 指标定义与阈值
- `false_positive_rate = false_positive_hits / total_hits`
  - 目标：`<= 0.15`
- `avg_pipeline_seconds = sum(rule_avg_pipeline_seconds) / rule_count`
  - 目标：`<= 300`
- `block_value_ratio = actionable_blocks / total_hits`
  - 目标：`>= 0.60`

说明：
- `false_positive_hits`：被复核判定为误报的命中次数。
- `actionable_blocks`：触发后产生有效修复或风险拦截的命中次数。

## 2. 规则分级（阻断/告警/观察）
- `block`：高风险且需要立即阻断合并。
- `warn`：中风险，要求整改但不阻断。
- `observe`：低置信或高噪声，先观察并持续调优。

当前分级清单：
- 见 `data/ops/rule-levels-2026-05-16.csv`

## 3. 统计机制
- 输入：`data/ops/rule-quality-input-YYYY-MM.csv`
- 计算脚本：`scripts/ops/calc_rule_quality_metrics.sh`
- 输出：`data/ops/rule-quality-YYYY-MM.json`

命令示例：
```bash
./scripts/ops/calc_rule_quality_metrics.sh data/ops/rule-quality-input-2026-05.csv 2026-05
```

## 4. 验收判定
- 当月 `PASS` 条件：
  - `false_positive_rate <= 0.15`
  - `avg_pipeline_seconds <= 300`
  - `block_value_ratio >= 0.60`
- 连续 2 个周期 `PASS` 才能完成 CARD-P5-02。
