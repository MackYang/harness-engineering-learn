# CI / Policy Baseline（CARD-P0-07 & CARD-P0-08）

## 已完成
- Git 仓库已初始化
- `.github/workflows/ci.yml` 已创建
- `policy/high-risk-changes.rego` 已创建
- `make verify` 已通过（lint/test/eval/policy）

## 待补齐
- 将当前仓库专用脚本替换为目标业务项目真实命令
- 配置分支保护与禁止 bypass（依赖远端平台）
