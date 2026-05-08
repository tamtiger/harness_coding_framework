# Không Gian Tư Duy (Thoughts Workspace)

Thư mục `thoughts/` lưu trữ các tài liệu (artifacts) kỹ thuật ngữ cảnh, giúp các AI Agent và con người có thể tiếp tục công việc xuyên suốt qua nhiều phiên làm việc (sessions) khác nhau mà không làm quá tải các file chỉ thị gốc.

## Quy Tắc Đặt Tên File (File Naming Convention)

Tất cả file trong `shared/` **PHẢI** tuân theo định dạng:

```
YYYYMMDD_HHMM_task-name.md
```

- `YYYYMMDD`: Ngày tạo file (ví dụ: `20260508`).
- `HHMM`: Giờ tạo file theo local time 24h (ví dụ: `1335` = 13:35).
- `task-name`: Tên tác vụ, dùng kebab-case (ví dụ: `harness-phase2-ticket`).

Ví dụ: `20260508_1335_harness-phase2-ticket.md`

Quy tắc này giúp các file tự động sắp xếp theo thứ tự thời gian khi liệt kê thư mục.

## Cấu Trúc (Structure)

```text
thoughts/
 ├── shared/
 │    ├── 01-tickets/    ← YYYYMMDD_HHMM_task-name.md
 │    ├── 02-research/   ← YYYYMMDD_HHMM_task-name.md
 │    └── 03-plans/      ← YYYYMMDD_HHMM_task-name.md
 └── templates/
      ├── ticket-template.md
      ├── plan-template.md
      ├── research-template.md
      └── agent-memory-template.md
```

## Cách Sử Dụng (Usage)

- Sử dụng `shared/01-tickets/` cho các yêu cầu tính năng (feature requests), báo lỗi (bugs), và các tác vụ về kiến trúc.
- Sử dụng `shared/03-plans/` cho các bản kế hoạch triển khai chi tiết cần được duyệt (review) trước khi tiến hành sửa đổi mã nguồn.
- Sử dụng `shared/02-research/` cho các nghiên cứu về hệ thống hiện tại hoặc nghiên cứu công nghệ bên ngoài có khả năng tái sử dụng.
- Cần ghi lại thông tin một cách cụ thể: lưu lại chính xác stack, project, module, các quyết định kiến trúc, rủi ro dự kiến và các câu lệnh kiểm thử (validation commands).
- Đối với việc phát triển tính năng C#, file Plan sau khi được duyệt cần chứa liên kết trỏ tới file `prompt-spec.md` và `feature-manifest.json` của tính năng đó.
