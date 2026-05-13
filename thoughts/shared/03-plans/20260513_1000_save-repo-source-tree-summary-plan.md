# Plan: Lưu Source Tree và Summary của Repo Git

## Source Ticket
- `thoughts/shared/01-tickets/20260513_1000_save-repo-source-tree-summary-ticket.md`

## Scope Summary
- **Stack**: PowerShell scripting + Markdown templates
- **Project**: harness_coding_framework
- **Module**: `scripts/`, `thoughts/templates/`, `thoughts/shared/02-research/`
- **Feature**: Tạo script và template chuẩn hóa để sinh source tree + summary cho bất kỳ repo Git nào
- **Expected Outcome**: Agent hoặc developer có thể chạy 1 lệnh để sinh artifact context cho repo, lưu vào thoughts workspace

## Rulebooks Read
- `AGENTS.md`
- `thoughts/README.md` (naming convention, cấu trúc thư mục)
- `scripts/validate-harness.ps1` (tham khảo pattern script hiện có)

## Implementation Steps (Tuân thủ EPCC)

### 1. Explore
- [x] Đọc `thoughts/README.md` để hiểu naming convention và cấu trúc.
- [x] Đọc `thoughts/templates/ticket-template.md` để tạo ticket đúng format.
- [x] Đọc `scripts/validate-harness.ps1` để tham khảo pattern PowerShell.
- [x] Chạy thử lệnh tree trên repo hiện tại để xác định output mong muốn.

### 2. Plan
- [x] Xác định 3 deliverables: script, template, file ví dụ.
- [x] Xác định parameters cho script: Path, Depth, OutputFile, ExcludeDirs, IncludeSummaryHeader.
- [x] Xác định sections cho template: Metadata, Purpose, Tech Stack, Modules, Entry Points, Tree, Build & Run.

### 3. Code
- [x] Tạo `scripts/generate-source-tree.ps1` với các tính năng:
  - Nhận input: repo path, depth, exclude dirs, output file.
  - Sinh tree dạng text với connectors (├──, └──, │).
  - Hỗ trợ flag `-IncludeSummaryHeader` để thêm metadata Markdown.
  - Xuất ra stdout hoặc file.
- [x] Tạo `thoughts/templates/repo-summary-template.md` với sections chuẩn.
- [x] Tạo file ví dụ `thoughts/shared/02-research/20260513_1000_harness-repo-source-tree.md`.

### 4. Check
- [x] Chạy script với `-Depth 2 -IncludeSummaryHeader` → verify output đúng format.
- [x] Chạy `validate-harness.ps1` → pass (không break gì).
- [x] Cập nhật ticket status → Done.

## Files Expected To Change
- `scripts/generate-source-tree.ps1` ← **MỚI**
- `thoughts/templates/repo-summary-template.md` ← **MỚI**
- `thoughts/shared/02-research/20260513_1000_harness-repo-source-tree.md` ← **MỚI**
- `thoughts/shared/01-tickets/20260513_1000_save-repo-source-tree-summary-ticket.md` ← cập nhật status

## Validation Plan
- `.\scripts\generate-source-tree.ps1 -Path . -Depth 2 -IncludeSummaryHeader` → output hợp lệ
- `.\scripts\validate-harness.ps1 -Root .` → pass

## Risks And Mitigations
- **Risk**: Script không xử lý đúng ký tự đặc biệt trong tên thư mục (ví dụ `c#`).
- **Mitigation**: Dùng `-LiteralPath` thay vì `-Path` trong Get-ChildItem. Đã test với thư mục `c#/`.

- **Risk**: Output quá dài nếu repo lớn và depth cao.
- **Mitigation**: Mặc định depth = 4, user có thể giảm. Exclude list loại bỏ các thư mục nặng.

## Open Questions
- None (đã triển khai xong).
