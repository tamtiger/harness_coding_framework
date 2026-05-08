# Thuật Ngữ (Glossary)

Danh sách thuật ngữ chuyên biệt được sử dụng trong harness này. Sắp xếp theo
thứ tự bảng chữ cái.

| Thuật ngữ | Giải thích |
| --- | --- |
| **ABP Framework** | Framework mã nguồn mở cho .NET, cung cấp kiến trúc module hóa, DDD, multi-tenancy, và hệ sinh thái enterprise |
| **Agent Memory** | File `AGENT_MEMORY.md` lưu trữ ngữ cảnh xuyên phiên làm việc (cross-session) cho AI agent |
| **Canonical State** | Trạng thái chuẩn hóa trong state machine — mọi provider phải ánh xạ (map) trạng thái riêng về bộ trạng thái chuẩn này |
| **Circuit Breaker** | Pattern cắt mạch tạm thời khi dịch vụ bên ngoài lỗi liên tục, tránh cascading failure |
| **CloudEvents** | Đặc tả (specification) chuẩn hóa cấu trúc event metadata (envelope) cho hệ thống event-driven |
| **CQRS** | Command Query Responsibility Segregation — tách riêng luồng ghi (Command) và luồng đọc (Query) |
| **DDD** | Domain-Driven Design — thiết kế phần mềm xoay quanh nghiệp vụ (domain model) |
| **ETO** | Event Transfer Object — DTO chuyên dùng cho distributed events trong ABP (ví dụ: `ProductCreatedEto`) |
| **Exemplar** | Ví dụ tham khảo hoàn chỉnh (reference example) nằm trong `c#/examples/`, KHÔNG phải code production |
| **Feature Manifest** | File `feature-manifest.json` mô tả metadata của một feature: dependencies, layers, permissions, events, status |
| **Harness** | Bộ khung chỉ thị (instruction framework) giúp AI agent hoạt động tất định (deterministic) trong repo |
| **Idempotency** | Tính lũy đẳng — gọi cùng request N lần cho kết quả giống hệt như gọi 1 lần |
| **Inbox Pattern** | Pattern lưu trữ message đã nhận để dedup (chống trùng lặp) ở consumer side |
| **KMS** | Key Management Service — hệ thống quản lý khóa mã hóa tập trung |
| **Modular Monolith** | Kiến trúc monolith nhưng chia thành các module có ranh giới rõ ràng, giao tiếp qua interface/event |
| **Outbox Pattern** | Pattern lưu event vào DB cùng transaction với data, sau đó publish lên message broker (đảm bảo exactly-once) |
| **Prompt Spec** | File `prompt-spec.md` — đặc tả yêu cầu tính năng (feature request specification) dạng Prompt-as-Code |
| **Repair Strategy** | Hướng dẫn có cấu trúc để agent tự sửa lỗi (compile, runtime, test) mà không cần con người can thiệp |
| **Row-Level Security** | Cơ chế phân quyền ở mức dòng dữ liệu trong database, dùng để cách ly tenant |
| **Rulebook** | Tập hợp các quy tắc kiến trúc và vận hành mà agent PHẢI tuân thủ khi làm việc trong một stack/project |
| **Terminal State** | Trạng thái cuối cùng (final state) trong state machine — không được phép chuyển tiếp nữa |
| **Thoughts** | Workspace (`thoughts/`) chứa tickets, research, plans — "bộ nhớ ngoài" của agent |
| **Vertical Slice** | Kiến trúc cắt dọc — mỗi feature chứa tất cả các tầng (layer) cần thiết trong một folder duy nhất |
