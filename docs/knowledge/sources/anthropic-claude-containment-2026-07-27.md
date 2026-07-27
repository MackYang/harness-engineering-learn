# Anthropic Claude Containment 补充知识笔记 (2026-07-27)

> 来源：https://www.anthropic.com/engineering/how-we-contain-claude
> 学习日期：2026-07-27
> 对比笔记：2026-07-23版本
>
> 说明：本文为对已收录的 Claude Containment 文章的深度审视，提取上次遗漏的架构细节和具体数据。

---

## 一、新发现的架构细节

### 1.1 Claude Cowork 完整 VM 架构

**三种隔离模式对比（更精确版本）**：

``n
Pattern 1: Ephemeral Container (claude.ai)
  - gVisor 容器 + seccomp
  - 完全服务器端，代码不跑在本地
  - 文件系统按会话临时化
  - 威胁模型：保护 Anthropic 基础设施和租户隔离
  - 安全教训：最弱的层是你自己构建的层

Pattern 2: Human-in-the-loop Sandbox (Claude Code)
  - 最初：允许读，写/bash/网络需要审批
  - 改进：OS 级沙箱（Seatbelt/bubblewrap）
    → 读：允许
    → 写：工作区内允许
    → 网络：默认拒绝
  - 结果：84% 权限提示减少
  - 开源了 sandbox-runtime

Pattern 3: Local VM (Claude Cowork) ← 本次重点新内容
  - 使用平台供应商虚拟机监控器
    → macOS: Apple Virtualization Framework
    → Windows: HCS
  - VM 有自己的 Linux 内核、文件系统、进程表
  - 用户选择的工作区和 .claude 文件夹被挂载
  - 凭证留在 host keychain，不进入 guest
```

**Full-VM 模式 vs Host 模式的架构演进**：

``n
Full-VM 模式（原始）：
  - 代理循环在 guest 内运行
  - Claude 作为普通 Linux 用户执行，不知道被沙箱化
  - 无外部进程持有逃逸密钥
  - 问题：VM 启动失败时 Cowork 完全不可用

Host 模式（演进后）：
  - 代理循环移到 VM 外
  - 代码执行仍在 VM 内
  - VM 崩溃时 Claude 仍可响应用户
  - 安全影响最小：VM 仍强制文件系统和网络控制

本地 MCP 服务器也移到 VM 外：
  - 在 VM 内更难审计
  - VM 更新时有脆弱的依赖问题
  - 不支持需要与本地进程交互的 MCP（如数据库）
  - 与 Claude Desktop 保持一致
```

**六层隔离机制**（Cowork VM）：

``n
在外部 kernel 执行（2 层 - 即使代理获得 root 也能存活）：
  1. 虚拟机监控器级隔离
  2. 外部 egress 控制

在 guest 内执行（4 层 - 刻意最小化，外部层承担主要责任）：
  3. 文件系统边界
  4. 网络控制
  5. 进程隔离
  6. 资源限制
```

**文件系统挂载模式**：

``n
三种粒度的文件挂载控制：
  1. read-only：只读
  2. read-write：读写
  3. read-write-no-delete：读写但不删除

⚠️ symlink 陷阱：
  symlink 解析必须在路径验证之前
  否则授权文件夹内的 symlink 可指向外部并逃逸

企业级：通过 MDM 设置中的 mount-path allowlist 控制
```

### 1.2 已批准域外泄漏洞（新发现）

**攻击场景**：
``n
1. 恶意文件被放入用户挂载的工作区
2. 文件携带隐藏指令和攻击者控制的 API key
3. Cowork 的 egress 白名单正确放行到 api.anthropic.com 的流量
4. 但恶意代码利用 API key 将数据发送到攻击者控制的服务器

关键教训：
  → egress 白名单检查的是域名，不是最终目的地
  → 攻击者可以搭便车通过已批准的域名
```

### 1.3 具体安全数据

**模型层防御数据（新）**：

``n
Gray Swan Agent Red Teaming Benchmark (Claude Opus 4.7):
  - 单次尝试攻击成功率：约 0.1%
  - 100 次自适应尝试后：约 5-6%

Claude Code Auto Mode:
  - 在执行前捕获约 83% 的过度行为

Claude Code 权限提示:
  - 用户批准约 93% 的权限提示
  - OS 级沙箱减少了 84% 的权限提示
```

### 1.4 Claude Mythos Preview 安全决策

**新信息**：
> "Claude Mythos Preview is an example of a model whose blast radius was deemed too high to ship in April 2026."

**含义**：
- Anthropic 会因安全原因主动扣留模型发布
- 但预期随着防御者加固系统和安全措施成熟，类似能力的模型会更广泛发布
- 风险永远存在，但可以被控制在可接受范围内

### 1.5 Canary String 反模式

**安全实践（新）**：
``n
场景：内部讨论恶意 prompt 时
  → 有人在 Slack 中指出，一些内部代理会读取 Slack
  → 攻击 payload 现在变成了环境中的"背景辐射"
  → 添加 canary string 到线程中
  → 如果任何代理 picked up，会被注意到

教训：
  在代理读取一切的世界里，调查工具本身也是攻击面
```

---

## 二、关键安全原则的深化

### 2.1 "信任对话框前"原则的精确化

**2026-07-23 版本**：信任对话框前的代码执行

**2026-07-27 深化**：
``n
三条具体漏洞都结构相同：
  - 来自尚未信任的目录的输入
  - 在信任边界建立之前被解析

修复模式统一：
  延迟项目本地配置的解析和执行
  直到用户接受信任提示之后

设计原则：
  treat project-open, config-load, and localhost listeners
  the way you'd treat any inbound request from the internet
  → 不要因为它们"感觉本地"就隐式信任
```

### 2.2 用户作为注入向量的数据

**2026-07-23 版本**：概念性描述

**2026-07-27 深化**：
``n
红队测试具体数据：
  - 钓鱼邮件伪装为"能帮我跑一下这个吗？"的协作请求
  - 25 次重试中，Claude 完成了 24 次数据外泄

模型层防御失效原因：
  模型层防御锚定于用户意图
  当用户自己在输入指令时，分类器没有异常可抓

唯一有效的防御：环境层
  - egress 控制阻止 POST（无论意图如何）
  - 文件系统边界让 ~/.aws 不可达
```

### 2.3 审批疲劳的精确数据

``n
Claude Code 用户行为数据（匿名化）：
  - 经验丰富用户自动批准频率 ≈ 新用户的 2 倍
  - 但经验丰富用户中断代理执行也更频繁
  - 经验用户只在代理偏离轨道时监督
  - 问题：随着模型写更复杂的 bash，偏差越来越难察觉
  - 多代理系统下此方法更不可行
```

---

## 三、与其他来源的交叉洞察

### 3.1 Containment + Loop Engineering 的安全设计

**Claude Cowork VM 的六层隔离对 Loop 的启示**：

``n
Loop 中的子代理也应有类似的分层隔离：
  1. 外部层（即使代理被攻破也能存活）：
     → 网络层控制（egress 白名单）
     → 资源配额限制
  2. 内部层（最小化）：
     → 文件系统只读
     → 工具权限最小化

Loop 状态文件的安全：
  状态文件是 Loop 的"持久化内存"
  → 需要类似 Cowork 的文件挂载模式（read-only 状态文件）
  → 需要 symlink 解析在路径验证之前
```

### 3.2 Containment + OpenAI Harness 的架构约束

``n
OpenAI 的"刚性行政模型"（Types → Config → Repo → Service → Runtime → UI）
+ Anthropic 的分层隔离
= 双重安全架构：

  OpenAI 约束代码的形状（质量维度）
  Anthropic 约束代码的可达性（安全维度）

  两者结合形成"代理只能做正确的事"的完整框架
```

### 3.3 Full-VM → Host 模式演进与 Harness Engineering

``n
Anthropic 的教训：
  理论上更安全的架构（full-VM）在实践中因可靠性问题被修改

对应到 Harness Engineering 的"Ratchet"原则：
  每个约束都必须有明确的失败案例支撑
  如果约束导致系统不可靠，它本身就成为了问题

教训：
  安全约束必须考虑可靠性代价
  一个经常崩溃的安全系统 → 用户绕过安全 → 更不安全
```