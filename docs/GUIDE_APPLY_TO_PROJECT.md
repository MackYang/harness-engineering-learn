<!-- gp-09-exempt: 业务接入完整指南（reference guide），按章节顺序覆盖 10 周落地节奏。
     不是 navigation 文件；读者按需跳转章节，拆分会破坏 cross-reference。 -->

# Harness Engineering 业务项目接入指南

> 本文档详细说明如何将本仓库的 Harness Engineering 成果应用到具体业务项目中。
> 适合人群：技术负责人、DevOps 工程师、AI Coding 使用者、项目管理人。

---

## 目录

- [1. 概念速览：什么是 Harness Engineering](#1-概念速览什么是-harness-engineering)
- [2. 接入前的自我评估](#2-接入前的自我评估)
- [3. 两种接入模式选择](#3-两种接入模式选择)
- [4. 接入准备清单（Go/No-Go）](#4-接入准备清单gono-go)
- [5. 分阶段接入步骤](#5-分阶段接入步骤)
  - [5.1 阶段 0：基础设施准备（第 0 周）](#51-阶段-0基础设施准备第-0-周)
  - [5.2 阶段 A：项目准入评估（第 1-2 天）](#52-阶段-a项目准入评估第-1-2-天)
  - [5.3 阶段 B：接入 P0 硬机制（第 1-2 周）](#53-阶段-b接入-p0-硬机制第-1-2-周)
  - [5.4 阶段 C：接入项目执行面（第 2-3 周）](#54-阶段-c接入项目执行面第-2-3-周)
  - [5.5 阶段 D：质量与可靠性增强（第 4-6 周）](#55-阶段-d质量与可靠性增强第-4-6-周)
  - [5.6 阶段 E：扩圈与长期运营（第 7 周起）](#56-阶段-e扩圈与长期运营第-7-周起)
- [6. 文件级迁移详解](#6-文件级迁移详解)
- [7. 改造业务项目文件的具体示例](#7-改造业务项目文件的具体示例)
  - [7.1 AGENTS.md 改造示例](#71-agentsmd-改造示例)
  - [7.2 ARCHITECTURE.md 改造示例](#72-architecturemd-改造示例)
  - [7.3 Makefile 改造示例](#73-makefile-改造示例)
  - [7.4 CI 门禁配置示例](#74-ci-门禁配置示例)
  - [7.5 Policy-as-Code 改造示例](#75-policy-as-code-改造示例)
- [8. 业务需求 → 任务卡映射实操](#8-业务需求--任务卡映射实操)
- [9. 三类典型业务场景全流程](#9-三类典型业务场景全流程)
- [10. AI 自治等级实操](#10-ai-自治等级实操)
- [11. 指标与度量体系落地](#11-指标与度量体系落地)
- [12. 发布与故障处理流程](#12-发布与故障处理流程)
- [13. 推荐落地节奏总结](#13-推荐落地节奏总结)
- [14. 常见问题与踩坑](#14-常见问题与踩坑)
- [15. 词汇表](#15-词汇表)

---

## 1. 概念速览：什么是 Harness Engineering

**Harness Engineering** 是一种用结构化框架（Harness）来管理 AI Coding（AI 辅助编码）的工程化方法论。核心理念：

| 概念 | 含义 |
|------|------|
| **Harness** | 包裹 AI Agent 的工程脚手架——包括入口文档、CI 门禁、策略规则、指标采集、状态追踪 |
| **Loop** | 在 Harness 之上的调度循环层——自动化调度、子 Agent 协作、跨 session 状态记忆（[Loop Engineering](https://addyosmani.com/blog/loop-engineering/)） |
| **任务卡** | 将业务需求拆解为一张张可独立执行、可验证的卡片，AI 每次只做一张 |
| **自治等级** | L1（人工主导）→ L2（半自动）→ L3（受控自动）→ L4（高自动），渐进放权 |
| **Eval 驱动** | 先建评估标准，再优化实现；评估与实现严格分离 |
| **失败反哺** | 每次故障/回滚必须产出至少一项可执行改进 |

**核心原则**：
1. **增量优先**：一次一个 feature，禁止 one-shot 大改造
2. **外部记忆**：用文件保存跨 session 状态，AI 不靠"记忆"
3. **实现 ≠ 评估**：写代码的和验证代码的不是同一个角色
4. **测试即验证**：给 AI 真正可运行的测试工具
5. **Sprint Contract**：实现前先协商完成标准

---

## 2. 接入前的自我评估

在决定接入之前，先回答以下问题：

### ✅ 适合接入的项目特征

- [ ] 需求边界清晰、验收标准可量化
- [ ] 有基础 CI 能力（至少可执行 test/lint）
- [ ] 对交付节奏有持续要求
- [ ] 团队愿意投入 2-4 周做基础设施改造
- [ ] 有明确的项目 owner 和技术 owner

### ⚠️ 需要降级接入的项目

- 强监管场景（金融核心交易、医疗诊疗决策、隐私高敏）
- 遗留系统严重缺乏测试与文档（先补测试再接入）
- 高度探索型需求（需求频繁变化、目标不可量化）

### ❌ 不建议接入的场景

- 跨组织战略决策
- 法务条款与合规解释
- 高风险架构路线选择

### 评估结果判定

| 得分 | 建议 |
|------|------|
| 全部 ✅ | 按标准流程接入 |
| 有 ⚠️ | 先降级到 L1，只接入 P0 硬机制 |
| 有 ❌ | 不适合接入，重新评估范围 |

---

## 3. 两种接入模式选择

### 模式 A：仓库内直接接入（推荐）

```
适用场景：你可以直接改造目标仓库结构
接入速度：快（1-2 周）
一致性：高

做法：
将 Harness 的"入口文档 + 门禁脚本 + 状态治理 + 指标采集"
直接落到目标仓库 <TARGET_REPO> 中
```

### 模式 B：平台模板接入

```
适用场景：多个项目由平台模板统一孵化
接入速度：前期慢（需先做模板），后期快
一致性：跨项目最高

做法：
先把 Harness 成果沉淀到模板仓库，再让各业务项目继承模板
```

**决策建议**：
- 1-3 个项目 → 选模式 A
- 4 个以上项目 → 先用模式 A 做试点，验证后再升级为模式 B

---

## 4. 接入准备清单（Go/No-Go）

在正式接入前，必须确认以下条件全部满足（对应 `CARD-P-1-01` ~ `CARD-P-1-05`）：

### 4.1 试点范围冻结

- [ ] 选定 1-2 个试点项目，明确业务边界
- [ ] 定义实施周期（建议 4-8 周）
- [ ] 冻结 RACI 矩阵：

```
角色              | 职责                    | 具体人选
Owner             | 推进进度、资源协调        | ________
Reviewer          | 代码和方案评审           | ________
Approver          | 高风险变更审批           | ________
Incident Commander| 故障响应和复盘协调        | ________
```

### 4.2 工程基础验证

- [ ] CI 最小能力可用（lint + test 稳定通过）
- [ ] 代码托管权限模型确认（合并权限、豁免权限）
- [ ] 发布与回滚路径完成至少 1 次演练
- [ ] 演练记录保存到 `docs/readiness/release-rollback-drill.md`

### 4.3 数据与风险基线

- [ ] 指标数据源可连通（Git/CI/Issue）
- [ ] 高风险目录已识别并冻结（权限、计费、生产配置、数据删除）

### 4.4 首轮执行包

- [ ] 首批 10-12 张任务卡已分配 owner 和截止日期
- [ ] PR 证据格式已明确
- [ ] 评审节奏已冻结（周会/月会/季度评审）

### Go/No-Go 决策

| 条件 | 状态 |
|------|------|
| RACI 签字确认 | ☐ |
| 回滚演练成功 | ☐ |
| 基线指标可自动产出 | ☐ |
| 首轮任务卡已分配 | ☐ |

**全部打勾 → Go！进入阶段 A。有未勾选项 → No-Go，先补齐。**

---

## 5. 分阶段接入步骤

### 5.1 阶段 0：基础设施准备（第 0 周）

**目标**：让目标项目具备接入 Harness 的最低条件。

#### 步骤 0.1：创建接入分支

```bash
cd <TARGET_REPO>
git checkout -b harness/onboarding
```

> ⚠️ 在单独分支操作，不和业务需求混改。完成后再合并回主分支。

#### 步骤 0.2：建立目录结构

在目标项目根目录创建以下结构：

```
<TARGET_REPO>/
├── AGENTS.md                    # AI 入口文档（必须）
├── ARCHITECTURE.md              # 架构文档（必须）
├── CONTRIBUTING.md              # 贡献规范（必须）
├── Makefile                     # 统一命令入口（必须）
├── harness-progress.txt         # 执行进度日志
├── docs/
│   ├── status/
│   │   └── harness-execution-status.md   # 任务状态总表
│   ├── handoff/
│   │   └── context-handoff.md            # 上下文交接
│   ├── incidents/
│   │   ├── failure-taxonomy.md            # 失败分类标准
│   │   ├── postmortem-template.md         # 复盘模板
│   │   └── lessons-learned-log.md         # 教训日志
│   ├── metrics/
│   │   └── engineering-scorecard.md       # 指标记分卡
│   ├── readiness/
│   │   ├── pilot-charter.md               # 试点章程
│   │   └── raci-matrix.md                 # RACI 矩阵
│   └── harness-engineering-task-cards.md  # 任务卡（可精简）
├── policy/
│   └── high-risk-changes.rego             # 高风险变更策略
├── evals/
│   └── feature_list.json                  # 功能清单
└── scripts/
    ├── ci/
    │   ├── lint.sh
    │   ├── test.sh
    │   ├── eval.sh
    │   └── policy_check.sh
    ├── metrics/
    │   └── collect_metrics.sh
    └── harness/
        └── init.sh
```

#### 步骤 0.3：验证 Git 基础

```bash
# 确保在正确分支
git branch
# 确保工作目录干净
git status
```

---

### 5.2 阶段 A：项目准入评估（第 1-2 天）

**目标**：确认项目风险级别和初始自治等级。

#### 步骤 A.1：确定风险级别

| 级别 | 判定条件 | 默认自治等级 |
|------|----------|-------------|
| **Low** | 内部工具、非核心业务、有完整测试 | L2 |
| **Medium** | 面向用户功能、有 CI 但测试不全 | L1 → L2 |
| **High** | 核心交易、支付、权限、金融数据 | L1（强制） |

#### 步骤 A.2：评估基础条件

```bash
# 检查 CI 是否可用
cat .github/workflows/*.yml 2>/dev/null || echo "No CI found"
# 或 Jenkins
cat Jenkinsfile 2>/dev/null || echo "No Jenkinsfile found"

# 检查测试命令
grep -r "test" package.json 2>/dev/null || grep -r "test" pom.xml 2>/dev/null || echo "No test command found"

# 检查 lint 命令
grep -r "lint" package.json 2>/dev/null || echo "No lint command found"
```

#### 步骤 A.3：记录评估结果

创建 `docs/readiness/pilot-charter.md`，填写：

```markdown
# 试点项目章程

## 项目信息
- 项目名称：
- 仓库地址：
- 风险级别：Low / Medium / High
- 初始自治等级：L1 / L2

## RACI
- Owner：
- Reviewer：
- Approver：
- Incident Commander：

## 准入条件检查
- [ ] 有明确验收标准
- [ ] 有可执行测试命令
- [ ] 有失败回滚路径

## 实施周期
- 开始日期：
- 结束日期：
```

---

### 5.3 阶段 B：接入 P0 硬机制（第 1-2 周）

**目标**：建立度量驱动、失败反哺、自动执行三大硬机制。

这是最关键的阶段，决定了后续所有工作是否能持续运转。

#### 步骤 B.1：建立指标字典（`CARD-P0-01`）

创建 `docs/metrics/engineering-scorecard.md`：

```markdown
# 工程指标记分卡

## DORA 指标
| 指标 | 公式 | 数据源 | 采样周期 | 绿 | 黄 | 红 |
|------|------|--------|----------|----|----|-----|
| Lead Time | PR 创建到合并的时间 | Git | 周 | <2天 | 2-5天 | >5天 |
| Deploy Frequency | 每周发布次数 | CI/CD | 周 | >=5 | 2-4 | <2 |
| Change Failure Rate | 回滚次数/发布总数 | CI/CD | 周 | <5% | 5-15% | >15% |
| MTTR | 故障到恢复的平均时间 | 监控 | 周 | <1h | 1-4h | >4h |

## Eval 指标
| 指标 | 公式 | 数据源 | 采样周期 | 绿 | 黄 | 红 |
|------|------|--------|----------|----|----|-----|
| Eval 通过率 | 通过数/总数 | eval 脚本 | 周 | >=90% | 70-90% | <70% |
| 回归失败率 | 回归失败数/总数 | 测试 | 周 | <5% | 5-10% | >10% |
| 人工返工率 | 返工 PR 数/总 PR 数 | Git | 周 | <10% | 10-20% | >20% |
```

> **关键**：阈值必须是具体数字，不允许"高/中/低"模糊描述。

#### 步骤 B.2：建立指标采集管道（`CARD-P0-02`）

将 `scripts/metrics/collect_metrics.sh` 迁移到目标项目，替换数据源为项目实际数据：

```bash
#!/usr/bin/env bash
# 每周运行一次，自动产出指标快照
# 输出：data/metrics/weekly-summary-YYYY-MM-DD.json

WEEK=$(date +%Y-W%V)
OUTPUT_DIR="data/metrics"
mkdir -p "$OUTPUT_DIR"

# 从 Git 统计
PR_COUNT=$(git log --oneline --since="7 days ago" | wc -l)
# 从 CI 统计（根据实际 CI 替换）
# DEPLOY_COUNT=...
# MTTR=...

cat > "$OUTPUT_DIR/weekly-summary-$(date +%Y-%m-%d).json" <<EOF
{
  "week": "$WEEK",
  "pr_count": $PR_COUNT,
  "timestamp": "$(date -Iseconds)"
}
EOF

echo "Metrics collected: $OUTPUT_DIR/weekly-summary-$(date +%Y-%m-%d).json"
```

设置 cron 或 CI 定时任务每周自动运行：

```yaml
# .github/workflows/metrics.yml
name: Weekly Metrics
on:
  schedule:
    - cron: '0 9 * * 1'  # 每周一早上 9 点
jobs:
  collect:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: ./scripts/metrics/collect_metrics.sh
      - uses: actions/upload-artifact@v4
        with:
          name: metrics-${{ github.run_number }}
          path: data/metrics/
```

#### 步骤 B.3：建立失败分类与复盘机制（`CARD-P0-04`、`CARD-P0-05`）

创建 `docs/incidents/failure-taxonomy.md`：

```markdown
# 失败事件分类标准

## 事件类型
| 类型 | 定义 | 示例 |
|------|------|------|
| 回滚 | 发布后需要回退到上一版本 | 新功能导致线上异常 |
| 线上事故 | 影响用户正常使用的故障 | 服务不可用、数据错误 |
| 误改 | 非预期的代码变更 | AI 修改了不该改的文件 |
| 越权 | 超出授权范围的变更 | AI 绕过审批修改高风险目录 |
| Eval 失效 | 评估通过但实际产出不符合预期 | eval 覆盖不全 |

## 严重等级
| 等级 | 定义 | 响应要求 |
|------|------|----------|
| SEV1 | 影响核心业务流程 | 立即响应，30 分钟内止血 |
| SEV2 | 影响非核心功能或部分用户 | 2 小时内响应 |
| SEV3 | 影响开发效率但不影响用户 | 24 小时内处理 |

## 复盘 SLA
- 24 小时内完成初判
- 7 天内完成改进闭环
- 每次复盘必须产出至少一项可执行改进
```

#### 步骤 B.4：接入 CI 门禁（`CARD-P0-07`）

将 `scripts/ci/` 下的脚本迁移到目标项目，并替换为项目真实命令：

```bash
#!/usr/bin/env bash
# scripts/ci/lint.sh
set -euo pipefail
echo "=== Running Lint ==="
# 根据项目技术栈替换为实际命令：
# Node.js 项目：
npx eslint src/ --max-warnings=0
# Java 项目：
# mvn checkstyle:check
# Python 项目：
# ruff check src/
echo "✓ Lint passed"
```

```bash
#!/usr/bin/env bash
# scripts/ci/test.sh
set -euo pipefail
echo "=== Running Tests ==="
# 根据项目技术栈替换为实际命令：
# Node.js 项目：
npx jest --ci --coverage --coverageThreshold='{"global":{"branches":70,"functions":70,"lines":70}}'
# Java 项目：
# mvn test
# Python 项目：
# pytest --cov=src --cov-fail-under=70
echo "✓ Tests passed"
```

```bash
#!/usr/bin/env bash
# scripts/ci/eval.sh
set -euo pipefail
echo "=== Running Eval ==="
# 运行项目的功能评估
# 初始阶段可以是简单的冒烟测试
# 后续可替换为 evals/scorers/multi_grader.sh 的模式
echo "✓ Eval passed"
```

```bash
#!/usr/bin/env bash
# scripts/ci/policy_check.sh
set -euo pipefail
echo "=== Running Policy Check ==="
# 检查高风险文件是否被意外修改
# 依赖 policy/high-risk-changes.rego
if command -v opa &>/dev/null; then
  opa eval --data policy/high-risk-changes.rego \
    --input <(git diff --name-only HEAD~1) \
    "data.harness.deny"
else
  echo "  OPA not installed, skipping policy evaluation"
  echo "  Install: https://www.openpolicyagent.org/docs/latest/#running-opa"
fi
echo "✓ Policy check passed"
```

接入 CI（以 GitHub Actions 为例）：

```yaml
# .github/workflows/ci.yml
name: CI Gate
on:
  pull_request:
    branches: [main]
jobs:
  gate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4  # 或 setup-java / setup-python
        with:
          node-version: '20'
      - run: npm ci  # 或 mvn install / pip install
      - run: ./scripts/ci/lint.sh
      - run: ./scripts/ci/test.sh
      - run: ./scripts/ci/eval.sh
      - run: ./scripts/ci/policy_check.sh
```

> **关键**：CI 门禁必须配置为 PR 合并的必要条件，不允许绕过。

#### 步骤 B.5：接入 Policy-as-Code（`CARD-P0-08`）

创建 `policy/high-risk-changes.rego`，按项目实际高风险目录调整：

```rego
package harness

# 定义项目中的高风险目录（根据实际项目修改）
high_risk_paths := [
    "src/auth/",
    "src/payment/",
    "src/config/production",
    "src/database/migrations",
    ".env",
    "terraform/"
]

# 拒绝直接修改高风险目录的变更（需要特殊审批）
deny[msg] {
    input_path := input[_]
    risk_path := high_risk_paths[_]
    startswith(input_path, risk_path)
    msg := sprintf("高风险目录变更需要额外审批: %s", [input_path])
}
```

---

### 5.4 阶段 C：接入项目执行面（第 2-3 周）

**目标**：让 AI 可以只靠仓库文档就能正确执行任务。

#### 步骤 C.1：编写 AGENTS.md

这是 AI 的入口地图，直接决定了 AI 能否正确工作。详见 [7.1 节示例](#71-agentsmd-改造示例)。

#### 步骤 C.2：编写 ARCHITECTURE.md

记录项目的模块划分和依赖关系。详见 [7.2 节示例](#72-architecturemd-改造示例)。

#### 步骤 C.3：编写 CONTRIBUTING.md

统一开发规范和提交流程。

#### 步骤 C.4：接入 Makefile

提供统一命令入口。详见 [7.3 节示例](#73-makefile-改造示例)。

#### 步骤 C.5：初始化 Harness 环境

```bash
# 运行初始化脚本（首次）
./scripts/harness/init.sh

# 或手动验证
make lint && make test && echo "✓ 基础验证通过"
```

#### 通过条件

- [ ] 新人（或新 AI session）可在 30 分钟内定位核心信息
- [ ] `make verify` 可以一键运行所有检查
- [ ] PR 模板字段完整率 >= 95%

---

### 5.5 阶段 D：质量与可靠性增强（第 4-6 周）

**目标**：补齐评估体系和发布可靠性。

#### 步骤 D.1：建立 Eval 体系

创建 `evals/feature_list.json`，列出项目的核心功能点和验证步骤：

```json
[
  {
    "id": "FEAT-001",
    "category": "user-auth",
    "description": "用户登录功能正常工作",
    "steps": [
      "调用登录 API 返回 200",
      "返回有效的 JWT token",
      "token 可用于后续请求鉴权"
    ],
    "passes": false,
    "priority": "P0"
  }
]
```

#### 步骤 D.2：建立渐进发布机制

```yaml
# 发布策略配置示例
release:
  strategy: canary
  stages:
    - name: canary
      traffic_percent: 5
      duration_minutes: 30
      metrics_check:
        error_rate_threshold: 1%
        latency_p99_threshold: 500ms
    - name: staging
      traffic_percent: 25
      duration_minutes: 60
    - name: full
      traffic_percent: 100
  rollback_on:
    - error_rate > 2%
    - latency_p99 > 1000ms
```

#### 步骤 D.3：定义 SLO

```markdown
# SLO 定义

| 服务 | SLI | SLO 目标 | Error Budget |
|------|-----|---------|-------------|
| API 服务 | 请求成功率 | >= 99.9% | 每月 43 分钟不可用 |
| API 服务 | P99 延迟 | <= 200ms | - |
| 后台任务 | 处理成功率 | >= 99.5% | - |
```

---

### 5.6 阶段 E：扩圈与长期运营（第 7 周起）

**目标**：将成功经验复制到更多项目，建立持续运营机制。

#### 扩圈 Gate 判定

在扩圈到下一个团队/项目前，必须满足：

- [ ] 连续 2 周核心指标达标（DORA + Eval）
- [ ] 无重大回滚
- [ ] PR 模板完整率 >= 95%
- [ ] SOP 和培训包已准备就绪

#### 固化运营节奏

| 周期 | 活动 | 产出 |
|------|------|------|
| 每周 | 指标复盘 + 异常处理 | 周报 + 行动项 |
| 每月 | 规则质量调优 + 降噪 | 月度调优报告 |
| 每季度 | 自治健康评审 + 策略审计 | 季度健康报告 |

---

## 6. 文件级迁移详解

以下是 Harness 仓库中每个文件/目录迁移到目标项目时的要点：

### 必须迁移（核心文件）

| 源文件 | 目标位置 | 改造要点 |
|--------|----------|----------|
| `AGENTS.md` | `<TARGET_REPO>/AGENTS.md` | 按项目实际改写导航地图、场景指引、当前阶段 |
| `ARCHITECTURE.md` | `<TARGET_REPO>/ARCHITECTURE.md` | 写入真实模块划分、依赖方向、owner |
| `CONTRIBUTING.md` | `<TARGET_REPO>/CONTRIBUTING.md` | 对齐团队现有流程，统一 PR 规范 |
| `Makefile` | `<TARGET_REPO>/Makefile` | **替换占位命令为项目真实命令** |
| `scripts/harness/init.sh` | `<TARGET_REPO>/scripts/harness/init.sh` | 修改 required_files 列表和验证逻辑 |

### 必须迁移（CI 与策略）

| 源文件 | 目标位置 | 改造要点 |
|--------|----------|----------|
| `scripts/ci/*.sh` | `<TARGET_REPO>/scripts/ci/` | 替换为项目实际的 lint/test/eval 命令 |
| `policy/high-risk-changes.rego` | `<TARGET_REPO>/policy/` | 修改 `high_risk_paths` 为项目实际高风险目录 |
| CI 配置模板 | `.github/workflows/ci.yml` | 按项目技术栈调整 setup 步骤 |

### 建议迁移（治理文件）

| 源文件 | 目标位置 | 改造要点 |
|--------|----------|----------|
| `docs/status/harness-execution-status.md` | `docs/status/` | 清空为模板状态，等待项目任务填充 |
| `docs/handoff/context-handoff.md` | `docs/handoff/` | 清空为模板 |
| `docs/incidents/*` | `docs/incidents/` | 直接复用模板，按需调整 SEV 等级定义 |
| `docs/metrics/engineering-scorecard.md` | `docs/metrics/` | 调整阈值和指标定义 |
| `evals/feature_list.json` | `evals/` | 按项目实际功能填写 |
| `scripts/metrics/collect_metrics.sh` | `scripts/metrics/` | 替换数据源为项目实际数据 |
| `harness-progress.txt` | 根目录 | 初始化为空日志 |

### 可选迁移（高级功能）

| 源文件 | 适用时机 |
|--------|----------|
| `scripts/scaling/evaluate_pilot_gate.sh` | 准备扩圈到新团队时 |
| `scripts/ops/calc_rule_quality_metrics.sh` | 规则数量增长后需要优化时 |
| `scripts/autonomy/evaluate_l3l4_window.sh` | 考虑升级到 L3/L4 时 |
| `templates/service-starter/` | 需要创建新服务脚手架时 |
| `assets-library/` | 跨项目复用资产时 |

---

## 7. 改造业务项目文件的具体示例

以下给出各核心文件的完整改造示例，展示如何从 Harness 仓库的模板适配到具体业务项目。

### 7.1 AGENTS.md 改造示例

**改造前**（Harness 仓库的通用版）→ **改造后**（以一个电商订单服务为例）：

```markdown
# AGENTS Entry Point — 订单服务

> 这是 AI Agent 的入口地图。按需深入，不要一次全部加载。

## Quick Start

1. 读本文件（你正在做）
2. 检查当前状态：`docs/status/harness-execution-status.md`
3. 查看可用任务：`docs/harness-engineering-task-cards.md`

## 项目概况

- 技术栈：Node.js + TypeScript + PostgreSQL + Redis
- 框架：NestJS
- 测试：Jest
- CI：GitHub Actions
- 部署：Kubernetes + ArgoCD

## 关键路径

| 路径 | 说明 |
|------|------|
| `src/modules/order/` | 订单核心逻辑 |
| `src/modules/payment/` | 支付集成（高风险） |
| `src/modules/inventory/` | 库存管理 |
| `src/modules/notification/` | 通知服务 |
| `src/common/` | 共享工具和中间件 |

## 场景导航

### 开始新任务
1. 读 `docs/status/harness-execution-status.md` → 找下一个未完成任务
2. 读对应任务卡 → 理解目标和验收标准
3. 执行 → `make verify` → 提交 PR

### 写代码
1. 先读 `ARCHITECTURE.md` → 理解模块边界
2. 读 `CONTRIBUTING.md` → 理解提交规范
3. 实现后运行 `make verify`

### 会话中断
1. 读 `docs/handoff/context-handoff.md` → 获取交接信息
2. 填写交接模板 → 确保下一个 session 可接续

## 必须遵守

- 一次只执行一张任务卡
- 状态变化必须回写到 `docs/status/harness-execution-status.md`
- 实现后必须运行 `make verify`
- **高风险目录**（payment/、database/migrations/）变更需额外审批
```

### 7.2 ARCHITECTURE.md 改造示例

```markdown
# Architecture — 订单服务

## 系统分层

```
┌─────────────────────────────┐
│         API Gateway          │
├─────────────────────────────┤
│  Order │ Payment │ Inventory │   ← 业务模块层
├─────────────────────────────┤
│     Common / Middleware      │   ← 共享层
├─────────────────────────────┤
│  PostgreSQL │ Redis │ MQ     │   ← 数据层
└─────────────────────────────┘
```

## 依赖方向
- 严格单向：上层 → 下层
- 同层模块间通过事件通信，不直接调用
- Common 层不依赖任何业务模块

## 模块 Owner

| 模块 | Owner | 说明 |
|------|-------|------|
| order | @zhangsan | 订单创建、查询、状态流转 |
| payment | @lisi | 支付集成（高风险，需 Approver 审批） |
| inventory | @wangwu | 库存扣减和恢复 |
| notification | @zhaoliu | 通知推送 |

## 高风险目录

以下目录的变更需要 Approver 审批（CI 门禁会自动拦截）：
- `src/modules/payment/` — 支付相关
- `src/config/production/` — 生产环境配置
- `src/database/migrations/` — 数据库迁移
```

### 7.3 Makefile 改造示例

```makefile
.PHONY: lint test eval policy verify metrics init

# 代码风格检查
lint:
	npx eslint src/ --max-warnings=0
	@echo "✓ Lint passed"

# 单元测试 + 覆盖率
test:
	npx jest --ci --coverage
	@echo "✓ Tests passed"

# 功能评估（基于 evals/feature_list.json）
eval:
	./scripts/ci/eval.sh
	@echo "✓ Eval passed"

# 策略检查（高风险目录保护）
policy:
	./scripts/ci/policy_check.sh
	@echo "✓ Policy check passed"

# 一键验证（CI 门禁使用）
verify: lint test eval policy
	@echo "✓ All checks passed"

# 指标采集
metrics:
	./scripts/metrics/collect_metrics.sh
	@echo "✓ Metrics collected"

# 初始化 Harness 环境
init:
	./scripts/harness/init.sh
```

> **关键**：每个 target 都要替换为项目真实的命令。不要保留占位符。

### 7.4 CI 门禁配置示例

#### GitHub Actions（Node.js 项目）

```yaml
name: CI Gate
on:
  pull_request:
    branches: [main, develop]

jobs:
  gate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0  # 需要完整 git 历史做 policy check

      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'

      - run: npm ci

      # Harness 门禁（按顺序执行，任一失败即阻断）
      - name: Lint
        run: make lint

      - name: Test
        run: make test

      - name: Eval
        run: make eval

      - name: Policy Check
        run: make policy

      # 全部通过后自动产出验证摘要
      - name: Verify Summary
        if: always()
        run: make verify 2>/dev/null || true
```

#### GitLab CI（Java 项目）

```yaml
stages:
  - gate

ci-gate:
  stage: gate
  image: maven:3.9-eclipse-temurin-17
  script:
    - make lint
    - make test
    - make eval
    - make policy
  rules:
    - if: $CI_MERGE_REQUEST_TARGET_BRANCH_NAME == "main"
```

#### Jenkins（通用项目）

```groovy
pipeline {
    agent any
    stages {
        stage('Lint') { steps { sh 'make lint' } }
        stage('Test') { steps { sh 'make test' } }
        stage('Eval') { steps { sh 'make eval' } }
        stage('Policy') { steps { sh 'make policy' } }
    }
    post {
        failure {
            echo 'Harness CI gate failed. PR cannot be merged.'
        }
    }
}
```

### 7.5 Policy-as-Code 改造示例

根据不同项目类型，调整高风险目录列表：

```rego
package harness

# === 电商订单服务的高风险目录 ===
high_risk_paths := [
    "src/modules/payment/",
    "src/modules/refund/",
    "src/config/production/",
    "src/database/migrations/",
    "kubernetes/production/",
    "terraform/"
]

deny[msg] {
    input_path := input[_]
    risk_path := high_risk_paths[_]
    startswith(input_path, risk_path)
    msg := sprintf("⚠️ 高风险目录变更需要 Approver 审批: %s", [input_path])
}

# 禁止直接修改生产配置
deny[msg] {
    input_path := input[_]
    input_path == "src/config/production.ts"
    msg := "⛔ 禁止直接修改生产配置文件，请通过配置中心变更"
}
```

---

## 8. 业务需求 → 任务卡映射实操

### 输入（业务侧提供）

每个需求必须包含以下字段（可通过 Issue 模板收集）：

```yaml
需求模板:
  业务目标: "提升用户下单转化率 5%"
  影响范围: "订单创建流程"
  验收标准: "用户可在 3 步内完成下单，下单成功率 >= 99.5%"
  风险等级: "Medium"
  截止时间: "2026-06-30"
```

### 映射规则

```
业务需求
    │
    ├── 拆解为 ──→ 治理卡（来自 Harness 任务卡 P-1 ~ P5）
    │
    └── 拆解为 ──→ 功能卡（具体业务实现）
                     │
                     ├── 绑定 1 个 eval 验收项
                     ├── 绑定 1 个发布策略
                     └── 绑定 1 个失败回滚策略
```

### 具体映射示例

**业务需求**：「优化订单创建流程，支持一键下单」

拆解为以下任务卡：

| 卡号 | 类型 | 标题 | 优先级 | 依赖 |
|------|------|------|--------|------|
| CARD-001 | 功能卡 | 简化下单 API 接口设计 | P0 | - |
| CARD-002 | 功能卡 | 实现一键下单后端逻辑 | P0 | CARD-001 |
| CARD-003 | 功能卡 | 前端适配一键下单 UI | P1 | CARD-002 |
| CARD-004 | eval 卡 | 下单流程端到端测试 | P0 | CARD-002 |
| CARD-005 | 发布卡 | 一键下单渐进发布策略 | P1 | CARD-003, CARD-004 |

每张卡的 PR 必须包含：
- 执行命令输出（`make verify` 的结果）
- 验收证据（测试报告、截图等）
- 风险说明（本次变更可能影响什么）
- 回滚说明（出问题如何回退）

---

## 9. 三类典型业务场景全流程

### 场景 A：新功能开发（中风险）

```
第 1 天：业务提交需求 → 工程拆卡（功能卡 + eval 卡 + 发布卡）
第 2 天：AI 执行 CARD-001（接口设计），提交 PR → 人工 Review
第 3 天：AI 执行 CARD-002（后端实现），提交 PR → 人工 Review
第 4 天：AI 执行 CARD-004（eval），验证功能正确性
第 5 天：AI 执行 CARD-003（前端 UI），提交 PR
第 6 天：执行 CARD-005，渐进发布 5% → 25% → 100%
```

### 场景 B：线上缺陷修复（高优先）

```
T+0m   发现故障，创建故障卡并标注 SEV 等级
T+5m   AI 定位问题并提交热修复 PR
T+30m  人工审批发布
T+1h   修复上线，验证恢复
T+24h  初判完成（根因分析 + 短期改善）
T+7d   复盘完成（长期改进项 + 新测试/策略/规则）
```

### 场景 C：模块重构（中高风险）

```
前置条件：先补齐测试覆盖率和 eval 基线

第 1 周：小步改造第一批（10% 代码），每批可独立回滚
        → 指标正常 → 继续
        → 指标异常 → 立即回退并调整方案

第 2 周：改造第二批（20% 代码）
第 3 周：改造第三批（30% 代码）
...
每批都走完整 PR 流程：lint → test → eval → policy → merge
```

---

## 10. AI 自治等级实操

### L1：人工主导模式（推荐起步）

```
AI 职责：
  ✓ 产出代码建议
  ✓ 编写测试
  ✓ 生成文档
  ✓ 运行验证命令

人工职责：
  ✓ 评审所有代码
  ✓ 决定发布时机
  ✓ 审批高风险变更

适用：
  - 新接入项目
  - 遗留系统
  - 团队不熟悉 AI Coding
```

**升级到 L2 的条件**（连续 2 周满足）：
- [ ] Eval 达标率 >= 90%
- [ ] 无重大回滚
- [ ] PR 模板完整率 >= 95%

### L2：半自动执行

```
AI 职责（新增）：
  ✓ 独立提交标准任务卡 PR
  ✓ 自主运行验证
  ✓ 更新状态总表

人工职责（简化）：
  ✓ 关键变更审批
  ✓ 发布策略决策
  ✓ 异常干预

适用：
  - 中低风险功能迭代
  - 团队已熟悉 Harness 流程
```

**升级到 L3 的条件**（连续 4 周满足）：
- [ ] DORA 指标持续改善
- [ ] Change Failure Rate 未上升
- [ ] 复盘闭环率 >= 80%

### L3：受控自动

```
AI 可自动合并低风险变更（CI 门禁全绿即自动合并）
高风险变更仍需人工审批
```

**回退条件**：
- 连续 2 次发布触发回滚
- Eval 波动超过阈值

### L4：边界内高自动

```
仅在成熟、低风险、规则完备的项目启用
默认保留人工紧急刹车
```

---

## 11. 指标与度量体系落地

### 11.1 指标采集实现

```bash
#!/bin/bash
# scripts/metrics/collect_metrics.sh
# 每周运行一次

set -euo pipefail

WEEK=$(date +%Y-W%V)
TODAY=$(date +%Y-%m-%d)
OUTPUT_DIR="data/metrics"
mkdir -p "$OUTPUT_DIR"

# === DORA 指标 ===

# Lead Time（PR 从创建到合并的平均时间，单位：小时）
LEAD_TIME=$(git log --merges --since="7 days ago" --format="%ct" | \
  awk '{sum+=$1; count++} END {if(count>0) printf "%.1f", (systime()-sum/count)/3600; else print "null"}')

# Deploy Frequency（本周合并的 PR 数）
DEPLOY_FREQ=$(git log --merges --since="7 days ago" --oneline | wc -l)

# === Eval 指标 ===

# 测试通过率（如果有 Jest 的 junit 输出）
TEST_PASS_RATE="null"  # 初始占位，后续接入真实数据
EVAL_PASS_RATE="null"

# === 输出 JSON ===
cat > "$OUTPUT_DIR/weekly-summary-${TODAY}.json" <<EOF
{
  "week": "$WEEK",
  "date": "$TODAY",
  "dora": {
    "lead_time_hours": $LEAD_TIME,
    "deploy_frequency": $DEPLOY_FREQ,
    "change_failure_rate": null,
    "mttr_hours": null
  },
  "eval": {
    "test_pass_rate": $TEST_PASS_RATE,
    "eval_pass_rate": $EVAL_PASS_RATE
  },
  "timestamp": "$(date -Iseconds)"
}
EOF

echo "✓ Metrics collected: $OUTPUT_DIR/weekly-summary-${TODAY}.json"
```

### 11.2 指标运营节奏

| 时间 | 活动 | 参与人 | 产出 |
|------|------|--------|------|
| 每周一 | 运行 `make metrics` | DevOps | 指标 JSON |
| 每周一 | 周会复盘指标 | 全团队 | 行动项 |
| 每月末 | 规则质量调优 | Tech Lead | 月度报告 |
| 每季度 | 自治健康评审 | EM + Tech Lead | 季度报告 |

---

## 12. 发布与故障处理流程

### 发布前检查清单

```markdown
## 发布前检查

- [ ] `make verify` 全部通过
- [ ] 风险等级已确认
- [ ] 发布策略已确定（普通 / 渐进）
- [ ] 回滚方案已准备
- [ ] 监控面板已就绪
- [ ] 值班人员已确认
```

### 发布流程（渐进发布）

```
1. Canary 5% 流量 → 观察 30 分钟
   ├── 指标正常 → 进入 Stage 2
   └── 指标异常 → 自动回滚

2. Staging 25% 流量 → 观察 60 分钟
   ├── 指标正常 → 进入 Stage 3
   └── 指标异常 → 自动回滚

3. Full 100% 流量
   └── 发布完成
```

### 故障处理

```
发现故障
  │
  ├─ SEV1 → 立即响应（30 分钟内止血）
  │         → 必要时直接回滚
  │
  ├─ SEV2 → 2 小时内响应
  │         → 评估是否需要回滚
  │
  └─ SEV3 → 24 小时内处理
            → 下一迭代修复

T+24h → 初判完成（根因 + 短期改善）
T+7d  → 复盘完成（至少产出 1 项改进：新测试/新策略/新规则）
```

---

## 13. 推荐落地节奏总结

| 时间 | 阶段 | 关键动作 | 产出 |
|------|------|----------|------|
| 第 0 周 | 实施准备 | Go/No-Go 评估 | 章程 + RACI + 演练记录 |
| 第 1-2 天 | 准入评估 | 风险定级 + 自治等级 | `pilot-charter.md` |
| 第 3-5 天 | P0 硬机制 | 指标 + 复盘 + CI 门禁 | `Makefile` + CI + 指标管道 |
| 第 6-10 天 | 执行面接入 | 入口文档 + 统一命令 | `AGENTS.md` + `ARCHITECTURE.md` |
| 第 2-3 周 | 试跑 | 3-5 个真实需求完整闭环 | 首次复盘 + 规则微调 |
| 第 4-6 周 | 质量增强 | Eval 体系 + 渐进发布 + SLO | eval 数据集 + 发布策略 |
| 第 7-8 周 | 扩圈评估 | Gate 判定 + 审批 | 扩圈审批 + 复盘记录 |
| 第 9 周起 | 持续运营 | 周/月/季节奏 | 治理证据 + 健康报告 |

---

## 14. 常见问题与踩坑

### Q1：项目没有 CI，能不能接入？

**可以，但需要先补齐**。最少需要：
1. 一个 lint 命令（代码风格检查）
2. 一个 test 命令（至少冒烟测试）
3. 一个 CI 配置（GitHub Actions / GitLab CI / Jenkins 都可以）

建议用 1-2 天先把 CI 基础搭好，再接入 Harness。

### Q2：AI 经常改错文件怎么办？

1. 检查 `AGENTS.md` 是否有明确的项目路径说明
2. 检查 `policy/high-risk-changes.rego` 是否配置了正确的保护目录
3. 在 `AGENTS.md` 的"必须遵守"部分明确写出禁止修改的路径

### Q3：指标采集脚本的数据源是占位值，怎么办？

优先级：
1. **最高**：接通 Git 数据（PR 数、合并时间）— 这是最容易获取的
2. **其次**：接通 CI 数据（构建成功/失败、测试结果）
3. **最后**：接通 Issue 数据（需求交付周期）

先接通一个数据源就开始用，不要等全部就绪。

### Q4：任务卡执行到一半 AI session 断了怎么办？

这是正常情况，Harness 就是为了解决这个问题：
1. AI 会把当前进度写到 `docs/handoff/context-handoff.md`
2. 下一个 session 启动时，先读 `docs/status/harness-execution-status.md`
3. 找到未完成的卡，从断点继续

关键：**每次状态变化都要回写状态总表**，这是 Harness 的核心纪律。

### Q5：团队不习惯用模板，PR 经常缺字段怎么办？

1. 启用 PR 模板自动校验（`scripts/ci/validate_schema.sh`）
2. 在 CI 门禁中增加 PR 字段检查，缺字段不让合并
3. 初期容忍度可以放宽，先保证核心字段（Task ID + 验证证据）

### Q6：只迁移了文档但没迁脚本，有问题吗？

**这是最常见的失败模式**。文档是说明，脚本是执行。
没有脚本，AI 无法自动运行验证，Harness 就只是"装饰"。

**最低限度必须迁移**：`Makefile` + `scripts/ci/*.sh` + CI 配置。

### Q7：项目很小，只有 2-3 个开发者，需要全部接入吗？

不需要。精简接入：
1. `AGENTS.md` + `ARCHITECTURE.md` + `CONTRIBUTING.md`（文档）
2. `Makefile`（统一命令）
3. CI 门禁（lint + test）
4. `docs/status/`（状态追踪）

不需要：Policy-as-Code、指标采集、扩圈机制（这些是给大团队用的）。

### Q8：多个项目接入后如何复用经验？

参见 `assets-library/asset-manifest.yaml`：
1. 每个项目接入后，把可复用的模板/策略/eval 数据集沉淀到资产库
2. 新项目接入时优先从资产库复用
3. 目标：新项目资产复用率 >= 70%

---

## 15. 词汇表

| 术语 | 定义 |
|------|------|
| **Harness** | 包裹 AI Agent 的工程脚手架，包含文档、脚本、策略、指标 |
| **任务卡** | 一个可独立执行、可验证的最小工作单元 |
| **自治等级** | AI 的自主程度，从 L1（人工主导）到 L4（高自动） |
| **Eval** | 评估/评测，用于验证 AI 产出是否达标 |
| **P0/P1/P2/P3/P4/P5** | 任务优先级，P0 最高（必须先完成），P5 是长期成熟度 |
| **DORA** | DevOps 研究与评估指标（Lead Time、Deploy Frequency、CFR、MTTR） |
| **SPACE** | 开发者体验指标（满意度、协作、流效率） |
| **CFR** | Change Failure Rate，变更失败率 |
| **MTTR** | Mean Time To Recovery，平均恢复时间 |
| **SLI** | Service Level Indicator，服务水平指标 |
| **SLO** | Service Level Objective，服务水平目标 |
| **Go/No-Go** | 准入决策，全部条件满足才能进入下一阶段 |
| **RACI** | 责任矩阵（Responsible/Accountable/Consulted/Informed） |
| **Policy-as-Code** | 用代码（如 OPA/Rego）定义的策略规则 |
| **Sprint Contract** | 实现前协商的完成标准 |
| **Generator ≠ Evaluator** | 实现代码的和验证代码的不能是同一角色 |

---

## 关联文档

- [主 README](../README.md)
- [任务卡清单](harness-engineering-task-cards.md)
- [优先级主清单](harness-engineering-priority-checklist.md)
- [项目落地 Playbook](harness-usage-playbook.md)
- [架构文档](../ARCHITECTURE.md)
