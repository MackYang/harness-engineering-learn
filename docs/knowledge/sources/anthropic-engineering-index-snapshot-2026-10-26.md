# Anthropic Engineering 完整文章索引快照 (2026-10-26)

> 来源：https://www.anthropic.com/engineering
> 提取方式：curl 直取 HTML，解析 Next.js 内嵌 JSON（`self.__next_f.push`）
> 用途：作为后续每周对比的基线快照。新文章 = 快照 diff 出的增量，不再凭记忆翻旧笔记。
> 状态：✅ 已深读 / ⚠️ 值得补读 / ➖ 与 harness 主题弱相关，按需

## Featured 轮播

- ✅ Redesigning source control at Anthropic（2026-10-13）→ `anthropic-source-control-scion-2026-10-19.md`
- ✅ Harness design for long-running application development（2026-03-24）→ `anthropic-long-running-apps-2026-03-24.md`
- ⚠️ Designing AI-resistant technical evaluations（2026-01-21，`/research/AI-resistant-technical-evaluations`）→ 未深读，与 eval-patterns 相关，候选补读

## 文章列表（新 → 旧）

### 2026
- ✅ 2026-10-13 redesigning-source-control — Redesigning source control at Anthropic（Scion）
- ✅ 2026-05-25 how-we-contain-claude — How we contain Claude across products
- ✅ 2026-04-23 april-23-postmortem — An update on recent Claude Code quality reports
- ✅ 2026-04-08 managed-agents — Scaling Managed Agents: Decoupling the brain from the hands
- ✅ 2026-03-25 claude-code-auto-mode — How we built Claude Code auto mode
- ✅ 2026-03-24 harness-design-long-running-apps — Harness design for long-running application development
- ➖ 2026-03-23 long-running-claude — Long-running Claude for scientific computing
- ➖ 2026-03-06 eval-awareness-browsecomp — eval-awareness 评估研究
- ➖ 2026-02-23 making-of-claude-code — The making of Claude Code（Features 栏目）
- ➖ 2026-02-05 zero-days — LLM-discovered 0-days 风险评估
- ⚠️ 2026-02-05 infrastructure-noise — Quantifying infrastructure noise in agentic coding evals（与 eval-patterns 直接相关，候选补读）
- ➖ 2026-02-05 building-c-compiler — Building a C compiler with a team of parallel Claudes（多 agent 并行实证）
- ➖ 2026-01-28 servicenow-anthropic-claude — ServiceNow 合作案例

### 2025
- ✅ 2025-11-26 effective-harnesses-for-long-running-agents — Effective harnesses for long-running agents
- ➖ 2025-11-24 advanced-tool-use — Introducing advanced tool use
- ⚠️ 2025-11-04 code-execution-with-mcp — Code execution with MCP（Addy harness 文引用的 context 优化实证，候选补读）
- ✅ 2025-10-20 claude-code-sandboxing — Beyond permission prompts
- ✅ 2025-09-29 effective-context-engineering-for-ai-agents — Effective context engineering for AI agents
- ✅ 2025-09-29 enabling-claude-code-to-work-more-autonomously — Enabling Claude Code to work more autonomously
- ➖ 2025-09-11 writing-tools-for-agents — Writing effective tools for agents
- ➖ 2025-08-04 our-framework-for-developing-safe-and-trustworthy-agents
- ➖ 2025-06-13 multi-agent-research-system — multi-agent research system
- ✅ 2025-04-18 claude-code-best-practices — Claude Code best practices
- ➖ 2025-03-20 claude-think-tool — think tool
- ➖ 2024-12-19 building-effective-agents — Building effective agents
- ➖ 2024-11-25 model-context-protocol — MCP 发布

### 其余（安全/模型发布/公司动态，与 harness 弱相关）
2026：claude-sonnet-5-5（09-28）、claude-opus-5（07-24）、fable-safeguards-jailbreak-framework（07-02）、redeploying-fable-5（06-30）、n-days（06-08）、expanding-project-glasswing（06-02）、anthropic-acquires-stainless（05-18）、higher-limits-spacex（05-06）、claude-for-creative-work（04-28）、trustworthy-agents（04-09）、claude-opus-4-7（04-16）、demystifying-evals-for-ai-agents（01-09）
2025：introspection（10-29）、small-samples-poison（10-09）、cyber-competitions（08-09）、claude-opus-4-1（08-05）、paul-smith（07-15）、shade-arena-sabotage-monitoring（06-16）、desktop-extensions（06-26）、confidential-inference-trusted-vms（06-18）、swe-bench-sonnet（01-06）
更早：model-context-protocol（2024-11-25）、building-effective-agents（2024-12-19）等

## 深读闭环统计

- Featured 3 篇：已读 2，候选补读 1（AI-resistant evals）
- harness 强相关文章（effective-harnesses / context-engineering / sandboxing / auto-mode / containment / postmortem / managed-agents / long-running-apps / best-practices / Scion）：均已深读
- 中相关候选补读：infrastructure-noise、code-execution-with-mcp

## 下周盯防

1. **Antique 专文**（Scion 文预告的代码评审工具文章）
2. Scion 后续（git 平台响应、迁移复盘续篇）
