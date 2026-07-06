# Anthropic Engineering 新知识笔记 (2026-07-06)

> 来源：Anthropic 工程博客 - 最新文章分析
> 学习日期：2026-07-06
> 覆盖文章数：最新发布的工程文章

---

## 一、Anthropic Engineering 最新文章分析

### 1.1 最新文章列表（截至2026-07-06）

**近期重点文章**：
1. **How we contain Claude across products**（2026-06-23）- 三种代理隔离模式
2. **Scaling Managed Agents: Decoupling the brain from the hands**（2026-04-08）- 托管代理架构革新
3. **Harness design for long-running application development**（2026-03-24）- 长期应用设计
4. **Effective harnesses for long-running agents**（2025-11-26）- 长期代理实践

### 1.2 关键趋势分析

**安全架构演进**：
- 从临时容器到虚拟机隔离
- 三层防御模型：环境层、模型层、外部内容
- 信任对话框前一切的安全风险

**架构设计趋势**：
- 脑手分离：Claude与执行环境和会话日志解耦
- 组件化：从耦合到解耦，从宠物到牛群
- 安全优先：凭证与执行环境隔离

**性能优化成果**：
- TTFT改进：p50 TTFT下降约60%，p95 TTFT下降超过90%
- 按需分配：只在需要时才分配资源
- 故障隔离：组件可以独立失败和替换

### 1.3 长期运行代理的Harness设计

**上下文管理策略**：
1. **压缩技术**：智能摘要和卸载旧上下文
2. **工具调用卸载**：大输出卸载到文件系统，保留head + tail
3. **渐进式披露**：按需加载工具和指令
4. **完整上下文重置**：从紧凑的hand-off文件重建session

**多代理协作模式**：
- **规划者/生成者/评估者分离**：优于自评估
- **冲刺合同**：生成者和评估者事先协商"完成"定义
- **子代理上下文防火墙**：隔离不同代理的上下文

### 1.4 安全防御体系的深化

**三层防御模型**：
```
1. 环境层防御
   - 沙箱隔离
   - 文件系统边界
   - 出口控制
   - 符号链接处理

2. 模型层防御
   - 系统提示
   - 分类器
   - 探测
   - 训练修改

3. 外部内容防御
   - MCP服务器审计
   - 第三方插件验证
   - 网络搜索工具过滤
```

**关键安全教训**：
1. **本地不等于安全**：来自本地目录的输入应视为来自互联网
2. **用户是注入向量**：通过用户传递的恶意指令也需要环境防御
3. **符号链接是攻击路径**：必须正确处理符号链接解析
4. **批准疲劳问题**：过多的批准提示导致用户注意力下降

### 1.5 元级Harness设计（Meta-Harness）

**设计哲学**：
> "设计一个系统，适应未来的Harness、沙箱或其他组件"

**通用接口**：
- `execute(name, input) → string`：手的基本接口
- `wake(sessionId)`：重启Harness
- `getSession(id)`：获取事件日志
- `emitEvent(id, event)`：记录事件

**核心原则**：
- 对接口有意见，对实现无意见
- 期待Claude需要操作状态和执行计算的能力
- 不对未来大脑或手的数量和位置做假设

---

## 二、知识体系更新总结

### 新增核心概念

| 概念 | 来源文章 | 一句话描述 |
|------|----------|-----------|
| **三层防御模型** | Claude Containment | 环境、模型层、外部内容的三层防御体系 |
| **临时容器模式** | Claude Containment | 完全服务器端执行，文件系统临时化的安全模式 |
| **信任对话框前一切** | Claude Containment | 用户同意前执行的代码是重大安全风险 |
| **大脑-手-会话解耦** | Managed Agents | 将Claude与执行环境和会话日志解耦的架构 |
| **凭证绑定模式** | Managed Agents | 令牌与资源绑定或存储在保险库，Harness不接触凭据 |
| **Meta-Harness** | Managed Agents | 适应未来Harness的元级架构设计 |
| **上下文压缩技术** | Long-running Apps | 智能摘要和卸载旧上下文的多种技术 |
| **规划/生成/评估分离** | Long-running Agents | 生成与评估分离优于自我评估的协作模式 |

### 跨文章交叉洞察

1. **环境防御的关键性**：
   - Claude Containment强调了环境防御的重要性
   - Managed Agents通过解耦和接口抽象增强了环境安全性
   - 两篇文章都指出：模型层防御有概率性失败，环境防御是必要的

2. **架构演进模式**：
   - 从耦合到解耦：单体容器 → 组件分离
   - 从宠物到牛群：避免单点故障，采用可替换组件
   - 从固定到灵活：通用接口允许未来扩展

3. **安全与性能的权衡**：
   - 解耦架构既提升了性能（TTFT降低60%+）又增强了安全性
   - 安全边界设计需要平衡便利性和安全性
   - 用户作为注入向量提醒我们：安全需要多层次防御

### 实践指导

#### 安全设计原则
1. **分层防御**：不要依赖单一安全层，使用多层次防御
2. **默认拒绝**：默认拒绝所有操作，显式允许必要操作
3. **隔离敏感数据**：凭据与执行环境隔离
4. **符号链接处理**：正确处理符号链接解析，防止路径遍历

#### 架构设计原则
1. **组件解耦**：将大脑、手、会话作为独立组件
2. **接口抽象**：设计通用接口，允许实现变化
3. **按需分配**：资源只在需要时分配
4. **故障隔离**：组件独立失败和恢复

#### 用户交互设计
1. **减少批准疲劳**：减少不必要的批准提示
2. **上下文感知**：在不同用户层级提供不同交互方式
3. **透明度**：让用户了解代理的访问范围
4. **默认安全**：默认采用最安全的配置

---

## 三、参考链接

- [How we contain Claude across products](https://www.anthropic.com/engineering/how-we-contain-claude) - 2026-06-23
- [Scaling Managed Agents: Decoupling the brain from the hands](https://www.anthropic.com/engineering/managed-agents) - 2026-04-08
- [Harness design for long-running application development](https://www.anthropic.com/engineering/harness-design-long-running-apps) - 2026-03-24
- [Effective harnesses for long-running agents](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents) - 2025-11-26