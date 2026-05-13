# Changelog

Tất cả thay đổi đáng chú ý của harness này được ghi nhận tại đây. Định dạng dựa
trên [Keep a Changelog](https://keepachangelog.com/).

## [harness-source-tree] Script sinh Source Tree & Repo Summary - 2026-05-13

### Added
- `scripts/generate-source-tree.ps1` — Script PowerShell sinh source tree dạng Markdown từ bất kỳ repo Git nào. Hỗ trợ: custom depth, exclude dirs, output file, summary header.
- `thoughts/templates/repo-summary-template.md` — Template chuẩn cho file summary repo (purpose, tech stack, modules, entry points, tree, build commands).
- `thoughts/shared/02-research/20260513_1000_harness-repo-source-tree.md` — Ví dụ áp dụng cho chính repo `harness_coding_framework`.

### Changed
- `README.md` (root) — Cập nhật Repository Map thêm entry cho `generate-source-tree.ps1`.

## [harness-epcc] Tích hợp quy trình EPCC (Explore-Plan-Code-Check) - 2026-05-12

### Added
- `thoughts/workflows/epcc.md` — Định nghĩa chi tiết quy trình 4 bước cho AI Agent.

### Changed
- `AGENTS.md` — Bắt buộc tuân thủ quy trình EPCC trong mục Agent Workflow và bổ sung vào bảng Routing.
- `README.md` (root) — Cập nhật mục "Context Workflow" theo quy trình EPCC.
- `thoughts/README.md` — Link tới tài liệu EPCC.
- `thoughts/templates/plan-template.md` — Cập nhật cấu trúc Implementation Steps theo chuẩn EPCC.
- Tạo Ticket và Plan lưu vết cho việc triển khai EPCC.

## [harness-003] Làm Rõ Hai Loại Error Code (Internal vs Public API) - 2026-05-12

### Changed
- `c#/error-code-conventions.md` — thêm section "Two Layers of Error Codes"
  phân biệt rõ Internal Domain Error Code vs Public API Error Code, bao gồm
  mapping flow diagram, project-specific overrides, và end-to-end example.
- `c#/projects/payment-hub/api-contract-rules.md` — thêm Scope Note ở đầu file
  giải thích đây là public API error codes (không phải internal
  `BusinessException` codes) và reference về generic rule.
- `c#/examples/CreateProduct/prompt-spec.md` — thêm "Error Code Mapping" table
  thể hiện ánh xạ internal → public API code, cập nhật Acceptance Criteria.
- `c#/prompts/feature-generator.md` — thêm `c#/error-code-conventions.md` vào
  Required Context Loading list (item #7).

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
