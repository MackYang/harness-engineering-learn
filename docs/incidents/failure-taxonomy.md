# Failure Taxonomy（CARD-P0-04）

日期：2026-05-15

## 1. 事件类型
- ROLLBACK：发布后触发回滚
- PROD_INCIDENT：线上故障
- MISCHANGE：错误修改导致功能异常
- PRIV_ESCALATION：权限/越权风险
- EVAL_REGRESSION：评测回归失效

## 2. 严重等级
- SEV1：核心功能不可用或高风险安全问题
- SEV2：关键路径受损但有替代路径
- SEV3：局部影响或可容忍退化

## 3. 触发复盘阈值
- 所有 SEV1/SEV2 必复盘
- 同类型 SEV3 一周内 >=2 次必复盘
- 任一策略绕过事件必复盘

## 4. 复盘时限
- 24 小时内初判
- 7 天内闭环（至少输出测试/策略/规则之一）
