# Harness Engineering 知识库

> 这是本仓库的知识中心。按需深入，不要一次全部加载。
> 核心理念：给地图不给说明书，渐进式披露。

## 目录结构

```
docs/knowledge/
├── README.md              ← 你正在读的索引文件
├── principles/            ← 核心设计原则
│   ├── golden-rules.md            ← 十五大黄金原则（OpenAI/Anthropic 来源）
│   ├── operational-principles.md  ← 项目操作原则（15 条执行纪律）
│   └── context-engineering.md     ← 上下文工程原则
├── patterns/              ← Agent 工作流和架构模式
│   ├── agent-workflows.md         ← Anthropic 的 5 种工作流模式
│   ├── eval-patterns.md           ← 评估模式（Generator ≠ Evaluator）
│   └── architecture-patterns.md   ← 分层架构与约束执行
└── sources/               ← 权威来源学习笔记（按日期归档）
    ├── anthropic-harness-engineering-knowledge-2026-05-30.md
    ├── anthropic-engineering-2026-06-08.md
    ├── anthropic-engineering-2026-06-09.md
    ├── anthropic-engineering-2026-06-16.md
    ├── anthropic-managed-agents-2026-04-08.md                ← Meta-Harness 接口设计
    ├── anthropic-long-running-apps-2026-03-24.md             ← GAN 三 Agent + Sprint Contract
    ├── addy-loop-engineering-2026-06-07.md                      ← Loop Engineering 首次正式定义
    ├── addy-agent-harness-engineering-2026-06-26.md              ← Agent Harness Engineering 综合指南
```

## 按场景导航

### 我想了解 Harness Engineering 是什么
→ 读 `principles/golden-rules.md`

### 我在设计 Agent 工作流
→ 读 `patterns/agent-workflows.md`（Prompt Chaining、Routing、Parallelization 等）

### 我在做评估/验证
→ 读 `patterns/eval-patterns.md`

### 我想深入看原始学习笔记
→ 读 `sources/` 目录下的文件

### 我想了解 Agent Harness Engineering（脚手架工程）
→ 读 `sources/addy-agent-harness-engineering-2026-06-26.md`（Addy Osmani 综合指南，含 Ratchet、HaaS、Context Rot 等）

### 我想了解 Loop Engineering（循环工程）
→ 读 `sources/addy-loop-engineering-2026-06-07.md`（Addy Osmani 首次命名，五大构件）
→ 读 `principles/loop-engineering-principles.md`（六大构件原则 + 检查清单）

### 我想认知风险管理
→ 读 `docs/org/cognitive-risks.md`（验证责任、理解力萎缩、认知投降）

## 核心参考来源

| 来源 | 链接 | 笔记位置 |
|------|------|----------|
| OpenAI Harness Engineering | https://openai.com/index/harness-engineering/ | `principles/golden-rules.md` |
| Anthropic Building Effective Agents | https://www.anthropic.com/engineering/building-effective-agents | `patterns/agent-workflows.md` |
| Anthropic Harness Design 系列 | https://www.anthropic.com/engineering/ | `sources/` |
| Addy Osmani Agent Harness Engineering | https://addyosmani.com/blog/agent-harness-engineering/ | `sources/addy-agent-harness-engineering-2026-06-26.md` |
| Addy Osmani Loop Engineering | https://addyosmani.com/blog/loop-engineering/ | `sources/addy-loop-engineering-2026-06-07.md` |

## 维护规则

- 每周更新一次知识笔记（cron job 或手动）
- 新增知识必须放到正确的子目录中
- 过时知识标记 `⚠️ STALE` 或删除
- 运行 `make garden` 检查文档健康度
