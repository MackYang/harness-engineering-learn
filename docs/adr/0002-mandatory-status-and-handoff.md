# ADR-0002: 强制状态总表与交接记录

- Status: Accepted
- Date: 2026-05-15

## Context
多轮执行和上下文切换容易造成状态丢失。

## Decision
要求每次状态变化更新 `harness-execution-status.md`，阻塞时更新 `context-handoff.md`。

## Consequences
保证长时间执行连续性。
