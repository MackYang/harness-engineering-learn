# Addy Osmani：Audit your Agent files 深读笔记 (2026-11-02)

> 来源：https://addyosmani.com/blog/audit-your-agent-files/
> 发布：2026-08-27（从 agent-harness-engineering 文末 Related reading 发现）
> 学习日期：2026-11-02
> 定位：**全新文章，首次学习**。主题：agent 配置的半衰期与定期审计

## 一、核心命题

> "Your coding agent's configuration has a half-life."

模型改进、harness 加能力、代码库变化——为旧版本写的指令被留在原地。官方建议是每隔几个月**整个删掉 CLAUDE.md/skills/hooks 重建**，但人们怕删了质量崩盘又没有快速恢复手段。Addy 的务实替代：**定期 /doctor + 逐条让指令重新挣得位置**。

## 二、为什么 agent 配置会腐烂（含实证数据）

- 每见 agent 跑偏就加一条规则 → 文件膨胀 → 遵循度下降 → 加更多 → 质量更差（**越加越差的死亡螺旋**）
- 把决策指南写成了知识库是经典错误
- **2026-06 研究（100 个热门仓库，arxiv 2606.15828）**：lint 相关泄漏 62%、context bloat 42%、skill leakage 35%；多数文件至少有一个配置 smell；普遍超过 Anthropic 200 行指引，有的上千行
- **Anthropic "new rules of context engineering"**：为 Claude 5 代模型**删除了 Claude Code 系统提示的 80%+**，内部编码评估无可测损失。注意边界：非公开 eval、特定模型+harness——教训是"指令价值会过期"而非"删 80% 是目标"
- 策略：**archive first**；必须永远成立的规则 → 编码进 test / hook / permission，别留在模型可能丢失的散文里

## 三、个性化 skills 有用吗（研究转译）

- **arxiv 2608.10319**：从个人交互历史提取的"个人 skill"表现 ≈ 借用别人的 skill；**从大量开发者聚合的通用 skill 总体更有用**
- 个性化何时有价值：同一偏好在多个相似任务中反复出现（但该实验用 LLM 模拟开发者，是"promising 而非 final"）
- Skills 增加价值的真正条件：**具体任务的丰富示例与特异性**（如 scheduling 的各种怪癖），而非"我偏好这样的格式"
- **Addy 的实践准则：从强通用 skill 起步，渐进添加个人规则；提过一次的偏好不足以晋升为永久 agent 记忆**
- 企业视角：个人 skill 有用，但团队/org 级 skill 集才有复利——工程文化、合规、品牌、内部工具怪癖、跨人跨 agent 一致性

## 四、Context files 有用吗（研究转译）

- **arxiv 2607.27250**（288 runs × 17 真实任务，Claude Code + Codex）：AGENTS.md/CLAUDE.md 对**正确性没有明确差异**——但改变了 agent 的工作方式（例：文件警告测试套件慢 → agent 跑更有针对性的测试，少浪费时间）
- 有用/无用的分界：
  - ✅ 能教：贵命令在哪、生成文件在哪、架构边界、项目安全规则、如何跑对的检查
  - ❌ 不能教：微妙的设计决策（near-miss 都卡在实现判断上，更多仓库散文救不了）
- **arxiv 2607.09691**：散文摘要只答对 45 个代码行为问题中的 4 个，源代码本身答对 27 个——**摘要抹平了重要的小细节，指向真代码而非代码描述**

## 五、Addy 自己的审计发现

- Claude Code 的 **/doctor**（session 内）= 配置审计：未使用 skills/MCP/plugins（对照其 context 成本）、过度规定的 CLAUDE.md、慢 hooks、cruft
- 命名陷阱：shell 里 `claude doctor` 只打印安装诊断——有人误报 doctor"只显示状态"就是这个原因
- 自己的案例：4-5 个月前试的一堆 anti-slop 写作 skills 全忘了还装着——它们互相触发吗？谁优先？还是全被忽略？不知道 = 未管理的干扰
- 推友案例：审计后 250 skills → 25。实验性社区 skill 会随时间复利堆积
- **"Installing a useful skill and keeping it forever are separate decisions."**（装一个有用的 skill 和永远保留它是两个决定）
- memory 也单独审（/memory）：auto-memory 可能存着过时偏好，即使项目文件已整洁

## 六、质量审计与装载机制

- Anthropic Skill Creator 现含 evals 和 benchmark mode 查质量
- 装载事实澄清：skill 不是全量进每个 prompt——名称和描述在**listing budget**（默认 context window 的 1%）内做发现，正文调用时才加载。所以 skill 的边际成本主要在描述条目，但堆积仍污染发现通道
- 社区已有 SKILL.md 质量检查器（描述/触发器/步骤/示例）和安全审计器

## 七、Audit on a cadence, then test removal

节奏：**每 2-4 周跑一次 /doctor**；有余力做删除实验——指示 agent"完全不用本地 skills，只用裸模型+harness 完成任务"，看是否真的不行。很多时候你会发现自己靠 skills 当拐杖，是因为不信任模型和 harness 已经变好——而这份不信任本身可能过期了。

## 八、与既有知识库的连接

- **Ratchet 的另一半**：Ratchet 讲"只加挣得的规则"，本文讲"定期质询已有规则是否还挣得位置"——加法纪律 + 减法节奏 = 完整的配置生命周期
- Harness 不缩小只移动 → 配置层的表现形式就是半衰期与审计
- managed-agents 重写（本周）→ "assumptions go stale" 在个人配置层的同构
- **新增候选 feature**：FEAT-079（配置审计节奏：定期对 AGENTS.md/skills 做删除实验）
- 本项目自身动作：harness-progress.txt 已接近需要审计的体量，AGENTS.md 维持精简
