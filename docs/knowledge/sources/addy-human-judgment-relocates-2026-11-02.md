# Addy Osmani：Human Judgment Doesn't Leave the Software Factory, It Relocates 深读笔记 (2026-11-02)

> 来源：https://addyosmani.com/blog/human-judgment-doesnt-leave-the-software/
> 发布：2026-08（从 agentic-skill-decay 文末 Related reading 发现）
> 学习日期：2026-11-02
> 定位：**全新文章，首次学习**。主题：software factory 中人类判断的新位置。与 `addy-software-factories-2026-08-17.md`（同主题首次学习）互补，本文是其判断论深化篇

## 一、核心命题

> "Human judgment is being relocated, not removed."
> "The best software factories will not be defined by how completely they eliminate human involvement. They will be defined by **how intelligently they place it**."

人类离开的是"机器能给出更强、更快、更确定性信号的环节"；集中到 context、taste、risk、长期所有权最重要的地方。

## 二、Do you really need a factory?（门槛判断）

- **stock harness（Claude Code / Codex）+ 多 session + 好的带验证 SPEC + 约束，能走很远**——甚至能批量扔 GitHub issues
- Factory 的真正触发条件：系统需要 **repeatable + event-driven**——事件驱动工作队列（Slack 触发 / issues / Linear / backlog）在隔离云环境跑 triage→实现→测试，带显式人类看护
- 最小 factory 示例 prompt 的要素：读 issue + 仓库指令 → 只实现声明的验收标准 → 禁改区（auth/billing/migrations/既有测试断言）→ 必须跑 lint/test/build，跑不了就停下解释 → 开 draft PR 附检查记录/剩余风险/待人类决策 → **不许 merge**
- **Warp 四态 triage label**：ready-to-implement / ready-to-spec / needs-info / wait-to-implement——label 同时是队列、锁、和人类"暂存而不永久拒绝"的位置

## 三、Factory 中的三种人类介入

- **Steering**：agent 需要纠偏时给输入重定向
- **Notifications**：factory 报告被阻塞（需求模糊/启动了高风险动作/需要人类输入）
- **Handoff**：任务+状态+上下文在云 factory/另一 agent/人类评审者之间移动；好 handoff 记录发生了什么、还剩什么、为什么需要 handoff

关键：**人不只在末端审 diff——可以在早期塑造、实现中引导、经 handoff 推进、或阻止上线。**

## 四、My cognitive bandwidth does not scale with the agents

- 可以开成百上千 agent，但你的认知带宽不随之扩展 → comprehension debt 加剧
- 上下文切换成本的老问题被放大：每天 5-10 个项目/特性/session
- **"Consider optimising the software factory for your reviewer"**：所有路径的输出都汇到一个人的注意力——问自己 factory 让你必须做的决定便宜了多少
- Wrong-project mistake：把 dark mode 需求发进错误项目的 session——人会在并行中犯的错，factory 设计要防

## 五、When green is misleading

- AI 改测试满足条件或改代码过测试 ≠ 对齐意图
- 案例：要求加 GitHub 登录 provider → UI 空间只有 3 个 → agent 悄悄砍掉另一个 → 砍掉的恰好是客户要的
- **安全注记**：factory 读不可信输入（GitHub issue/Slack 消息）可能是对抗性的（供应链攻击）。Vercel 的做法：agent 在**只持有所需 secrets 的隔离 sandbox** 里跑——被攻破的 run 摸不到任务不需要的东西，防御分层

## 六、82 分钟 factory 实战复盘

- 60 分钟点感觉慢 → 问 harness → "一切正常，verifiers 都在跑"
- 单任务名义 10-20 分钟 → 实际 2-4 倍（verification / retries / browser checks / human review 的延迟叠加）
- **verification budget 概念**（类比 performance budget）：lint/typecheck 等快检查前置；全套测试/mutation testing/browser testing/security 放 draft PR 前后。要真测试不要摘要，但要预算在正确位置，不拖慢开发循环
- **成本可见性**：quick finder 无拒绝 7 分钟；favorites 带两次拒绝+一次人类决策 56 分钟——同一个 factory。四态分类不显示成本，**要配 per-stage timing**，否则知道 run 有缺陷不知道缺陷多贵
- **handoff 边界修复**：sample factory 把 issue 标记 factory:needs-info 停下是对的，但人不知道答案放哪——**"manual run 在 factory 停下时不算完成，在人类知道下一步做什么时才算"**

## 七、Vercel 四态 + autonomy 阶梯

- Vercel 给每个 run 打标：**success / flawed / blocked / manual**，只有 success 上生产，其余重新入环
  - flawed = 实现错了或缺上下文，要修
  - blocked = 缺凭证之类，要供给
  - manual = factory 尚不被允许跨越的信任边界
- **Autonomy is not a single setting**：verification 买到 trust，trust 换来更多 autonomy——同类任务下次做过且验过 → 放宽；风险变 → 收紧。**"Your verification is going to change with risk. Your goal is the best signal to noise ratio."**

## 八、The feature I had to relearn（comprehension debt 实录）

- favoriting 功能：测试绿 → 浏览器看着 OK → merge。几天后想微调点击效果，回到代码**无法解释它如何工作**——仓库是我的，改动是我批的，但理解没跟上代码积累
- 被迫重做该功能逐步搞懂。教训：**重要功能让 agent 存储它的 trajectory / 关键 lessons**（如何解题），供日后回看——commit 决策不留 why
- 并行工作把"审阅量问题"放大成"**多个心理模型同时变冷**"的问题

## 九、Ownership doesn't disappear

> "'The agent wrote it' doesn't cut it."

人类保留的决策链：选问题 / 选架构 / 定质量 bar / 决定哪些验证信号值得信 / 决定证据何时足以发布 / 失败时负责。

实践准则（factory 设计七条）：
1. 意图、系统形态、质量 bar 上游保持人类判断
2. 自动 back-pressure 变弱或后果主观处人工评审
3. 确定性信号尽早、持续进循环
4. 系统赢得/失去信任时**刻意**收紧或放松约束
5. 检查数量 ≠ 质量，试出最佳信噪比
6. 人类品味编码进环境 + agent 给出工作正确的证据 + 人类仍"拥有"上线物
7. 最终 ship 的代码有人负责

## 十、Which old projects deserve another life?

- Agent 让完成旧项目变 trivial，但"**该不该存在**"是新的第一问题——5 个用户也要维护，质量 bar 要守
- 复活流程：先 build 起来 → 补测试锁行为 → 再谈升级/迁移 → UI 重写（Bootstrap→Tailwind/shadcn）开始吃产品感与品味 → 耗时回升
- 稀缺资源叙事升级：过去稀缺的是小时数（开会/设计/编码预算），现在是**注意力投向与理由**

## 十一、与既有知识库的连接

- software-factories-2026-08-17（Back Pressure / Light-Dark Factory）→ 本文给出判断/成本/autonomy 三个深化维度
- cognitive-risks.md（comprehension debt）→ 第八节是教科书级实录案例
- own-the-outer-loop → 判断重定位 = outer loop 所有权的新表述
- brownfield 文（本周同日深读）→ "先一个单元跑通再并行"与"Parallelize last"同源
- **新增候选 feature**：FEAT-080（run 四态分类 + per-stage timing 成本可见性）

## 十二、金句摘录

> "Generating code is not necessarily the part that you need to worry about the most."
> "Parallelism multiplies the bottleneck you already have."
> "A green suite with all traffic still taking the old path is busywork."（brownfield 文重申）
> "Code good enough to ship still starts there."
