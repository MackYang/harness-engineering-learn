# Addy Osmani Agent Harness Engineering 补充知识笔记 (2026-07-23)

> 来源：https://addyosmani.com/blog/agent-harness-engineering/
> 作者：Addy Osmani (Google Chrome 团队核心成员)
> 学习日期：2026-07-23
> 对比笔记：2026-07-20版本（补充上次截断的 HaaS 和行业收敛部分）

---

## 一、上次截断内容补充

### 1.1 Harness-as-a-Service (HaaS) 完整概念

**定义**（Viv Trivedy 提出）：
> 我们正在从构建在 LLM API 之上（给你一个 completion）转向构建在 Harness API 之上（给你一个 runtime）。

**三种 SDK 指向同一方向**：
- Claude Agent SDK
- Codex SDK
- OpenAI Agents SDK

**共同提供的开箱即用能力**：
```
Loop（循环）
Tools（工具）
Context Management（上下文管理）
Hooks（钩子）
Sandbox Primitives（沙盒原语）
```

**路径转变**：
``n
旧路径：构建自己的循环 → 自己的 tool-calling → 自己的会话状态 → 自己的审批流程
新路径：选择 Harness 框架 → 配置四大支柱 → 专注领域特定设计

四大支柱：
1. System Prompt（系统提示）
2. Tools（工具）
3. Context（上下文）
4. Subagents（子代理）
``

**关键洞察**：
> 这使得"skill issue"变得可处理。你不是每次出问题都从零重建代理，而是在一个已经良好分化的配置面上调优。

**Viv 的"先乱后治"原则**：
> "Good agent building is an exercise in iteration. You can't do iterations if you don't have a v0.1."

### 1.2 行业收敛现象

**关键观察**：
> 顶级 coding agents（Claude Code、Cursor、Codex、Aider、Cline）并排放在一起，它们比底层模型更像彼此。模型不同，Harness 模式正在收敛。这不是巧合——是行业在缓慢找到将生成模型转化为可交付产物的关键脚手架。

**含义**：
- Harness 的核心模式正在标准化
- 竞争优势从"有没有这个功能"转向"这个功能实现得多好"
- 学习一种 Harness 的模式可以迁移到其他 Harness

### 1.3 开放问题

**Viv 提出的三个最令人兴奋的开放问题**：

**1. 并行多代理编排**：
```
挑战：多个代理在共享代码库上并行工作
  - 工具树解决文件冲突
  - 但语义层面的冲突（同一功能的不同实现）怎么办？
  - 跨代理的依赖关系管理
```

**2. 自我诊断的 Harness**：
```
挑战：代理分析自己的 trace 来识别和修复 Harness 级别的失败模式
  - 代理不仅修复代码，还能改进自己的运行环境
  - 这是对"ratchet"模式的元级别应用
  - 代理成为自己 Harness 的改进者
```

**3. 动态工具/上下文组装**：
```
挑战：Harness 根据任务即时组装正确的工具和上下文，
      而不是在启动时预配置

  → 这是 Addy 认为最激动人心的方向
  > "这感觉像是 Harness 停止成为静态配置，
    开始变得更像编译器的地方。"

从预配置到即时编译：
  静态配置：启动时加载所有工具和上下文
  动态组装：根据任务需求即时选择和组合
  编译器类比：Harness 变成将任务规范编译为运行时配置的编译器
```

---

## 二、审视性补充：深入理解之前未充分注意的要点

### 2.1 "Success is silent, failures are verbose" 原则的实践价值

这个原则在 Hook 设计中极其重要：
```
常见情况（成功）：typecheck 通过 → 代理无感知 → 零开销
异常情况（失败）：typecheck 失败 → 错误文本注入循环 → 代理自动修正

实践价值：
1. 反馈回路在常见情况下几乎免费
2. 出问题时反馈直接可操作
3. 不会因频繁的"通过"通知而造成注意力稀释

对比传统 CI：传统 CI 总是报告结果（成功也报告）
              Hook 式反馈只在失败时介入 → 更高效
```

### 2.2 Sprint Contract 模式的深度理解

```
Sprint Contract = 生成者和评估者在写代码前协商"完成"的定义

传统流程：
  生成者写代码 → 评估者检查 → 不一致 → 修改

Sprint Contract 流程：
  生成者和评估者先达成"完成"标准 → 生成者写代码 → 评估者检查

Addy 的经验：
  > "在我自己的工作流中，在开始前写下完成条件，
    比任何 prompt 修改都更能捕获范围漂移。"

这对应软件工程中的"Definition of Done"但应用于代理间协作
```

### 2.3 工具数量与质量的关系

```
10 个聚焦的工具 > 50 个重叠的工具

原因：模型的工具选择受限于上下文窗口
  - 每个工具的名称、描述、schema 都会被压入 prompt
  - 工具越多，模型越难准确选择
  - 50 个工具的"菜单"模型无法有效记忆

安全隐含：MCP 服务器安装的任何工具描述都是模型会读取的受信文本
  → 粗心或恶意的 MCP 可以在你输入任何内容之前进行 prompt 注入
```

### 2.4 模型-Harness 共训练的实践启示

```
共训练效应：
  Opus 4.6 在 Claude Code 内表现 ≠ 在其他 Harness 内表现
  因为它专门针对 Claude Code 的工具和操作进行了后训练

实践启示：
  1. "最佳" Harness ≠ 模型训练时的 Harness
     = 为你的任务设计的 Harness 才是最佳的
  2. 改变工具逻辑可能导致奇怪的性能回退
     = 共训练导致了过拟合
  3. Harness 是活系统，不是一次性配置
     = 需要随模型更新而维护

Viv 的 Terminal Bench 证明：
  仅改变 Harness，同一模型从 Top 30 提升到 Top 5
  → 真正的通用模型不应该关心 apply_patch vs str_replace
  → 但共训练创造了这种差异
```

---

## 三、与 Loop Engineering 的交叉洞察

### 3.1 Loop 的安全维度

```
Loop Engineering 的五大构件都有安全维度：

1. Automations
   - 定时任务运行时谁在监督？
   - 状态文件可能被注入吗？
   → 需要状态文件完整性保护

2. Worktrees
   - 隔离的代码是否包含恶意内容？
   → 需要入口检查

3. Skills
   - Skill 文件本身可能是注入向量
   → 需要审计和版本控制

4. Plugins/Connectors
   - MCP 连接器的双重风险（代码执行 + 注入）
   → 远程连接器应视为不受信任

5. Sub-agents
   - 信任升级风险
   → 明确的信任边界
```

### 3.2 HaaS 对 Loop 工程的影响

```
HaaS 的出现意味着 Loop 设计更简单：

之前：自己构建循环基础 → 在此之上设计 Loop
现在：选择 HaaS 框架 → 在框架之上设计 Loop

但核心挑战不变：
  - 验证仍然是人类的责任
  - 理解债务会加速增长
  - 舒适姿态（cognitive surrender）是最危险的
```