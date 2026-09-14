# Addy Osmani Agent Harness Engineering 审视笔记 (2026-09-14)

> 来源：https://addyosmani.com/blog/agent-harness-engineering/
> 学习日期：2026-09-14
> 对比笔记：2026-08-17版本
>
> 结论：文章正文无变化。本次通过全文重读发现两个此前笔记遗漏的参考引用，补录如下。

---

## 一、审视确认

连续五周（07-27、08-03、08-10、08-17、09-14）文章正文无变化。核心概念稳定：

- **Agent = Model + Harness**（Viv Trivedy 提出 "If you're not the model, you're the harness"）
- **Ratchet 原则**：每个错误成为永久规则；AGENTS.md 每一行都应可追溯到一次具体失败
- **"Skill issue" 框架**：大多数代理失败是配置问题而非模型问题；Terminal Bench 2.0 上同模型仅换 harness 从 Top 30 → Top 5
- **Context Rot 四项技术**：Compaction / Tool-call Offloading / Skills 渐进披露 / Full Context Resets
- **"Harnesses don't shrink, they move"**：模型变强后旧脚手架退役、新天花板需要新脚手架
- **Model-harness 训练耦合**：agent 产品在训练时以 harness 在环，换 harness 反而可能释放被压住的能力
- **HaaS (Harness-as-a-Service)**：从 LLM API（给补全）到 harness API（给运行时）

## 二、本次补录：两个此前遗漏的参考引用

全文重读对比发现，以下两个文中引用的资源未在既往笔记中单独记录：

### 2.1 Birgitta Böckeler — Harness Engineering 用户侧综述

- 链接：https://martinfowler.com/articles/exploring-gen-ai/harness-engineering.html
- 定位：Addy 文中列举的参考之一，Martin Fowler 站点上对 harness engineering 的**使用者视角**综述
- 与 Addy 的分工：Viv Trivedy 给出概念推导，Anthropic 给出长任务设计细节，Böckeler 补的是"作为用户这意味着什么"的实践视角
- 后续行动：可作为独立来源在下周学习中精读（martinfowler.com 域名，非三大权威来源，但为 Addy 背书的补充参考）

### 2.2 Fareed Khan — Claude Code 架构（估计）解构

- 链接：https://levelup.gitconnected.com/building-claude-code-with-harness-engineering-d2e8c0da85f0
- 定位：Addy 称之为"我所见过的最清晰的成熟 harness 公开图景"
- 核心价值：Claude Code 架构图中，前文每个概念都能对应到具名组件：
  - Context injection → 知识层
  - Loop state → memory store + worktree isolator
  - 破坏性操作 hooks → permission gate 之后
  - Subagent context firewall → 整个多代理层
  - Tool dispatch registry → MCP 与 bash 的接入点
- 论点：Claude Code 的演进是 harness 的演进，至少与底层模型同等重要 —— 与 Viv 的结论一致，但以实际产品为载体
- 后续行动：可作为插图参考资料，辅助理解 harness 组件如何映射到真实产品

## 三、建议

文章已长期稳定，维持每两周一次的审视频率。本次价值在于通过"全文重读 + 逐引用核对"发现遗漏，说明稳定期仍值得偶尔做全文级复读而非只看 diff。
