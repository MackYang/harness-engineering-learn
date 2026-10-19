# Anthropic 新文章深读笔记：Redesigning source control at Anthropic (Scion)

> 来源：https://www.anthropic.com/engineering/redesigning-source-control
> 学习日期：2026-10-19
> 文章时间：2026-10 中旬发布（正文标注 "Updated October 15"）——**终结连续十一周无新文章的记录**
> 与 Harness Engineering 的关系：Anthropic 用 Claude 大规模写代码后，瓶颈从"写代码"移动到"为人类规模设计的基础设施"（source control / builds / CI），被迫重构版本控制。这是 OpenAI 原则 8（吞吐量改变合并哲学）在基础设施层的直接延伸与数据印证。

---

## 一、核心论点

**编程不再是瓶颈，为人类规模设计的基础设施才是。**

- Anthropic 内部合并量：2026 年 5 月约 **2,500 次/天** → 9 月 **30,000+ 次/天**（4 个月 12 倍）
- 原文："the latent demand for merging code is practically infinite, and every bottleneck we remove immediately leads to a further increase in the amount of code we produce" —— **合并的潜在需求近乎无限，每移除一个瓶颈立刻产出更多代码**（利特尔定律式的自我加速）
- 单仓库规模：main 分支历史近 **100 GB**，压缩工作副本 **25+ GB**，CI 每天约 **2,500 万次** checkout（还不算开发环境、agent 沙箱、研究作业）；朴素的 git fetch 意味着每天 **600+ PB** 流量

**Git 的根本错配**：他们实际上把 git 当"中心化系统 + 单一权威副本"用，但客户端（agents/jobs）**天然永远在线**。Git 为分布式离线工作优化的特性（每个 clone 是完整自足仓库）在仓库增长时**主动损害**扩展能力。核心提问："如果从第一天就把 agent 永远在线当作设计前提，版本控制会长什么样？"

## 二、Scion 六原则（agent 规模版本控制）

1. **客户端永远在线**：服务端永远可达，客户端按需取数（与 git 离线优先相反）
2. **客户端-服务端不对称**：git 中每个客户端都是完整服务端；Scion 中服务端负责 history/blame/commit/merge/rebase，客户端只是有界对象缓存 + 工作副本布局器 + 文件系统监视器——本地数据极少
3. **版本控制即综合服务 API**：客户端用的所有查询（blame、commit 关系）都通过 API 暴露，很多作业**根本不需要本地仓库**。自动化 bisect / revert 流水线若无这种廉价编程访问根本不现实
4. **一切水平可扩展**：数据分布式存储，任何地方（包括服务端）都没有完整物化副本；没有 packfile，无需仓库维护
5. **提交必须廉价、增量、无锁**：commit/rebase/merge 全在服务端发生，**没有 push 这个动作**；成本随变更大小而非仓库大小扩展；**抑制 refs**（分支/标签）——全局共识状态是扩展隐患，只保留 main 和 release 分支
6. **工作副本可选且天生稀疏**：需要 diff 的 CI 作业直接问服务端；写操作也可纯 API；sparse checkout（只含请求的目录）+ virtualized checkout（按需物化文件）——只为你真正读的数据付费

## 三、实现要点

**数据结构**：
- 工作单元是 **changeset**——写前日志（WAL）的一条记录；不存 tree 指针，存"相对第一父提交变更的文件列表 + 指向 blob storage 的内容寻址指针"；服务端创建，**即时全局可见**
- 高吞吐的关键：无 packfile 接收、无锁、无跨服务协调、无 refs 移动；refs 移动只是对单行 Spanner row 的 compare-and-swap，与 changeset 创建解耦
- **Derived data 通用递归机制**：blame、path history、commit graph skip list 都从 changeset 递归计算（某 changeset 的值 = 父 changeset 值的函数）。三收益：新索引易加、每类可选 eager/deferred（避免物化用不到的数据）、客户端看不到内部结构（可无感优化）

**获取架构**（分层缓存）：
- `scn` 客户端 → `scion-daemon`（每节点，存整节点对象）→ `scion-cache`（区域级，按磁盘格式直接从内存流式吐对象，不做 delta 压缩）→ `scion-server`（权威，读 Spanner/云存储）
- 协商协议的根本差异：**不告诉服务端"我已有什么"**（git 的 have/want），只按需请求具体 tree/blob——每个请求都是不可变对象的点查，任意缓存可答，架构形似分层缓存，天然可断点续传
- 三层响应**完全相同的 RPC**，客户端无需知道缓存拓扑；但严格强制分层以**隔离故障域**（防区域 cache 故障击穿权威层）
- 每层缓存命中率 **>99%**，无长命状态

**结果数据**：
- 基础设施足迹比原 git mirror 体系小 **200 倍**（CPU/内存）
- CI/研究作业 checkout 快 **两个数量级**（分钟 → 秒）；仅 CI 就赢回 **25% CPU 容量**
- 客户端和缓存都不需要仓库维护

## 四、教训（与 Harness Engineering 直接相关部分）

### 1. 小团队快速开发将成为常态
**7 人团队**在 5 个月内构建了 Scion + Antique（代码评审工具）+ 六个左右配套系统并完成整体迁移，期间日合并量还涨了 10 倍。过去这类系统要公司级多年迭代迁移。

### 2. 工程师价值不减，但工作变了——"告诉 Claude 不"
- 所有参与工程师都自评 **Claude 写代码比自己强**
- 人类提供的不可替代价值：高层系统间组件理解、设计级权衡、要解决的问题与目标规模的判断
- **"Very often, we found that the role of the engineers was to tell Claude 'no.'"** Agent 有时会为满足某种模式而违反核心系统约束（例：多个系统为了查"变更何时合入 main"暴力线性读 commit log，而不是问代码评审工具）
- **对抗式评审（adversarial review）有效但短视**：会让 Claude 针对假想担忧过度工程（例：对受信任的内部服务加过度校验和复杂度）。有经验的工程师要把 Claude 从过度工程中 steering 回来
- **评审粒度变化**：人仍然评审每个变更请求，但**审的是变更意图，不再逐行读代码**

### 3. 质量与优化大幅提升
- 为每个非平凡基础设施交互构建了**密闭仿真（hermetic simulations）**，加上 fuzzing 和精细限流——"我们有史以来测试最完备、防御最严的代码库之一"
- Claude 顺手找到祖先查询的算法优化（绕过一个索引，专家要数天到数周才能发现）……"然后第二天又找到一个"

### 4. 运维卓越的新形态——**Superfans 模式**
- 为**单个组件**创建专属 Claude，放在 Slack 频道里，任务是**痴迷地盯着该组件健康度**（scion-daemon superfan、scion-cache superfan、Antique merge queue superfan……）
- 有遥测和日志的完整访问权，行为像"一个闲得没事干、一直刷新图表、寻找任何异样的资深工程师"
- 传统告警仍然保留，但 superfan 能发现让告警"显得一维"的细微新型问题
- **Harness 视角**：这是 Loop Engineering 的 Automations 构件（心跳式自主任务）在 SRE 领域的实例化——分诊发现型循环 + maker/checker 分离（superfan 只报告判断，人处置）

### 5. 重新审视人类规模的先验——合并哲学（交叉验证 OpenAI 原则 8）
- **merge queue 在 agent 规模没有意义**："当成百上千个变更在测试运行期间就能合入时，CI 还算什么意思？"
- 无法有效复制 merge queue 的全局仓库锁 → 转向**合并后（post-merge）+ 部署前（pre-deploy）自动化测试**
- 并发变更确实会冲突，但 **Claude 修冲突比人类识别冲突还快**
- 与 OpenAI 的"最小阻塞门控、PR 短生命周期、flaky 用后续运行解决"完全同频——两家在 agent 吞吐下的合并哲学互相印证

### 6. 生态判断
- Scion 不适合做通用 git 替代品（仅适用于"数万工程师或 agent 集群大量产码"的真·巨型单仓；配套评审/搜索/CI 高度定制）
- 预判：**这类问题在未来 6-12 个月会变常见**；每家 git 公司独自面对是工程资源浪费
- 对生态的建议：git 服务端不必与客户端同构；服务端可以做重量级 RPC（甚至跨 forge 标准化）；协商协议可重设计；sparse/shallow 特性可以组合得更好；与 GitHub/GitLab/OSS 社区合作

## 五、Claude Mythos Preview 轶事（量化对比点）

手写的 git→Scion 摄取管线原型（团队自认为不错）→ 交给 Claude Mythos Preview 早期内部快照，**零额外指令**整体重写 → **内存降 20 倍、速度提 4 倍**，且完整保留了摄取顺序和数据结构的全部隐式不变量。

## 六、与已有知识体系的映射

| Scion 文章要点 | 对应已有原则 |
|---|---|
| 合并哲学重构（post-merge 测试替代 merge queue） | OpenAI 原则 8（吞吐量改变合并哲学）——**首次获得第二家数据印证** |
| 瓶颈从编码移到人类规模基础设施 | Addy "Harness 不缩小只移动"——瓶颈/脚手架移动论在基础设施层的体现 |
| Superfans（每组件专属常驻监控 agent） | Loop Engineering Automations 构件 + FEAT-066 控制矩阵中的 Feedback Sensors |
| 工程师角色 = 审意图 + 说"不" | OpenAI 原则 1（人类掌舵）+ golden-rules 补充 F（端到端自主中 "escalate when judgment is required"）|
| hermetic simulation + fuzzing | FEAT-069（传感器覆盖度/故障注入）的工业级实践样本 |
| 评审意图而非逐行 | Böckeler 矩阵中 Inferential 控制（AI 评审）承担 Computational 控制之上的意图层 |

## 七、新增 Feature

- FEAT-071（P2）：Agent 规模瓶颈转移——基础设施重新设计
- FEAT-072（P2）：Scion 六原则（永远在线客户端 / 客户端-服务端不对称 / API-first / 水平扩展 / 廉价无锁提交 / 稀疏工作副本）
- FEAT-073（P2）：意图级评审 + "对 Claude 说不"（人审意图、防约束违反、防过度工程）
- FEAT-074（P3）：Superfans 运维模式（每组件专属监控 agent + 传统告警并存）

---

*深读完成：2026-10-19*
