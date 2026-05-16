# Release / Rollback Drill（CARD-P-1-02）

日期：2026-05-15
状态：`DONE（本地模拟演练）`

## 演练目标
- 完成“发布 -> 回滚 -> 恢复”闭环

## 演练步骤（本地模拟）
1. 发布版本 `v2`（模拟回归版本）。
2. 检测异常并触发回滚。
3. 回滚到稳定版本 `v1`。
4. 验证恢复状态。

## 执行命令
```bash
scripts/drills/release_rollback_simulation.sh
```

## 演练结果
- RELEASE: `v2`
- ROLLBACK_TARGET: `v1`
- RECOVERY_STATE: `stable`
- MTTR_SIMULATED: `under_5_minutes`

## 证据
- 脚本：`scripts/drills/release_rollback_simulation.sh`
- 日志：`logs/readiness/release_rollback_simulation.log`

## 限制说明
- 当前为本地模拟演练，后续进入真实发布环境后需补一次生产等价演练。
