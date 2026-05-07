# AI-Native Engineering Harness

Chào mừng bạn đến với repository **Harness Coding Framework**. Đây không chỉ là một codebase tiêu chuẩn; nó là một **Nền tảng Kỹ thuật AI-Native Đa Ngôn Ngữ (Polyglot Harness)** được xây dựng đặc biệt để thao tác, mở rộng và bảo trì bởi các AI Coding Agent tự trị (như Gemini, Cursor, GitHub Copilot).

Kiến trúc được thiết kế xoay quanh tính **Tất định (Determinism)** và **Cô lập Tính năng (Strict Feature Isolation)**, áp dụng cho nhiều hệ sinh thái công nghệ khác nhau.

---

## 🤖 Hướng dẫn dành cho AI Agents (ĐẶC BIỆT QUAN TRỌNG)

Hệ thống được truyền cảm hứng từ các mô hình **Agentic Coding Harness** hiện đại (như khái niệm từ Fabric, Trellis, hay Prompt-Driven Development). Để đảm bảo trải nghiệm liền mạch, chúng tôi cấu trúc repository thành các phân hệ theo ngôn ngữ/công nghệ (Ví dụ: `/c#/`, `/frontend/`, `/python/`).

- Tại thư mục gốc đã tích hợp sẵn file cấu hình chung `AGENTS.md`. Tất cả các AI Agent đều phải lấy đây làm điểm khởi đầu.
- **Cơ chế Định tuyến (Routing)**: Tùy thuộc vào task bạn đang thực thi thuộc ngôn ngữ/framework nào, bạn PHẢI tìm đến thư mục chứa rulebook của hệ sinh thái đó. 

1. **Tải Ngữ Cảnh (Context Loading)**: Luôn đọc file `AGENTS.md` ở thư mục gốc, và file `README.md` nằm trong thư mục công nghệ (VD: `/c#/README.md`) trước khi viết code.
2. **Tính Tất định (Determinism)**: Không tự bịa ra các đường dẫn file (hallucinate file paths). Tuân thủ nghiêm ngặt các quy tắc đặt tên và cấu trúc thư mục quy định trong từng phân hệ.
3. **Cô lập Tính năng (Feature Isolation)**: Mỗi tính năng cần được module hóa chặt chẽ (VD: Vertical Slices cho Backend C#).
4. **Tính Rõ ràng (Explicitness)**: Không bao giờ sử dụng các đoạn code giữ chỗ (placeholder) như `TODO` hoặc `...`. Phải viết code hoàn chỉnh.

---

## 🏛️ Các Hệ Sinh Thái Hỗ Trợ (Supported Stacks)

Harness này cung cấp các bộ quy tắc chuyên sâu (Rulebook), Prompts, và Workflows cho các hệ sinh thái sau. AI Agent cần truy cập vào từng thư mục để nhận bộ quy tắc tương ứng:

- 🟢 **[C# / .NET ABP Framework](c#/README.md)**: Nằm tại `/c#/`. Dành cho các dự án Backend Monolith Modular sử dụng .NET 8, tuân thủ Strict Vertical Slices và DDD.

*(Các hệ sinh thái khác như Node.js, Frontend React/Vue, Python AI sẽ được mở rộng trong tương lai theo cấu trúc tương tự).*

---

## 👨‍💻 Dành cho Lập trình viên Con người

**Cách sử dụng hệ thống này:**
Thay vì tự tay viết những đoạn code boilerplate, công việc của bạn là điều hướng AI.
1. Định nghĩa logic nghiệp vụ của bạn bằng ngôn ngữ tự nhiên.
2. Trỏ AI vào các file prompt generator (Ví dụ: `/c#/prompts/feature-generator.md`) để khởi tạo tính năng mới.
3. Yêu cầu AI tuân thủ **Prompt-Driven Architecture** (có `prompt-spec.md`).
4. Review code được sinh ra và kiểm tra các logic nghiệp vụ.
