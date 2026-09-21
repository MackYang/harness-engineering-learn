# Böckeler — Harness Engineering for Coding Agent Users（深度笔记）

> 来源：https://martinfowler.com/articles/exploring-gen-ai/harness-engineering.html
> （现已重定向至 https://martinfowler.com/articles/harness-engineering.html）
> 作者：Birgitta Böckeler（Martin Fowler / Thoughtworks）
> 学习日期：2026-09-21
> 性质：**补充参考精读**（非三大权威来源，但为 Addy Osmani 在 Agent Harness Engineering 一文中背书的用户侧综述，系 2026-09-14 笔记预留的跟进项）

---

## 一、定位与核心贡献

- Addy 文中评价："a good overview of what this looks like from the user's side"
- 与其他来源的分工：
  - Viv Trivedy → 概念推导（Agent = Model + Harness）
  - Anthropic → 长任务 harness 设计细节
  - OpenAI → 全代理生成仓库的一线实践
  - **Böckeler → 使用者视角的控制系统工程**：把 harness 拆成可分类、可排布、可评估的"控制器体系"
- 核心动作：把极宽的 harness 定义收窄到"编码代理用户"的有界上下文（bounded context），区分**内置 harness**（系统提示词、检索机制、编排系统）与用户自建的 **outer harness**

## 二、Outer Harness 的两个目标

1. **前馈**：提高代理第一次就做对的概率
2. **反馈**：在人眼看到之前尽可能自愈，最终降低 review 负担、提高质量、减少浪费的 token

## 三、Feedforward / Feedback（方向维度）

- **Guides（前馈控制）**：预判代理行为，在其行动前施加引导
- **Sensors（反馈控制）**：代理行动后观察结果，帮助自愈
- **关键洞察——正向 prompt injection**：反馈信号应为 LLM 消费优化，例如自定义 linter 的报错信息中直接嵌入自愈指令。与 OpenAI 文中"定制 lint 错误信息注入修复指令"完全同构，两大来源互证
- **单侧失衡的不对称性**：
  - 只有反馈 → 代理不断重复同样错误（规则从未前置）
  - 只有前馈 → 规则被编码但永远不知道有没有生效

## 四、Computational / Inferential（执行维度）

- **Computational**：确定性、CPU、毫秒~秒级、可靠（测试、linter、类型检查、结构分析）
- **Inferential**：语义判断、GPU/NPU、慢且贵、非确定（AI code review、LLM-as-judge）
- **2×2 矩阵示例**：

| 控制 | 方向 | 执行类型 | 实现 |
|------|------|----------|------|
| 编码约定 | 前馈 | Inferential | AGENTS.md、Skills |
| 项目引导说明 | 前馈 | Both | Skill 说明 + 引导脚本 |
| Code mods | 前馈 | Computational | OpenRewrite recipes |
| 结构测试 | 反馈 | Computational | ArchUnit 边界检查 hook |
| Review 指南 | 反馈 | Inferential | Skills |

## 五、Steering Loop（人的角色）

- 人的工作 = **通过迭代 harness 来驾驶代理**；同一问题重复出现 → 改进前馈/反馈控制使其不再发生
- 可用 AI 改进 harness 本身：让代理写结构测试、从观察到的模式生成规则草稿、脚手架自定义 linter、从代码库考古生成 how-to 指南
- 与 Addy "Loop Engineering" 呼应：人类杠杆点上移到控制面

## 六、Timing：Keep Quality Left

把 left-shift 应用到两类传感器，按成本/速度/关键性分布在交付生命周期：

1. **提交前/集成前**：linter、快速测试套件、轻量 review agent
2. **集成后 pipeline**：变异测试、能看全局的更广 review
3. **变更生命周期之外的持续传感器**（漂移与健康监测）：死代码检测、测试覆盖质量分析、依赖扫描、运行时 SLO 退化监测、AI judge 持续抽样响应质量并标记日志异常

## 七、三类 Regulation Categories（调节对象维度）

> Harness 是一个**控制论调节器**（cybernetic governor），组合前馈+反馈把代码库调节到期望状态。按调节对象分三类：

### 7.1 Maintainability Harness
- 当前最容易建的一类（既有工具最丰富）
- **失败模式映射**（关键洞察）：
  - Computational sensors 可靠捕获：重复代码、圈复杂度、覆盖缺失、架构漂移、风格违规
  - LLM 部分捕获（贵、概率性）：语义重复、冗余测试、暴力修复、过度设计
  - **两类都不可靠捕获**：误诊问题、过度工程/不必要功能、误解指令
  - **正确性超出任何传感器的职责范围——如果人一开始没说清楚想要什么**

### 7.2 Architecture Fitness Harness
- 即 Fitness Functions 思路：定义并检查架构特性
- 例：性能需求做成 Skills（前馈）+ 性能测试反馈改善/退化；可观测性编码规范（日志标准）+ 让代理反思"手头日志质量"的调试指令

### 7.3 Behaviour Harness
- **房间里的大象**：功能行为如何引导与感知？
- 现状实践：前馈=功能规格（细节不一）；反馈=AI 生成测试全绿+覆盖率+变异测试+手工测试
- 对 AI 生成测试的信任过重，**尚不够好**；同事用 **approved fixtures** 模式见到效果，但只适合选择性应用，非整体答案

## 八、Harnessability（可 harness 性）

- 代码库被 harness 的能力不均：强类型→类型检查传感器；清晰模块边界→架构约束规则；Spring 类框架→抽象掉代理无需关心的细节
- **Greenfield vs Legacy 悖论**：greenfield 可以从第一天把 harnessability 烤进去；legacy（尤其技术债重的）面临更难的题——**harness 最需要的地方恰恰最难建**

## 九、Harness Templates

- 企业 80% 需求由少数服务拓扑覆盖（API 服务、事件处理、数据看板），成熟组织已固化为 service templates
- 演进方向：**harness templates** = 一捆 guides+sensors，把代理拴在拓扑的结构/约定/技术栈上；团队选型时可能部分基于"harness 是否现成"
- 会复刻 service templates 的版本漂移问题，且非确定组件使测试更难

## 十、Role of the Human

- 人是每个代码库的**隐性 harness**：内化的约定与好实践、对 300 行函数的"审美恶心"、"我们这儿不这么干"的直觉、组织记忆（哪些技术债是业务原因容忍的）、知道哪个约定是承重墙哪个只是习惯、社会性问责（commit 上有你的名字）
- 代理全都没有：无社会问责、无审美厌恶、无组织记忆
- Harness 的本质：**把人的经验外显化**，但只能走到这里
- **目标修正：好 harness 不追求消灭人类输入，而是把人类输入引导到最重要的地方**

## 十一、开放问题（全文最有前瞻价值的部分）

1. Harness 长大后如何保持一致（guides 与 sensors 互不矛盾）？
2. 指令与反馈信号冲突时，能信任代理做合理权衡到什么程度？
3. **传感器从不触发，是质量高还是检测不足？**
4. 需要**harness 覆盖率/质量度量**——类比代码覆盖率和变异测试对测试的意义
5. 前馈/反馈控制散落在交付各环节，需要工具把配置、同步、推理整合为系统
6. 外层 harness 是持续的工程实践，不是一次性配置

## 十二、文中补充参考

- **Stripe Minions**（https://stripe.dev/blog/minions-stripes-one-shot-end-to-end-coding-agents）：pre-push hooks 按启发式跑相关 linter；强调 shift feedback left；"blueprints" 把反馈传感器集成进代理工作流
- Thoughtworks 内部实践：computational+inferential 传感器治理架构漂移（agent+自定义 linter 提升 API 质量；"janitor army" 提升代码质量）
- 变异测试与结构测试作为 computation 反馈传感器正在复兴；LSP/代码智能作为 computation 前馈 guide 的讨论增多

## 十三、与其他来源的交叉验证

| Böckeler 概念 | 其他来源同构概念 |
|---------------|------------------|
| 正向 prompt injection（linter 信息嵌自愈指令） | OpenAI：定制 lint 错误信息注入修复指令 |
| Computational/Inferential 分维 | Anthropic/Addy：Hooks 确定性执行 vs LLM-as-judge |
| 三类调节对象 | OpenAI：taste invariants + 架构 linter（属 Maintainability+Architecture 类）；Behaviour 类是全行业短板 |
| Steering loop（人迭代 harness） | Addy：Ratchet 原则；Loop Engineering |
| sensors-never-fire 歧义 | 新增独立洞察，既往笔记未覆盖 |

## 十四、可执行 takeaway（落入本项目）

1. feature_list 新增 FEAT-066~069（控制分类矩阵、正向注入传感器、harness 覆盖度量开放问题、behaviour harness 缺口）
2. 后续若扩展 scripts/ci/，可把 lint/test 输出改造为"含自愈指令的 LLM 优化信号"
3. 知识导航（README）新增 Böckeler 入口，标注为"用户侧综述"补充参考
