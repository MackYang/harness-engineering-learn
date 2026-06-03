# 架构模式与约束执行

> 来源：OpenAI Harness Engineering
> 核心原则：用约束而非微观管理来规范架构

## 分层架构

```
每个业务域内的分层（严格单向依赖）：
Types → Config → Repo → Service → Runtime → UI
```

### 各层职责

| 层 | 职责 | 示例 |
|----|------|------|
| Types | 类型定义、接口 | TypeScript interfaces, JSON schemas |
| Config | 配置管理 | 环境变量、特性标志 |
| Repo | 数据访问 | Repository pattern, ORM models |
| Service | 业务逻辑 | Use cases, domain services |
| Runtime | 运行时基础设施 | 服务器、中间件、队列 |
| UI | 用户界面 | Components, pages |

### 横切关注点

认证、连接器、遥测、功能标志等通过单一的显式接口：`Providers` 进入。

## 约束执行

### 通过 Linter 机械强制执行

不规定具体实现方式，而是通过工具强制执行边界：
- 自定义 linter 验证依赖方向
- 结构测试验证分层合规
- CI 作业阻塞违反约束的 PR

### Parse, don't validate

在边界处解析数据形状，而不是在内部重复验证：
- 外层数据进入时解析为内部类型
- 内部代码可以信任类型安全
- 不指定用哪个库，只要求行为

## 品味编码（Encode Taste）

人类审查反馈不应是临时指令，而应转化为：
1. **文档更新** → 更新 `docs/principles/`
2. **Linter 规则** → 编码到 `scripts/ci/lint.sh`
3. **CI 作业** → 自动检查

> 当文档不够完善时，将规则转化为代码。

## 持续垃圾回收

技术债像高息贷款：
- 定期运行后台任务扫描偏差
- 更新质量等级
- 发起重构 PR
- 大多数可以一分钟内审查并自动合并

---

*最后更新：2026-06-04*
