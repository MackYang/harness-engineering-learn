# Anthropic Claude Containment 审视笔记 (2026-08-03)

> 来源：https://www.anthropic.com/engineering/how-we-contain-claude
> 学习日期：2026-08-03
> 对比笔记：2026-07-27版本
>
> 结论：文章内容无显著变化，但结合新增的 Postmortem 文章有新的交叉洞察。

---

## 一、审视确认

文章内容与 2026-07-27 版本一致，无新增架构细节或数据变更。

### 重新确认的核心安全原则

**三层防御体系**：
1. **环境层**：沙箱、VM、文件系统边界、egress 控制
2. **模型层**：系统提示词、分类器、probes、训练修改（概率性，永不 100%）
3. **外部内容层**：MCP 服务器、第三方插件、web search（可审计 ≠ 数据安全）

**三种隔离模式**：
- claude.ai：gVisor ephemeral container
- Claude Code：OS-level sandbox (Seatbelt/bubblewrap)
- Cowork：Local VM (Apple Virtualization Framework / HCS)

### 重新确认的关键数据

- Opus 4.7 Gray Swan 单次攻击成功率：~0.1%，100 次自适应尝试后：~5-6%
- Claude Code auto mode：83% 过度行为在执行前被拦截
- Claude Code 用户批准 ~93% 权限提示
- OS 级沙箱减少 84% 权限提示
- 用户钓鱼测试：25 次中 24 次成功外泄数据

## 二、结合 Postmortem 的新交叉洞察

### Containment 与质量退化之间的关系

Anthropic postmortem 的三个问题与 containment 架构有深层联系：

1. **缓存 bug（context 管理）**：虽然不是安全漏洞，但展示了**环境层中上下文管理的脆弱性**。正如 containment 中"最弱的层是你自己构建的层"，缓存优化也是自定义代码，容易出 bug。

2. **系统提示词 bug**：这直接关联到 containment 中的**模型层防御**。模型层的提示词变更不仅影响安全性，还影响功能性。这种杠杆效应在两个维度都成立。

3. **Code Review 工具的进化**：Opus 4.7 + 完整仓库上下文能发现 Opus 4.6 不能发现的 bug。这与 containment 文章中 "安全防御应重叠和互补" 的原则一致——**模型能力的进化增强了所有层的防御能力**。

### "Mythos Preview 扣留" 决策的深层含义

结合 postmortem 中 Anthropic 展现的透明度（公开承认三个问题、重置用量限制），可以理解 Mythos Preview 扣留决策：
- Anthropic 会在不确定安全边界时主动扣留发布
- 但同时展现出**一旦出问题就快速、透明修复的文化**
- 这种文化本身就是一种安全 harness——它降低了"扣留"的决策成本，因为修复流程成熟
