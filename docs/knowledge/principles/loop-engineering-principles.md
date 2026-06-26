# Loop Engineering 原则

> 来源: Addy Osmani — [Loop Engineering](https://addyosmani.com/blog/loop-engineering/) (2026-06-07)
> 定位: 在 Harness Engineering 之上的一层，设计自主驱动 Agent 的闭环系统。

## 核心定义

> Loop engineering is the practice of designing systems that autonomously prompt AI agents, rather than manually writing prompts yourself.

**层级关系**: Loop（调度+循环）> Harness（单 Agent 环境）> Model

Harness 是单个 Agent 的运行环境（scaffold、skills、约束）。Loop Engineering 在 Harness 之上加了**调度、循环和自主决策**，让系统"自己在定时器上跑"。

## 五大构件原则

### LP-1. Automations 是心跳

没有 Automation 的 Loop 只是一次性运行，不是真正的循环。

**设计要点**:
- 定时发现 + 分诊（daily triage、CI failure、bug hunting）
- `/goal` 持续运行直到条件满足，由**独立小模型**判断完成
- Automations 可以调用 Skills，保持可维护性
- 找到东西的 run 进 triage inbox，没找到的自动归档

**检查清单**:
- [ ] 有定时运行的自动化任务吗？
- [ ] 自动化调用了 Skill 而非硬编码 prompt 吗？
- [ ] /goal 有明确的、可机器验证的停止条件吗？
- [ ] 停止条件由独立模型判断，而非写代码的 agent 自己判断？

### LP-2. Worktree 隔离并行

多 Agent 并行工作的前置条件。没有 Worktree 隔离，两个 Agent 写同一个文件会变成灾难。

**设计要点**:
- 每个 Agent 在独立 git worktree 中工作（独立分支 + 独立工作目录）
- Worktree 解决机械碰撞，但**人类审查带宽才是并行上限**
- 并行 Agent 数量不应超过你能有效审查的 PR 数量（编排税 Orchestration Tax）

**检查清单**:
- [ ] 多 Agent 任务是否使用了 worktree 隔离？
- [ ] 并行数量是否在你的审查带宽之内？
- [ ] worktree 在任务完成后是否自动清理？

### LP-3. Skills 编码项目知识

每次循环都重新解释项目 = 浪费。Skill 将意图固化，防止 Agent 冷启动时空洞猜测。

**设计要点**:
- SKILL.md 格式：指令 + 元数据 + 可选脚本/资源
- **Skill 是创作格式（authoring format），Plugin 是分发格式（distribution format）**
- Skill 描述要"枯燥具体"，不要"聪明抽象"——因为 Agent 是按描述匹配的
- 没有 Skill 的 Loop 每次都从零推导项目，有 Skill 的 Loop 会**复利增长**

**检查清单**:
- [ ] 项目核心约定是否编码为 Skills？
- [ ] Skill 描述是否足够具体让 Agent 自动匹配？
- [ ] 需要跨项目分享时是否打包为 Plugin？

### LP-4. Connectors 连接真实工具

只能看到文件系统的 Loop 是小 Loop。通过 MCP Connector 接入真实工具（issue tracker、Slack、数据库、CI）后，Loop 才能**真正自主行动**。

**设计要点**:
- 没有 Connector: Agent 说"这是修复方案"，然后等你执行
- 有 Connector: Agent 自己开 PR、更新 ticket、CI 通过后 ping 频道
- Codex 和 Claude Code 都支持 MCP，Connector 通常可以跨工具复用
- Plugin = Connector + Skills 打包分发

**检查清单**:
- [ ] Loop 是否连接了必要的工具（CI、issue tracker、通知）？
- [ ] Connector 是否能让 Loop 完成端到端操作（不依赖人类）？
- [ ] 敏感操作是否有适当的权限控制？

### LP-5. Sub-agents 分离生成与验证

**写代码的 Agent 不能批改自己的作业。** 这是 Loop 工程中最有价值的结构性决策。

**设计要点**:
- 拆分为 Explorer → Implementer → Verifier
- Verifier 使用不同指令，必要时使用不同模型
- `/goal` 的停止条件判断本身也是 maker/checker 分离
- Sub-agent 有独立 token 成本，在值得付费的场景使用

**检查清单**:
- [ ] 代码生成和代码验证是否由不同 Agent 执行？
- [ ] Verifier 是否使用不同于 Generator 的指令/模型？
- [ ] 停止条件是否由独立模型判断？

### LP-6. State 持久化记忆

模型会忘，仓库不会。所有跨循环的状态必须持久化到磁盘。

**设计要点**:
- Markdown 文件或 Linear board 作为状态载体
- 状态文件必须包含足够的语义上下文（Contextual Storage）
- 新 session 能从状态文件无歧义地恢复进度
- 进度文件应记录"做了什么"和"为什么"，不只是"当前状态"

**检查清单**:
- [ ] 跨 session 状态是否持久化到文件？
- [ ] 状态文件是否包含足够的上下文让新 Agent 理解？
- [ ] 每次循环是否从上次停下的地方继续？

## 完整 Loop 实例参考

```
[Automation 每天早上运行]
  → 调用 Triage Skill（读 CI failures + open issues + recent commits）
  → 发现写入 State File
  → 为每个发现打开隔离 Worktree
  → 子 Agent A 起草修复
  → 子 Agent B 审查（对照 Skills + 测试）
  → Connector 开 PR + 更新 ticket
  → 无法处理的进入 Triage Inbox
  → State File 记录进度
  → [明天从这里继续]
```

## 风险与局限

1. **验证仍在人类身上** — "done" 是声明不是证明
2. **理解力萎缩（Comprehension Debt）** — loop 越快，你不理解的代码越多
3. **认知投降（Cognitive Surrender）** — "设计好 loop 就躺平" 是最危险的姿态

> That's what makes loop design harder than prompt engineering, not easier. The leverage point moved, the difficulty didn't go away.

---

*最后更新：2026-06-26*
*来源: Addy Osmani Loop Engineering + OpenAI Harness Engineering + Anthropic Engineering*
