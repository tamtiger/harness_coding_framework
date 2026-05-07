# Cấu trúc và Quy trình Cập nhật Agent Memory (Nhật ký AI)

Để đảm bảo các AI Agent không bị mất ngữ cảnh (Context Loss) khi xử lý các task phức tạp kéo dài qua nhiều phiên làm việc, hệ thống yêu cầu áp dụng quy trình **Agent Memory / Journaling**.

## 1. File Context Trung Tâm (`AGENT_MEMORY.md`)

Khi bắt đầu làm việc trên một module lớn hoặc một epic, Agent phải tự động tạo (hoặc đọc nếu đã có) file `AGENT_MEMORY.md` ở thư mục gốc của dự án hoặc thư mục của feature đang làm.

File này hoạt động như bộ não ngoài của AI, chứa các thông tin:
- **Ngữ cảnh hiện tại**: Đang làm gì, mục tiêu cuối cùng là gì.
- **Tiến độ**: Các task đã hoàn thành, các task đang làm.
- **Quyết định kỹ thuật**: Vì sao lại chọn phương pháp A thay vì B (VD: tại sao lại sử dụng EventBus thay vì gọi API trực tiếp).
- **Lỗi đã gặp và cách khắc phục**: Để tránh mắc lại lỗi cũ (VD: Lỗi EF Core migration do thiếu khóa ngoại).

## 2. Quy trình làm việc (The Loop)

1. **Khởi tạo/Đọc Memory**:
   - Khi nhận prompt mới, AI phải kiểm tra xem có file `AGENT_MEMORY.md` hay không.
   - Nếu có, đọc nó đầu tiên để khôi phục ngữ cảnh.
   - Nếu không, và tác vụ phức tạp, hãy đề xuất tạo file này.

2. **Thực thi và Ghi chú**:
   - Trong quá trình viết code, nếu có một quyết định thiết kế quan trọng đi ngược lại chuẩn thông thường nhưng đã được User đồng ý, PHẢI ghi ngay vào Memory.

3. **Cập nhật Memory trước khi kết thúc**:
   - Trước khi báo cáo "Đã xong" với User, AI cập nhật lại `AGENT_MEMORY.md` để đánh dấu tiến độ và lưu ý cho phiên làm việc sau.

## 3. Lợi ích đối với Agentic Harness
- Mô hình này mô phỏng các kiến trúc Agentic tiên tiến như **Trellis** hay **Archon**, giúp biến AI từ một công cụ "hỏi-đáp" đơn thuần thành một thành viên nhóm phát triển có trí nhớ dài hạn (Long-term memory).
- Giảm thiểu số lượng token cần thiết để giải thích lại vấn đề mỗi khi mở chat mới.
