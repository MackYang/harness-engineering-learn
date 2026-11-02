# Addy Osmani Loop Engineering 审视笔记 (2026-11-02)

> 来源：https://addyosmani.com/blog/loop-engineering/
> 学习日期：2026-11-02
> 对比笔记：2026-10-26 版本
>
> 结论：文章正文无变化（连续十三周稳定），核心框架复核无遗漏。本次细读补录 4 个此前未捕获的细节。

## 一、审视确认

- 五大构件 + State、/goal 双工具一致、三个越循环越尖锐的问题、核心命题（杠杆点移动 / 同一循环相反结果 / loop 设计比 prompt 工程更难）：均已覆盖 ✅

## 二、本次新发现的遗漏细节（4 项）

1. **Automations "无发现自动归档"**：Codex Automations 的 runs "that find nothing just archive themselves"——发现进 Triage inbox，无发现自归档，人只处理有信号的运行（07-20 笔记提过 archive 但未与 inbox 机制连起来讲）
2. **/goal 运行时控制**：Codex 版 /goal 支持 **pause / resume / clear**——停止条件之外还有运行时生命周期管理，这是此前笔记未记录的
3. **Skill 描述写作准则**："a **tight boring description beats a clever one**"——因为 skill 靠任务匹配隐式触发，描述的匹配准确性比表达力重要。与 OpenAI "boring technologies" 形成跨来源呼应：boring 在两个层面都是美德（技术选型 + 描述写作）
4. **Sub-agent 规格化的安全实例**：Codex 的 `.codex/agents/` TOML 支持 **reasoning effort 配置**——"your security reviewer can be a strong model on high effort while your explorer is some fast read-only thing"。安全审查员配强模型高推理、探索员配快模型只读，这是 maker/checker 分离的资源配置维度（此前只记录了角色分离，未记录模型/推理力度/只读权限的配置自由度）

## 三、维护纪律说明

- 本文连续十三周无变化。与 OpenAI 篇同步执行降频策略：每周核对 + 每月细读
- 本次 4 个细节的价值密度高于上周（0 个），证明"稳定≠无矿"，但同也证明边际递减——下月细读预期收益更低

## 四、交叉观察

- 本周 Anthropic managed-agents 重写 + Addy agent-harness-engineering 的 context-anxiety 更新，恰好验证了 Loop Engineering 的 State 构件思想：**知识源不是快照而是活文档**，本知识库的"dated 笔记 + 索引快照 diff"正是对抗源漂移的最小 State 实现
