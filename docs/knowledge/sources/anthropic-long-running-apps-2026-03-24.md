# Anthropic Engineering 知识笔记：Harness Design for Long-Running Application Development

> 来源：[Harness design for long-running application development](https://www.anthropic.com/engineering/harness-design-long-running-apps)
> 作者：Prithvi Rajasekaran
> 发表：2026-03-24
> 学习日期：2026-06-23

## 核心问题

简单 harness（initializer + coding agent + 上下文 reset）在长任务上有两个持续失败模式：

1. **上下文窗口填满后模型失序** — Sonnet 4.5 还会有"context anxiety"（接近 limit 时提前收尾）
2. **自评偏宽容** — Agent 评自己的工作时倾向于自信地夸，主观任务（设计）尤其严重；即便有可测输出，判断也常失误

## 核心架构：GAN 式三 Agent

借鉴生成对抗网络：generator + evaluator 对抗迭代。扩展到三 agent：

| Agent | 职责 | 关键约束 |
|------|------|---------|
| **Planner** | 1-4 句 prompt → 完整产品 spec | 关注产品上下文与高层技术设计，**不**做粒度细节（错误会级联到下游） |
| **Generator** | 按 sprint 实现，每个 sprint 后自评 | 一个 sprint 一个 feature；用 git 版本控制 |
| **Evaluator** | 用 Playwright MCP 真点真测，按硬阈值打分 | 4 个标准 + 每个的硬阈值；任一不达标 sprint 失败 |

### Evaluator 的四个评分标准（前端版本）

- **Design quality** — 整体感、独立视觉身份（权重高）
- **Originality** — 是否有自定义决策，而非模板/AI slop（权重高）
- **Craft** — 字体层级、间距一致性、对比度（基础项）
- **Functionality** — 用户能否理解界面、找到主操作（基础项）

> 故意把 craft / functionality 权重降低，因为 Claude 默认就做得不错；design / originality 才是杠杆点。

## Sprint Contract（关键机制）

**Generator 和 Evaluator 在写代码之前协商"完成标准"。**

- Spec 故意高层 → contract 把用户故事桥接到可测实现
- Generator 提议要建什么 + 如何验证 → Evaluator 审查是否在建对的东西 → 迭代到达成一致
- 然后 Generator 才开始实现

> "这个步骤存在是因为 product spec 故意高层，我需要一个步骤来桥接 user stories 和可测实现之间的 gap。"

## Evaluator 调参（关键机制）

开箱 Claude 是**糟糕的** QA agent：会识别出真问题然后"自己说服自己这不是大问题"，然后 approve。

调参 loop：
1. 读 evaluator 日志
2. 找 evaluator 判断与人类分歧的例子
3. 更新 QA prompt 解决这些具体问题
4. 多轮迭代

> "把独立 evaluator 调成怀疑论，比让 generator 对自己的工作挑剔，要可行得多。"

校准方法：few-shot 示例 + 详细的分数分布说明，减少跨迭代的分数漂移。

## Context Reset vs Compaction

| 方案 | 做法 | 代价 | 适用 |
|------|------|------|------|
| **Compaction** | 原地总结早期对话，同一 agent 继续 | 不给清白状态；context anxiety 可能持续 | 上下文还能救 |
| **Context Reset** | 完全清空 + 结构化 handoff 给下一个 agent | orchestration 复杂度 + token 开销 + 延迟 | Sonnet 4.5 这类有 context anxiety 的模型 |

**Opus 4.5 大幅消除了 context anxiety**，所以本文的 full-stack harness 完全不需要 context reset，靠 SDK 的自动 compaction 跑全程。

## Harness 简化纪律（关键原则）

> "每个 harness 组件都编码了一个假设：模型不能独立做什么。这些假设值得反复 stress test，因为它们可能是错的，而且会随模型改进迅速 stale。"

**新模型来了逐个移除组件：**
- Opus 4.6 → 移除 sprint 结构（模型能原生处理大块工作）
- Opus 4.6 → evaluator 从 per-sprint 改为 run 末单次（边界外推）

**Evaluator 不是固定的 yes/no** — 任务在模型能可靠独立完成的边界内时是开销；在边界外时是真杠杆。

## 性能对比

### V1 Harness（Opus 4.5，retro game maker）

| 配置 | 时长 | 成本 |
|------|------|------|
| Solo（单 agent） | 20 min | $9 |
| Full harness（planner + generator + evaluator + sprint） | 6 hr | $200 |

> 贵 20 倍，但 solo run 的核心功能（玩游戏）根本不工作；harness run 真的能玩。

### V2 Harness（Opus 4.6，DAW）

| 阶段 | 时长 | 成本 |
|------|------|------|
| Planner | 4.7 min | $0.46 |
| Build R1 | 2 hr 7 min | $71.08 |
| QA R1 | 8.8 min | $3.24 |
| Build R2 | 1 hr 2 min | $36.89 |
| QA R2 | 6.8 min | $3.09 |
| Build R3 | 10.9 min | $5.88 |
| QA R3 | 9.6 min | $4.06 |
| **总计** | **3 hr 50 min** | **$124.70** |

## Agent 间通信：基于文件

一个 agent 写文件 → 另一个读并在该文件内或新文件回应 → 前者再读。**没有共享内存**。

## 对 Harness Engineering 的启示

1. **Generator ≠ Evaluator 是必须的** — 自评不可信，独立 evaluator + 调参 loop 才有效
2. **Sprint Contract 解决"spec 高层 vs 实现可测"的桥接** — 写代码之前协商完成标准
3. **Harness 组件是负债** — 每个组件编码了"模型不能做什么"的假设，新模型来了要逐个移除
4. **主观质量可以打分** — 把"美不美"分解成可判定的子标准（design quality / originality / craft / functionality）
5. **Evaluator 调参本身是工程** — few-shot 校准、读日志找分歧、多轮迭代
6. **基于文件的 agent 间通信** — 比共享内存更健壮，天然支持异步

## 与项目原则的映射

- 原则 3（独立验证）→ 本文给出了 generator/evaluator 分离的具体调参方法
- 原则 5（Sprint Contract）→ 本文是这一原则的原始来源
- 原则 9（Eval 驱动）→ evaluator 用 Playwright 真测，不是静态评分
- 新增建议：**原则 16 — Harness 简化纪律** — 新模型来了必须 stress test 现有 harness 组件，移除不再是负载的

---

*参考链接：*
- *[Harness design for long-running application development](https://www.anthropic.com/engineering/harness-design-long-running-apps)* — 2026-03-24
