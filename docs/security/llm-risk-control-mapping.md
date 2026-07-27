# LLM Risk Control Mapping（CARD-P2-03）

| Risk | Control | Test Method |
|---|---|---|
| Prompt Injection | 输入边界与工具权限限制 | 对抗样例测试 |
| Data Leakage | 敏感数据脱敏与权限隔离 | 泄漏用例扫描 |
| Tool Misuse | 工具调用白名单 | 调用审计与策略检查 |
| Hallucination Critical Path | 高风险回答需证据 | 高风险任务人工审批 |
| Egress Exfiltration via Approved Domain | egress 白名单 + 协议级验证（非仅域名检查） | 第三方红队测试 |
| Pre-Trust Config Execution | 延迟项目配置解析至用户确认信任后 | 负责披露 + 启动时安全审计 |
| User-as-Injection-Vector | 文件系统边界 + egress 控制（模型层防御无效） | 内部红队钓鱼测试 |
| Symlink Escape | symlink 解析在路径验证之前执行 | 路径遍历测试 |
| Approval Fatigue | OS 级沙箱替代逐操作审批（减少 84% 提示） | 匿名使用数据分析 |
