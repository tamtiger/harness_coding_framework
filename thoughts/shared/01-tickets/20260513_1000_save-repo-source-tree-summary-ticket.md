# Ticket: Lưu Source Tree và Summary của Repo Git

## Metadata
- **Ticket ID**: `HARNESS-TREE-001`
- **Stack**: `other`
- **Project**: `harness_coding_framework`
- **Module**: `thoughts / integrations`
- **Requester**: `Dev`
- **Priority**: `Medium`
- **Estimated Effort**: `S`
- **Status**: `Done`

## Problem
Hiện tại không có cách nhanh chóng để agent hoặc developer mới nắm được toàn bộ cấu trúc (source tree) và tóm tắt (summary) của một repo Git. Mỗi lần cần context, phải duyệt thủ công hoặc chạy lệnh `tree` rồi copy-paste. Thiếu một artifact chuẩn hóa để lưu trữ thông tin này phục vụ onboarding và cross-session context.

## Desired Outcome
Có một workflow/script hoặc template chuẩn để:
1. Tự động sinh **source tree** (cấu trúc thư mục) của một repo Git, loại bỏ các thư mục không cần thiết (node_modules, bin, obj, .git, v.v.).
2. Sinh **summary** ngắn gọn mô tả mục đích repo, tech stack, các module chính, và entry points.
3. Lưu kết quả vào `thoughts/shared/02-research/` với naming convention chuẩn để tái sử dụng.

## Scope
### In Scope
- Tạo script (PowerShell hoặc Bash) để sinh source tree từ repo path.
- Tạo template cho file summary (bao gồm: repo name, purpose, tech stack, module list, entry points, dependencies overview).
- Tạo hướng dẫn sử dụng (khi nào chạy, output lưu ở đâu).
- Áp dụng thử cho repo `harness_coding_framework` làm ví dụ.

### Out Of Scope
- Tích hợp tự động vào CI/CD pipeline.
- Sinh summary bằng AI tự động (chỉ cần template để agent điền).
- Hỗ trợ các VCS khác ngoài Git.

## Constraints
- Output phải là Markdown, tuân thủ naming convention `YYYYMMDD_HHMM_task-name.md`.
- Script phải chạy được trên Windows (PowerShell) vì đây là môi trường phát triển chính.
- Không commit file chứa absolute path hoặc thông tin nhạy cảm.
- Source tree nên giới hạn depth (mặc định 3-4 levels) để không quá dài.

## Acceptance Criteria
- [ ] Có script `scripts/generate-source-tree.ps1` nhận input là repo path, output là Markdown source tree.
- [ ] Có template `thoughts/templates/repo-summary-template.md` với các section chuẩn.
- [ ] Có file ví dụ `thoughts/shared/02-research/20260513_1000_harness-repo-source-tree.md` chứa source tree của repo hiện tại.
- [ ] Script loại bỏ đúng các thư mục ignore (.git, node_modules, bin, obj, packages).
- [ ] README hoặc hướng dẫn mô tả cách sử dụng script và template.

## References
- `thoughts/README.md` — Quy tắc đặt tên và cấu trúc thoughts workspace.
- `c#/workflows/project-onboarding.md` — Workflow onboarding có thể tích hợp bước này.
- `scripts/validate-harness.ps1` — Script hiện có, tham khảo pattern.
