# Addy Osmani Loop Engineering 审视笔记 (2026-08-03)

> 来源：https://addyosmani.com/blog/loop-engineering/
> 学习日期：2026-08-03
> 对比笔记：2026-07-27版本
>
> 结论：文章内容无变化，本次重新审视未发现新要点。

---

## 一、审视确认

文章内容与 2026-07-27 版本完全一致，无新增段落或数据变更。

### 重新确认的五大构件

| 构件 | Codex App | Claude Code | 核心价值 |
|------|-----------|-------------|---------|
| **Automations** | Automations tab: 项目+提示词+频率+环境 | /loop, cron, hooks, GitHub Actions | 循环的心跳，发现+分诊 |
| **Worktrees** | 内建 worktree per thread | git worktree, --worktree, isolation:worktree | 并行不碰撞 |
| **Skills** | SKILL.md, $name 或隐式调用 | SKILL.md | 停止每次重新解释项目 |
| **Plugins/Connectors** | MCP + plugins | MCP + plugins | 触达真实工具 |
| **Sub-agents** | .codex/agents/ TOML | .claude/agents/, agent teams | 制造者和检查者分离 |

**第六要素：State** - 记忆（AGENTS.md、进度文件或 Linear），让 agent 在运行间保持连续性。

### 重新确认的关键概念

**1. /goal vs /loop**
- `/loop`: 按节奏重跑
- `/goal`: 持续运行直到验证条件为真，每次 turn 后由独立小模型检查是否完成（maker-checker split 应用于停止条件本身）

**2. 认知投降（Cognitive Surrender）**
- 舒适的姿势是最危险的
- Loop 设计是解药（有判断力使用时）也是加速器（为避免思考而使用时）

**3. 人类审查带宽仍是天花板**
- Worktrees 解决了机械碰撞，但人类审查带宽决定实际可运行数量

## 二、与本次其他来源的交叉思考

### 结合 Anthropic Postmortem 的思考

Anthropic 的 postmortem 中三个问题的修复过程可以理解为 Loop 的 "Ratchet" 实践：
- 缓存 bug → Code Review 增强（sub-agent 审查进化）
- 系统提示词 bug → 添加 ablation 测试到 CI
- Effort 默认值 → 用户反馈直接修改配置

这正好是 Addy 说的 "every mistake becomes a rule" 的真实案例。

### 与 OpenAI 实践的映射

OpenAI 仓库中的 doc-gardening agent 就是 Addy 描述的 Automation 构件的具体实现：
- 每日/定期运行
- 调用 skill（检查文档过时模式）
- 扫描并开修复 PR
- 结果汇入 triage inbox 或自动合并

OpenAI 的 agent-to-agent review 对应 Sub-agents 构件：
- 一个 agent 写代码
- 另一个 agent review
- Ralph Wiggum Loop 自动迭代
