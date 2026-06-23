# Harness Engineering 操作原则（十五条）

> 项目级操作原则 — 日常执行 Agent 任务时必须遵守的纪律。
> 与 `golden-rules.md`（OpenAI/Anthropic 来源原则）互补：golden-rules 是"为什么"，本文是"怎么做"。

## 为什么单独有这份文件

`golden-rules.md` 记录的是从权威来源（OpenAI Harness Engineering + Anthropic Engineering Blog）提炼的原则体系，偏理论。

本文档是**项目自身的操作原则**：每条都对应 Agent 在本仓库内执行任务时的具体行为约束。来源是 README + AGENTS.md 长期沉淀下来的纪律。

## 十五条

1. **增量优先** — 一次一个 feature，禁止 one-shot
2. **外部记忆** — 用文件（JSON/progress log）保存跨 session 状态
3. **独立验证** — 实现和评估必须分离（Generator ≠ Evaluator）
4. **测试即验证** — 给 Agent 真正可运行的测试工具
5. **Sprint Contract** — 实现前先协商完成标准
6. **上下文是稀缺资源** — 精简工具、精简 prompt、Just-in-Time 检索
7. **脑手分离** — Harness、Session、Sandbox 独立部署、独立替换
8. **安全纵深** — 凭证与沙箱隔离，通过代理访问外部服务
9. **Eval 驱动** — 先建 eval 再优化，能力评估 → 回归测试
10. **保持简单** — 能用简单方案解决的，不要用复杂系统
11. **按需发现** — 工具定义、上下文、技能按需加载，不预加载所有内容
12. **代码编排** — 复杂工具调用链用代码执行环境编排，中间结果不污染上下文
13. **验证闭环** — 没有验证手段的 Agent 不是真正的 Agent，沙箱是自主的赋能者
14. **错误防御工具设计** — 工具层面阻止常见错误（强制绝对路径、唯一匹配检查），优于在 prompt 中写警告
15. **上下文感知存储** — 中间状态文件（progress、feature list）必须包含足够的上下文说明，让新 session 无歧义理解状态

## 与 golden-rules.md 的映射

| 操作原则 | 对应来源原则 |
|---------|-------------|
| 1 增量优先 | OpenAI: 深度优先逐层解锁 |
| 2 外部记忆 | OpenAI: 仓库是记录系统 |
| 3 独立验证 | OpenAI: 用约束而非微观管理 |
| 5 Sprint Contract | Anthropic: Sprint Contract（[long-running apps](../sources/anthropic-long-running-apps-2026-03-24.md)） |
| 6 上下文是稀缺资源 | OpenAI: 给地图不给说明书 |
| 7 脑手分离 | Anthropic: Meta-Harness 接口（[managed-agents](../sources/anthropic-managed-agents-2026-04-08.md)） |
| 8 安全纵深 | Anthropic: vault + proxy |
| 14 错误防御工具设计 | Anthropic: SWE-bench str_replace_editor |
| 15 上下文感知存储 | Anthropic: Contextual Retrieval |

---

*最后更新：2026-06-23*
