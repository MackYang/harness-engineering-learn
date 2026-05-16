# Harness-Engineering 项目落地使用说明（Playbook）

> 目的：指导团队把 `docs/harness-engineering-task-cards.md` 应用到具体业务项目，实现长期可控的 AI Coding。

## 1. 适用范围

适合直接接入的项目：
- 需求边界清晰、验收标准可量化的功能开发
- 有基础 CI 能力的服务（至少可执行 test/lint）
- 对交付节奏有持续要求的业务线

需要降级接入（先 L1/L2）的项目：
- 强监管场景（金融核心交易、医疗诊疗决策、隐私高敏项目）
- 遗留系统严重缺乏测试与文档
- 高度探索型需求（需求频繁变化、目标不可量化）

不建议直接全自动接入的工作：
- 跨组织战略决策
- 法务条款与合规解释
- 高风险架构路线选择

## 2. 项目接入标准流程（Project Onboarding Flow）

### 阶段 0：实施准备（Go/No-Go，1 周）
1. 执行 `CARD-P-1-01` 到 `CARD-P-1-05`。
2. 完成试点范围、RACI、自治等级与回退条件冻结。
3. 完成 CI 基线、权限模型、发布回滚演练。
4. 完成数据源打通与高风险目录冻结。
5. 完成首轮任务分配与评审节奏冻结。

Go/No-Go 条件（全部满足才可进入阶段 A）：
- 有签字确认的试点章程与 RACI。
- 能证明发布 -> 回滚 -> 恢复演练成功。
- 首周基线指标可自动产出。
- 首轮任务卡 owner 与截止日期完整。

### 阶段 A：项目准入评估（1-2 天）
1. 确认项目 owner、技术 owner、风险 owner。
2. 判定项目风险级别：`Low / Medium / High`。
3. 评估基础条件：
- 是否有 CI
- 是否有最小测试集
- 是否有发布/回滚路径
4. 决定初始自治等级：`L1` 或 `L2`（默认从低等级开始）。

准入门槛：
- 有明确验收标准
- 有可执行测试命令
- 有失败回滚路径

### 阶段 B：接入 P0 硬机制（2-5 天）
按任务卡优先执行：
1. `CARD-P0-01` 指标字典
2. `CARD-P0-02` 自动采集
3. `CARD-P0-04` 失败 taxonomy
4. `CARD-P0-05` 复盘 SLA
5. `CARD-P0-07` CI 门禁
6. `CARD-P0-08` Policy-as-Code

通过条件：
- 指标自动采集
- 失败能复盘并生成改进任务
- 门禁不可绕过

### 阶段 C：接入项目执行面（3-7 天）
1. 执行 `CARD-P1-01`：建立 `ARCHITECTURE.md`、`CONTRIBUTING.md`、`AGENTS.md`。
2. 执行 `CARD-P1-03`：统一命令入口（`make lint/test/eval/verify`）。
3. 执行 `CARD-P1-04`：Issue/PR 模板上线。

通过条件：
- 新任务可以只靠仓库文档被 AI 正确执行
- PR 模板字段完整率 >= 95%

### 阶段 D：质量与可靠性增强（持续迭代）
1. 执行 `CARD-P2-02` 建立 eval。
2. 执行 `CARD-P3-01` 和 `CARD-P3-03` 建立 SLO + 渐进发布。
3. 结合业务风险补齐 P2/P3 其他卡。

通过条件：
- eval 稳定
- 发布具备观测与自动回滚能力

## 3. 业务需求如何映射到任务卡

### 输入（业务侧给到工程侧）
每个需求必须包含：
- 业务目标（收益或效率目标）
- 影响范围（模块/服务/用户）
- 验收标准（数字化）
- 风险等级
- 截止时间

### 映射规则
1. 先把需求拆为“治理卡”和“功能卡”。
- 治理卡：来自本 playbook 和主任务卡（P-1-P5）
- 功能卡：具体业务实现任务
2. 每个功能卡必须绑定：
- 1 个 eval 验收项
- 1 个发布策略（普通或渐进）
- 1 个失败回滚策略
3. 高风险功能必须增加策略卡（policy/eval/security）。

## 4. AI 执行协议（单项目）

### 基本协议
1. 一次只执行一张卡。
2. 一张卡一个 PR。
3. PR 标题必须带 Task ID。
4. PR 必须附：
- 执行命令输出
- 验收证据
- 风险说明
- 回滚说明
5. 每次任务状态变化，必须更新 `docs/status/harness-execution-status.md`。
6. 若上下文不够或任务阻塞，必须先更新 `docs/handoff/context-handoff.md` 再结束当前会话。

### 禁止行为
- 跳过依赖卡直接执行后续卡
- 验收未通过强行合并
- 无日志证据声明“完成”

### 人类审批点（必须）
- 涉及权限、计费、数据删除、生产配置变更
- 策略规则新增/放宽
- 预算耗尽后的发布豁免

## 5. 自治等级在业务项目中的应用

### L1（建议模式）
- AI 产出代码与测试建议
- 人工主导评审与发布
- 适用：新接入项目、遗留系统

升级到 L2 条件：
- 连续 2 周：eval 达标、无重大回滚、PR 模板完整率 >= 95%

### L2（半自动执行）
- AI 可独立提交标准卡 PR
- 人工做关键审批
- 适用：中低风险功能迭代

升级到 L3 条件：
- 连续 4 周：DORA 改善且 CFR 不上升，复盘闭环率 >= 80%

### L3（受控自动）
- AI 可自动合并低风险变更（门禁全绿）
- 高风险仍需人工审批

回退到 L2 条件：
- 连续 2 次发布触发回滚
- eval 波动超过阈值

### L4（边界内高自动）
- 仅在成熟、低风险、规则完备项目启用
- 默认仍保留人工紧急刹车

## 6. 三类业务场景示例

### 场景 A：新功能（中风险）
1. 业务提交需求模板。
2. 工程拆卡：功能卡 + eval 卡 + 发布卡。
3. AI 按依赖顺序执行并提交 PR。
4. 走渐进发布，观察指标后全量。

### 场景 B：线上缺陷修复（高优先）
1. 创建故障卡并标注 SEV。
2. AI 先修复 + 最小回归测试。
3. 人工审批发布。
4. 24h 初判、7 天复盘并反哺规则。

### 场景 C：模块重构（中高风险）
1. 先补测试与 eval 基线。
2. 分批小步改造，每批可回滚。
3. 指标异常立即停止并回退。

## 7. 发布与故障处理流程

发布前：
- test/lint/eval/security/policy 全绿
- 风险等级与发布策略匹配

发布中：
- 采用 staged/canary
- 监控关键 SLI

发布后：
- 观测窗口内检查业务 KPI 与技术指标
- 异常触发自动回滚

故障后：
- 24h 初判
- 7 天内复盘闭环
- 必须形成测试/策略/规则中的至少一项改进

## 8. 指标映射（业务 KPI -> 工程指标）

映射示例：
- 业务“上线速度” -> DORA Lead Time / Deploy Frequency
- 业务“稳定性” -> CFR / MTTR / SLO 达成率
- 业务“功能正确率” -> Eval 通过率 / 回归失败率
- 业务“团队效率” -> SPACE 流效率与协作指标

要求：
- 每个业务项目至少绑定 2 个业务 KPI 与 4 个工程指标

## 9. 项目级完成定义（Project DoD）

满足以下条件可视为项目接入成功：
- P0 全部完成并稳定运行
- P1 核心项完成（文档、命令、模板）
- 至少 1 个核心业务流程具备 eval + 渐进发布 + 回滚
- 连续 4 周：同类问题复发率下降，人工 review 负载下降，CFR 不上升

## 10. 建议落地节奏（前 10 周）

- 第 0 周：完成 P-1（实施准备 Go/No-Go）
- 第 1-2 周：完成 P0（至少 80%）
- 第 3-4 周：完成 P1 并试跑 3-5 个真实需求
- 第 5-6 周：补齐 P2 核心（eval + 安全映射）
- 第 7-8 周：补齐 P3 核心（SLO + 渐进发布）并决定是否扩圈
- 第 9-10 周：执行 P4 首轮扩圈评估

## 11. 成熟期运营（第 9 周起，持续执行）

### 11.1 跨项目复用资产库（对应 `CARD-P5-01`）
- 触发时机：至少 2 个业务项目完成 P1-P3 后
- 执行动作：
- 统一沉淀模板、策略、eval 数据集、发布 runbook
- 建资产版本管理和变更日志
- 项目接入时优先复用，不重复造轮子
- 目标指标：新项目资产复用率 >= 70%

### 11.2 误报率与规则成本优化（对应 `CARD-P5-02`）
- 触发时机：门禁规则数量明显增长或流水线耗时上升
- 执行动作：
- 建误报率、耗时、阻断价值三项指标
- 规则分级为“阻断/告警/观察”
- 每月执行一次规则降噪与性能优化
- 目标指标：误报率逐季下降，流水线时长稳定

### 11.3 人机协作组织能力（对应 `CARD-P5-03`）
- 触发时机：团队扩圈或跨团队协作增多
- 执行动作：
- 固化角色矩阵与审批 SLA
- 建 AI 失败升级路径和值班机制
- 建新人 onboarding 与认证清单
- 目标指标：关键审批链按 SLA 完成，交接不依赖单点专家

### 11.4 L3/L4 稳定性验证周期（对应 `CARD-P5-04`）
- 触发时机：项目准备从 L2 升级到 L3/L4
- 执行动作：
- 设 8-12 周验证窗口
- 跟踪升级/回退事件与根因
- 季度输出自治等级健康报告
- 回退规则：CFR、MTTR、eval 任一指标持续劣化即自动回退

## 12. 长周期完成定义（Maturity DoD）

- P5 四项机制均已落地并运行至少一个季度
- 跨项目复用率逐季提升
- 关键门禁误报率与执行成本逐季优化
- L3/L4 项目具备可解释的升级/回退闭环
- 组织层面的角色、值班、升级机制稳定运行

## 13. 如何把当前成果应用到具体项目（实操指南）

本节默认你已经有一个目标业务仓库（记为 `<TARGET_REPO>`），目标是在 1-2 周内把当前 Harness-Engineering 成果接入并跑通。

### 13.1 两种接入模式（先选一种）

模式 A：仓库内直接接入（推荐）
- 场景：可直接改造目标仓库结构。
- 做法：将“入口文档 + 门禁脚本 + 状态治理 + 指标采集”直接落到 `<TARGET_REPO>`。
- 优点：接入快、执行面一致性高。

模式 B：平台模板接入
- 场景：多个项目由平台模板统一孵化。
- 做法：先把成果沉淀到模板仓库，再让项目继承。
- 优点：规模化成本低、跨项目一致。

### 13.2 成果映射表（从当前仓库到目标项目）

最低建议迁移清单：
- 入口与规则：
  - `AGENTS.md`
  - `ARCHITECTURE.md`
  - `CONTRIBUTING.md`
- 执行入口与 CI：
  - `Makefile`
  - `.github/workflows/ci.yml`
  - `scripts/ci/*.sh`
- 策略门禁：
  - `policy/high-risk-changes.rego`
  - `scripts/ci/policy_check.sh`
- 指标与状态治理：
  - `scripts/metrics/collect_metrics.sh`
  - `docs/status/harness-execution-status.md`
  - `docs/handoff/context-handoff.md`
- 成熟度运营：
  - `docs/ops/rule-quality/*`
  - `docs/autonomy/*`
  - `scripts/ops/calc_rule_quality_metrics.sh`
  - `scripts/autonomy/evaluate_l3l4_window.sh`

### 13.2.1 文件级影响清单（接入后会对业务项目产生什么影响）

| 文件/目录 | 接入后对业务项目的主要影响 | 额外成本/注意点 |
|---|---|---|
| `AGENTS.md` | 明确 AI 执行入口和必读上下文，减少“同类任务不同做法”导致的返工。 | 需要持续维护入口链接与当前阶段信息。 |
| `ARCHITECTURE.md` | 明确模块边界和 owner，降低跨模块改动的沟通成本。 | 架构变化后需同步更新，否则会误导执行。 |
| `CONTRIBUTING.md` | 统一开发/提交流程，降低协作摩擦和评审分歧。 | 若与团队现有流程冲突，需先做一次规范对齐。 |
| `Makefile` | 提供统一执行面（`make verify`），让本地与 CI 行为一致。 | 需要把占位命令替换为项目真实命令。 |
| `.github/workflows/ci.yml` | 将质量要求转成强制门禁，减少“带病合并”。 | 初期可能增加排队时长和修复成本。 |
| `scripts/ci/lint.sh` | 提前暴露风格/静态问题，减少后期返工。 | 规则过严会增加误报，需要逐步调优。 |
| `scripts/ci/test.sh` | 将回归检查标准化，降低线上回归风险。 | 测试基础薄弱项目会先暴露大量历史问题。 |
| `scripts/ci/eval.sh` | 引入任务质量回归能力，减少 AI 产出漂移。 | 需要持续维护 eval 样本与评分口径。 |
| `scripts/ci/policy_check.sh` | 在合并前拦截高风险变更，降低事故概率。 | 初期可能出现误拦截，需配合规则分级。 |
| `policy/high-risk-changes.rego` | 把高风险目录审批规则自动化，提升合规可审计性。 | 目录匹配范围需要按项目实际调整。 |
| `scripts/metrics/collect_metrics.sh` | 自动产出指标快照/CSV/看板输入，减少人工统计。 | 若数据源仍是占位值，决策价值有限。 |
| `docs/metrics/engineering-scorecard.md` | 统一指标口径，减少团队对“是否变好”的争议。 | 阈值需按业务阶段校准，避免失真。 |
| `docs/status/harness-execution-status.md` | 将任务推进透明化，交接成本显著下降。 | 执行中不回写会导致信息迅速失真。 |
| `docs/handoff/context-handoff.md` | 会话中断时可快速续跑，减少上下文丢失。 | 需要在关键节点及时补全交接信息。 |
| `docs/scaling/pilot-expansion-gates.md` | 扩圈有明确准入门槛，降低“过早放权”风险。 | 门槛过高可能拖慢扩圈，需要周期复核。 |
| `scripts/scaling/evaluate_pilot_gate.sh` | 扩圈 gate 可自动判定，减少主观审批波动。 | 输入数据质量直接决定判定可靠性。 |
| `docs/scaling/pilot-expansion-approval-*.md` | 审批结论可追溯，便于治理审计。 | 需要和真实审批链对齐（人/时限/SLA）。 |
| `docs/scaling/pilot-expansion-retrospective-*.md` | 扩圈后可结构化复盘，避免重复踩坑。 | 若不执行后续动作，复盘价值会衰减。 |
| `assets-library/asset-manifest.yaml` | 统一资产索引，提升新项目复用速度。 | 需要版本治理，否则资产会快速失效。 |
| `docs/scaling/reuse-metrics.md` | 复用率可量化，便于评估平台化收益。 | 指标定义需稳定，否则横向对比失真。 |
| `scripts/scaling/calc_reuse_metrics.sh` | 复用率计算自动化，降低手工统计成本。 | 依赖输入数据真实性，需防止“填报美化”。 |
| `docs/ops/rule-quality/rule-quality-metrics.md` | 明确误报率/耗时/阻断价值目标，指导规则优化。 | 需要持续采样，否则无法反映真实趋势。 |
| `docs/ops/rule-quality/monthly-tuning-report.md` | 月度调优有证据链，避免规则债累积。 | 报告若只记录结果不跟动作，会失去执行力。 |
| `scripts/ops/calc_rule_quality_metrics.sh` | 规则质量计算标准化，支持跨周期对比。 | 输入字段定义变更时需同步脚本。 |
| `docs/autonomy/l3-l4-validation-plan.md` | 明确高自治放权与回退边界，降低治理风险。 | 需要坚持按窗口评估，不能跳过周期。 |
| `docs/autonomy/autonomy-health-report-template.md` | 自治健康报告结构化，便于季度评审决策。 | 模板必须绑定真实数据，避免空转。 |
| `scripts/autonomy/evaluate_l3l4_window.sh` | L3/L4 稳定性可自动评估，减少主观判断。 | 阈值需结合业务特性调整，不可盲套。 |
| `templates/service-starter/README.md` | 新项目接入路径清晰，缩短启动时间。 | 模板需定期升级，否则“最佳实践”会过时。 |
| `.github/ISSUE_TEMPLATE/task.yml` | 需求输入质量提升，减少执行歧义。 | 团队需适应模板字段，初期填写成本上升。 |
| `.github/pull_request_template.md` | PR 证据标准化，评审效率与可审计性提升。 | 若字段过多，会增加提交阻力，需平衡。 |

### 13.3 目标项目落地步骤（10 个动作）

1. 创建接入分支
- 在 `<TARGET_REPO>` 创建单独分支，避免和业务需求混改。

2. 落地入口文档
- 接入并按项目实际改写 `AGENTS.md`、`ARCHITECTURE.md`、`CONTRIBUTING.md`。

3. 接入统一命令入口
- 迁移 `Makefile` 与 `scripts/ci/*`。
- 将占位命令替换为目标项目真实命令（lint/test/eval）。

4. 接入 CI 门禁
- 迁移 `.github/workflows/ci.yml`，确保 PR 失败即阻断。

5. 接入策略检查
- 迁移 `policy/` 与策略脚本，按目标项目风险目录调路径。

6. 接入指标采集
- 迁移 `scripts/metrics/collect_metrics.sh`。
- 先本地可跑，后替换为真实 Git/CI/Issue 数据源。

7. 启用状态总表与交接
- 在目标项目创建 `docs/status/harness-execution-status.md` 与 `docs/handoff/context-handoff.md`。
- 任务状态变化必须回写状态表。

8. 启动首轮任务卡
- 优先执行 P-1 与 P0，再进入 P1/P2/P3。
- 每张卡单独 PR，并附命令输出、验收证据、风险说明、回滚说明。

9. 执行扩圈与成熟度机制
- 运行 `P4-01` gate 判定与审批。
- 运行 `P5-01/P5-02/P5-04` 相关统计和报告。

10. 固化运营节奏
- 周度：指标和异常复盘。
- 月度：规则质量调优。
- 季度：自治健康评审。

### 13.4 可复用命令模板

```bash
# 基础验证
make lint
make test
make eval
make verify

# 指标采集
make metrics

# 扩圈 gate（示例）
MAJOR_ROLLBACK=false ./scripts/scaling/evaluate_pilot_gate.sh 2026-05-16 \
  data/scaling/pilot-dashboard-input-2026-05-16.json \
  data/scaling/pilot-lessons-2026-05-16.md

# 规则质量月度统计（示例）
./scripts/ops/calc_rule_quality_metrics.sh data/ops/rule-quality-input-2026-05.csv 2026-05

# L3/L4 窗口评估（示例）
./scripts/autonomy/evaluate_l3l4_window.sh data/autonomy/l3l4-window-2026Q2.csv 2026Q2
```

### 13.5 项目接入完成判定（最低标准）

满足以下条件可判定“已接入 Harness-Engineering”：
- `make verify` 稳定通过且 CI 已启用阻断。
- 状态总表与交接文档开始真实使用。
- 至少 1 个真实需求完成“任务卡 -> PR -> 证据 -> 发布 -> 复盘”闭环。
- 至少 1 份可追溯指标输出（JSON/CSV/看板输入）。
- 高风险变更可被策略命中并进入审批链。

### 13.6 常见失败点与修正

失败点 1：只迁移文档，不迁移脚本和 CI
- 修正：优先接入 `Makefile + scripts/ci + ci.yml`，保证可执行。

失败点 2：指标长期停留在占位字段
- 修正：按优先级接通 Git/CI/Issue 实际数据源。

失败点 3：任务完成后不更新状态总表
- 修正：将“状态回写”设为 PR 必填检查项。

失败点 4：过早提升自治等级
- 修正：严格执行 `P4 gate` 与 `P5-04` 窗口验证，不达标不升级。

### 13.7 推荐节奏（具体项目版）

第 1-2 天：
- 入口文档、Makefile、CI 门禁、策略检查接入完成。

第 3-5 天：
- 指标采集和状态治理跑通，完成首个任务卡闭环。

第 6-10 天：
- 跑 3-5 个真实需求，完成首轮复盘与规则微调。

第 2-4 周：
- 运行扩圈 gate，形成审批与复盘记录。

第 2-3 个月：
- 按周/月/季固定输出治理证据，进入运营态。



## 关联文档
- 主任务卡：`docs/harness-engineering-task-cards.md`
- 优先级主清单：`docs/harness-engineering-priority-checklist.md`
