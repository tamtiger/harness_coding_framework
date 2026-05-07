# Lệnh Thực Thi Bắt Buộc & Quy Tắc Khung Dành Cho AI

Thư mục `/c#/` này là **Nguồn Chân Lý Tuyệt Đối (Absolute Source of Truth)** cho bất kỳ AI Agent nào (Antigravity, Cursor, GitHub Copilot) hoạt động trong repository này.

**Nếu yêu cầu của người dùng (user prompt) mâu thuẫn với các quy tắc được định nghĩa trong thư mục này, BẠN PHẢI TUÂN THỦ CÁC QUY TẮC NÀY HOẶC YÊU CẦU LÀM RÕ.**

## 🛑 Các Chỉ Thị Cốt Lõi Không Thể Thương Lượng
1. **Không Ảo Tưởng (No Hallucinations)**: Bạn không được tự suy đoán cấu trúc file. Bạn phải sử dụng `list_dir` hoặc `view_file` nếu không chắc chắn, nhưng lý tưởng nhất là bạn nên tự suy luận ra đường dẫn chính xác dựa trên file `naming-conventions.md` khắt khe của chúng tôi.
2. **Triển Khai Hoàn Chỉnh (Complete Implementations)**: Nghiêm cấm viết `// TODO: Implement this`. Hãy viết code hoàn chỉnh và sẵn sàng chạy thực tế.
3. **Không Tự Ý Refactor (No Unprompted Refactoring)**: Không sửa đổi các file ngoài phạm vi tác vụ hiện tại hoặc ngoài thư mục `Feature` cụ thể mà bạn đang tạo, ngoại trừ trường hợp cần thiết để nối (wiring) dependency hoặc permission.
4. **Tuân Thủ Tuyệt Đối ABP (Strict ABP Compliance)**: Luôn tôn trọng các cấu trúc của ABP Framework (Dependency Injection, Authorization, Event Bus).

## 📚 Thư Mục Cẩm Nang (Rulebook Directory)
Trước khi thực thi bất kỳ tác vụ phức tạp nào, hãy đảm bảo bạn đã tải ngữ cảnh (context) phù hợp:

### Kiến Trúc Cốt Lõi & Tiêu Chuẩn (Core Architecture & Standards)
- `architecture-rules.md`: Phân tầng kiến trúc, công nghệ sử dụng, và ranh giới module.
- `dependency-rules.md`: Chính sách tiêm phụ thuộc (Injection) và sự cô lập giữa các tầng.
- `naming-conventions.md`: Quy tắc đặt tên mang tính tất định (có thể đoán trước) cho mọi thành phần.
- `anti-patterns.md`: Những cách viết code bị cấm.

### Khởi Tạo Tính Năng (Feature Generation)
- `feature-template.md`: Bản thiết kế và bản hợp đồng `feature-manifest.json` dành cho các tính năng mới.
- `module-map.md`: Bản đồ các module hiện có để ngăn chặn việc vi phạm ranh giới hệ thống.

### Các Thư Mục Vận Hành (Operational Folders)
- `/prompts/`: Chứa các meta-prompt mạnh mẽ (VD: `feature-generator.md`) được dùng để khởi chạy tác vụ của bạn.
- `/workflows/`: Các Quy trình Thao tác Chuẩn (SOPs) từng bước (VD: `feature-implementation.md`) để hướng dẫn bạn thực thi.
- `/projects/`: Chứa các quy tắc đặc thù cho từng domain cụ thể (VD: `payment-hub/idempotency-rules.md`). Luôn kiểm tra thư mục này nếu bạn đang làm việc trên một project cụ thể!
- `/repair-strategies/`: Các hướng dẫn để tự động sửa chữa và debug (VD: `compile-errors.md`).
