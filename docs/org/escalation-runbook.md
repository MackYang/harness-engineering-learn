# Escalation Runbook（CARD-P5-03）

> 何时升级、向谁升级、SLA 是什么。
> 状态：骨架（业务接入时按组织实际情况具体化角色与联系方式）

## 升级触发条件

| 触发条件 | 升级到 | SLA |
|---------|--------|-----|
| Agent 在沙箱内执行高风险操作被 policy 拦截 | 值班工程师 | 30 min |
| Agent 自主修改了 `policy/` 或 `.github/workflows/` | 安全负责人 | 立即 |
| 连续 3 次 `make verify` 失败且原因相同 | Tech Lead | 4 hr |
| Eval 通过率单周下跌 > 10pp | Tech Lead | 24 hr |
| 沙箱外泄疑似（异常网络流量、token 异常用量） | 安全负责人 + On-call | 立即 |
| 任务卡 BLOCKED 超 48 hr 无交接 | PM | 24 hr |

## AI 失败升级路径

```
L1: Agent 自检（lint/eval/principles advisory）
  ↓ 失败
L2: 自动重试 + Ralph Wiggum Loop（agent-to-agent review）
  ↓ 仍失败
L3: 人工审查（按 ADR-0004 的双轨语义，先看 feature_list.json 而非任务卡）
  ↓ 无法判断
L4: Tech Lead 决策（是否回滚、是否升级到架构层）
```

## 审批超时升级路径

```
T+0:    PR 提交
T+1hr:  无 reviewer 响应 → 自动 ping
T+4hr:  仍无响应 → 升级到 Tech Lead
T+24hr: 仍未合并 → 升级到 PM 决策（是否强合或关闭）
```

## 联系人（待业务接入时填）

- 值班工程师：`TBD`
- Tech Lead：`TBD`
- 安全负责人：`TBD`
- PM：`TBD`

## 相关

- 角色 RACI：`docs/readiness/raci-matrix.md`
- 高风险范围：`docs/readiness/high-risk-scope.md`
- 失败分类：`docs/incidents/failure-taxonomy.md`
- 复盘模板：`docs/incidents/postmortem-template.md`
