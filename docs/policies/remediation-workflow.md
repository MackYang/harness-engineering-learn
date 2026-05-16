# Remediation Workflow（CARD-P0-06）

## 1. 目标
将每次复盘结论自动转为可追踪改进项，避免停留在文档层。

## 2. 状态机
- OPEN：新建改进项
- IN_PROGRESS：执行中
- DONE：完成并验收
- BLOCKED：阻塞（需外部输入）

## 3. 流转规则
1. 每个 postmortem 必须关联至少 1 个任务卡或行动项。
2. 行动项必须有 owner 和 due date。
3. 每周周会检查未关闭项。
4. 30 天关闭率 < 80% 时，冻结自治等级升级。

## 4. 记录位置
- 复盘模板：`docs/incidents/postmortem-template.md`
- 经验日志：`docs/incidents/lessons-learned-log.md`
- 状态总表：`docs/status/harness-execution-status.md`
