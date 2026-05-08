# Plan: Harness Phase 2 – Defensive Hardening & Agent Productivity

## Source Ticket
- [`thoughts/shared/01-tickets/20260508_1335_harness-phase2-ticket.md`](../../01-tickets/20260508_1335_harness-phase2-ticket.md)

## Scope Summary
Triển khai 16 cải tiến từ review toàn diện, chia thành 4 wave theo thứ tự
dependency:
- Wave 1: Governance (AGENTS.md rule, .gitignore, ticket template)
- Wave 2: Defensive Hardening (repair strategies, bug-fix workflow, error codes)
- Wave 3: Agent Productivity (exemplar, glossary, code-review, CHANGELOG)
- Wave 4: Validation Enhancement (cross-ref, memory validation, summary output)

## Rulebooks Read
- [x] `AGENTS.md`
- [x] `c#/README.md`
- [x] `c#/projects/payment-hub/README.md`
- [x] `c#/workflows/feature-implementation.md`
- [x] `c#/workflows/project-onboarding.md`
- [x] `c#/workflows/agent-memory-workflow.md`
- [x] `thoughts/README.md`

## Implementation Steps

### Wave 1: Governance & Foundation
- [x] 1.1 Thêm rule "Thoughts First" vào `AGENTS.md`.
- [x] 1.2 Tạo `.gitignore` chuẩn polyglot.
- [x] 1.3 Bổ sung `Priority` & `Estimated Effort` vào `thoughts/templates/ticket-template.md`.
- [x] 1.4 Document language policy trong root `README.md`.

### Wave 2: Defensive Hardening
- [x] 2.1 Tạo `c#/repair-strategies/runtime-errors.md`.
- [x] 2.2 Tạo `c#/repair-strategies/test-failures.md`.
- [x] 2.3 Tạo `c#/workflows/bug-fix.md`.
- [x] 2.4 Tạo `c#/error-code-conventions.md`.
- [x] 2.5 Thêm `version` field vào `c#/feature-manifest.schema.json`.

### Wave 3: Agent Productivity
- [x] 3.1 Tạo `c#/workflows/code-review.md`.
- [x] 3.2 Tạo `c#/examples/CreateProduct/prompt-spec.md` (exemplar).
- [x] 3.3 Tạo `c#/examples/CreateProduct/feature-manifest.json` (exemplar).
- [x] 3.4 Tạo `c#/examples/README.md` (exemplar index).
- [x] 3.5 Tạo `glossary.md` ở root.
- [x] 3.6 Tạo `CHANGELOG.md` ở root.
- [x] 3.7 Consolidate data retention rules: thêm section summary trong
      `c#/projects/payment-hub/data-rules.md`.

### Wave 4: Validation Enhancement
- [x] 4.1 Thêm cross-reference validation cho `AGENTS.md` routing table.
- [x] 4.2 Thêm agent memory format validation.
- [x] 4.3 Thêm detailed summary output.
- [x] 4.4 Cập nhật root `README.md` và `c#/README.md` phản ánh files mới.

## Files Expected To Change
- `AGENTS.md`
- `README.md`
- `.gitignore` (new)
- `thoughts/templates/ticket-template.md`
- `c#/README.md`
- `c#/repair-strategies/runtime-errors.md` (new)
- `c#/repair-strategies/test-failures.md` (new)
- `c#/workflows/bug-fix.md` (new)
- `c#/workflows/code-review.md` (new)
- `c#/error-code-conventions.md` (new)
- `c#/feature-manifest.schema.json`
- `c#/examples/` (new directory with 3 files)
- `glossary.md` (new)
- `CHANGELOG.md` (new)
- `c#/projects/payment-hub/data-rules.md`
- `scripts/validate-harness.ps1`

## Validation Plan
- Run `./scripts/validate-harness.ps1` sau mỗi wave.
- Đảm bảo backward compatibility (no breaking changes).

## Risks And Mitigations
- **Risk**: Validation script mới quá nghiêm ngặt, block agent khi chưa có code.
- **Mitigation**: Cross-reference check chỉ validate files được reference trong
  routing tables, không validate toàn bộ markdown links.
- **Risk**: Exemplar feature gây nhầm lẫn với code thật.
- **Mitigation**: Đặt trong `c#/examples/` riêng biệt, README ghi rõ là ví dụ.

## Open Questions
- None cho phase này.
