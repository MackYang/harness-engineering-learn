# Harness Engineering 知识库

> 这是本仓库的知识中心。按需深入，不要一次全部加载。
> 核心理念：给地图不给说明书，渐进式披露。

## 目录结构

```
docs/knowledge/
├── README.md              ← 你正在读的索引文件
├── principles/            ← 核心设计原则
│   ├── golden-rules.md    ← 十大黄金原则（OpenAI 权威来源）
│   └── context-engineering.md  ← 上下文工程原则
├── patterns/              ← Agent 工作流和架构模式
│   ├── agent-workflows.md ← Anthropic 的 5 种工作流模式
│   ├── eval-patterns.md   ← 评估模式（Generator ≠ Evaluator）
│   └── architecture-patterns.md  ← 分层架构与约束执行
└── sources/               ← 权威来源学习笔记
    └── anthropic-harness-engineering-knowledge-2026-05-30.md  ← 已有笔记
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

### 我想理解上下文工程
→ 读 `principles/context-engineering.md`

## 核心参考来源

| 来源 | 链接 | 笔记位置 |
|------|------|----------|
| OpenAI Harness Engineering | https://openai.com/index/harness-engineering/ | `principles/golden-rules.md` |
| Anthropic Building Effective Agents | https://www.anthropic.com/engineering/building-effective-agents | `patterns/agent-workflows.md` |
| Anthropic Harness Design 系列 | https://www.anthropic.com/engineering/ | `sources/` |

## 维护规则

- 每周更新一次知识笔记（cron job 或手动）
- 新增知识必须放到正确的子目录中
- 过时知识标记 `⚠️ STALE` 或删除
- 运行 `make garden` 检查文档健康度
