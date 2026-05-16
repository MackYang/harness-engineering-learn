# LLM Risk Control Mapping（CARD-P2-03）

| Risk | Control | Test Method |
|---|---|---|
| Prompt Injection | 输入边界与工具权限限制 | 对抗样例测试 |
| Data Leakage | 敏感数据脱敏与权限隔离 | 泄漏用例扫描 |
| Tool Misuse | 工具调用白名单 | 调用审计与策略检查 |
| Hallucination Critical Path | 高风险回答需证据 | 高风险任务人工审批 |
