# L3/L4 Validation Plan（CARD-P5-04）

更新时间：2026-05-16（UTC+8）

## 1. 验证窗口
- 窗口长度：`8-12 周`
- 评审频率：周度快照 + 季度评审
- 最小完成条件：至少 1 个完整窗口并输出健康报告

## 2. 指标与阈值
- CFR（Change Failure Rate）`<= 0.10`
- MTTR（minutes）`<= 60`
- Eval Pass Rate `>= 0.85`
- 回退事件数（窗口内）`<= 1`

## 3. 触发与回退规则
- 任一关键指标连续 2 周劣化：自动降级到上一自治等级。
- 单周出现高风险回滚且根因不可解释：冻结进一步放权。
- 回退后必须提交：
  - 根因分析
  - 修复动作
  - 重新放权前置条件

## 4. 数据与自动评估
- 输入数据：`data/autonomy/l3l4-window-<window_id>.csv`
- 评估脚本：`scripts/autonomy/evaluate_l3l4_window.sh`
- 输出结果：`data/autonomy/l3l4-validation-<window_id>.json`

命令示例：
```bash
./scripts/autonomy/evaluate_l3l4_window.sh data/autonomy/l3l4-window-2026Q2.csv 2026Q2
```

## 5. 季度评审决策
- `PASS`：保持或逐步提升自治等级。
- `HOLD`：保持当前等级，执行专项整改。
- `FAIL`：回退一级并冻结自动放权，直到连续 2 周恢复阈值。
