<!-- gp-09-exempt: 这是任务卡参考目录（reference catalog），按 P-1→P5 顺序索引 32 张卡。
     不是 navigation 文件；按 phase 拆分会破坏 grep/搜索便利性。OpenAI 原则针对 AGENTS.md 类导航文件。 -->

# Harness-Engineering 任务卡清单（AI Coding 友好版）

> 使用方式：AI 每次只领取 1 张任务卡，完成后提交 PR，并附该卡的验收证据。
> 执行顺序：严格按优先级 `P-1 -> P0 -> P1 -> P2/P3 -> P4 -> P5`，并满足依赖关系。

## 0. 任务卡模板（统一格式）

```md
- Task ID:
- 标题:
- 优先级:
- 目标:
- Owner:
- 依赖:
- 输入上下文:
- 执行步骤:
- 命令:
- 产出物:
- 验收标准:
- 失败分支:
- 完成定义:
```

---

## P-1：实施前准备（Go/No-Go）

### CARD-P-1-01 试点项目与 RACI 冻结
- Task ID: `CARD-P-1-01`
- 标题: 冻结试点范围、责任矩阵与自治起点
- 优先级: `P-1`
- 目标: 保证实施前责任清晰、边界明确
- Owner: `EM + Tech Lead`
- 依赖: 无
- 输入上下文: 业务优先级、团队编制、风险等级初评
- 执行步骤:
1. 选定 1-2 个试点项目并定义边界
2. 明确 4-8 周实施周期
3. 冻结 RACI（Owner/Reviewer/Approver/Incident Commander）
4. 确定初始自治等级（L1/L2）及回退条件
- 命令:
```bash
mkdir -p docs/readiness
```
- 产出物:
- `docs/readiness/pilot-charter.md`
- `docs/readiness/raci-matrix.md`
- 验收标准:
- 项目章程、RACI、自治等级策略均已签字确认
- 失败分支:
- 若负责人或边界不明确，禁止进入 P0
- 完成定义:
- Go/No-Go 会议通过

### CARD-P-1-02 工程基础与权限模型验证
- Task ID: `CARD-P-1-02`
- 标题: 验证 CI 最小能力、权限模型、回滚演练
- 优先级: `P-1`
- 目标: 确保实施基础设施可用
- Owner: `DevEx + SRE`
- 依赖: `CARD-P-1-01`
- 输入上下文: 当前仓库权限与发布流程
- 执行步骤:
1. 验证 lint + test 在 CI 稳定通过
2. 确认合并权限与豁免权限
3. 完成一次发布 -> 回滚 -> 恢复演练
- 命令:
```bash
mkdir -p docs/readiness/evidence
```
- 产出物:
- `docs/readiness/ci-baseline-check.md`
- `docs/readiness/release-rollback-drill.md`
- 验收标准:
- 可证明在一次演练内完成回滚和服务恢复
- 失败分支:
- 演练失败必须先修复基础流程，再进入 P0
- 完成定义:
- 演练证据被审批人确认

### CARD-P-1-03 数据源与风险目录冻结
- Task ID: `CARD-P-1-03`
- 标题: 打通数据源并冻结高风险目录
- 优先级: `P-1`
- 目标: 为指标和风控提供可执行基线
- Owner: `DevEx + Security`
- 依赖: `CARD-P-1-02`
- 输入上下文: Git/CI/Issue 系统与代码目录结构
- 执行步骤:
1. 打通 Git/CI/Issue 指标数据源
2. 冻结高风险目录（权限、计费、生产配置、数据删除）
3. 产出首周自动周报样本
- 命令:
```bash
mkdir -p docs/readiness data/readiness
```
- 产出物:
- `docs/readiness/data-source-mapping.md`
- `docs/readiness/high-risk-scope.md`
- `data/readiness/weekly-baseline-sample.json`
- 验收标准:
- 指标可自动产出，且风险目录有 owner 与审批链
- 失败分支:
- 任一关键数据源不可用时，禁止进入 P0
- 完成定义:
- 首周基线周报可复现

### CARD-P-1-04 首轮执行包与节奏冻结
- Task ID: `CARD-P-1-04`
- 标题: 冻结首轮任务卡、证据格式、评审节奏
- 优先级: `P-1`
- 目标: 让 AI 可直接进入实施，无需额外解释会
- Owner: `EM + DevEx`
- 依赖: `CARD-P-1-03`
- 输入上下文: 主任务卡清单、项目日历
- 执行步骤:
1. 为首批 10-12 张卡填 owner 与截止日期
2. 固化 PR 证据格式（命令输出、验收证据、风险说明）
3. 冻结周会/月会/季度评审日历
- 命令:
```bash
mkdir -p docs/readiness/schedule
```
- 产出物:
- `docs/readiness/first-wave-task-assignment.md`
- `docs/readiness/pr-evidence-standard.md`
- `docs/readiness/operating-calendar.md`
- 验收标准:
- 首轮任务可直接分发执行，且评审周期固定
- 失败分支:
- 未填 owner 或截止日期的任务卡不得开始
- 完成定义:
- 首轮任务 kickoff 完成

### CARD-P-1-05 强化项与扩圈前门槛
- Task ID: `CARD-P-1-05`
- 标题: 完成实施强化项（AI 环境、模板校验、合规边界）
- 优先级: `P-1`
- 目标: 降低实施期风险，提升可扩展性
- Owner: `Security + Compliance + DevEx`
- 依赖: `CARD-P-1-04`
- 输入上下文: 当前 AI 工具链、模板、合规要求
- 执行步骤:
1. 标准化 AI 执行环境（模型、上下文来源、命令白名单）
2. 启用 Issue/PR 模板字段自动校验
3. 上线最小 eval 集（覆盖 1 条核心流程）
4. 完成值班与升级演练、法务/合规边界确认
- 命令:
```bash
mkdir -p docs/readiness/compliance
```
- 产出物:
- `docs/readiness/ai-runtime-standard.md`
- `docs/readiness/template-validation-rules.md`
- `docs/readiness/compliance-boundaries.md`
- 验收标准:
- 强化项完成率 >= 80%
- 失败分支:
- 强化项低于阈值时禁止大规模扩圈
- 完成定义:
- Readiness 审核报告完成

---

## P0（最高优先级）：自我进化硬机制

### CARD-P0-01 指标字典与阈值基线
- Task ID: `CARD-P0-01`
- 标题: 定义统一指标字典（DORA + SPACE + Eval）
- 优先级: `P0`
- 目标: 统一指标口径，避免后续统计冲突
- Owner: `Engineering Manager + DevEx`
- 依赖: 无
- 输入上下文: 当前主清单、团队现有交付流程
- 执行步骤:
1. 定义 DORA 字段与计算公式
2. 定义 SPACE 最小采样字段（满意度、协作效率、流效率）
3. 定义 Eval 字段（通过率、误报率、回归失败率）
4. 定义红黄绿阈值
- 命令:
```bash
mkdir -p docs/metrics
```
- 产出物:
- `docs/metrics/engineering-scorecard.md`
- 验收标准:
- 所有指标有公式、数据源、采样周期
- 阈值有明确数值，不允许“高/中/低”模糊描述
- 失败分支:
- 若无法统一口径，先冻结冲突指标，保留最小集（DORA + Eval）
- 完成定义:
- 文档评审通过并进入仓库主分支

### CARD-P0-02 指标采集管道落地
- Task ID: `CARD-P0-02`
- 标题: 建立自动采集脚本与看板输入
- 优先级: `P0`
- 目标: 指标不依赖人工填报
- Owner: `DevEx`
- 依赖: `CARD-P0-01`
- 输入上下文: 指标字典文档
- 执行步骤:
1. 定义数据源连接（Git/CI/Issue）
2. 实现每周汇总脚本
3. 输出统一 JSON/CSV
4. 接入可视化看板
- 命令:
```bash
mkdir -p scripts/metrics data/metrics
```
- 产出物:
- `scripts/metrics/collect_metrics.sh`
- `data/metrics/weekly-summary.json`
- 验收标准:
- 连续 2 周自动产出数据
- 手工修正比例 <= 5%
- 失败分支:
- 若某数据源不稳定，先做 fallback（前一周数据 + 异常标记）
- 完成定义:
- 看板可展示 4 周趋势图

### CARD-P0-03 周度指标运营节奏
- Task ID: `CARD-P0-03`
- 标题: 固化周会复盘机制
- 优先级: `P0`
- 目标: 指标驱动决策，不只做展示
- Owner: `EM`
- 依赖: `CARD-P0-02`
- 输入上下文: 周度指标结果
- 执行步骤:
1. 创建固定议程模板
2. 指定异常项 owner
3. 输出行动项与截止日期
- 命令:
```bash
mkdir -p docs/ops
```
- 产出物:
- `docs/ops/weekly-metrics-review-template.md`
- `docs/ops/action-items-log.md`
- 验收标准:
- 每周至少 1 个异常项被关闭或降级
- 失败分支:
- 若无行动项关闭，暂停新流程扩圈
- 完成定义:
- 连续 4 周稳定执行

### CARD-P0-04 失败事件分类标准
- Task ID: `CARD-P0-04`
- 标题: 建立失败事件 taxonomy
- 优先级: `P0`
- 目标: 统一“什么算失败”
- Owner: `SRE + Security`
- 依赖: 无
- 输入上下文: 当前事故/回滚记录
- 执行步骤:
1. 定义事件类型（回滚/事故/误改/越权/eval 失效）
2. 定义严重等级（SEV1-3）
3. 定义触发复盘阈值
- 命令:
```bash
mkdir -p docs/incidents
```
- 产出物:
- `docs/incidents/failure-taxonomy.md`
- 验收标准:
- 新事件可在 5 分钟内归类
- 失败分支:
- 若归类冲突，按更高 SEV 处理
- 完成定义:
- 通过 incident owner 评审

### CARD-P0-05 复盘模板与 SLA
- Task ID: `CARD-P0-05`
- 标题: 建立 24h/7d 复盘时限与模板
- 优先级: `P0`
- 目标: 确保失败被结构化反哺
- Owner: `SRE`
- 依赖: `CARD-P0-04`
- 输入上下文: 失败 taxonomy
- 执行步骤:
1. 写 postmortem 模板
2. 明确 24h 初判、7d 闭环字段
3. 增加必填“改进项类型”字段（测试/策略/规则）
- 命令:
```bash
true
```
- 产出物:
- `docs/incidents/postmortem-template.md`
- `docs/incidents/lessons-learned-log.md`
- 验收标准:
- 每个复盘至少含 1 个可执行改进项
- 失败分支:
- 未达到 SLA 自动升级到工程负责人
- 完成定义:
- 模板被真实事件使用 >= 3 次

### CARD-P0-06 复盘到规则自动流转
- Task ID: `CARD-P0-06`
- 标题: 建立“复盘 -> 任务卡 -> CI 规则”自动流
- 优先级: `P0`
- 目标: 防止复盘停留在文档层
- Owner: `DevEx`
- 依赖: `CARD-P0-05`
- 输入上下文: postmortem 模板
- 执行步骤:
1. 在复盘模板中新增任务卡引用字段
2. 定义改进项状态机（open/in-progress/done）
3. 每周校验未关闭改进项
- 命令:
```bash
mkdir -p docs/policies
```
- 产出物:
- `docs/policies/remediation-workflow.md`
- 验收标准:
- 复盘改进项关闭率 >= 80%（30 天内）
- 失败分支:
- 低于阈值时禁止提升自治等级
- 完成定义:
- 连续 2 个周期达标

### CARD-P0-07 CI 门禁最小闭环
- Task ID: `CARD-P0-07`
- 标题: 建立 test/lint/eval 的强制门禁
- 优先级: `P0`
- 目标: 口头规范全部可执行
- Owner: `DevEx`
- 依赖: `CARD-P0-01`
- 输入上下文: 指标阈值与流程要求
- 执行步骤:
1. 新建 CI 工作流骨架
2. 串联 lint/test/eval
3. 设定失败即阻断合并
- 命令:
```bash
mkdir -p .github/workflows
```
- 产出物:
- `.github/workflows/ci.yml`
- 验收标准:
- 关键分支无 bypass 合并
- 失败分支:
- 若 CI 误报 > 10%，48 小时内修正规则
- 完成定义:
- 连续 20 次 PR 门禁执行成功

### CARD-P0-08 Policy-as-Code 骨架
- Task ID: `CARD-P0-08`
- 标题: 建立策略目录与高风险拦截规则
- 优先级: `P0`
- 目标: 高风险改动自动拦截
- Owner: `Security + DevEx`
- 依赖: `CARD-P0-07`
- 输入上下文: 风险目录（权限/计费/生产配置）
- 执行步骤:
1. 创建策略目录
2. 编写最小规则：高风险文件变更需审批
3. 在 CI 引入策略检查
- 命令:
```bash
mkdir -p policy
```
- 产出物:
- `policy/README.md`
- `policy/high-risk-changes.rego`（或等价规则）
- 验收标准:
- 高风险改动被命中率 >= 95%
- 失败分支:
- 误拦截 > 15% 时立即迭代规则
- 完成定义:
- 至少 1 次真实拦截并正确处理

---

## P1：真相源与统一入口

### CARD-P1-01 基础文档框架
- Task ID: `CARD-P1-01`
- 标题: 建立 ARCHITECTURE/CONTRIBUTING/AGENTS
- 优先级: `P1`
- 目标: 让 AI 与人共享上下文
- Owner: `Tech Lead`
- 依赖: `CARD-P0-01`
- 输入上下文: 当前工程目标与边界
- 执行步骤:
1. 创建三份文档骨架
2. 填写 owner、模块边界、关键命令
3. 在 AGENTS 中指向所有规范文档
- 命令:
```bash
touch ARCHITECTURE.md CONTRIBUTING.md AGENTS.md
```
- 产出物:
- `ARCHITECTURE.md`
- `CONTRIBUTING.md`
- `AGENTS.md`
- 验收标准:
- 新 agent 可在 30 分钟内独立完成一次标准 PR
- 失败分支:
- 若无法完成，补齐缺失上下文再试
- 完成定义:
- 通过一次盲测 onboarding

### CARD-P1-02 ADR 流程
- Task ID: `CARD-P1-02`
- 标题: 建立 ADR 模板与索引
- 优先级: `P1`
- 目标: 关键决策可追溯
- Owner: `Tech Lead`
- 依赖: `CARD-P1-01`
- 输入上下文: 架构文档
- 执行步骤:
1. 建 ADR 模板
2. 建 ADR 索引页
3. 补录当前关键决策
- 命令:
```bash
mkdir -p docs/adr
```
- 产出物:
- `docs/adr/0000-template.md`
- `docs/adr/README.md`
- 验收标准:
- 新增高影响决策 ADR 覆盖率 100%
- 失败分支:
- 缺失 ADR 的变更不能进入发布候选
- 完成定义:
- 至少补录 3 条历史关键决策

### CARD-P1-03 统一命令入口
- Task ID: `CARD-P1-03`
- 标题: 建 Makefile/Taskfile 统一入口
- 优先级: `P1`
- 目标: 人和 AI 走同一执行面
- Owner: `DevEx`
- 依赖: `CARD-P0-07`
- 输入上下文: CI 任务定义
- 执行步骤:
1. 创建命令：`make lint/test/eval/verify`
2. 本地与 CI 复用同一命令
3. 输出标准化日志
- 命令:
```bash
touch Makefile
```
- 产出物:
- `Makefile`
- `docs/runbooks/dev-workflow.md`
- 验收标准:
- 90% 以上 PR 使用统一命令产出验证证据
- 失败分支:
- 若命令漂移，本地流程回收至 CI 基线
- 完成定义:
- 通过 10 次 PR 抽检

### CARD-P1-04 模板化输入输出
- Task ID: `CARD-P1-04`
- 标题: 建 Issue/PR 模板
- 优先级: `P1`
- 目标: 提高 AI 任务输入质量与可审计性
- Owner: `EM`
- 依赖: `CARD-P1-01`
- 输入上下文: 验收标准与风险策略
- 执行步骤:
1. 创建 issue 模板
2. 创建 PR 模板
3. 增加必填字段校验
- 命令:
```bash
mkdir -p .github/ISSUE_TEMPLATE .github
```
- 产出物:
- `.github/ISSUE_TEMPLATE/task.yml`
- `.github/pull_request_template.md`
- 验收标准:
- 模板字段完整率 >= 95%
- 失败分支:
- 字段不完整自动阻断合并
- 完成定义:
- 连续 2 周达标

---

## P2：质量、安全、供应链

### CARD-P2-01 测试金字塔基线
- Task ID: `CARD-P2-01`
- 标题: 定义并落地 unit/integration/e2e 比例目标
- 优先级: `P2`
- 目标: 保证质量成本平衡
- Owner: `QA Lead`
- 依赖: `CARD-P1-03`
- 输入上下文: 当前测试状况
- 执行步骤:
1. 定义测试层级比例
2. 配置覆盖率阈值
3. 纳入 CI 报告
- 命令:
```bash
mkdir -p docs/testing
```
- 产出物:
- `docs/testing/test-strategy.md`
- 验收标准:
- 高风险模块覆盖率高于全局阈值
- 失败分支:
- 覆盖率下降触发阻断或豁免审批
- 完成定义:
- 连续 3 个迭代满足阈值

### CARD-P2-02 Eval 套件落地
- Task ID: `CARD-P2-02`
- 标题: 建立任务级 eval 数据集与评分器
- 优先级: `P2`
- 目标: AI 产出质量可回归验证
- Owner: `AI Engineer`
- 依赖: `CARD-P0-01`, `CARD-P1-03`
- 输入上下文: 核心任务类型清单
- 执行步骤:
1. 建立核心任务数据集
2. 定义评分器与通过阈值
3. 接入 CI 每次变更执行
- 命令:
```bash
mkdir -p evals
```
- 产出物:
- `evals/README.md`
- `evals/datasets/`
- `evals/scorers/`
- 验收标准:
- 核心任务 eval 通过率达到基线并可回归
- 失败分支:
- eval 波动超过阈值自动降级自治等级
- 完成定义:
- 连续 4 周稳定运行

### CARD-P2-03 OWASP LLM Top10 映射
- Task ID: `CARD-P2-03`
- 标题: 将 LLM 风险映射为检查与测试项
- 优先级: `P2`
- 目标: GenAI 风险前置
- Owner: `Security`
- 依赖: `CARD-P2-02`
- 输入上下文: 现有安全策略
- 执行步骤:
1. 建风险-控制映射表
2. 对每项控制指定测试方式
3. 接入发布前安全 eval
- 命令:
```bash
mkdir -p docs/security
```
- 产出物:
- `docs/security/llm-risk-control-mapping.md`
- 验收标准:
- 发布前关键风险测试通过率 100%
- 失败分支:
- 任一关键项失败即阻断发布
- 完成定义:
- 至少覆盖注入、泄露、工具滥用三大类

### CARD-P2-04 SBOM 与 provenance
- Task ID: `CARD-P2-04`
- 标题: 建立依赖清单与构建来源证明
- 优先级: `P2`
- 目标: 供应链可追溯
- Owner: `DevSecOps`
- 依赖: `CARD-P0-07`
- 输入上下文: 当前构建流程
- 执行步骤:
1. 构建时生成 SBOM
2. 保存 provenance 元数据
3. 产物与提交 hash 绑定
- 命令:
```bash
mkdir -p artifacts/sbom artifacts/provenance
```
- 产出物:
- `docs/security/supply-chain-baseline.md`
- 验收标准:
- 关键构建可追溯到源码和依赖版本
- 失败分支:
- 追溯失败的构建不得发布
- 完成定义:
- 连续 1 个版本周期无缺失

---

## P3：可靠性与风险治理

### CARD-P3-01 SLO 定义
- Task ID: `CARD-P3-01`
- 标题: 为关键服务定义 SLO/SLI
- 优先级: `P3`
- 目标: 稳定性目标可计算
- Owner: `SRE`
- 依赖: `CARD-P0-02`
- 输入上下文: 服务目录、历史故障数据
- 执行步骤:
1. 确定关键用户旅程
2. 定义可观测 SLI
3. 设定 SLO 与误差预算
- 命令:
```bash
mkdir -p docs/sre
```
- 产出物:
- `docs/sre/slo-catalog.md`
- 验收标准:
- 关键服务 SLO 覆盖率 100%
- 失败分支:
- 缺少 SLO 的服务禁止进入自动发布队列
- 完成定义:
- 通过业务与技术双评审

### CARD-P3-02 Error Budget 策略
- Task ID: `CARD-P3-02`
- 标题: 预算耗尽触发冻结策略
- 优先级: `P3`
- 目标: 速度与稳定性冲突时有硬规则
- Owner: `SRE + EM`
- 依赖: `CARD-P3-01`
- 输入上下文: SLO 目录
- 执行步骤:
1. 定义 budget 消耗阈值
2. 定义冻结范围与豁免条件
3. 写入发布策略文档
- 命令:
```bash
true
```
- 产出物:
- `docs/sre/error-budget-policy.md`
- 验收标准:
- 预算耗尽事件均触发预定义动作
- 失败分支:
- 未执行冻结需记录豁免审批链
- 完成定义:
- 至少演练 1 次冻结流程

### CARD-P3-03 渐进发布流水线
- Task ID: `CARD-P3-03`
- 标题: 建 canary/staged rollout 流程
- 优先级: `P3`
- 目标: 降低发布爆炸半径
- Owner: `Release Engineer`
- 依赖: `CARD-P3-01`, `CARD-P3-02`
- 输入上下文: 现有发布脚本
- 执行步骤:
1. 增加分阶段流量切换
2. 定义阶段观测指标
3. 失败触发自动回滚
- 命令:
```bash
mkdir -p docs/release
```
- 产出物:
- `docs/release/progressive-delivery.md`
- 验收标准:
- 高风险发布 100% 走渐进流程
- 失败分支:
- 阶段指标异常自动回滚并开 incident
- 完成定义:
- 至少完成 2 次演练发布

### CARD-P3-04 AI 风险治理（NIST AI RMF）
- Task ID: `CARD-P3-04`
- 标题: 落地 Govern/Map/Measure/Manage
- 优先级: `P3`
- 目标: AI 风险治理结构化
- Owner: `Risk Owner`
- 依赖: `CARD-P2-03`
- 输入上下文: 安全风险映射、评测结果
- 执行步骤:
1. 明确治理角色与责任
2. 建场景风险地图
3. 建风险度量与处置流程
- 命令:
```bash
mkdir -p docs/risk
```
- 产出物:
- `docs/risk/ai-rmf-operating-model.md`
- 验收标准:
- 高风险场景均有对应控制与负责人
- 失败分支:
- 无 owner 风险项禁止上线
- 完成定义:
- 完成季度治理评审一次

---

## P4：扩圈与平台化

### CARD-P4-01 Pilot 扩圈门槛
- Task ID: `CARD-P4-01`
- 标题: 定义扩圈准入标准
- 优先级: `P4`
- 目标: 防止扩圈导致质量回撤
- Owner: `EM`
- 依赖: `CARD-P0-03`, `CARD-P2-02`, `CARD-P3-03`
- 输入上下文: 最近 4 周指标
- 执行步骤:
1. 定义扩圈门槛（速度、质量、稳定性）
2. 定义不达标降级动作
3. 输出扩圈审批模板
- 命令:
```bash
mkdir -p docs/scaling
```
- 产出物:
- `docs/scaling/pilot-expansion-gates.md`
- 验收标准:
- 新团队扩圈前均通过 gate
- 失败分支:
- 未达标保持在当前自治等级
- 完成定义:
- 完成首轮扩圈并复盘

### CARD-P4-02 Golden Path 脚手架
- Task ID: `CARD-P4-02`
- 标题: 建立新服务标准脚手架
- 优先级: `P4`
- 目标: 让新项目默认继承最佳实践
- Owner: `Platform Team`
- 依赖: `CARD-P1-03`, `CARD-P2-01`, `CARD-P2-04`
- 输入上下文: 统一命令、门禁、安全基线
- 执行步骤:
1. 建标准模板仓库
2. 默认集成 lint/test/eval/security
3. 提供服务接入指南
- 命令:
```bash
mkdir -p templates/service-starter
```
- 产出物:
- `templates/service-starter/`
- `docs/scaling/golden-path.md`
- 验收标准:
- 新服务接入时间较基线下降 >= 30%
- 失败分支:
- 未达到目标时迭代模板并复测
- 完成定义:
- 至少 2 个新服务采用模板

### CARD-P4-03 周月季运营机制
- Task ID: `CARD-P4-03`
- 标题: 固化周/月/季度治理节奏
- 优先级: `P4`
- 目标: 保证体系持续更新
- Owner: `EM + DevEx + SRE`
- 依赖: `CARD-P0-03`, `CARD-P0-06`
- 输入上下文: 指标看板、复盘日志、策略变更记录
- 执行步骤:
1. 周会复盘指标与异常
2. 月会复盘流程债与误报
3. 季度审计策略有效性
- 命令:
```bash
true
```
- 产出物:
- `docs/ops/operating-cadence.md`
- 验收标准:
- 每个周期输出改进清单并跟踪关闭率
- 失败分支:
- 连续两个周期关闭率 < 70% 时触发专项整治
- 完成定义:
- 连续 1 个季度运行稳定

---

## P5：长期成熟度与规模化优化

### CARD-P5-01 跨项目资产复用库
- Task ID: `CARD-P5-01`
- 标题: 建立跨项目可复用资产库
- 优先级: `P5`
- 目标: 减少重复建设，提升新项目接入效率
- Owner: `Platform Team + DevEx`
- 依赖: `CARD-P4-02`
- 输入上下文: 现有模板、策略、eval、发布流程文档
- 执行步骤:
1. 盘点可复用资产（模板/策略/eval/任务卡）
2. 建立统一目录与版本规范
3. 建变更日志和使用说明
4. 建立复用率统计机制
- 命令:
```bash
mkdir -p assets-library/{templates,policy,evals,runbooks}
```
- 产出物:
- `assets-library/README.md`
- `assets-library/CHANGELOG.md`
- `docs/scaling/reuse-metrics.md`
- 验收标准:
- 新项目接入时可直接复用资产比例 >= 70%
- 失败分支:
- 复用率低于阈值时，新增“资产标准化”整改卡
- 完成定义:
- 至少 2 个项目完成复用并记录结果

### CARD-P5-02 误报率与规则成本优化
- Task ID: `CARD-P5-02`
- 标题: 建立门禁误报与执行成本优化机制
- 优先级: `P5`
- 目标: 提升规则质量，避免流程过重
- Owner: `DevEx + Security`
- 依赖: `CARD-P0-07`, `CARD-P0-08`, `CARD-P2-02`
- 输入上下文: CI 日志、策略命中记录、eval 结果
- 执行步骤:
1. 定义误报率与流水线耗时指标
2. 对规则进行分级（阻断/告警/观察）
3. 月度执行降噪与性能优化
4. 输出规则优化报告
- 命令:
```bash
mkdir -p docs/ops/rule-quality
```
- 产出物:
- `docs/ops/rule-quality/rule-quality-metrics.md`
- `docs/ops/rule-quality/monthly-tuning-report.md`
- 验收标准:
- 关键门禁误报率逐季下降
- 平均流水线时长维持在目标阈值内
- 失败分支:
- 若误报率上升且超过阈值，暂停新增阻断规则
- 完成定义:
- 连续 2 个周期达到优化目标

### CARD-P5-03 人机协作组织能力建设
- Task ID: `CARD-P5-03`
- 标题: 建立人机协作角色矩阵与升级流程
- 优先级: `P5`
- 目标: 避免对少数专家依赖，提升组织韧性
- Owner: `EM + Tech Lead + SRE`
- 依赖: `CARD-P4-03`
- 输入上下文: 当前审批链、值班机制、培训材料
- 执行步骤:
1. 定义角色矩阵（Owner/Reviewer/Approver/Incident Commander）
2. 定义值班与升级路径（含 AI 执行失败升级）
3. 建立 onboarding 与认证清单
4. 建立季度演练计划
- 命令:
```bash
mkdir -p docs/org
```
- 产出物:
- `docs/org/human-ai-roles-matrix.md`
- `docs/org/escalation-runbook.md`
- `docs/org/onboarding-certification.md`
- 验收标准:
- 关键审批链满足 SLA
- 团队交接不因单点人员造成阻塞
- 失败分支:
- 若审批超时率超阈值，升级审批链优化专项
- 完成定义:
- 完成至少 1 次跨团队演练并通过复盘

### CARD-P5-04 高自治等级稳定性验证
- Task ID: `CARD-P5-04`
- 标题: 建立 L3/L4 持续稳定性验证与回退评估
- 优先级: `P5`
- 目标: 在高自治下保持质量与稳定性
- Owner: `EM + Risk Owner + SRE`
- 依赖: `CARD-P3-04`, `CARD-P4-01`
- 输入上下文: 自治等级规则、近 8-12 周指标数据
- 执行步骤:
1. 定义 L3/L4 稳定性验证窗口（8-12 周）
2. 记录升级/回退触发事件与根因
3. 建自治等级健康报告模板
4. 季度评审升级与回退策略
- 命令:
```bash
mkdir -p docs/autonomy
```
- 产出物:
- `docs/autonomy/l3-l4-validation-plan.md`
- `docs/autonomy/autonomy-health-report-template.md`
- 验收标准:
- 高自治等级下 CFR、MTTR、eval 不劣化
- 回退触发率处于可控区间并可解释
- 失败分支:
- 指标劣化时自动回退并冻结进一步放权
- 完成定义:
- 至少完成 1 个完整验证窗口并出报告

---

## AI 执行约束（必须）
- [ ] 一次只做一张任务卡，不允许跨卡混改
- [ ] 每张卡必须有单独 PR，PR 标题包含 Task ID
- [ ] PR 必须附“命令输出 + 验收证据 + 风险说明”
- [ ] 若依赖卡未完成，当前卡禁止开始
- [ ] 任一验收项不达标，自动回到失败分支，不得强行合并
- [ ] 每次状态变化必须回写 `docs/status/harness-execution-status.md`
- [ ] 若上下文不足或会话中断，必须先写 `docs/handoff/context-handoff.md` 再移交

## 实施启动顺序（P-1，5 张）
1. `CARD-P-1-01`
2. `CARD-P-1-02`
3. `CARD-P-1-03`
4. `CARD-P-1-04`
5. `CARD-P-1-05`

## 建议的首批执行顺序（P0+，12 张）
1. `CARD-P0-01`
2. `CARD-P0-02`
3. `CARD-P0-04`
4. `CARD-P0-05`
5. `CARD-P0-07`
6. `CARD-P0-08`
7. `CARD-P1-01`
8. `CARD-P1-03`
9. `CARD-P1-04`
10. `CARD-P2-02`
11. `CARD-P3-01`
12. `CARD-P3-03`

## P5 启动顺序（成熟期）
1. `CARD-P5-01`
2. `CARD-P5-02`
3. `CARD-P5-03`
4. `CARD-P5-04`
