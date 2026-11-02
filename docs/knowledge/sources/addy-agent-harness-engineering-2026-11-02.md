# Addy Osmani Agent Harness Engineering 审视笔记 (2026-11-02)

> 来源：https://addyosmani.com/blog/agent-harness-engineering/
> 学习日期：2026-11-02
> 对比笔记：2026-10-26 版本
>
> 结论：**文章有小幅实质更新**，其中 context-anxiety 表述与本周 Anthropic managed-agents 重写形成互证。

## 一、核心框架复核（无变化）

Agent = Model + Harness、Ratchet 棘轮、Context Rot 四技术、Ralph Loop / planner-generator-evaluator / sprint contract、Hooks 执法层、AGENTS.md 60 行 / earned each line、harness 不缩小只移动、模型-harness 训练耦合、HaaS 四支柱、三个开放问题（多 agent 并行共享代码库 / agent 自析 trace 修 harness / 动态组装工具与上下文 = harness 编译器化）：均已覆盖 ✅

## 二、本次发现的更新点

### 1. Context-anxiety 案例的模型版本表述
- 文中 "Where this is going" 段（此前 07-23 笔记已学习过该段）现在的表述："**Opus 4.6** largely killed the context-anxiety failure mode (**Sonnet 4.5** used to wrap up work prematurely...), which means a whole class of anxiety-mitigation scaffolding I was writing six months ago is now **dead code**"
- 与 Anthropic managed-agents 重写版（10-30）的表述基本一致，但 Anthropic 原文写的是 **Opus 4.5**。二手来源的版本漂移再次提醒：以一手来源为准，本知识库已在 managed-agents-rewrite 笔记中记录该差异

### 2. 文末 Related reading 更新（新文章雷达）
文章末尾"Related reading"当前列出三篇：
- **Brownfield Agentic Engineering**（2026-09）→ 本周已深读，见 `addy-brownfield-agentic-engineering-2026-11-02.md`
- **Agentic Skill Decay**（2026-08-31）→ 本周已深读，见 `addy-agentic-skill-decay-2026-11-02.md`
- **Audit your Agent files**（2026-08-27）→ 本周已深读，见 `addy-audit-your-agent-files-2026-11-02.md`
- 另有第四篇关联文 **Human judgment doesn't leave the software factory. It relocates.**（2026-08）从 skill-decay 文末发现，已深读，见 `addy-human-judgment-relocates-2026-11-02.md`

### 3. 作者简介更新
文末 bio 现在明确："Addy Osmani is an engineering and evangelism leader and a **Member of Technical Staff at Anthropic, where he works on Claude Code**"（此前 14 年 Google，Chrome / Gemini / Cloud AI Director）。这解释了其博客与 Anthropic 工程理念的深度同频——两来源的独立性弱于表面上"OpenAI vs Anthropic vs 独立博主"的三方结构，交叉印证时需注意同源性

## 三、维护纪律说明

- 本文正文自 06-26 首学以来核心框架未变，但**文末 Related reading 是活跃的新文章发现渠道**——本周四篇新文全部由该入口发现。后续每周核对本文时，Related reading 列表 diff 纳入标准动作
