# Addy Osmani Loop Engineering 审视笔记 (2026-09-14)

> 来源：https://addyosmani.com/blog/loop-engineering/
> 学习日期：2026-09-14
> 对比笔记：2026-08-17版本
>
> 结论：文章内容无变化，本次重新审视未发现新要点。

---

## 一、审视确认

连续五周（07-27、08-03、08-10、08-17、09-14）文章无变化。核心框架稳定：

- **五大构件 + 记忆**：Automations（心跳/发现+分诊）/ Worktrees（并行隔离）/ Skills（项目知识固化）/ Plugins+Connectors（MCP 接入真实工具）/ Sub-agents（maker-checker 分离）/ State（外部记忆，markdown 或 Linear）
- **/goal vs /loop**：/goal 运行到可验证停止条件成立，由独立小模型判定是否完成 —— maker-checker split 应用于停止条件本身
- **三个不变的问题**：验证责任仍在人（"done"是主张不是证明）、comprehension debt 随循环加速、cognitive surrender 风险
- **同一循环两人用结果相反**：循环放大使用者的判断力，不替代判断力

## 二、建议

文章已长期稳定，维持每两周一次的审视频率。关注点继续放在 Addy 的新文章（Software Factories、Own the Outer Loop 已于 08-17 学习）。
