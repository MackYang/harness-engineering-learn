# Policy-as-Code Baseline

本目录存放高风险变更策略规则。

## 当前规则
- `high-risk-changes.rego`：高风险路径变更需人工审批

## 执行建议
- 在 CI 中执行策略检查
- 命中高风险规则时阻断合并
