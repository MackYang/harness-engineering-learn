# 认知风险：Loop Engineering 中人的维度

> 来源: Addy Osmani — [Loop Engineering](https://addyosmani.com/blog/loop-engineering/) (2026-06-07)
> 定位: Loop Engineering 不是删除人类，而是改变工作方式。三种风险如果不主动管理，会导致灾难。

## 三大认知风险

### 1. 验证责任不能外包

**核心观点**: "done" 是 Agent 的声明，不是证明。Loop 运行无人看管 = Loop 在无人看管地犯错。

**缓解措施**:
- 分离 Maker/Checker（Golden Rule #13 + LP-5）
- 人类必须定期审查 Loop 产出的代码
- 验证强度递进：prompt 检查 → /goal 条件 → hook 门控 → 验证子 agent

**检查**: 你上次读 Loop 产出的代码是什么时候？

### 2. 理解力萎缩（Comprehension Debt）

**核心观点**: Loop 越快地生产你没写的代码，你理解现有代码的差距就越大。

**类比**: 就像用计算器做数学 — 你得到正确答案，但如果不练习，你失去理解过程的能力。

**缓解措施**:
- 定期阅读 Loop 产出（不只是看 diff，理解为什么）
- 对关键修改做 walkthrough（即使 Loop 说它已经验证了）
- 保持对架构的心智模型更新
- 设置"理解预算"：每周至少花时间理解 N 个 Loop 产出的变更

**检查**: 如果 Loop 突然停工，你能接手吗？

### 3. 认知投降（Cognitive Surrender）

**核心观点**: 最危险的姿态不是 Loop 做错了什么，而是你停止思考。当 Loop 自己运行时，很容易放弃判断力。

**Addy 的原话**:
> The same action, opposite result. Designing the loop is the cure when you do it with judgement, and the accelerant when you do it to avoid thinking.

**关键区分**:
- ✅ 用 Loop 加速你**深刻理解**的工作
- ❌ 用 Loop 逃避你**不愿理解**的工作
- Loop 不知道区别。**你知不知道。**

**缓解措施**:
- 对每个 Loop 的输出保持"有观点的人类"角色
- 不要全盘接受，要质疑和验证
- 定期评估：Loop 是在放大你的能力，还是在替代你的判断？

## 实践建议

1. **审查节奏**: 每日审查 Loop 的 Triage inbox
2. **理解审计**: 每周挑 2-3 个 Loop 产出做完整 walkthrough
3. **能力检查**: 每月问自己"如果 Loop 停工一周，我能跟上吗？"
4. **认知健康指标**: 追踪你主动理解 vs 被动接受的比例

## 相关概念

- **Intent Debt** — Agent 每次冷启动时空洞猜测，意图没有编码 → [addyosmani.com/blog/intent-debt](https://addyosmani.com/blog/intent-debt/)
- **Orchestration Tax** — 编排成本，人类审查带宽是并行上限 → [addyosmani.com/blog/orchestration-tax](https://addyosmani.com/blog/orchestration-tax/)
- **Adversarial Code Review** — 对抗性审查，分离生成和验证 → [addyosmani.com/blog/adversarial-code-review](https://addyosmani.com/blog/adversarial-code-review/)

---

*最后更新：2026-06-26*
