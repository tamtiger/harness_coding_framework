# Ticket: Harness Phase 2 – Defensive Hardening & Agent Productivity

## Metadata
- **Ticket ID**: `harness-002`
- **Stack**: `other`
- **Project**: `None`
- **Module**: `None`
- **Requester**: `User`
- **Priority**: `High`
- **Estimated Effort**: `L`
- **Status**: `Done`

## Problem
Harness phase 1 đã hoàn tất với cấu trúc cơ bản. Tuy nhiên, sau review toàn diện, phát hiện 16 điểm cần cải tiến thuộc 3 nhóm:
1. **Defensive Hardening**: Thiếu `.gitignore`, repair strategies cho runtime/test errors, bug-fix workflow, cross-reference validation.
2. **Agent Productivity**: Thiếu exemplar feature, error code conventions, glossary, code-review workflow.
3. **Governance**: Thiếu rule bắt buộc tạo thoughts trước khi implement, CHANGELOG, language policy, version tracking cho manifest.

## Desired Outcome
- Harness có đầy đủ repair strategies, workflows, và validation checks.
- Agent bắt buộc phải tạo ticket/plan trước khi implement (rule mới trong AGENTS.md).
- Validation script kiểm tra cross-reference integrity và agent memory format.
- Có exemplar feature để agent tham khảo.

## Scope
### In Scope
- Thêm `.gitignore`.
- Thêm repair strategies: `runtime-errors.md`, `test-failures.md`.
- Thêm workflow: `bug-fix.md`, `code-review.md`.
- Thêm `version` field vào `feature-manifest.schema.json`.
- Thêm `error-code-conventions.md`.
- Bổ sung `Priority` & `Estimated Effort` vào ticket template.
- Enhance validation script (cross-reference, agent memory, summary output).
- Tạo exemplar feature example.
- Thêm `glossary.md`, `CHANGELOG.md`.
- Document language policy trong root README.
- Consolidate data retention rules cho Payment Hub.
- Thêm rule "Thoughts First" vào `AGENTS.md`.

### Out Of Scope
- Triển khai business logic thực tế.
- Thay đổi kiến trúc Payment Hub.

## Constraints
- Phải tuân thủ cấu trúc hiện tại: `AGENTS.md` → stack README → project README.
- Không phá vỡ validation script hiện tại (backward compatible).
- Giữ `AGENTS.md` ngắn gọn.

## Acceptance Criteria
- Validation script pass 100% sau mọi thay đổi.
- `AGENTS.md` có rule bắt buộc tạo thoughts trước implement.
- Tất cả 16 cải tiến được triển khai hoặc ghi nhận lý do bỏ qua.

## References
- Review: conversation `17d693fb-327c-4713-9c0d-824ea26a1926`
- Phase 1: [`thoughts/shared/01-tickets/20260508_1006_harness-improvement-ticket.md`](../20260508_1006_harness-improvement-ticket.md)
- Phase 1 Plan: [`thoughts/shared/03-plans/20260508_0931_harness-improvement-plan.md`](../../03-plans/20260508_0931_harness-improvement-plan.md)
