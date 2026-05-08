# Không Gian Tư Duy (Thoughts Workspace)

Thư mục `thoughts/` lưu trữ các tài liệu (artifacts) kỹ thuật ngữ cảnh, giúp các AI Agent và con người có thể tiếp tục công việc xuyên suốt qua nhiều phiên làm việc (sessions) khác nhau mà không làm quá tải các file chỉ thị gốc.

## Cấu Trúc (Structure)

```text
thoughts/
 ├── shared/
 │    ├── 01-tickets/
 │    ├── 02-research/
 │    └── 03-plans/
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
