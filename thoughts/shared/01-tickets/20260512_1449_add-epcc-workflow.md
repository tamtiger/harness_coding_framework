# Ticket: Bổ sung quy trình EPCC vào Harness

## Metadata
- **Ticket ID**: HARNESS-EPCC
- **Stack**: other
- **Project**: harness_coding_framework
- **Module**: core
- **Requester**: USER
- **Priority**: High
- **Estimated Effort**: S
- **Status**: Done

## Problem
Harness hiện tại chưa có quy trình làm việc chuẩn hóa cho AI Agent. Cần một quy trình giúp đảm bảo chất lượng từ khâu hiểu yêu cầu đến khâu kiểm tra cuối cùng.

## Desired Outcome
AI Agent tuân thủ quy trình EPCC (Explore, Plan, Code, Check) để tăng tính ổn định và chính xác khi thực hiện nhiệm vụ.

## Scope
### In Scope
- Tạo tài liệu hướng dẫn EPCC.
- Cập nhật `AGENTS.md` để bắt buộc tuân thủ EPCC.
- Cập nhật các template và README liên quan.

### Out Of Scope
- Tự động hóa hoàn toàn quy trình bằng script.

## Constraints
- Phải đảm bảo script `validate-harness.ps1` vẫn pass 100%.

## Acceptance Criteria
- File `thoughts/workflows/epcc.md` tồn tại và đầy đủ nội dung.
- `AGENTS.md` đã link tới quy trình EPCC.
- `plan-template.md` đã cập nhật các bước theo EPCC.
- Root `README.md` đã cập nhật luồng làm việc.

## References
- `AGENTS.md`
- `thoughts/README.md`
