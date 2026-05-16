# Progressive Delivery（CARD-P3-03）

## 发布阶段
1. Canary（5%）
2. Stage（25%）
3. Full（100%）

## 自动回滚条件
- 关键 SLI 跌破阈值
- Error budget 快速消耗

## 回滚要求
- 必须有可回滚版本
- 必须保留回滚证据
