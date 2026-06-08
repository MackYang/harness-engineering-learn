# Anthropic Engineering 新知识笔记 (2026-06-09)

> 来源：Anthropic 工程博客 - 2025年文章（之前未覆盖）
> 学习日期：2026-06-09
> 覆盖文章数：6篇

---

## 一、Introducing Advanced Tool Use on the Claude Developer Platform（2025-11-24）

**核心主题**：三大高级工具使用特性——按需发现、代码编排、示例学习

### 1.1 三大特性概览

| 特性 | 解决的问题 | 核心收益 |
|------|-----------|---------|
| **Tool Search Tool** | 大量工具定义塞满上下文 | 85% token 节省，准确率大幅提升 |
| **Programmatic Tool Calling (PTC)** | 每次工具调用都需要推理 pass，中间结果膨胀 | 37% token 节省，消除 19+ 推理轮次 |
| **Tool Use Examples** | Schema 只能表达结构，无法传达使用模式 | 模型从示例学习正确用法 |

### 1.2 Tool Search Tool（工具搜索工具）

**问题**：5 个 MCP 服务器 = 58 个工具 ≈ 55K tokens，Jira 一个服务器就 17K tokens。内部案例达到 134K tokens。

**解决方案**：用 `defer_loading: true` 标记工具，Agent 通过搜索按需加载。

**效果**：
- 传统方式：~72K tokens（50+ 工具），总上下文 ~77K
- Tool Search Tool：只加载搜索工具（~500 tokens）+ 按需 3-5 个工具（~3K），总消耗 ~8.7K
- **保留 95% 上下文窗口**，85% token 使用减少
- Opus 4 准确率从 49% → 74%，Opus 4.5 从 79.5% → 88.1%

**适用场景**：
- 工具定义 >10K tokens
- 工具选择准确率有问题
- MCP 多服务器集成
- 10+ 个工具

### 1.3 Programmatic Tool Calling（编程式工具调用）

**问题**：传统方式每个工具调用 = 一次完整推理 pass，中间结果堆积在上下文中。

**示例**：预算合规检查
- 传统：获取 20 人 → 每人获取支出（20 次调用，50-100 行/人）→ 获取预算 → 所有 2000+ 行明细进入上下文 → 手动汇总
- PTC：Claude 写 Python 代码，并行获取所有数据，在执行环境处理，只返回最终超预算的 2-3 人

**效果**：
- Token 使用：43,588 → 27,297（减少 37%）
- 知识检索准确率：25.6% → 28.5%
- GIA benchmark：46.5% → 51.2%

**对 Harness 的启示**：
- **代码编排 > 自然语言编排**：循环、条件、错误处理用代码表达比自然语言可靠
- **上下文过滤器**：PTC 让中间结果不进入模型上下文，是上下文工程的重要工具
- **隐私保护**：敏感数据可以在执行环境中处理，只返回脱敏结果

### 1.4 Tool Use Examples（工具使用示例）

JSON Schema 定义结构有效性，但不能表达使用模式：
- 何时包含可选参数
- 哪些参数组合有意义
- API 期望什么约定

---

## 二、Code Execution with MCP: Building More Efficient Agents（2025-11-04）

**核心主题**：用代码执行环境替代传统 MCP 直接工具调用，实现 98.7% token 节省

### 2.1 核心洞察

> "Although many of the problems here feel novel—context management, tool composition, state persistence—they have known solutions from software engineering."

Agent 面临的上下文管理问题可以用软件工程的成熟模式解决。

### 2.2 文件系统即工具注册表

将 MCP 工具转换为文件系统中的代码文件：
```
servers/
├── google-drive/
│   ├── getDocument.ts
│   └── index.ts
├── salesforce/
│   ├── updateRecord.ts
│   └── index.ts
```

Agent 通过探索文件系统发现工具，按需读取定义 → **Progressive Disclosure 的完美实现**。

**Token 节省**：150,000 → 2,000（98.7%）

### 2.3 五大收益

1. **Progressive Disclosure**：模型擅长浏览文件系统，按需加载工具定义
2. **上下文高效**：10,000 行数据在执行环境中过滤，只返回 5 行给模型
3. **更强控制流**：循环、条件、错误处理用熟悉的代码模式
4. **隐私保护**：中间结果默认留在执行环境，可对 PII 自动脱敏/tokenize
5. **状态持久化与技能**：Agent 可保存中间结果到文件，甚至保存可复用函数

### 2.4 Skills 概念

代码执行允许 Agent 将成功的代码保存为可复用函数，加上 SKILL.md 文件形成结构化技能。这使 Agent 随时间积累"工具箱"。

**对 Harness 的启示**：
- **上下文效率的关键模式**：代码执行 + 文件系统工具发现 = 最激进的 token 节省
- **Skills 系统**：Agent 自我改进的基础设施——不仅能执行任务，还能积累能力
- **安全权衡**：代码执行需要沙箱和资源限制，增加了运维复杂度

---

## 三、How We Built Our Multi-Agent Research System（2025-06-13）

**核心主题**：多 Agent 系统的设计原则——编队架构 + 子代理并行 + 评估

### 3.1 为什么需要多 Agent

> "The essence of search is compression: distilling insights from a vast corpus."

三个因素解释了 BrowseComp 评估中 95% 的性能方差：
1. **Token 使用量**（解释 80%）
2. **工具调用次数**
3. **模型选择**

**关键数据**：
- 多 Agent (Opus 4 lead + Sonnet 4 subagents) 比单 Agent Opus 4 高出 **90.2%**
- Agents 使用约 4× token，多 Agent 系统约 15× token

### 3.2 架构：LeadResearcher → Subagents → CitationAgent

```
用户查询 → LeadResearcher（规划+协调）
  ├→ Subagent 1（搜索方向 A）
  ├→ Subagent 2（搜索方向 B）
  └→ Subagent 3（搜索方向 C）
← 汇总结果
→ CitationAgent（标注引用来源）
→ 最终结果
```

### 3.3 七大 Prompt Engineering 原则

1. **像你的 Agent 一样思考**：用 Console 模拟相同 prompt + 工具，观察 Agent 逐步工作
2. **教会编排器委派**：每个子代理需要目标、输出格式、工具指引、明确边界
3. **按复杂度分配资源**：简单事实查询 1 agent/3-10 calls，复杂研究 10+ agents
4. **工具设计决定成败**：给 Agent 明确的启发式规则选择工具
5. **让 Agent 自我改进**：Claude 4 可以诊断自己的失败并建议 prompt 改进
6. **先宽后窄**：搜索策略从广泛探索到逐步聚焦
7. **引导思考过程**：Extended thinking 用于规划，interleaved thinking 用于评估结果

### 3.4 并行化转型

两种并行：
1. Lead agent 同时启动 3-5 个子代理
2. 子代理并行使用 3+ 个工具

**效果**：复杂查询时间减少 **90%**

### 3.5 评估多 Agent 系统

挑战：传统评估假设 AI 每次走相同步骤，但 Agent 行为是动态的。

方法：
- 使用 pass^k 指标（所有 k 次试验都成功的概率）
- 创建 Agent 可以运行的评估框架
- LLM-as-judge 评分 + 人类专家验证

**对 Harness 的启示**：
- **多 Agent = Token 扩展**：当单个上下文不够时，用多个上下文解决
- **编排即 Prompt Engineering**：多 Agent 系统的质量主要取决于编排提示的质量
- **工具-测试 Agent**：让一个 Agent 专门测试和改进工具描述（40% 任务完成时间减少）
- **子代理压缩**：子代理的核心价值是在独立上下文中探索和压缩信息

---

## 四、Claude Code: Best Practices for Agentic Coding（2025-04-18）

**核心主题**：Claude Code 最佳实践——上下文管理是第一约束

### 4.1 核心约束

> "Claude's context window fills up fast, and performance degrades as it fills."

上下文窗口是最重要的资源。每条消息、每个文件读取、每个命令输出都在消耗它。

### 4.2 六大最佳实践

#### 实践 1：给 Agent 验证手段

| 策略 | 说明 |
|------|------|
| **测试套件** | `run the test suite after implementing` |
| **构建检查** | `fix it and verify the build succeeds` |
| **视觉对比** | `take a screenshot and compare` |
| **Linter** | 自动代码风格检查 |

验证强度递进：
1. 单 prompt 中要求运行检查
2. `/goal` 条件：每次 turn 后自动重检
3. Stop hook：脚本级确定性门控
4. 验证子代理：独立模型反驳结果

#### 实践 2：先探索，再规划，再编码

四阶段工作流：
1. **Explore**：Plan mode 读文件，不做修改
2. **Plan**：创建详细实施计划
3. **Implement**：退出 plan mode，按计划编码
4. **Commit**：描述性提交 + PR

> "If you could describe the diff in one sentence, skip the plan."

#### 实践 3：提供具体上下文

- 用 `@` 引用文件而非描述位置
- 粘贴图片/截图
- 指向现有代码模式
- 描述症状 + 可能位置 + "修复"的标准

#### 实践 4：配置环境

**CLAUDE.md 最佳实践**：
- 只放 Claude 无法从代码推断的信息
- 包含：不可猜测的 Bash 命令、偏离默认的代码风格、测试指令、仓库礼仪
- 排除：Claude 能从代码推断的、标准语言约定、详细 API 文档

> "For each line, ask: 'Would removing this cause Claude to make mistakes?' If not, cut it."

#### 实践 5：使用 Headless 模式

CI/CD 集成：`claude -p "fix the failing test" --allowedTools`
自动化工作流：PR review、issue 处理、批量重构

#### 实践 6：并行扩展

- 多个 Claude Code session 并行处理独立任务
- 用 `git worktree` 避免工作目录冲突
- 每个 session 处理一个独立关注点

### 4.3 对 Harness 的启示

- **验证闭环是核心**：没有验证的自主 = 不负责任的自主
- **Plan mode 是 Harness 的标准阶段**：探索 → 规划 → 实现 → 提交
- **CLAUDE.md 即 Harness 配置**：轻量级但关键的环境配置文件
- **Headless = 无人值守 Harness**：CI 集成是 Harness 成熟度的标志

---

## 五、The "Think" Tool: Enabling Claude to Stop and Think（2025-03-20）

**核心主题**：通过专用"思考工具"提升复杂工具使用场景的表现

### 5.1 Think Tool vs Extended Thinking

| 维度 | Extended Thinking | Think Tool |
|------|------------------|------------|
| 时机 | 生成响应**前**的深度思考 | 响应**中**的阶段性反思 |
| 用途 | 数学、编码、物理等不需要工具的场景 | 长工具调用链、政策密集、序列决策 |
| 内容 | 全面规划 | 针对新获取信息的推理 |

### 5.2 基准测试结果

**τ-Bench（Airline 域）**：
- Baseline: 0.370 → Think + Prompt: 0.570（**54% 相对提升**）
- k=5 一致性：Think + Prompt 0.340 vs Baseline 0.100

**SWE-bench**：
- 包含 think tool 提升 1.6%（p < .001, d = 1.47 大效应量）

### 5.3 何时使用

**适用场景**：
- 工具输出分析：处理复杂工具结果后需要决定下一步
- 政策密集环境：需要验证合规性
- 序列决策：每步依赖前一步，错误代价高

**不适用场景**：
- 非序列工具调用
- 简单指令遵循

### 5.4 最佳实践

1. **提供领域特定的思考示例**：在 system prompt 中放复杂指导
2. **不要放在工具描述中**：长/复杂的指导放在 system prompt 更有效
3. **指导思考内容**：列出适用规则 → 检查信息完整性 → 验证合规性 → 迭代工具结果

**对 Harness 的启示**：
- **Think Tool 是 Agent 的"工作记忆"**：区别于上下文窗口的"长期记忆"
- **复杂政策遵循的必备工具**：特别适用于需要严格遵守规则的 Agent 场景
- **低成本高收益**：实现极其简单（只是一个不做什么的工具），但效果显著

---

## 六、Beyond Permission Prompts: Making Claude Code More Secure and Autonomous（2025-10-20）

**核心主题**：OS 级沙箱实现——文件系统隔离 + 网络隔离 = 安全自主

### 6.1 沙箱架构

**两个隔离维度**（缺一不可）：
1. **文件系统隔离**：Agent 只能访问指定目录
2. **网络隔离**：Agent 只能连接批准的服务器

> "Without network isolation, a compromised agent could exfiltrate sensitive files like SSH keys; without filesystem isolation, a compromised agent could easily escape the sandbox and gain network access."

### 6.2 OS 级实现

- **macOS**：Seatbelt (sandbox-exec)
- **Linux**：bubblewrap (bwrap)
- 不仅是 Claude Code 自身，还包括所有子进程和脚本

**效果**：沙箱安全地减少 **84% 权限提示**

### 6.3 Cloud 版本：凭证代理

Claude Code on the Web 的安全模型：
- 凭证（git token、签名密钥）**永远不在沙箱中**
- 自定义代理服务处理所有 git 交互
- 沙箱内只有 scope 受限的临时凭证
- 代理验证凭证 + 分支名 + 仓库目标后才发送请求

### 6.4 开源

sandbox-runtime 已开源：`github.com/anthropic-experimental/sandbox-runtime`

**对 Harness 的启示**：
- **沙箱是自主的前提**：没有安全边界，Agent 只能不断请求权限
- **OS 级 > 应用级**：用 OS 原语而非自己写隔离逻辑
- **凭证代理模式**：敏感凭证永远不进执行环境，通过代理桥接
- **两种隔离缺一不可**：只有文件系统隔离或只有网络隔离都不安全

---

## 七、知识体系更新总结

### 新增原则提炼

**第 11 条（候选）**：按需发现 > 预加载——工具定义、上下文、技能都应按需加载，而非一次性塞入上下文窗口

**第 12 条（候选）**：代码编排 > 自然语言编排——复杂的多步骤工具调用链应使用代码执行环境，让中间结果不污染模型上下文

**第 13 条（候选）**：验证闭环是自主的前提——没有验证手段的 Agent 不是真正的 Agent，只是一个需要人类不断纠正的半成品

### 跨文章洞察

1. **上下文效率的三层策略**：
   - L1: 精简工具定义（Tool Search Tool）
   - L2: 代码执行过滤中间结果（PTC）
   - L3: 文件系统 Progressive Disclosure（MCP as code）

2. **多 Agent 编排 = Prompt Engineering 的高级形式**：
   - 单 Agent 系统的质量上限取决于 prompt
   - 多 Agent 系统的质量上限取决于编排 prompt
   - 两者都需要 eval 驱动的迭代优化

3. **安全 = 自主的赋能者**：
   - 沙箱不是限制，而是让 Agent 更自由的框架
   - OS 级隔离 > 应用级隔离
   - 凭证代理是 Agent 安全的基石模式

---

## 八、参考链接

- [Introducing Advanced Tool Use](https://www.anthropic.com/engineering/advanced-tool-use) - 2025-11-24
- [Code Execution with MCP](https://www.anthropic.com/engineering/code-execution-with-mcp) - 2025-11-04
- [Multi-Agent Research System](https://www.anthropic.com/engineering/multi-agent-research-system) - 2025-06-13
- [Claude Code Best Practices](https://code.claude.com/docs/en/best-practices) - 2025-04-18
- [The "Think" Tool](https://www.anthropic.com/engineering/claude-think-tool) - 2025-03-20
- [Claude Code Sandboxing](https://www.anthropic.com/engineering/claude-code-sandboxing) - 2025-10-20
