# Addy Osmani Loop Engineering 审视笔记 (2026-08-10)

> 来源：https://addyosmani.com/blog/loop-engineering/
> 学习日期：2026-08-10
> 对比笔记：2026-08-03版本
>
> 结论：文章内容无变化，本次重新审视未发现新要点。

---

## 一、审视确认

文章内容与 2026-08-03 版本完全一致，无新增段落或数据变更。

### 重新确认的核心框架

**定义**：Loop Engineering 是替代自己作为提示代理者的人。你设计执行此操作的循环系统。

**五大构件 + 记忆**：

| 构件 | 核心功能 | 两个产品的实现 |
|------|---------|---------------|
| **Automations** | 发现+分诊的调度 | Codex: Automations tab; Claude Code: /loop, cron, hooks, GitHub Actions |
| **Worktrees** | 并行隔离 | Codex: 内建 per thread; Claude Code: git worktree, --worktree, isolation:worktree |
| **Skills** | 项目知识编码 | 两产品均用 SKILL.md 格式 |
| **Plugins/Connectors** | MCP 连接真实工具 | 两产品均支持 MCP |
| **Sub-agents** | 制造者-检查者分离 | Codex: .codex/agents/ TOML; Claude Code: .claude/agents/ |
| **State** | 运行间记忆 | Markdown 或 Linear |

### 重新确认的关键概念

**1. /goal vs /loop 的 maker-checker split**
- /goal 在每次 turn 后由独立小模型检查完成条件
- maker-checker split 应用于停止条件本身

**2. 认知投降（Cognitive Surrender）**
- Loop 设计是解药（有判断力使用时）也是加速器（为避免思考而使用时）
- 同一设计可产生完全相反的结果

**3. 编排税（Orchestration Tax）**
- Worktrees 解决机械碰撞，但人类审查带宽仍是天花板

**4. 意图债务（Intent Debt）**
- 代理每次会话冷启动，用自信猜测填补意图空白
- Skill 是意图外化写入，一次编写每次运行读取

**5. 典型 Loop 架构**
- 每日 Automation → triage skill → worktree per finding → sub-agent 实现 + sub-agent review → connectors 开 PR 更新 ticket → triage inbox 收集无法处理项 → state file 记录进度

## 二、持续审视观察

连续三周（07-27、08-03、08-10）文章无变化。Loop Engineering 文章是 Addy 的核心定义性文章，已趋于稳定。

**值得关注的新概念**：
- 文章引用了多个 Addy 其他博客文章作为补充阅读，这些补充文章可能会有更新：
  - Long-running agents
  - The orchestration tax
  - Intent debt
  - Cognitive surrender
  - Code agent orchestra
  - Adversarial code review
  - Factory model
