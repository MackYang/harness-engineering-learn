# Addy Osmani：Brownfield Agentic Engineering 深读笔记 (2026-11-02)

> 来源：https://addyosmani.com/blog/brownfield-agentic-engineering/
> 发布：2026-09（从 agent-harness-engineering 文末 Related reading 发现）
> 学习日期：2026-11-02
> 定位：**全新文章，首次学习**。主题：agent 时代如何改造老旧代码库（brownfield）

## 一、核心命题

> "Agentic engineering in an old codebase is about making hidden constraints visible and cheap changes trustworthy."

Brownfield 的本质困难：**仓库不再是系统行为的完整描述**——机构知识、胶带代码、legacy 服务、其他团队依赖的隐性预期都活在代码树之外。另一个尖锐观点：当下 agent 产出的、你没逐决策亲自写的代码，本身就让任何项目变成 brownfield。

## 二、Zones：分级自治区域（本文最有操作价值的框架）

| 区域 | 特征 | agent 自治级别 |
|------|------|----------------|
| 🟢 Green | 测试好 / 隔离好 / 现代惯例 | 紧循环自主跑 |
| 🟡 Yellow | 混合质量 | 先写 characterization tests 再动 |
| 🔴 Red | 敏感（auth/billing/permissions/payroll）/ 少数人理解 | 每步人类结对，或干脆不做 |

**三条让 zones 成为操作规程而非比喻的规则**：
1. **地图由人画，不由 agent 画**——放任选择，agent 会从最吓人的文件开始，因为吓人的文件名字最有意思
2. **区域升级要挣得**（earned）：yellow→green 的条件 = characterization tests 存在 + 模块 owner 审过 agent 的首批改动
3. **区域决定动词**（zone sets the verbs）：green=紧循环 / yellow=测试先行 / red=人类结对每步

## 三、Write down what the code can't say

- Agent 从代码本身能推断的**不用写**——"有一段时期大家给一切写 markdown 塞满上下文窗口"是反面教材
- 只写代码推不出的：业务/团队特有细节、结构性权衡的 why、静态分析无法强制的约定、领域规则、外部约束、反直觉实现的历史背景
- **自治应跟随 blast radius / observability / recoverability，模型自信度是坏指南**

## 四、Make the research survive the session

- Yellow/Red 工作先跑独立的**只读研究 pass**，产出 comprehension memo：入口点、owner、调用方、现有抽象、测试、生产信号、相关历史、开放问题；**每个论断引用文件/issue/owner 记录/dashboard**
- 默认循环的浪费：agent 搞清了 auth 流 → 完成任务 → 会话结束知识蒸发。聊天历史不是 system of record（compaction 之后更不可靠）
- 研究后**清空上下文再规划**：问哪些文件会被哪些方案触及、保持哪些不变量、如何回滚；**人选路径**；实现中发现地图错了就停；审查也从验收标准反向清空开始

## 五、When instructions become a harness

> "Every repeated correction is a missing piece of the harness."

- 层次分工：instructions 记录仓库非常规事实 / skills 打包可复用程序（查 blast radius、验证 schema 变更）/ plugins 提供治理过的访问（owner 目录、事故档案、dashboard）/ harness 是完整工作环境 / factory 调度多个可靠循环
- 实践检验：agent 错了如果你悄悄修 diff，下个 session 还会再犯；同一评审意见第二次出现 → **升级为 lint rule / hook / type / test / skill**；散文只留给无法机械化强制的约束
- **"Over time the harness becomes a record of failures the team has decided not to pay for twice."**（harness 是团队决定不二次支付的失败记录）——Ratchet 原则的最佳表述之一

## 六、Start with zero-risk work：characterization tests 优先

- 入手顺序：先解释系统如何工作 → 生成 characterization tests（锁定当前行为，**包括丑的部分**——老系统中丑行为可能是业务依赖，agent 会很乐意在绿色测试套件后面"修好"它）→ 机械变换（死代码清单等）→ 最后才碰最难的部分
- **Netflix GraphQL cutover 模式**：新旧双路径 replay/shadow 流量 → diff payloads → 匹配才晋级。没有诚实单测的 homepage 级别界面，晋级路径就是"别猜，双跑对比"
- ⚠️ 关键纪律：**写测试的 session 不能是改代码的 session**。先在独立 pass 或由人锁定行为，否则得到的是"把刚发明的实现编码成绿色测试"

## 七、Migrate in complete units

> "A migration is complete when the new path works and the old dependency is demonstrably gone."

- 半拉子迁移最迷惑 agent：搜索返回 40 处旧模式 + 12 处新模式 + 1 个 shim，agent 看到矛盾先例
- 宁可端到端完成一条路线（含删除旧路径），也不要转换 30 个文件留双模式。**"如果删除还在 future cleanup ticket 里，迁移单元就没有完成"**
- SWE Refactor Bench 的 **"Migration Blindness"**：520 次 agent run 只有 28 次通过迁移审计（行为测试 + 独立验证）——测试绿 ≠ 旧依赖消失（测试可以继续调 legacy 实现）

## 八、大型迁移案例的可迁移结构

| 案例 | 数据 | 可复制点 |
|------|------|----------|
| Bun Zig→Rust | 53.5 万行 / 11 天 / 50 workflows | **agent 跑之前，先花数小时写移植指南**（Zig 惯用法→Rust 映射）；每单元 2 个对抗式审查员；全套既有测试做 merge gate |
| Anthropic 自身迁移流程 | — | 规则书先在**一次性 mini-migration** 上试跑，试跑产物丢弃，再大范围跑 |
| VB6→C# 对照研究 | 简单特性 92% 行为等价 / 复杂的 47% | **单元大小是杠杆** |
| Stripe 370 万行→TS | 一个 PR / 数月 codemod / 无 agent | 耐久产物是**迁移机器**（codemod），不是迁移本身 |
| Asana Enzyme 清债 | 多年 backlog → 2 周 / ~$12k | vendor 报告的生成成本 ≠ 受控节省研究；可迁移的是窄机械迁移 + 既有套件 + 人审每项 |
| Shopify Shop app | RN→Swift/Kotlin 12 周 | agent 门控的屏幕级 checkpoints；更大的 merchant app 仍是 brownfield 长跑 |
| Spotify | 650+ agent PR/月 | 铁轨是**多年前建好的 Backstage**——结构先于 agent |

**"What transfers between companies is the structure around the agents."**

## 九、What's actually changed

> "Agents have changed the price of trying several plausible implementations. They haven't changed the evidence required to choose one."

- 现在可行的新玩法：让 agent 用竞争性技术栈各实现一遍 → 全部过单测 → 全部性能画像 → 再选。尝试多种重写的价格塌了，**选择的证据标准没变**

## 十、Parallelize last

- 软件工厂能并行跑多个变更，但**先让一个单元拥有可靠的裁判、恢复路径和人类可吸收的评审格式，再复制**
- **并行放大你已有的瓶颈**：自动验证能处理 5 个已检变更；一个资深读每一行只会得到队列、碎片化注意、最终仪式性批准
- 评审排序：自动化评审以意图/变更不变量/测试结果/parity 失配/回滚路线领先呈现；人类注意力先给最大 blast radius + 最弱 oracle
- ⚠️ Worktrees 隔离的是变更不是行为：共享 git 元数据、凭证、本地服务、网络。无人值守 agent 消费不可信内容时需要更强 sandbox + 缩权凭证

## 十一、Agents put a price on ambiguity

- 行数不说明代码库变好了。应跟踪：lead time、评审分钟数、人工干预次数、逃逸缺陷、回滚、oracle 失配、留下的 suppressions
- 迁移专项：剩余旧 import 数、新路径服务的流量、parity 失配、移除的 legacy 依赖。**全绿但流量仍走旧路径 = 忙碌功**
- 模糊性代价可见化 = 维护工作更强的立项论据（部族惯例变成反复出现的评审意见 = 可计数的成本）
- 修复之外，agent 应留下：synthetic user journey、ownership 记录、回归测试——**"下一个工程师和下一个 agent 继承什么"同样重要**

## 十二、与既有知识库的连接

- Ratchet（agent-harness-engineering）→ 第五节"record of failures"是最佳表述
- Orchestration Tax（loop-engineering）→ 第十节"并行放大已有瓶颈"的展开
- Software Factories（08-17）→ "先一个单元跑通再并行"是 factory 落地的前置条件
- Loop Engineering State 构件 → comprehension memo = 研究产物的 State 化
- **新增候选 feature**：Zones 分级自治 + characterization-test-first 进 brownfield playbook

## 十三、下一步动作

- 新增 FEAT-076（Zones）、FEAT-077（characterization tests 先行 + 测试作者与实现者分离）
- 考虑把"迁移完整性判据"（旧依赖 demonstrably gone）补进 golden-rules
