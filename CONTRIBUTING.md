# Contributing

## 入场前（每个 session 开始）

1. 读 `AGENTS.md` 理解导航地图
2. 读 `harness-progress.txt` 看当前进度（跨 session 外部记忆）
3. 读 `docs/status/harness-execution-status.md` 看任务卡状态
4. 读 `docs/knowledge/principles/operational-principles.md` 看 15 条执行纪律
5. 读 `docs/handoff/context-handoff.md` 最新条目看是否有未完成交接

## 工作流

1. 领取**单张**任务卡（禁止跨卡混改）— `docs/harness-engineering-task-cards.md`
2. 修改代码/文档并产出验证证据
3. 跑 `make verify`（不是单独的 `make lint` — verify 包含 lint+test+eval+policy 必过 + garden/principles advisory）
4. 更新 `docs/status/harness-execution-status.md`（任务卡状态列）
5. **追加**记录到 `harness-progress.txt`（不要覆盖历史）
6. 如阻塞或上下文不足，更新 `docs/handoff/context-handoff.md`（用模板填新条目）

## PR Minimum

- 必须包含 Task ID（`CARD-P*-*`）
- 必须包含命令输出 / 验证证据 / 风险说明 / 回滚方案
- 必须贴出 `make verify` 尾部输出
- 涉及知识库的 PR 必须基于权威来源（OpenAI Harness Engineering + Anthropic Engineering Blog）

## Do Not

- 不得跳过依赖任务卡
- 不得在无证据情况下标记 DONE
- 不得把"任务卡 DONE"等同于"feature 通过"（见 status doc 顶部澄清）
- 不得靠 `touch` 修复 garden 报告的 stale 文件（要真的更新内容）
- 不得为单次便利绕过 lint/principles（反馈应编码为新规则）

## 高影响变更（触发 ADR）

以下变更必须在 `docs/adr/` 新建 ADR：

- 改变架构分层（`Types→Config→...`）
- 改变任务卡 / feature 的语义
- 引入新的权威知识来源
- 工具链重大调整（如换 linter、改 Makefile 依赖结构）
- 安全模型变更（凭证/vault/proxy 边界）

参考现有 ADR：0001 任务卡驱动 / 0002 强制状态回写 / 0003 分阶段发布 / 0004 task DONE vs feature 通过。

## 知识库贡献

- 新笔记放 `docs/knowledge/sources/`，命名 `anthropic-<slug>-YYYY-MM-DD.md` 或 `openai-<slug>-YYYY-MM-DD.md`
- 提炼原则到 `docs/knowledge/principles/golden-rules.md`
- 项目操作纪律到 `docs/knowledge/principles/operational-principles.md`
- 更新 `docs/knowledge/README.md` 目录树
- 追加 `harness-progress.txt` 记录变更
