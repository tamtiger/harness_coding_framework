# Plan: Triển khai quy trình EPCC vào Harness

## Source Ticket
- `thoughts/shared/01-tickets/20260512_1449_add-epcc-workflow.md`

## Scope Summary
Tích hợp quy trình Explore - Plan - Code - Check vào hệ thống harness để hướng dẫn AI Agent làm việc bài bản hơn.

## Rulebooks Read
- `AGENTS.md`
- `thoughts/README.md`

## Implementation Steps (Tuân thủ EPCC)
1. **Explore**:
   - Nghiên cứu yêu cầu người dùng: Bổ sung 4 bước Explore (hỏi/brainstorm), Plan (viết task nhỏ), Code (TDD), Check (verify/merge).
   - Xác định các file cần sửa: `AGENTS.md`, `README.md`, `thoughts/README.md`, `thoughts/templates/plan-template.md`.
2. **Plan**:
   - Tạo ticket và plan (đang thực hiện retroactively).
3. **Code (TDD)**:
   - Tạo file `thoughts/workflows/epcc.md`.
   - Cập nhật `AGENTS.md` (Routing & Workflow section).
   - Cập nhật `thoughts/README.md`.
   - Cập nhật `thoughts/templates/plan-template.md`.
   - Cập nhật root `README.md`.
4. **Check**:
   - Chạy `scripts/validate-harness.ps1`.
   - Kiểm tra lại nội dung các file đã sửa.

## Files Expected To Change
- `AGENTS.md`
- `README.md`
- `thoughts/README.md`
- `thoughts/templates/plan-template.md`
- `thoughts/workflows/epcc.md` (New)

## Validation Plan
- Chạy `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/validate-harness.ps1`

## Risks And Mitigations
- **Risk**: Làm hỏng bảng routing trong `AGENTS.md`.
- **Mitigation**: Chạy validation script để kiểm tra tính toàn vẹn của các tham chiếu.

## Open Questions
- None.
