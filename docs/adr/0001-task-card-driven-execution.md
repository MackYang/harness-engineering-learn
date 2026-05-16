# ADR-0001: 采用任务卡驱动执行

- Status: Accepted
- Date: 2026-05-15

## Context
需要保证 AI 执行可追踪、可验收、可回滚。

## Decision
使用任务卡作为唯一执行单位，一次只执行一张卡。

## Consequences
提高可审计性，降低跨范围改动风险。
