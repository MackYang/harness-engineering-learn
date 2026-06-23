# ADR-0004: 区分"任务卡 DONE"与"feature 通过"，garden/principles 改为 advisory

- Status: Accepted
- Date: 2026-06-23

## Context

第一轮审计发现三类系统性问题：

1. **语义混淆**：`docs/status/harness-execution-status.md` 报 32/32 任务卡 DONE，但 `evals/feature_list.json` 只有 2/38 feature 通过（5%）。任务卡衡量"项目脚手架完成度"，feature 衡量"Harness 行为真实通过"，两者长期被混用导致认知失调。

2. **检查工具跨平台 bug**：`scripts/ci/doc_gardening.sh` 用 GNU `date -d`，在 macOS（BSD date）下失败导致所有文件报 20627 天 stale；旧 ci.yml 不跑 garden 所以从未发现。

3. **advisory vs gating 错位**：`Makefile` 把 garden 作为 verify 硬依赖，但 30 天 stale 阈值在长期项目上误伤；同时 principles 又用 `-` 前缀 advisory，逻辑不一致。

4. **operational principles 无正式归属**：项目自身的 15 条执行纪律只在 README/AGENTS.md 散落，未进入知识库；知识库 grader 想检查也找不到。

## Decision

1. **明确双轨语义**：在 `harness-execution-status.md` 顶部加"语义澄清"段，明确任务卡和 feature 是独立轨道，附对照表。
2. **修复跨平台 bug**：garden 改用 `git log --format=%ct`（Unix 时间戳），不再依赖系统 `date -d`。
3. **garden 与 principles 统一为 advisory**：Makefile 用 `-` 前缀调用两者，不阻塞 verify；CI 跑 `make verify` 但 advisory 失败不挂构建。
4. **新增 operational-principles.md**：把项目自身的 15 条执行纪律抽到 `docs/knowledge/principles/operational-principles.md`，与 `golden-rules.md`（来源原则）互补；AGENTS.md 导航同步更新。

## Consequences

正面：
- "DONE" 不再被误读为"production-ready"；评估真实能力必须查 `feature_list.json`
- `make verify` 在 macOS 和 Linux 都能跑通；CI 暴露的问题更准确
- 项目级原则有了正式归属，未来 review 反馈有地方沉淀
- garden 报告的 stale 文件仍可见，但不强制修复（长期项目可能合理 stale）

负面 / 取舍：
- advisory 化意味着 garden/principles 不再是硬门禁；需要团队自律定期查看报告
- operational-principles.md 与 golden-rules.md 的边界需要维护者持续区分（前者是"项目怎么做"，后者是"来源怎么说"）

## Alternatives Considered

- **方案 A：保持现状，只改 README 描述** — 治标不治本，工具 bug 还在，CI 切换到 `make verify` 时立刻爆
- **方案 B：把所有带"后续"占位的任务卡改回 IN_PROGRESS** — 扰动大且语义不对（脚手架确实完成，只是后续要替换占位）；正确做法是把"占位债"显式列在 status doc 单独段
- **方案 C：拆分 status doc 为 scaffolding-status.md + feature-status.md 两个文件** — 增加导航成本；当前顶部澄清段 + feature_list.json 已足够区分
- **方案 D：grader 改成搜全仓库而不是只搜 docs/knowledge/** — 错误方向；正确做法是把项目原则真正放进知识库
