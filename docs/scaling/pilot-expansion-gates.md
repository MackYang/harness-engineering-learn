# Pilot Expansion Gates（CARD-P4-01）

更新时间：2026-05-19（UTC+8）

## 1. 扩圈准入标准（速度/质量/稳定性）
- 条件 A（速度+质量+稳定性）：最近连续 2 周核心指标均为 `green`
- 条件 B（稳定性）：最近 2 周无重大回滚（`MAJOR_ROLLBACK=false`）
- 条件 C（治理闭环）：复盘改进项闭环率 `>= 0.80`

准入结论：
- `PASS`：A+B+C 全满足，可提交扩圈审批
- `HOLD`：任一条件不满足，维持当前自治等级，不得扩圈

## 2. 不达标降级动作
- 任一核心指标从 `green` 降至 `yellow/red`：冻结扩圈申请，补齐 2 周恢复窗口
- 出现重大回滚：立即降级至当前或更低自治等级，进入 incident + postmortem
- 闭环率低于 0.80：暂停扩圈，优先清理未关闭改进项

## 3. 自动判定与证据
- 判定脚本：`scripts/scaling/evaluate_pilot_gate.sh`
- 输入：
  - `data/scaling/pilot-dashboard-input-YYYY-MM-DD.json`
  - `data/scaling/pilot-lessons-YYYY-MM-DD.md`
  - 环境变量 `MAJOR_ROLLBACK=true|false`
- 输出：
  - `data/scaling/pilot-gate-<YYYY-MM-DD>.json`

命令：
```bash
./scripts/scaling/evaluate_pilot_gate.sh 2026-05-16 data/scaling/pilot-dashboard-input-2026-05-16.json data/scaling/pilot-lessons-2026-05-16.md
```

## 4. 扩圈审批模板（最小）
```md
# Pilot Expansion Approval

- 日期：
- 申请团队：
- 申请自治等级：
- 评审人（EM/Tech Lead/SRE）：

## Gate 输入
- 周期：最近 2 周
- 指标输入文件：`data/scaling/pilot-dashboard-input-YYYY-MM-DD.json`
- 复盘闭环输入文件：`data/scaling/pilot-lessons-YYYY-MM-DD.md`
- 回滚标记：`MAJOR_ROLLBACK=<true|false>`

## Gate 结果
- 条件 A（2 周核心指标 green）：`true|false`
- 条件 B（无重大回滚）：`true|false`
- 条件 C（闭环率 >= 0.80）：`true|false`
- 自动判定：`PASS|HOLD`

## 决策
- 审批结论：`批准扩圈 | 维持现状`
- 风险说明：
- 回退预案链接：
```


## 5. 首轮扩圈执行证据
- Gate 输入：`data/scaling/pilot-dashboard-input-2026-05-16.json`
- 闭环快照：`data/scaling/pilot-lessons-2026-05-16.md`
- Gate 输出：`data/scaling/pilot-gate-2026-05-16.json`（`PASS`）
- 审批记录：`docs/scaling/pilot-expansion-approval-2026-05-16.md`
- 复盘记录：`docs/scaling/pilot-expansion-retrospective-2026-05-16.md`

## 6. 周度复核证据（运营维护）
- 2026-05-17 Gate 输出：`data/scaling/pilot-gate-2026-05-17.json`（`HOLD`）
- 2026-05-17 周度复核记录：`docs/scaling/pilot-expansion-weekly-review-2026-05-17.md`
- 2026-05-19 Gate 输出：`data/scaling/pilot-gate-2026-05-19.json`（`HOLD`）
- 2026-05-19 周度复核记录：`docs/scaling/pilot-expansion-weekly-review-2026-05-19.md`
