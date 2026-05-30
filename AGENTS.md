# AGENTS Entry Point

## First Read
1. `docs/harness-engineering-task-cards.md`
2. `docs/status/harness-execution-status.md`
3. `evals/feature_list.json`
4. `harness-progress.txt` (if exists)

## Mandatory Rules
- 一次只执行一张任务卡
- 每次状态变化必须回写状态总表
- 上下文不足必须写交接记录
- ⚠️ 增量优先：一次只做一个 feature，禁止 one-shot
- ⚠️ 独立验证：实现完成后必须用 `make eval` 验证
- ⚠️ 每次完成必须 git commit + 更新 harness-progress.txt

## Context Engineering Guidelines
- 上下文是稀缺资源：精简工具、精简 prompt
- Just-in-Time 检索：维护文件路径引用，运行时按需加载
- Progressive Disclosure：通过探索逐步发现上下文
- 绝对路径：所有文件操作使用绝对路径

## Current Phase
- 参考 `docs/status/harness-execution-status.md`
