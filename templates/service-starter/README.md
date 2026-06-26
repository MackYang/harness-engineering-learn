# Service Starter Template

> 模板用途：新服务从这里继承 harness-engineering 的默认配置。
> 状态：骨架（待业务项目接入时按 `docs/GUIDE_APPLY_TO_PROJECT.md` 具体化）

## 用法

```bash
# 复制到新服务仓库根目录
cp -r templates/service-starter/* /path/to/new-service/

# 然后按 GUIDE_APPLY_TO_PROJECT.md 第十章"文件级迁移详解"调整
```

## 应包含的文件清单（待业务接入时补全）

| 文件 | 用途 | 来源参考 |
|------|------|----------|
| `AGENTS.md` | 服务入口地图（~100 行） | 本仓库 `AGENTS.md` |
| `Makefile` | 统一命令入口（init/verify/eval） | 本仓库 `Makefile` |
| `evals/feature_list.json` | 服务功能清单 | 本仓库 `evals/feature_list.json` |
| `docs/status/` | 任务状态总表 | 本仓库对应目录 |
| `docs/handoff/` | 上下文交接 | 本仓库对应目录 |
| `.github/workflows/ci.yml` | CI 跑 `make verify` | 本仓库对应文件 |
| `harness/skills/` | 项目知识编码（SKILL.md） | Loop Engineering LP-3 |
| `harness/plugins/` | 跨项目分发包（Skill+Connector 打包） | Loop Engineering LP-4 |

## Skill vs Plugin

- **Skill** = 创作格式。单个项目的知识编码，存放在 `harness/skills/<name>/SKILL.md`
- **Plugin** = 分发格式。打包 Skills + Connectors，跨项目一键安装

当多个服务需要共享同一套 Skill 时，应将其提升为 Plugin。

## 不要直接复制的

- `docs/knowledge/` — 知识库集中在本学习仓库，业务仓库只引用
- `docs/GUIDE_APPLY_TO_PROJECT.md` — 接入指南，业务仓库不需要
- 任何带 `CARD-P*-*` 标记的任务卡 — 这些是本仓库的执行记录

## 相关

- 接入流程：`docs/GUIDE_APPLY_TO_PROJECT.md`
- CARD-P4-02：Golden Path 设计
- 复用度量：`docs/scaling/reuse-metrics.md`
