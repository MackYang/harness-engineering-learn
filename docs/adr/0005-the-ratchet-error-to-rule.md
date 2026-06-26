# ADR-0005: The Ratchet — 从错误到规则的追溯机制

- **状态**: 已采纳
- **日期**: 2026-06-26
- **来源**: Addy Osmani Agent Harness Engineering + Viv Trivedy "Anatomy of an Agent Harness"

## 背景

在 Agent 驱动的开发中，Agent 会反复犯同类错误。传统做法是在 prompt 中加警告，但 prompt 警告会被 Agent 忽略或遗忘。

Viv Trivedy 团队仅通过改进 harness，将 coding agent 从 Top 30 提升到 Top 5。核心方法就是 **The Ratchet** — 每次错误都变成一条永久的、可追溯的规则。

## 决策

采纳 "The Ratchet" 作为本项目的核心实践：

1. **每个 AGENTS.md 规则必须追溯到具体失败事件** — 不允许"灵感式"规则
2. **错误升级路径**: Prompt 警告 → AGENTS.md 条目 → Pre-commit Hook → Reviewer Sub-agent blocker
3. **规则移除条件**: 只有当更有能力的模型已证明某规则多余时才移除，不是"感觉不需要了"
4. **记录格式**: 每条规则附带来源（哪个 agent、什么任务、什么错误）

## 示例升级路径

```
事件: Agent 发了一个注释掉测试的 PR，被合并了
  ↓
Level 1: AGENTS.md 加 "never comment out tests; delete them or fix them"
  ↓
Level 2: pre-commit hook grep `.skip(` 和 `xit(`
  ↓
Level 3: reviewer subagent 标记注释掉测试为 blocker
```

## 实施指引

### AGENTS.md 规则格式

```markdown
## 规则: [简短描述]
> 来源: [Agent名称] 在 [任务ID] 中 [错误描述]
> 日期: YYYY-MM-DD
> 升级: L1(prompt) | L2(hook) | L3(subagent)
```

### 错误日志格式

在 `docs/incidents/lessons-learned-log.md` 中记录：

```markdown
## [日期] [简短标题]
- **Agent**: [哪个 agent]
- **任务**: [在做什么]
- **错误**: [具体描述]
- **影响**: [造成了什么]
- **Ratchet 动作**: [新增了什么规则，什么级别]
- **状态**: [已修复/待观察]
```

## 后果

- **正面**: AGENTS.md 变成有据可查的质量记录，而非主观的风格指南；Agent 行为持续改善
- **负面**: AGENTS.md 会随时间增长，需要定期清理已证明多余的规则
- **风险**: 过度规则化可能限制 Agent 的合理自主性

## 关联

- Golden Rule #6: 将品味编码为工具和规则
- Golden Rule #18: 成功静默，失败冗长
- FEAT-044: The Ratchet feature eval
- ADR-0002: 强制状态和交接
