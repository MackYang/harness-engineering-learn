# Monthly Tuning Report（CARD-P5-02）

更新时间：2026-05-16（UTC+8）

## 2026-04
- 输入：`data/ops/rule-quality-input-2026-04.csv`
- 输出：`data/ops/rule-quality-2026-04.json`
- 结果：`PASS`
- 关键指标：
  - false_positive_rate: `0.1125`
  - avg_pipeline_seconds: `235.00`
  - block_value_ratio: `0.7250`
- 调优动作：
  - 为 `high-risk-changes` 增加路径白名单，降低误报。
  - 优化 `eval-regression` 触发条件，减少无效阻断。

## 2026-05
- 输入：`data/ops/rule-quality-input-2026-05.csv`
- 输出：`data/ops/rule-quality-2026-05.json`
- 结果：`PASS`
- 关键指标：
  - false_positive_rate: `0.0619`（较上月下降）
  - avg_pipeline_seconds: `217.50`（较上月下降）
  - block_value_ratio: `0.7732`（较上月提升）
- 调优动作：
  - 保持 `block` 级规则稳定，继续压缩噪声。
  - 将 `secret-scan` 保持 `observe`，收集更多周期样本再升级。

## 趋势结论
- 连续两个周期（2026-04、2026-05）均达到目标阈值。
- 满足 `CARD-P5-02` 完成定义：`连续 2 个周期达到优化目标`。
