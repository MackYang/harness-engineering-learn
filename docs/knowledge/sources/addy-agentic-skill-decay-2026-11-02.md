# Addy Osmani：Agentic Skill Decay 深读笔记 (2026-11-02)

> 来源：https://addyosmani.com/blog/agentic-skill-decay/
> 发布：2026-08-31（从 agent-harness-engineering 文末 Related reading 发现）
> 学习日期：2026-11-02
> 定位：**全新文章，首次学习**。主题：agent 时代工程师的 reps（练习）与专长维护

## 一、核心命题

> "Mastery still comes from doing the reps."

Agent 之前，reps 天然内嵌在写代码里（试错、调试、评审、阅读）。Agent 替你跳过了这些，所以 **reps 必须变为刻意行为**。

## 二、两大能力与四项练习

好 agent 工作依赖两个能力：
- **Deep expertise**：足够理解问题域以定义好结果（含用户/产品/业务理解）
- **Applied judgment**：用品味把理解变成清晰可测的计划——选对 context、约束、测试与验证

要练的四项：**decision making / specifying / steering / verifying**

## 三、The short-circuit：学习路径被短路

- 从问题直达解决方案，跳过了本来会积累知识的一切环节
- AI 实验室产品目标是最快给答案，**不主动帮你学习**——"帮我做个排程 app"和"帮我做排程 app 并边做边教我"是两种请求，大多数人只会说前者（部分是不知道可以这么说）
- 初级工程师必须**主动**经营自己的学习旅程

## 四、A completed task is not necessarily a rep

- 任务完成 ≠ 学到东西。"事情顺利时没有教学时刻"——错误才强迫反思
- 对策：**让 agent 总结关键学习**（"这次有哪些关键学习能帮中级/初级开发者增进知识或改进问题思考方式？"）
- Addy 自己学 3D 图形的方式：问 agent"解释这怎么工作的 / 教我这个概念 / 帮我理清这些元素如何关联"——**想学就会 pairing，不想学就只剩产出**

## 五、Anthropic 两项实证（本文引用，含学习数据）

### 5.1 Trio 学习实验（2026）
- 初级工程师学 Python Trio 库：用 AI 助手组后续测验 **50%** vs 手写组 **67%**
- AI 组内成绩好的共同点：**问概念问题、要求解释**，而不是把模型当代码售货机
- 启示：只生成不理解 → 擅长 prompting 但不擅验证；问问题 → 反思、模式匹配、积累知识残渣

### 5.2 40 万 Claude Code 会话专长研究
- 即使**中级**任务专长也显著提高验证成功几率（vs novice）
- 不需要十年全栈，但需要**理解问题域到能识别"好"长什么样**（taste）
- Claude Code best practices 指南开篇即谈验证（测试/截图/信号）——给 agent 可迭代的东西，给你可评审的证据而非"完成"的口头总结

## 六、Verification is the floor, imagination is the ceiling

> "You can only prompt what you can imagine."

- 想象力是天花板（能想到才能让 agent 建造），专长是地板（能验证才算造出来）
- 案例：专辑网站 3D 交互对象——initial 版本交互模式不对、移动端性能差。先要专长**注意到有 bug**，再有**为什么的假设**，然后自己或让 agent profile 找因

## 七、Use them aggressively anyway

- 不因专长焦虑而回避 agent。Addy 每天 5-10 个并行 session，曾把 dark mode 需求发错项目——错误澄清了约束：**agent 吞吐扩展快于注意力**
- 每周至少两次撞上：prompt 任何 app 都容易，但你不知道什么是更好，因为没投入过时间

## 八、Does the next generation need the expertise?

- 专长今天仍有用的位置：agent 不完美、需要检查的地方。让它优化循环/动画/调度，它可能以别的代价达成——**不知道看什么、读不懂实现，就会发布实际不符合需求的东西**
- **"Skills and MCPs can encode a useful workflow. They cannot tell you when its assumptions no longer fit your system."**（skills/MCP 能编码工作流，但不能告诉你它的假设何时不再适配你的系统）——判断"假设过时"永远是人/专长的职责。与本周 managed-agents 重写"assumptions go stale"直接呼应
- 本文另引 [Skill Decay 相关研究]：个性化 skill（从个人历史提取）不比别人的 skill 更好用；**通用 skill（从大量开发者聚合）反而更有用**——细节见 audit-your-agent-files 笔记的展开

## 九、The return on expertise is going up

- 地板升高后，AI 同时**提高了既有专长的回报率**：会的人更快做出更好的东西
- 初级→非初级的方式没变：ship 真东西、犯错、学习、做 reps
- 专长的直觉：造什么、怎么验证、好没好、坏没坏、可维护吗、能扩展吗、跨平台能跑吗

## 十、Put the lesson where the next agent can find it

- "和 agent 工作时，你应该让它变好，它也应该让你变好"——每天应有循环让 lessons/memory 增长
- 聊天窗口里的教训会随窗口死亡（compaction 后更不可靠）→ **把教训 codify 进 repo**（lessons.md / 测试 / lint 规则），小到可固化才能教未来 agent
- Dual loop 概念：**好 rep 同时磨利你和你的 agent**；假设被纠正时，考虑该纠正是否值得变成 linting rule / type constraint / 文档约定 / 测试——与 Ratchet 原则完全同构
- Outer loop 定义（呼应 own-the-outer-loop）：invest in expertise → 做 reps → 写 plan → 定义 done → 规划人类驻留点（正确性/安全/用户影响检查）——**"这将大体上是今天工程师需要拥有的 outer loop"**

## 十一、与既有知识库的连接

- Cognitive risks（验证责任 / comprehension debt / cognitive surrender）→ 本文是"验证责任 + 理解力维持"的专长建设面
- Ratchet → dual loop 是其学习论表述
- managed-agents 重写（本周）→ "assumptions no longer fit" 的双向呼应
- **新增候选 feature**：FEAT-078（dual-loop learning：任务结束提取 lessons 并判断 codify 去向）
