# Anthropic Engineering 新知识笔记 (2026-06-16)

> 来源：Anthropic 工程博客 - 剩余未覆盖文章
> 学习日期：2026-06-16
> 覆盖文章数：3篇

---

## 一、Desktop Extensions: One-Click MCP Server Installation（2025-06-26）

**核心主题**：将 MCP 服务器打包为一键安装的扩展，消除安装摩擦

### 1.1 解决的问题

传统 MCP 服务器安装痛点：
- 需要 Node.js/Python 等开发工具
- 手动编辑 JSON 配置文件
- 依赖冲突和版本不匹配
- 没有发现机制，需要搜索 GitHub
- 更新需要手动重装

### 1.2 Desktop Extensions 架构

`.mcpb` 文件（ZIP 格式）包含：
```
extension.mcpb
├── manifest.json       # 扩展元数据和配置
├── server/             # MCP 服务器实现
├── dependencies/       # 所有依赖
└── icon.png            # 可选图标
```

**关键设计**：
- **内置运行时**：Claude Desktop 自带 Node.js，消除外部依赖
- **自动更新**：扩展有新版本时自动更新
- **安全密钥**：API Key 等敏感配置存储在 OS keychain 中
- **模板变量**：`${user_config.api_key}`、`${__dirname}` 等运行时替换

### 1.3 用户配置系统

manifest.json 中的 `user_config` 定义用户需要提供的输入：
```json
"user_config": {
  "api_key": {
    "type": "string",
    "title": "API Key",
    "sensitive": true,
    "required": true
  }
}
```

Claude Desktop 会自动：显示配置 UI → 验证输入 → 安全存储 → 传递给服务器

### 1.4 企业安全特性

- Windows Group Policy 和 macOS MDM 支持
- 预安装批准的扩展
- 黑名单特定扩展或发布者
- 禁用扩展目录

### 1.5 对 Harness Engineering 的启示

- **打包即分发**：MCP 服务器的"最后一公里"问题——再强大的工具，安装困难就等于不存在
- **敏感配置外置**：凭证由宿主应用管理，通过模板变量注入，工具本身不触碰
- **声明式配置 > 命令式安装**：manifest.json 声明需要什么，而非如何安装

---

## 二、Raising the Bar on SWE-bench Verified with Claude 3.5 Sonnet（2025-01-06）

**核心主题**：如何设计最小化 Harness 达到 SOTA——工具设计 > 复杂编排

### 2.1 核心哲学

> "Give as much control as possible to the language model itself, and keep the scaffolding minimal."

Harness 只有三个组件：Prompt + Bash Tool + Edit Tool。没有硬编码工作流，模型自主决定步骤。

### 2.2 工具设计经验

**Bash Tool**：
- Schema 极简，只有 `command` 参数
- 描述中包含关键指引：无网络、可用包、后台运行建议
- 避免产生大量输出的命令

**Edit Tool**（str_replace_editor）：
- 强制使用绝对路径（防止相对路径错误）
- **字符串替换 > 行号编辑**：`old_str` → `new_str`，要求唯一匹配
- 唯一性检查：不匹配或多个匹配时返回错误，让模型重试
- 支持 view/create/str_replace/insert/undo_edit 五个命令

### 2.3 关键教训

1. **错误防御工具设计**：预测模型会犯的错（如相对路径），在工具层面阻止
2. **工具描述比 Schema 更重要**：大段描述是"给模型的用户手册"
3. **字符串替换是最可靠的编辑模式**：唯一性约束比行号更健壮
4. **最小 Harness + 最强模型 = 最佳结果**：复杂编排可能反而限制模型能力

### 2.4 结果

| 模型 | SWE-bench Verified |
|------|-------------------|
| Claude 3.5 Sonnet (new) | **49%** |
| Previous SOTA | 45% |
| Claude 3.5 Sonnet (old) | 33% |
| Claude 3 Opus | 22% |

### 2.5 对 Harness Engineering 的启示

- **Less is More**：最简单的 Harness 可能就是最好的 Harness
- **工具接口设计是核心竞争力**：花在工具描述和 Schema 上的时间比编排逻辑更有价值
- **错误防御**：在工具层面阻止常见错误，而非在 Prompt 中警告

---

## 三、Introducing Contextual Retrieval（2024-09-19）

**核心主题**：用上下文感知的嵌入和 BM25 改进 RAG 检索准确率

### 3.1 传统 RAG 的问题

文档分块后，单个 chunk 丢失上下文。例如：
- 原始文本："公司收入比上季度增长 3%"
- 检索时无法知道这是哪家公司、哪个季度

### 3.2 Contextual Retrieval 方案

**核心思路**：在嵌入前，为每个 chunk 添加 chunk 特定的上下文说明。

```
原始 chunk → "公司收入比上季度增长 3%"
上下文化 chunk → "这段内容来自 ACME Corp 2023 Q2 的 SEC 文件；上季度收入为 $314M。公司收入比上季度增长 3%"
```

使用 Claude 3 Haiku 自动生成上下文，成本极低（$1.02/百万 token）。

### 3.3 两项技术

1. **Contextual Embeddings**：为 chunk 添加上下文后再做语义嵌入
2. **Contextual BM25**：为 chunk 添加上下文后再建 BM25 索引

### 3.4 性能数据

| 方法 | Top-20 检索失败率 | 改善 |
|------|-------------------|------|
| 基线 | 5.7% | - |
| Contextual Embeddings | 3.7% | ↓35% |
| Contextual Embeddings + Contextual BM25 | 2.9% | **↓49%** |
| + Reranking | 1.9% | **↓67%** |

### 3.5 Reranking 叠加效果

初始检索 top-150 → Reranking 模型评分 → 取 top-20 → 进一步降低失败率 67%

### 3.6 对 Harness Engineering 的启示

- **上下文不仅限于 Prompt**：检索阶段的上下文丢失同样致命
- **混合检索策略**：语义嵌入 + 精确匹配（BM25），互补而非互斥
- **预处理的复利效应**：一次性投入为 chunk 添加上下文，后续每次检索都受益
- **Agent 的"记忆"也需要上下文**：Harness 存储的中间状态（如 feature_list.json）也应包含足够的上下文，避免后续 session 误解

---

## 四、知识体系更新总结

### 新增核心概念

| 概念 | 来源文章 | 一句话描述 |
|------|----------|-----------|
| **MCPB 打包** | Desktop Extensions | 将 MCP 服务器打包为 .mcpb 一键安装包 |
| **最小 Harness 哲学** | SWE-bench | 给模型最大控制权，保持 Harness 最小化 |
| **错误防御工具设计** | SWE-bench | 在工具层面阻止常见错误，而非依赖 Prompt |
| **字符串替换编辑** | SWE-bench | 唯一性约束的字符串替换是最可靠的代码编辑模式 |
| **Contextual Retrieval** | Contextual Retrieval | 为 RAG chunk 添加上下文说明，检索失败率降低 49% |

### 跨文章洞察

1. **安装摩擦是工具采用的最大障碍**：Desktop Extensions 解决的正是"最后一公里"问题
2. **简单 Harness + 好工具 > 复杂编排**：SWE-bench 证明了最小 Harness 可以达到 SOTA
3. **上下文丢失无处不在**：从 Prompt 到检索到文件存储，每一步都可能丢失上下文

---

## 五、参考链接

- [Desktop Extensions](https://www.anthropic.com/engineering/desktop-extensions) - 2025-06-26
- [SWE-bench Verified](https://www.anthropic.com/engineering/swe-bench-sonnet) - 2025-01-06
- [Contextual Retrieval](https://www.anthropic.com/engineering/contextual-retrieval) - 2024-09-19
