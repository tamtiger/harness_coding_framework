# Changelog

Tất cả thay đổi đáng chú ý của harness này được ghi nhận tại đây. Định dạng dựa
trên [Keep a Changelog](https://keepachangelog.com/).

## [Phase 2] - 2026-05-08

### Added
- Rule **"Thoughts First"** bắt buộc trong `AGENTS.md` — agent phải tạo
  ticket/plan trước khi implement.
- Routing entries cho `bug-fix.md` và `code-review.md` trong `AGENTS.md`.
- `.gitignore` chuẩn polyglot (C#, Node.js, Python, IDE, OS, secrets).
- `Priority` và `Estimated Effort` fields trong ticket template.
- **Language Policy** section trong root `README.md`.
- Quy tắc đặt tên file `YYYYMMDD_HHMM_task-name.md` trong `thoughts/`.
- `c#/repair-strategies/runtime-errors.md` — xử lý NullRef, DI, timeout, auth.
- `c#/repair-strategies/test-failures.md` — xử lý assertion, flaky, setup.
- `c#/workflows/bug-fix.md` — reproduce → root cause → fix → regression test.
- `c#/workflows/code-review.md` — checklist review code có cấu trúc.
- `c#/error-code-conventions.md` — format `Module:Entity:NumericCode`.
- Optional `version` field (semver) trong `feature-manifest.schema.json`.
- `c#/examples/CreateProduct/` — exemplar feature hoàn chỉnh (prompt-spec +
  manifest).
- `glossary.md` — thuật ngữ chuyên biệt (25+ terms).
- Consolidation section trong `c#/projects/payment-hub/data-rules.md`.

### Changed
- `c#/README.md` — cập nhật Rulebook Directory với files mới.
- Root `README.md` — cập nhật structure diagram, plan references, language
  policy.

## [Phase 1] - 2026-05-08

### Added
- `AGENTS.md` — single tool-agnostic entrypoint cho tất cả AI agents.
- `thoughts/` workspace với ticket, plan, research, và agent memory templates.
- `scripts/validate-harness.ps1` — kiểm tra cấu trúc harness tự động.
- `c#/prompts/feature-generator.md` — structured workflow prompt.
- `c#/workflows/feature-implementation.md` — SOP triển khai tính năng.
- `c#/workflows/project-onboarding.md` — SOP tạo project rulebook mới.
- `c#/workflows/agent-memory-workflow.md` — SOP ghi nhớ xuyên phiên.
- C# stack rulebooks: architecture, dependency, naming, anti-patterns, API
  contracts, testing, CI.
- Payment Hub project rulebook: 12 specialized rule files.
