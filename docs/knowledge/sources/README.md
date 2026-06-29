# 知识笔记目录

本文档收录了来自 Harness Engineering 权威来源的知识笔记。

## 📚 知识来源

### ⭐ 权威知识来源（同等重要）

本项目的核心知识来自以下三个官方来源：

1. **OpenAI — Harness Engineering**
   - 链接：https://openai.com/index/harness-engineering/
   - 核心内容：零手动代码原则、脚手架纪律、品味编码、自主性进化

2. **Anthropic Engineering Blog**
   - 链接：https://www.anthropic.com/engineering
   - 核心内容：代理Harness设计、安全架构、长期运行应用、上下文工程

3. **Addy Osmani — Loop & Agent Harness Engineering**
   - 链接：https://addyosmani.com/blog/
   - 核心内容：Loop Engineering 五大构件、Agent Harness 系统实践

## 📁 文件命名规范

知识笔记文件遵循以下命名规范：

```
{source}-{topic}-{date}.md
```

其中：
- `source`: 来源名称（如 `openai`, `anthropic`, `addy-osmani`）
- `topic`: 主题名称（如 `harness-engineering`, `loop-engineering`）
- `date`: 学习日期（YYYY-MM-DD 格式）

## 🗓️ 学习历史

| 日期 | 来源 | 文件名 | 主要内容 |
|------|------|--------|----------|
| 2026-06-29 | OpenAI | openai-harness-engineering-2026-06-29.md | 零手动代码原则、脚手架纪律 |
| 2026-06-29 | Anthropic | anthropic-engineering-new-2026-06-29.md | 代理安全架构、大脑-手-会话解耦 |
| 2026-06-29 | Addy Osmani | addy-osmani-loop-agent-harness-2026-06-29.md | Loop Engineering 五大构件、Agent Harness 系统 |

## 📋 更新流程

1. **每周更新**：根据 cron workflow 提醒，定期学习最新内容
2. **对比分析**：对比已有笔记，识别新内容
3. **提取要点**：提取核心概念和最佳实践
4. **更新项目**：将新知识应用到 feature_list.json 和其他项目文件
5. **验证确认**：运行 `make verify` 确保一切正常
6. **版本控制**：使用 git 提交更新

## 🔍 查找方法

### 按来源查找

```bash
# 查找 OpenAI 相关笔记
find /home/yh/projects/Learn/harness-engineering-learn/docs/knowledge/sources -name "*openai*"

# 查找 Anthropic 相关笔记
find /home/yh/projects/Learn/harness-engineering-learn/docs/knowledge/sources -name "*anthropic*"

# 查找 Addy Osmani 相关笔记
find /home/yh/projects/Learn/harness-engineering-learn/docs/knowledge/sources -name "*addy*"
```

### 按主题查找

```bash
# 查找 Loop Engineering 相关笔记
find /home/yh/projects/Learn/harness-engineering-learn/docs/knowledge/sources -name "*loop*"

# 查找安全相关笔记
grep -r "security" /home/yh/projects/Learn/harness-engineering-learn/docs/knowledge/sources/
```

### 按日期查找

```bash
# 查找指定日期的笔记
find /home/yh/projects/Learn/harness-engineering-learn/docs/knowledge/sources -name "*2026-06-29"
```

## 🎯 学习重点

每次学习时重点关注以下方面：

### OpenAI Harness Engineering
- 零手动代码原则的最新应用
- 脚手架纪律的改进
- 品味编码的新实践
- 自主性进化的最新进展

### Anthropic Engineering
- 代理安全架构的新方法
- 长期运行应用的优化
- 上下文工程的改进
- 多代理协调的新模式

### Addy Osmani
- Loop Engineering 五大构件的扩展
- Agent Harness 系统的演进
- 循环设计的新模式
- 实践案例的更新

## 📊 知识体系演进

本项目采用渐进式知识积累方式，每次更新都：

1. **保持完整性**：确保新知识不与旧知识冲突
2. **强调实用性**：优先提取可落地的工程实践
3. **维护一致性**：保持知识格式和风格统一
4. **促进应用**：将新知识转化为具体的 feature 和改进

---

*最后更新：2026-06-29*