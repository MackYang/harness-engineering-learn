# Examples — Harness Engineering 实战案例

> 可运行的示例代码，展示 Harness Engineering 核心模式的落地方式

## 目录

| 示例 | 说明 | 核心原则 |
|------|------|----------|
| [initializer-agent](./initializer-agent/) | Initializer Agent 环境初始化 | 增量优先、外部记忆 |
| [coding-agent](./coding-agent/) | Coding Agent 增量式实现 | 一次一个 feature |
| [eval-loop](./eval-loop/) | Generator-Evaluator 评估循环 | Generator ≠ Evaluator |

## 快速体验

```bash
# 1. 运行初始化
cd examples/initializer-agent
chmod +x init.sh && ./init.sh

# 2. 查看生成的进度文件
cat ../../harness-progress.txt

# 3. 查看功能清单模板
cat feature_list_template.json
```

## 与项目主结构的关系

这些示例是项目核心模式的简化版本：

| 示例 | 对应项目文件 |
|------|-------------|
| `initializer-agent/init.sh` | `scripts/harness/init.sh` |
| `feature_list_template.json` | `evals/feature_list.json` |
| 评分逻辑 | `evals/scorers/multi_grader.sh` |

## 学习路径

1. 先读 `initializer-agent/README.md` → 理解环境初始化
2. 再读 `coding-agent/README.md` → 理解增量实现
3. 最后读 `eval-loop/README.md` → 理解评估闭环
