# Initializer Agent 示例

> 这是一个 Initializer Agent 的完整示例，展示 Harness Engineering "双 Agent 架构"中初始化阶段的工作方式。

## 工作流程

```
Initializer Agent 首次运行
  ├── 1. 执行 init.sh → 创建环境和进度文件
  ├── 2. 创建 feature_list.json（所有功能为 failing）
  ├── 3. 验证 CI 脚本可执行
  ├── 4. 创建初始 git commit
  └── 5. 输出下一步指引
```

## 文件说明

| 文件 | 说明 |
|------|------|
| `init.sh` | 初始化脚本 — 创建进度文件、验证环境 |
| `feature_list_template.json` | 功能清单模板 |

## 使用方式

```bash
cd examples/initializer-agent
./init.sh
```

## 关键原则

- **增量优先**：初始化只做环境搭建，不做功能实现
- **外部记忆**：进度记录在文件中，不依赖 Agent 内存
- **可验证**：每一步都有明确的成功/失败判断

## 参考

- `docs/knowledge/patterns/eval-patterns.md` — 评估模式详解
- `docs/knowledge/principles/golden-rules.md` — 十大黄金原则
