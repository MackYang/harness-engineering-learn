# 上下文工程原则

> 来源：Anthropic — "Effective Context Engineering for AI Agents" + OpenAI Harness Engineering
> 核心思想：Context window is RAM — 每个 token 花在基础设施噪音上，就是少了一个用于推理的 token

## 什么是上下文工程

上下文工程是 Prompt Engineering 的自然演进，关注的是：
- 系统指令的设计
- 工具的定义和优化
- 消息历史的管理
- 外部数据的检索策略
- 长时间运行任务的上下文维护

> "Context engineering is the art and science of curating what will go into the limited context window from that constantly evolving universe of possible information."

## 核心原则

### 1. 上下文是稀缺资源
- 每个 token 花在噪音上就少了推理空间
- 不要预加载全部知识，按需检索
- 精简工具定义、精简 prompt

### 2. Just-in-Time 检索
- 维护文件路径引用，运行时按需加载
- 不要把整个 docs/ 塞进上下文
- 用索引文件（如 AGENTS.md）指向更深层信息

### 3. Progressive Disclosure（渐进式披露）
- Agent 从小而稳定的切入点开始
- 被指导下一步该去哪里查看
- 不是一开始就被淹没

### 4. 给地图不给说明书
- AGENTS.md 应该是目录，不是百科全书
- 经验证"一个大文件"方案是失败的：
  - 巨大的指令文件挤掉任务和代码
  - 当一切都"重要"时，一切都不重要了
  - 单个 blob 会变成陈旧规则的坟场

### 5. 代码仓库是记录系统
- Agent 运行时无法访问的内容不存在
- Google Docs、Slack 讨论、人脑中的知识 — 不在仓库里就不算数
- 所有知识必须版本化并放在仓库中

## 实践建议

- 使用 JSON 而非 Markdown 存储结构化状态（模型更不容易篡改）
- 使用绝对路径避免 Agent 在子目录中迷路
- 设计工具时考虑 Agent 可读性（可组合、API 稳定、训练集友好）
- 定期运行 doc-gardening 检查知识库健康度

---

*最后更新：2026-06-04*
