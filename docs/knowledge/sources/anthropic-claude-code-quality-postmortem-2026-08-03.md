# Anthropic Claude Code 质量问题 Postmortem 学习笔记 (2026-08-03)

> 来源：https://www.anthropic.com/engineering/april-23-postmortem
> 发布日期：Apr 23, 2026
> 学习日期：2026-08-03
> 文章类型：全新文章（Anthropic Engineering Blog 新增）

---

## 一、文章概述

本文是 Anthropic 针对 2026 年 3-4 月期间用户反馈的 "Claude 响应质量下降" 问题所做的公开事后分析。调查发现三个独立问题分别影响了 Claude Code、Claude Agent SDK 和 Claude Cowork，API 不受影响。所有问题已在 v2.1.116 (Apr 20) 中修复。

**核心发现**：三个不同问题在不同时间影响不同流量切片，叠加效果看起来像是广泛、不一致的退化。内部评估最初无法复现问题。

---

## 二、三个具体问题

### 2.1 问题一：Claude Code 默认 Reasoning Effort 从 High 改为 Medium

**时间线**：
- Mar 4：将默认 reasoning effort 从 high 改为 medium（为了减少 Opus 4.6 high mode 下的超长延迟）
- Apr 7：回滚该变更

**影响模型**：Sonnet 4.6, Opus 4.6

**根因分析**：
- 内部评估中，medium effort 的智能略低于 high，但延迟显著降低
- medium 没有出现 high mode 的长尾延迟问题
- 但用户明确报告 Claude Code 感觉"变笨了"
- 尽管做了设计迭代（启动通知、内联 effort 选择器、恢复 ultrathink），多数用户仍保留 medium 默认值

**当前状态**：
- Opus 4.7 默认 xhigh effort
- 其他模型默认 high effort

**教训**：
- **用户宁愿等更久也要更聪明的输出**——这是一个重要的产品优先级信号
- 内部评估结果与用户感知可能不一致
- "减少延迟"和"降低智能"之间的权衡不能仅靠内部数据判断

### 2.2 问题二：缓存优化导致丢失 Prior Reasoning（最严重的 bug）

**时间线**：
- Mar 26：部署缓存优化（空闲超 1 小时的 session 清除旧 thinking）
- Apr 10：修复 bug

**影响模型**：Sonnet 4.6, Opus 4.6

**根因分析**：
- 设计意图：利用 prompt caching，session 空闲超 1 小时后清除旧 thinking sections，减少恢复时的 uncached token 数量
- 使用 `clear_thinking_20251015` API header + `keep:1`
- **实现 bug**：不是只清除一次，而是 **每个 turn 都清除**（对整个 session 的剩余部分）
- 一旦 session 触发了空闲阈值，后续每次请求只保留最近一块 reasoning，丢弃之前的所有内容
- 如果在 Claude 工具使用中途发送后续消息，当前 turn 的 reasoning 也被丢弃

**用户感知**：健忘、重复、奇怪的工具有选择

**副作用**：
- 连续清除 thinking blocks 导致 cache miss 级联
- 用量限制消耗速度超出预期

**为什么难以发现和修复**：
- 两个不相关的实验干扰了复现：内部消息队列实验 + thinking 显示方式的正交变更在 CLI 中抑制了 bug
- Bug 发生在 Claude Code 的上下文管理、Anthropic API 和 extended thinking 的交叉点
- 通过了多轮人工和自动化代码审查、单元测试、端到端测试、自动验证和 dogfooding
- 仅在角落情况（stale sessions）中出现
- **花了超过一周发现和确认根因**

**用 Opus 4.7 做 Code Review 的发现**：
- 对涉及 bug 的 PR 做 back-test，Opus 4.7（有完整仓库上下文时）能发现 bug
- Opus 4.6 不能
- 因此扩展了 Code Review 工具对额外仓库上下文的支持

### 2.3 问题三：系统提示词变更降低编码质量

**时间线**：
- Apr 16：随 Opus 4.7 发布添加减少冗长度的系统提示词
- Apr 20：回滚

**影响模型**：Sonnet 4.6, Opus 4.6, Opus 4.7

**具体的提示词变更**：
```
"Length limits: keep text between tool calls to ≤25 words.
Keep final responses to ≤100 words unless the task requires more detail."
```

**根因分析**：
- Opus 4.7 天生比前代更冗长（这也是它更聪明的原因之一）
- 内部测试数周无回归
- 在调查中做更广泛的 ablation 测试，发现 Opus 4.6 和 4.7 都有 **3% 的智能下降**
- 立即回滚

**教训**：
- **系统提示词的每一行都必须经过单独验证**（ablation）
- 不同的评估套件可能遗漏不同的回归
- 看似无害的长度限制可能严重影响智能

---

## 三、改进措施

### 3.1 流程改进

1. **更多内部员工使用公开构建版本**（而非内部测试版本）
2. **改进 Code Review 工具**并对外发布
3. **系统提示词变更的更严格控制**：
   - 每次变更都运行广泛的 per-model eval 套件
   - 持续做 ablation 理解每行的影响
   - 新工具让提示词变更更容易审查和审计
   - CLAUDE.md 中添加指导，确保模型特定变更只针对特定模型
   - 对可能影响智能的变更添加 soak period、更广泛 eval、渐进式发布

### 3.2 透明度改进

1. 创建 @ClaudeDevs X 账号，深度解释产品决策
2. 在 GitHub 集中发布更新
3. 重置所有订阅者的用量限制

---

## 四、与 Harness Engineering 的关联

### 4.1 这个案例是 Harness Engineering 的活教材

**三个问题本质上都是 Harness 问题，不是模型问题**：

| 问题 | Harness 层面 |
|------|-------------|
| Reasoning effort 默认值 | Harness 配置/产品层的决策 |
| 缓存 bug | Harness 的上下文管理实现 |
| 系统提示词 | Harness 的核心配置 |

**完美印证了 Addy Osmani 的 "skill issue" 框架**：
> "it's not a model problem. It's a configuration problem."

### 4.2 AGENTS.md/系统提示词的杠杆效应

- 一行提示词（"≤25 words"）造成了 3% 的智能下降
- 印证了 HumanLayer 的观点：**每行 AGENTS.md 都在竞争注意力**
- 但这里反转了：不是规则太多导致注意力稀释，而是**一条不当的规则直接损害了能力**

### 4.3 上下文管理的脆弱性

- 缓存 bug 展示了 Harness 中上下文管理层的极端重要性
- 一个 API header 的错误使用导致整个 session 的 reasoning 丢失
- **印证了 Addy Osmani 的 Context Rot 主题**：上下文是最稀缺的资源

### 4.4 用户反馈作为 Harness Ratchet 的信号

- 用户通过 /feedback 命令和在线示例报告了问题
- Anthropic 依赖用户反馈来发现和定位问题
- **与 OpenAI Harness Engineering 的 Ralph Wiggum Loop 类似**：反馈回路是 Harness 自我纠错的关键

### 4.5 Code Review Agent 的进化

- Opus 4.7 + 完整仓库上下文能发现 Opus 4.6 不能发现的 bug
- **Harness 的 sub-agent 审查能力随模型进化而进化**
- 这正是 Addy Osmani 说的 "maker and checker split" 的现实体现

---

## 五、可落地的工程实践

1. **永远对系统提示词做 ablation 测试**：每次修改一行，测量影响
2. **缓存/上下文管理是高风险区域**：任何优化都可能引入灾难性 bug
3. **角落情况的测试不够**：只有 stale session 才触发的 bug 在常规测试中不可见
4. **用户默认值很重要**：不要假设你的内部测试数据能代表用户偏好
5. **多个独立变更可能伪装成单一广泛退化**：当用户反馈不一致时，寻找多个叠加的原因
