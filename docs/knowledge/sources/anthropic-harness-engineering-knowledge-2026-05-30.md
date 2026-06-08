# Harness Engineering 权威知识汇总 (2026-05-30)

> 来源：Anthropic 工程博客系列 + Claude Code 最佳实践
> 学习日期：2026-05-30
> 下次更新：2026-06-06

---

## 一、核心概念定义

### 1.1 Harness（脚手架/运行框架）
Harness 是 AI Agent 运行的支撑系统，它定义了 Agent 如何与环境交互、如何管理上下文、如何跨 session 保持连续性。Harness 不是 Agent 本身，而是让 Agent 有效工作的基础设施。

### 1.2 评估体系（Evals）
- **Evaluation Harness**: 运行 eval 的端到端基础设施，提供指令和工具、并发运行任务、记录步骤、评分输出、聚合结果
- **Agent Harness (Scaffold)**: 让模型作为 Agent 行动的系统，处理输入、编排工具调用、返回结果
- **Evaluation Suite**: 设计用于测量特定能力或行为的任务集合

### 1.3 Context Engineering（上下文工程）
> "Context engineering is the art and science of curating what will go into the limited context window from that constantly evolving universe of possible information."

上下文工程是 Prompt Engineering 的自然演进，关注的是：
- 系统指令的设计
- 工具的定义和优化
- 消息历史的管理
- 外部数据的检索策略
- 长时间运行任务的上下文维护

---

## 二、六大核心文章要点

### 2.1 Effective Harnesses for Long-Running Agents (2025-11)

**核心问题**：Agent 在多 session 间无法保持记忆，导致：
1. 尝试一次性完成所有工作（one-shot），上下文用完后留下半成品
2. 后续 session 看到有进展就过早宣布完成

**解决方案：双 Agent 架构**
- **Initializer Agent**：首次运行时设置环境
  - 创建 init.sh 脚本
  - 创建 claude-progress.txt 进度文件
  - 创建 feature_list.json（所有功能点，初始为 failing）
  - 初始 git commit
- **Coding Agent**：后续每次 session
  - 读取 git log + progress file 了解状态
  - 一次只做一个 feature（增量式）
  - 测试验证后才标记 passes
  - session 结束前 commit + 更新 progress

**关键洞察**：
- Feature list 用 JSON 而非 Markdown（模型更不容易篡改 JSON）
- 必须给 Agent 真正的测试工具（如 Puppeteer），否则会"自以为完成了"
- 使用绝对路径避免 agent 在子目录中迷路

### 2.2 Harness Design for Long-Running Application Development (2026-03)

**核心问题**：
1. **Context Anxiety**：模型在接近上下文限制时会过早结束工作
2. **Self-Evaluation Bias**：Agent 对自己的工作总是过于自信地好评

**解决方案：三 Agent GAN 架构**
- **Planner**：将简单 prompt 扩展为完整产品规格（关注高层设计，不纠结技术细节）
- **Generator**：按 sprint 实现功能，每次只做一个 feature
- **Evaluator**：使用 Playwright MCP 像用户一样点击测试，按多维度评分

**Sprint Contract 机制**：
- Generator 和 Evaluator 在实现前先协商"完成标准"
- 避免因为规格高层模糊导致的实现偏差
- 两个 Agent 迭代直到达成一致

**评分维度**（前端设计示例）：
- Design Quality（设计质量）：是否是统一整体而非零件拼凑
- Originality（原创性）：是否有定制决策，还是默认模板
- Craft（工艺）：排版层级、间距一致性、色彩和谐
- Functionality（功能性）：用户能否理解并完成操作

**关键数据**：
- Solo run: 20分钟, $9 → 功能半成品，游戏不能玩
- Full harness: 6小时, $200 → 功能完整，可正常游戏
- 20x 成本差异，但质量天壤之别

### 2.3 Building Effective Agents (2024-12)

**核心原则**：
1. **保持简单**：最成功的实现不使用复杂框架，而是简单、可组合的模式
2. **按需增加复杂度**：先从简单 prompt 开始，只在必要时才添加 agent 系统
3. **透明性**：明确展示 agent 的规划步骤

**五种工作流模式**：
1. **Prompt Chaining**：将任务分解为步骤序列，每步有验证门
2. **Routing**：分类输入并路由到专门处理
3. **Parallelization**：分段并行 或 投票并行
4. **Orchestrator-Workers**：中心 LLM 动态分解并委派
5. **Evaluator-Optimizer**：一个生成，一个评估，循环迭代

**工具设计原则（ACI > HCI）**：
- 给模型足够的 token "思考"
- 格式接近模型训练数据中自然出现的格式
- 避免格式开销（如精确行数计算、字符串转义）
- Poka-yoke：通过参数设计让错误难以发生
- 测试模型如何使用工具，迭代优化

### 2.4 Effective Context Engineering for AI Agents (2025-09)

**核心约束**：上下文是有限资源，有边际递减效应
- Context Rot：随着 token 增加，模型准确回忆信息的能力下降
- 注意力预算：每个新 token 都在消耗这个预算
- n² 的注意力机制：上下文越长，关系捕获越稀薄

**最佳实践**：
1. **System Prompt**：找到"金发姑娘区间"——不太具体（脆弱），也不太模糊（缺乏指导）
2. **工具精简**：最小可行工具集，避免工具重叠和功能模糊
3. **Just-in-Time 检索**：维护轻量级标识符（文件路径、URL），运行时按需加载
4. **Progressive Disclosure**：让 Agent 通过探索逐步发现上下文
5. **混合策略**：部分预先加载 + 部分按需检索

### 2.5 Demystifying Evals for AI Agents (2026-01)

**评估类型**：
- **Capability Evals**："这个 Agent 能做什么？" → 低通过率起步，有提升空间
- **Regression Evals**："这个 Agent 还能做之前能做的吗？" → 接近100%通过率

**三种评分器**：
1. **Code-based**：字符串匹配、单元测试、静态分析 → 快、便宜、客观
2. **Model-based**：评分标准、自然语言断言、成对比较 → 灵活、可扩展
3. **Human**：专家审查、抽样检查 → 金标准

**核心洞察**：
- 能力评估高通过率的可以"毕业"为回归测试套件
- Agent 评估的是 harness + model 的组合，不是单独的模型
- Outcome（最终状态）比 Transcript（对话记录）更可靠

### 2.6 Writing Effective Tools for Agents (2025-09)

**工具设计流程**：
1. 快速原型 → 本地测试
2. 搭建评估（真实世界用例，非简化沙箱）
3. 用 Agent 分析结果并迭代优化

**关键原则**：
- 选择正确的工具实现（和不实现的）
- 工具命名空间定义清晰的功能边界
- 返回有意义的上下文给 Agent
- 优化工具响应的 token 效率
- Prompt Engineering 工具的描述和规格

### 2.7 Scaling Managed Agents (2026-04)

**脑手分离架构**：
- **Session**：不可变的事件日志，持久存储
- **Harness**：调用 Claude 并路由工具调用的循环（可重启、可替换）
- **Sandbox**：代码执行环境（可销毁、可重建）

**关键教训**：
- 不要养"宠物"（不可替代的容器），要养"牲口"（可替换的实例）
- 安全边界：凭证永远不要出现在沙箱中
- Session 不是 Context Window：Session 是完整的事件日志，可以从任意位置回放
- 多脑多手：一个 brain 可以连接多个 sandbox，按需创建

---

## 三、知识提炼：Harness Engineering 十大原则

1. **增量优先**：一次一个 feature，禁止 one-shot
2. **外部记忆**：用文件（JSON/progress log）而非上下文窗口保存状态
3. **独立验证**：实现和评估必须分离（Generator ≠ Evaluator）
4. **测试即验证**：给 Agent 真正可运行的测试工具，而非让它"自以为完成"
5. **Sprint Contract**：实现前先协商完成标准
6. **上下文是稀缺资源**：精简工具、精简 prompt、Just-in-Time 检索
7. **脑手分离**：Harness、Session、Sandbox 独立部署、独立替换
8. **安全纵深**：凭证与沙箱隔离，通过代理访问外部服务
9. **Eval 驱动**：先建 eval 再优化，能力评估 → 回归测试
10. **保持简单**：能用简单 prompt 解决的，不要用 agent 系统

---

## 四、已学习文章
- [x] How we contain Claude across products → 2026-06-08 笔记
- [x] Claude Code auto mode → 2026-06-08 笔记
- [x] Quantifying infrastructure noise → 2026-06-08 笔记
- [x] Designing AI-resistant technical evaluations → 2026-06-08 笔记
- [x] Equipping agents for the real world with Agent Skills → 2026-06-08 笔记
- [x] Advanced Tool Use → 2026-06-09 笔记
- [x] Code Execution with MCP → 2026-06-09 笔记
- [x] Multi-Agent Research System → 2026-06-09 笔记
- [x] Claude Code Best Practices → 2026-06-09 笔记
- [x] The "Think" Tool → 2026-06-09 笔记
- [x] Claude Code Sandboxing → 2026-06-09 笔记

### 待学习（尚未覆盖）
所有 Anthropic 工程博客文章已全部覆盖（截至 2026-06-16）。

---

## 五、参考链接
- [Anthropic Engineering Blog](https://www.anthropic.com/engineering)
- [Claude Agent SDK](https://platform.claude.com/docs/en/agent-sdk/overview)
- [Claude Code Best Practices](https://code.claude.com/docs/en/best-practices)
- [Autonomous Coding Quickstart](https://github.com/anthropics/claude-quickstarts/tree/main/autonomous-coding)
