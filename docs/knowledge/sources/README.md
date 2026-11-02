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
| 2026-11-02 | OpenAI | openai-harness-engineering-2026-11-02.md | 审视：正文无变化（12 周稳定）；细读补录 2 个遗漏细节（attractive nuisance、800ms/2s SLO prompt 示例）→ golden-rules 补充 K/L |
| 2026-11-02 | Anthropic | anthropic-engineering-new-2026-11-02.md | ⚠️ 无新文章，但发现 **managed-agents 于 10-30 被重写**（首次捕获重写事件）；索引快照升级 v2（含 _updatedAt） |
| 2026-11-02 | Anthropic | anthropic-managed-agents-rewrite-2026-11-02.md | **全新深读**：重写版新增 assumptions-go-stale 框架、context-anxiety 生命周期实证（Sonnet 4.5→Opus 4.5 dead weight）、meta-harness 主旨、攻击链放大机制；golden-rules 补充 M（三源印证）+ FEAT-075 |
| 2026-11-02 | Anthropic | anthropic-engineering-index-snapshot-2026-11-02.md | **基础设施升级**：快照 v2 含 `_updatedAt` 字段，可检测已发布文章的重写 |
| 2026-11-02 | Addy Osmani | addy-loop-engineering-2026-11-02.md | 审视：无变化（13 周稳定）；补录 4 个细节（无发现自动归档、/goal pause-resume-clear、boring description 准则、subagent reasoning-effort 配置） |
| 2026-11-02 | Addy Osmani | addy-agent-harness-engineering-2026-11-02.md | 审视：小幅更新（context-anxiety 表述与 Anthropic 互证，版本表述差异记录）；**文末 Related reading 成为新文章发现渠道**；作者 bio 确认 Anthropic MTS（Claude Code 团队） |
| 2026-11-02 | Addy Osmani | addy-brownfield-agentic-engineering-2026-11-02.md | **全新深读**：Zones 分级自治（绿/黄/红 + 三条操作规则）、characterization-test-first、迁移完整性判据、大迁移案例结构可迁移；FEAT-076/077 |
| 2026-11-02 | Addy Osmani | addy-agentic-skill-decay-2026-11-02.md | **全新深读**：reps 刻意化、dual-loop learning、Anthropic Trio 学习实验（50% vs 67%）+ 40 万会话专长研究、verification is the floor imagination is the ceiling；FEAT-078 |
| 2026-11-02 | Addy Osmani | addy-audit-your-agent-files-2026-11-02.md | **全新深读**：配置半衰期、Ratchet 减法节奏（/doctor 2-4 周 + 删除实验）、三项研究转译（个人 skill ≤ 通用 skill；context files 不提升正确性但优化行为；散文摘要 4/45 vs 源码 27/45）；FEAT-079 |
| 2026-11-02 | Addy Osmani | addy-human-judgment-relocates-2026-11-02.md | **全新深读**：判断重定位论、factory 门槛判断、四态 run 分类 + per-stage timing 成本可见性、verification budget、autonomy 阶梯；FEAT-080 |
| 2026-06-29 | OpenAI | openai-harness-engineering-2026-06-29.md | 零手动代码原则、脚手架纪律 |
| 2026-06-29 | Anthropic | anthropic-engineering-new-2026-06-29.md | 代理安全架构、大脑-手-会话解耦 |
| 2026-06-29 | Addy Osmani | addy-osmani-loop-agent-harness-2026-06-29.md | Loop Engineering 五大构件、Agent Harness 系统 |
| 2026-07-23 | Anthropic | anthropic-claude-containment-2026-07-23.md | 补充：已批准域外泄、EDR不可见、MCP安全、持久化内存中毒、多代理信任升级 |
| 2026-07-23 | Addy Osmani | addy-agent-harness-engineering-2026-07-23.md | 补充：HaaS完整概念、行业收敛、三个开放问题、Sprint Contract |
| 2026-07-23 | OpenAI | openai-harness-engineering-2026-07-23.md | 审视：Ralph Wiggum Loop引用、无聊技术三维度、最小化阻塞门控 |
| 2026-07-23 | Addy Osmani | addy-loop-engineering-2026-07-23.md | 审视：/goal停止条件验证、认知投降、人类审查带宽天花板 |
| 2026-07-27 | Anthropic | anthropic-claude-containment-2026-07-27.md | 深度：Cowork VM六层隔离、Full-VM→Host演进、Opus 4.7数据、canary string |
| 2026-08-10 | OpenAI | openai-harness-engineering-2026-08-10.md | 审视：无变化，连续三周确认稳定 |
| 2026-08-10 | Anthropic | anthropic-engineering-new-2026-08-10.md | 审视：无新文章，连续五周无更新 |
| 2026-08-10 | Addy Osmani | addy-loop-engineering-2026-08-10.md | 审视：无变化，连续三周确认稳定 |
| 2026-08-10 | Addy Osmani | addy-agent-harness-engineering-2026-08-10.md | 审视：无变化，连续三周确认稳定 |
| 2026-08-17 | OpenAI | openai-harness-engineering-2026-08-17.md | 审视：无变化，连续四周确认稳定 |
| 2026-08-17 | Anthropic | anthropic-engineering-new-2026-08-17.md | 审视：无新文章，连续六周无更新 |
| 2026-08-17 | Addy Osmani | addy-loop-engineering-2026-08-17.md | 审视：无变化，连续四周确认稳定 |
| 2026-08-17 | Addy Osmani | addy-agent-harness-engineering-2026-08-17.md | 审视：无变化，连续四周确认稳定 |
| 2026-08-17 | Addy Osmani | addy-software-factories-2026-08-17.md | **全新**：Software Factories 三层架构、Back Pressure、Light/Dark Factory、图vs循环 |
| 2026-08-17 | Addy Osmani | addy-own-the-outer-loop-2026-08-17.md | **全新**：Outer Loop Ownership、Quality→Verdict→Answerability、信任-验证缺口、High Agency |
| 2026-09-14 | OpenAI | openai-harness-engineering-2026-09-14.md | 审视：无变化，连续五周确认稳定 |
| 2026-09-14 | Anthropic | anthropic-engineering-new-2026-09-14.md | 审视：无新文章，连续七周无更新（时隔近一个月首检） |
| 2026-09-14 | Addy Osmani | addy-loop-engineering-2026-09-14.md | 审视：无变化，连续五周确认稳定 |
| 2026-09-14 | Addy Osmani | addy-agent-harness-engineering-2026-09-14.md | 审视+补录：正文无变化，全文复读发现 2 个遗漏引用（Böckeler 综述、Fareed Khan 架构解构），新增 FEAT-065 |
| 2026-09-21 | OpenAI | openai-harness-engineering-2026-09-21.md | 审视：无变化，连续六周确认稳定 |
| 2026-09-21 | Anthropic | anthropic-engineering-new-2026-09-21.md | 审视：无新文章，连续八周无更新 |
| 2026-09-21 | Addy Osmani | addy-loop-engineering-2026-09-21.md | 审视：无变化，连续六周确认稳定 |
| 2026-09-21 | Addy Osmani | addy-agent-harness-engineering-2026-09-21.md | 审视+跟进闭环：正文无变化；09-14 预留的 Böckeler 精读已完成 |
| 2026-09-21 | Böckeler | boeckeler-harness-engineering-2026-09-21.md | **全新精读**：Feedforward/Feedback × Computational/Inferential 矩阵、三类调节对象、Harnessability、覆盖度开放问题，新增 FEAT-066~069 |
| 2026-10-05 | OpenAI | openai-harness-engineering-2026-10-05.md | 审视：无变化，连续八周确认稳定；关键结构复核 + 数据点抽检维持无遗漏结论 |
| 2026-10-05 | Anthropic | anthropic-engineering-new-2026-10-05.md | 审视：无新文章，连续十周无更新 |
| 2026-10-05 | Addy Osmani | addy-loop-engineering-2026-10-05.md | 审视：无变化，连续八周确认稳定 |
| 2026-10-05 | Addy Osmani | addy-agent-harness-engineering-2026-10-05.md | 审视：无变化，连续八周确认稳定；核心概念清单复核 + 引用状态复核 |
| 2026-10-12 | OpenAI | openai-harness-engineering-2026-10-12.md | 审视+遗漏修补：正文无变化（连续九周稳定），细粒度复核发现 **Parse, don't validate** 遗漏，补入 golden-rules 补充细节 H |
| 2026-10-12 | Anthropic | anthropic-engineering-new-2026-10-12.md | 审视：无新文章，连续十一周无更新 |
| 2026-10-12 | Addy Osmani | addy-loop-engineering-2026-10-12.md | 审视：无变化，连续九周确认稳定；核心框架清单复核 |
| 2026-10-12 | Addy Osmani | addy-agent-harness-engineering-2026-10-12.md | 审视：无变化，连续九周确认稳定；核心概念清单复核 + 引用状态复核 |
| 2026-10-26 | OpenAI | openai-harness-engineering-2026-10-26.md | 审视：无变化，连续十一周稳定；建议降频为每月深读 |
| 2026-10-26 | Anthropic | anthropic-engineering-new-2026-10-26.md | 审视：无新文章（最新仍为 10-13 Scion）；Antique 专文未发布，继续盯防 |
| 2026-10-26 | Anthropic | anthropic-engineering-index-snapshot-2026-10-26.md | **基础设施改进**：首次提取完整文章索引（54 篇）固化快照，后续对比改为 diff 快照 |
| 2026-10-26 | Addy Osmani | addy-loop-engineering-2026-10-26.md | 审视：无变化，连续十一周稳定；五构件映射验证本 cron 任务本身即最小 Loop 实例 |
| 2026-10-26 | Addy Osmani | addy-agent-harness-engineering-2026-10-26.md | 审视：无变化；Ratchet 原则实践——Anthropic 页面解析摩擦固化为索引快照 |
| 2026-10-19 | OpenAI | openai-harness-engineering-2026-10-19.md | 审视：无变化，连续十周确认稳定；原则 8 获 Scion 文章双源印证 |
| 2026-10-19 | Anthropic | anthropic-engineering-new-2026-10-19.md | ⚠️ **新文章**：Redesigning source control（Scion），终结连续十一周无更新 |
| 2026-10-19 | Anthropic | anthropic-source-control-scion-2026-10-19.md | **全新深读**：Scion 六原则、200x 基础设施缩减、意图级评审、Superfans 运维模式、merge queue 在 agent 规模失效，新增 FEAT-071~074 |
| 2026-10-19 | Addy Osmani | addy-loop-engineering-2026-10-19.md | 审视：无变化，连续十周确认稳定；Superfans 验证 Automations 构件普适性 |
| 2026-10-19 | Addy Osmani | addy-agent-harness-engineering-2026-10-19.md | 审视：无变化，连续十周确认稳定；"harness 不缩小只移动"在基础设施层再现 |
| 2026-08-03 | Anthropic | anthropic-claude-code-quality-postmortem-2026-08-03.md | **全新**：Claude Code 3个质量退化问题（effort默认值、缓存bug、提示词bug）及修复措施 |
| 2026-07-27 | OpenAI | openai-harness-engineering-2026-07-27.md | 审视：无更新，重新确认核心要点 |
| 2026-07-27 | Addy Osmani | addy-loop-engineering-2026-07-27.md | 审视：无更新，重新确认五大构件 |
| 2026-07-27 | Addy Osmani | addy-agent-harness-engineering-2026-07-27.md | 审视：无更新，重新确认 Harness 构件清单 |

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

*最后更新：2026-10-26*