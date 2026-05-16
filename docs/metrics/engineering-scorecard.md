# Engineering Scorecard（CARD-P0-01）

日期：2026-05-15

## 1. 指标字典

### DORA
1. Lead Time for Changes
- 定义：代码提交到可发布状态的耗时
- 公式：`merge_time - first_commit_time`
- 数据源：Git 提交记录 + PR 记录
- 周期：周
- 阈值：
  - Green: `<= 3 days`
  - Yellow: `> 3 days and <= 7 days`
  - Red: `> 7 days`

2. Deployment Frequency
- 定义：单位时间发布次数
- 公式：`deploy_count / week`
- 数据源：发布日志/CI
- 周期：周
- 阈值：
  - Green: `>= 3/week`
  - Yellow: `1-2/week`
  - Red: `< 1/week`

3. Change Failure Rate (CFR)
- 定义：引发故障/回滚的变更比例
- 公式：`failed_deploy_count / total_deploy_count`
- 数据源：发布记录 + incident 记录
- 周期：周
- 阈值：
  - Green: `<= 10%`
  - Yellow: `> 10% and <= 20%`
  - Red: `> 20%`

4. MTTR
- 定义：从故障检测到恢复的平均时长
- 公式：`sum(recovery_time - incident_start_time) / incident_count`
- 数据源：incident 日志
- 周期：周
- 阈值：
  - Green: `<= 60 minutes`
  - Yellow: `> 60 and <= 240 minutes`
  - Red: `> 240 minutes`

### SPACE（最小集）
1. Satisfaction
- 定义：工程师满意度
- 公式：`survey_avg_score`
- 数据源：月度问卷
- 周期：月
- 阈值：Green `>=4.2/5`, Yellow `3.6-4.1`, Red `<3.6`

2. Collaboration Efficiency
- 定义：PR 平均 review 轮次
- 公式：`total_review_rounds / merged_pr_count`
- 数据源：PR 记录
- 周期：周
- 阈值：Green `<=1.8`, Yellow `1.9-2.5`, Red `>2.5`

3. Flow Efficiency
- 定义：活跃开发时间占比
- 公式：`active_coding_time / total_cycle_time`
- 数据源：任务流转记录
- 周期：周
- 阈值：Green `>=45%`, Yellow `30%-44%`, Red `<30%`

### Eval 质量
1. Eval Pass Rate
- 公式：`passed_cases / total_cases`
- 数据源：eval 运行结果
- 周期：周
- 阈值：Green `>=85%`, Yellow `70%-84%`, Red `<70%`

2. Regression Failure Rate
- 公式：`failed_regression_cases / total_regression_cases`
- 数据源：回归测试结果
- 周期：周
- 阈值：Green `<=5%`, Yellow `6%-10%`, Red `>10%`

3. Manual Rework Rate
- 公式：`reworked_tasks / total_tasks`
- 数据源：任务状态记录
- 周期：周
- 阈值：Green `<=15%`, Yellow `16%-25%`, Red `>25%`

## 2. 指标采集策略
- 自动采集优先，人工填报仅作兜底。
- 任一 Red 指标进入周会必审。
- 连续两周 Red 触发专项整治卡。

## 3. 看板输出要求
- 至少展示最近 4 周趋势。
- 必须显示红黄绿状态。
- 每条指标必须可追溯到原始数据源。
