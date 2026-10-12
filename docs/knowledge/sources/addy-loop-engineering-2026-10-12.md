# Addy Osmani Loop Engineering 审视笔记 (2026-10-12)

> 来源：https://addyosmani.com/blog/loop-engineering/
> 学习日期：2026-10-12
> 对比笔记：2026-10-05版本
>
> 结论：文章内容无变化，连续九周（07-27 起）稳定，本次未发现新要点。

---

## 一、审视确认

核心框架复核（对照 2026-10-05 清单）：

- **五大构件 + 第六件**：Automations（心跳：发现+分诊按计划自跑）/ Worktrees（并行隔离，机械碰撞归零但编排税仍在——你是天花板）/ Skills（项目知识固化，intent 写一次复利）/ Plugins+Connectors（MCP 打通真实工具，loop 才能行动而非口头建议）/ Sub-agents（maker/checker 分离，验证者是你能走开的唯一理由）+ State（对话外记忆：markdown/Linear，agent 会忘，repo 不会）✅
- **/goal 双工具一致**：独立小模型每轮判定停止条件——maker/checker 分离应用到停止条件本身 ✅
- **三个越循环越好反而越尖锐的问题**：验证责任（"done"是主张不是证明）/ comprehension debt（循环越顺滑差距涨得越快）/ cognitive surrender（同一动作，判断的解药或逃避的加速剂）✅
- **核心命题**：杠杆点从 prompting 移到 loop 设计；同一循环两个人用出相反结果——工具不知道差别，你知道；loop 设计比 prompt 工程更难而非更易 ✅

## 二、与本周其他来源的交叉核验

Steinberger / Cherny 引语、Codex Automations tab / Triage inbox、Subagents TOML 等引用与上周一致，无产品迭代导致映射表过时的迹象。

## 三、建议

维持每两周一次审视频率。
