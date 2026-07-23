# OpenAI Harness Engineering 审视笔记 (2026-07-23)

> 来源：OpenAI 官方博客 - Harness Engineering: Leveraging Codex in an Agent-First World
> 学习日期：2026-07-23
> 对比笔记：2026-07-20版本

---

## 一、审视性学习：之前未充分注意的要点

### 1.1 AGENTS.md 的精确使用方式

**原文细节**：
> "A short AGENTS.md (roughly 100 lines) is injected into context and serves primarily as a map, with pointers to deeper sources of truth elsewhere."

**之前遗漏的要点**：
- AGENTS.md 的精确长度是**约 100 行**，不是任意短小
- 它的角色是**地图**（table of contents），不是百科全书
- 知识库在结构化的 `docs/` 目录中
- 设计文档被编目和索引，包含**验证状态**和核心信念

### 1.2 Ralph Wiggum Loop 的明确引用

**新发现**：
> "we instruct Codex to review its own changes locally, request additional specific agent reviews both locally and in the cloud, respond to any human or agent given feedback, and iterate in a loop until all agent reviewers are satisfied (effectively this is a Ralph Wiggum Loop)."

**含义**：
- OpenAI 正式承认使用 Ralph Wiggum Loop 模式
- 这是代理间协作的核心机制
- 循环直到所有代理审查者满意为止

### 1.3 内部实现决策的完整逻辑

**"无聊"技术的选择标准（三维度）**：
``n
1. 可组合性（Composability）：API 稳定，容易组合
2. API 稳定性（API Stability）：接口不频繁变更
3. 训练集表示（Training Set Representation）：模型在训练中见过足够多的示例

这三个维度共同决定了代理对技术的"可读性"
```

**自定义实现的决策逻辑**：
``n
示例：不用 p-limit 包，自己实现 map-with-concurrency

决策因素：
1. 与 OpenTelemetry 集成（p-limit 不支持）
2. 100% 测试覆盖率
3. 行为完全符合运行时期望
4. 代理可以完全内化和推理

结论：有时让代理重新实现功能比使用不透明的上游库更有效
→ 代价是维护成本，但收益是代理可读性
```

### 1.4 最小化阻塞合并门控的哲学

**关键洞察**：
``n
传统：大量阻塞式合并门控 → 高质量但低吞吐
代理驱动：最小化阻塞门控 → 高吞吐，修正成本低

背后的经济学：
  - 代理吞吐量远超人类注意力
  - 等待是昂贵的（人类时间是最稀缺资源）
  - 修正是廉价的（代理可以快速修正）

这只有在代理高吞吐环境下才是正确的权衡
在低吞吐环境中这将是负责任的
```

### 1.5 代理可运行时间

**新数据点**：
> "We regularly see single Codex runs work on a single task for upwards of six hours (often while the humans are sleeping)."

**含义**：
- 单次代理运行可持续 6 小时以上
- 人类在睡觉时代理继续工作
- 这需要一个可靠的长期运行环境
- 包括：每个 git worktree 可启动的应用、Chrome DevTools Protocol、临时可观测性堆栈

---

## 二、与其他来源的交叉洞察

### 2.1 OpenAI + Anthropic 安全模型的对比

``n
OpenAI 焦点：
  - 架构约束防止质量衰减
  - 知识管理防止代理"不知道"
  - 黄金原则防止模式漂移

Anthropic 焦点：
  - 环境包含防止恶意行为
  - 出口控制防止数据外泄
  - 多层防御确保纵深安全

互补关系：
  OpenAI 关注"代理能做好工作"
  Anthropic 关注"代理不会做坏事"
  两者结合 = 完整的 Harness 安全框架
```

### 2.2 Codex 的 Chrome DevTools 集成与 Anthropic 出口控制的对比

``n
OpenAI：让代理"看到"UI → 能力最大化
  - Chrome DevTools Protocol
  - DOM 快照、截图、导航
  - 代理可以自行复现和验证 bug

Anthropic：让代理"不能做"危险事 → 安全最大化
  - 出口白名单
  - 文件系统边界
  - egress 代理

两者都需要，但优先级取决于应用场景
```