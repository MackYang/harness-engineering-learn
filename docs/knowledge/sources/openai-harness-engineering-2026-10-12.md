# OpenAI Harness Engineering 审视笔记 (2026-10-12)

> 来源：https://openai.com/index/harness-engineering/
> 学习日期：2026-10-12
> 对比笔记：2026-10-05版本
>
> 结论：文章内容无变化，但本次对照原文细粒度复核发现 1 个遗漏要点，已补入 golden-rules.md。

---

## 一、审视确认

全文与 2026-10-05 版本逐段比对一致，连续九周（07-27 起）确认稳定。

## 二、本次新发现（遗漏修补）

### H. Parse, don't validate（在边界解析数据形状）

原文："we require Codex to parse data shapes at the boundary, but are not prescriptive on how that happens (the model seems to like Zod, but we didn't specify that specific library)"

要点拆解：
- **强制"边界解析"不变式**：数据进入系统时必须在边界处解析/校验其形状，禁止 Agent 在代码内部"YOLO 式探测"（原文别处："we don't probe data YOLO-style—we validate boundaries or rely on typed SDKs so the agent can't accidentally build on guessed shapes"）
- **约束不变式 vs 微观管理实现的又一次体现**：只规定"必须边界解析"，不规定用什么库（Codex 自己选了 Zod，团队并未指定）
- **与原则 14（错误防御工具设计）、golden principles 之(2) 同源**：三者共同构成"让 Agent 无法建立在猜测之上"的防御纵深——工具层强约束、边界层强解析、原则层禁 YOLO

→ 已补入 `principles/golden-rules.md` 补充细节 H。

## 三、其余复核结果

- 数据点（1,500 PR / 3→7 人 / 3.5 PR/人/天 / 百万行 / 6 小时单任务 / Aardvark）：均已覆盖 ✅
- 九大要点清单（零手动代码、AGENTS.md 目录化、固定层级架构、per-worktree 可观测性、GC 式偿债、端到端自主、最小阻塞门控、Ralph Loop、枯燥技术）：均已覆盖 ✅

## 四、建议

维持每两周一次审视频率。下一个可能的增量点：文中若更新 "Aardvark" 相关表述或自主性清单条目数变化。
