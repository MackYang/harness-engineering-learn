# OpenAI Harness Engineering 审视笔记 (2026-08-03)

> 来源：https://openai.com/index/harness-engineering/
> 学习日期：2026-08-03
> 对比笔记：2026-07-27版本
>
> 结论：文章内容无变化，本次重新审视未发现新要点。

---

## 一、审视确认

文章内容与 2026-07-27 版本完全一致，无新增段落或数据变更。

### 重新确认的核心要点

**1. AGENTS.md 作为目录而非百科全书的理念**
- 约 100 行的 AGENTS.md 作为地图，指向结构化 docs/ 知识库
- 渐进式披露（Progressive Disclosure）
- 机械验证：linter 和 CI + doc-gardening agent 定期清理过时文档

**2. "人类不写代码"的零手动代码原则**
- 1500 个 PR，~100 万行代码
- 3 名工程师起步，平均 3.5 PR/工程师/天
- 扩展到 7 名工程师后吞吐量反而增加
- 代理经常单次运行 6+ 小时（人类睡觉时）

**3. 架构约束优先于实现细节**
- 每个业务域的固定层级：Types → Config → Repo → Service → Runtime → UI
- Cross-cutting concerns 通过 Providers 统一入口
- 自定义 linter 编码品味不变量（结构化日志、命名规范、文件大小限制等）
- "boring" 技术更容易被代理理解和操作（可组合性、API 稳定性、训练集覆盖）

**4. 垃圾回收式技术债务管理**
- 黄金原则（Golden Principles）编码进仓库
- 定期后台 Codex 任务扫描偏差
- 大多数清理 PR 可在一分钟内审查并自动合并
- 人类品味捕获一次，然后持续强制执行

**5. 最新自主性里程碑**
- 单个 prompt 即可端到端驱动新功能
- 包含：验证代码库状态、复现 bug、录制视频、实现修复、验证修复、开 PR、响应反馈、检测构建失败、升级人类、合并变更

## 二、与本次其他来源的交叉思考

### 结合 Anthropic Postmortem 的思考

Anthropic 2026-04-23 的 postmortem 中三个问题本质上都是 Harness 配置问题，完美印证了 OpenAI 的核心观点：**工程的纪律从脚手架中体现，而非代码本身**。

OpenAI 说的 "What broke, what compounded, and how to maximize our one truly scarce resource: human time and attention" 与 Anthropic 的教训形成呼应：
- OpenAI 通过机械验证和 doc-gardening 减少 human QA 瓶颈
- Anthropic 的缓存 bug 显示：即使有机械验证，角落情况仍可能被遗漏

### 结合 Addy Loop Engineering 的思考

OpenAI 的实践与 Addy 描述的 Loop 五大构件高度对应：
- **Automations**: doc-gardening agent、后台清理任务
- **Worktrees**: 每个 git worktree 启动独立应用实例
- **Skills**: 仓库内结构化知识库
- **Plugins/Connectors**: Chrome DevTools Protocol、LogQL、PromQL
- **Sub-agents**: agent-to-agent review（Ralph Wiggum Loop）
- **State**: 版本化的执行计划和技术债务追踪
