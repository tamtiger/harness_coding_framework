# Quy Trình EPCC (Explore - Plan - Code - Check)

Đây là quy trình làm việc tiêu chuẩn dành cho AI Agent trong Harness này để đảm bảo chất lượng code và tính nhất quán của hệ thống.

## Khi Nào Được Bỏ Qua EPCC

Bỏ qua EPCC khi thỏa **một trong** các điều kiện sau:
- Sửa lỗi nhỏ ảnh hưởng **< 3 files** (typo, format, fix nhỏ).
- Cập nhật tài liệu đơn lẻ (1 file markdown).
- Con người yêu cầu rõ ràng bỏ qua.

Trong mọi trường hợp khác, PHẢI tuân thủ đầy đủ 4 bước dưới đây.

## 1. Explore (Khám Phá & Phân Tích)
**Mục tiêu:** Hiểu rõ yêu cầu, xác định phạm vi và brainstorm thiết kế.

- **Hỏi rõ yêu cầu:** Nếu yêu cầu của người dùng chưa rõ ràng hoặc còn thiếu thông tin, Agent PHẢI đặt câu hỏi để làm rõ.
- **Brainstorm thiết kế:** Nghiên cứu mã nguồn hiện tại, xác định các module bị ảnh hưởng.
- **Tài liệu hóa:** Lưu kết quả vào `thoughts/shared/02-research/` nếu là nghiên cứu phức tạp, hoặc ghi chú vào Ticket trong `thoughts/shared/01-tickets/`.

## 2. Plan (Lập Kế Hoạch)
**Mục tiêu:** Chia nhỏ công việc thành các task có thể thực hiện và kiểm chứng được.

- **Viết Plan chi tiết:** Tạo file trong `thoughts/shared/03-plans/` sử dụng `plan-template.md`.
- **Chia nhỏ Task:** Mỗi task không nên quá lớn. Xác định rõ Input/Output cho từng task.
- **Xác định tiêu chí hoàn thành (Definition of Done):** Bao gồm cả các bài test cần pass.

## 3. Code (Triển Khai & TDD)
**Mục tiêu:** Viết code chất lượng cao thông qua Test-Driven Development.

- **Test Trước (Test-First):** Viết unit test hoặc integration test trước khi viết code logic (nếu có thể).
- **Implement Logic:** Viết code để pass test. Tuân thủ các rulebook của stack (ví dụ `c#/README.md`).
- **Refactor:** Tối ưu hóa code sau khi test đã pass.
- **Không Placeholder:** Tuyệt đối không để lại code giả hoặc `NotImplementedException`.

## 4. Check (Kiểm Tra & Hoàn Tất)
**Mục tiêu:** Xác minh toàn bộ thay đổi và chuẩn bị cho việc merge.

- **Verify toàn bộ:** Chạy lại toàn bộ test suite liên quan. Chạy các harness validation script.
- **Self-Review:** Tự kiểm tra lại code theo `code-review.md`.
- **Merge/PR:** Tạo Merge Request (MR) trên GitLab (nếu có tích hợp) hoặc báo cáo hoàn thành cho người dùng.
- **Cập nhật Manifest:** Đảm bảo `feature-manifest.json` và `CHANGELOG.md` được cập nhật chính xác.

---

## Ví Dụ Áp Dụng EPCC

**Yêu cầu:** "Thêm API endpoint POST /api/orders/{id}/cancel"

| Bước | Agent Làm Gì |
|------|---------------|
| **Explore** | Đọc `OrdersController.cs` hiện tại, xem `OrderAppService`, kiểm tra state machine cho phép cancel từ trạng thái nào. Tạo ticket trong `thoughts/shared/01-tickets/`. |
| **Plan** | Tạo plan: (1) Thêm `CancelOrderInput` DTO, (2) Thêm method `CancelAsync` trong AppService, (3) Thêm endpoint trong Controller, (4) Viết unit test. |
| **Code** | Viết test `CancelOrder_ShouldTransitionToCancel_WhenStatusIsPending` trước. Sau đó implement logic để test pass. |
| **Check** | Chạy `dotnet test`, chạy `validate-harness.ps1`, self-review, tạo MR. |
