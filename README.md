# harness-engineering-learn

> 基于最新 AI Coding 领域权威知识的 Harness Engineering 实践仓库

## 🎯 项目定位

本仓库是 Harness Engineering 的学习和实践平台，融合了来自 Anthropic、OpenAI 等权威来源的最新研究成果，形成可落地的工程化体系。

## 📚 知识来源

- [Anthropic Engineering Blog](https://www.anthropic.com/engineering) — 最权威的 AI Agent Harness 设计资料
- [Claude Code Best Practices](https://code.claude.com/docs/en/best-practices)
- 每周自动学习更新（通过 cron job）

## 🏗️ 项目结构

```
├── AGENTS.md                          # Agent 入口文件
├── ARCHITECTURE.md                    # 架构文档
├── Makefile                           # 统一命令入口 (init/lint/test/eval/policy/verify)
├── evals/                             # 评估体系
│   ├── feature_list.json              # 结构化功能清单 (JSON, Agent 友好)
│   ├── scorers/multi_grader.sh        # 多类型评分器 (Code/Model/Human)
│   └── results/                       # 评估结果存档
├── scripts/
│   ├── harness/init.sh                # Harness 环境初始化
│   ├── ci/                            # CI 门禁脚本
│   └── metrics/                       # 指标采集
├── docs/
│   ├── knowledge/                     # 权威知识笔记 (每周更新)
│   ├── status/                        # 执行状态追踪
│   └── ...                            # 各阶段文档
├── policy/                            # Policy-as-Code
├── assets-library/                    # 可复用资产库
└── data/                              # 运行数据
```

## 🚀 快速开始

```bash
# 初始化环境
make init

# 运行完整验证
make verify

# 只运行评估
make eval
```

## 📋 Harness Engineering 十大原则

1. **增量优先**：一次一个 feature，禁止 one-shot
2. **外部记忆**：用文件（JSON/progress log）保存跨 session 状态
3. **独立验证**：实现和评估必须分离（Generator ≠ Evaluator）
4. **测试即验证**：给 Agent 真正可运行的测试工具
5. **Sprint Contract**：实现前先协商完成标准
6. **上下文是稀缺资源**：精简工具、精简 prompt、Just-in-Time 检索
7. **脑手分离**：Harness、Session、Sandbox 独立部署、独立替换
8. **安全纵深**：凭证与沙箱隔离，通过代理访问外部服务
9. **Eval 驱动**：先建 eval 再优化，能力评估 → 回归测试
10. **保持简单**：能用简单方案解决的，不要用复杂系统

## 📖 业务项目接入指南

如果你想将 Harness Engineering 成果应用到具体业务项目中，请阅读详细的接入指南：

👉 **[业务项目接入指南（GUIDE_APPLY_TO_PROJECT.md）](docs/GUIDE_APPLY_TO_PROJECT.md)**

该指南涵盖：
- 接入前的自我评估
- 两种接入模式选择
- 分阶段接入步骤（10 周落地节奏）
- 文件级迁移详解（含完整改造示例）
- 业务需求 → 任务卡映射实操
- 三类典型业务场景全流程
- AI 自治等级实操
- 指标与度量体系落地
- 常见问题与踩坑

## 🔄 更新机制

- **知识更新**：每周自动学习最新文章，更新 `docs/knowledge/`
- **指标更新**：`make metrics` 采集最新指标
- **评估更新**：`make eval` 运行最新评估
