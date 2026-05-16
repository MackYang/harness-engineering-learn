# Assets Library（CARD-P5-01）

更新时间：2026-05-16（UTC+8）

## 1. 目标
跨项目沉淀并复用 Harness 资产，减少重复建设，提升新项目接入效率。

## 2. 目录规范
- `templates/`：服务脚手架与工程模板
- `policy/`：策略规则与策略说明
- `evals/`：评测数据集与评分器
- `runbooks/`：执行手册与运维流程
- `asset-manifest.yaml`：统一资产清单（ID、版本、来源、owner）

## 3. 版本规范
- 资产版本采用 `v<major>.<minor>.<patch>`。
- 新增资产：`minor +1`
- 兼容性破坏：`major +1`
- 文档或注释修订：`patch +1`

## 4. 使用方式
1. 从 `asset-manifest.yaml` 选择可复用资产。
2. 按条目中的 `source_path` 获取源文件。
3. 在项目接入记录中登记复用条目与比例。

## 5. 当前资产
见 [`asset-manifest.yaml`](asset-manifest.yaml)。
