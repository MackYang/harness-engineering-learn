# High Risk Scope（CARD-P-1-03）

日期：2026-05-15

## 高风险目录（冻结）
- `config/production/**`
- `infra/**`
- `auth/**`
- `billing/**`
- `data/delete/**`

## 高风险操作
- 权限策略变更
- 计费逻辑变更
- 生产配置变更
- 删除类数据操作

## 放行规则
- 必须人工审批（Approver）
- 必须附回滚方案
- 必须附验证证据
