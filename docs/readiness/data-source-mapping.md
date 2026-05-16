# Data Source Mapping（CARD-P-1-03）

日期：2026-05-15

## 数据源
- Git：本地仓库（已初始化）
- CI：`.github/workflows/ci.yml`（基线工作流）
- Issue：未接入（待绑定实际平台，如 GitHub Issues / Jira）

## 指标字段初始映射
- Lead Time：Git 提交与合并时间（待接入远端后完整化）
- Deploy Frequency：发布记录（当前使用本地模拟日志）
- CFR：回滚事件记录（当前使用演练日志）
- Eval Pass Rate：待 P2-02 接入

## 差距与下一步
1. 绑定 Issue 平台 API。
2. 接入远端 CI 运行结果。
3. 建立自动汇总脚本。
