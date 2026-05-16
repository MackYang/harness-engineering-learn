# Autonomy Health Report（2026Q2）

- 报告周期：2026Q2
- 窗口 ID：`2026Q2`
- 当前自治等级：L3（窗口中经历一次回退并恢复）
- 评审人：EM / Risk Owner / SRE
- 输入数据：`data/autonomy/l3l4-window-2026Q2.csv`
- 自动评估：`data/autonomy/l3l4-validation-2026Q2.json`

## 1. 窗口摘要
- 周数：8
- 结果：`PASS`
- 是否触发回退：是（1 次）

## 2. 指标趋势
- CFR：平均 `0.0875`，峰值 `0.11`
- MTTR：平均 `52.00` 分钟，峰值 `62` 分钟
- Eval Pass Rate：平均 `0.8900`，低点 `0.84`

结论：尽管第 5 周出现短时劣化并触发回退，窗口整体均值仍在阈值范围内。

## 3. 事件与根因
| Week | Event ID | Type | Root Cause | Action | Outcome |
|---|---|---|---|---|---|
| 2026-04-18 | EVT-005 | ROLLBACK | deploy gate misclassification | downgraded_to_l2_and_patch_rule | 一周内恢复并重新回到 L3 |
| 2026-04-25 | EVT-006 | RECOVERY | post rollback policy fix effective | restored_l3_with_guardrail | 连续 3 周稳定 |

## 4. 风险结论
- 回退触发率：`1/8`，处于可控区间且根因可解释。
- 风险控制有效性：回退后修复动作在 1 周内生效。
- 放权结论：可继续维持 L3，L4 放权需再观察一个窗口。

## 5. 后续动作
1. 强化 deploy gate 的规则回归测试，避免误分类复发。
2. 将回退事件的 root cause 模板化并纳入周会检查。
3. 在下个窗口（2026Q3）继续验证 L4 条件。
