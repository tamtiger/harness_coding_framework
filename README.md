# AI-Native ABP Engineering Harness

Chào mừng bạn đến với repository **Harness Coding Framework**. Đây không chỉ là một codebase tiêu chuẩn; nó là một **Nền tảng Kỹ thuật AI-Native** được xây dựng đặc biệt để thao tác, mở rộng và bảo trì bởi các AI Coding Agent tự trị (như Gemini, Cursor, GitHub Copilot).

Kiến trúc được thiết kế xoay quanh tính **Tất định (Determinism)**, **Phân lớp dọc nghiêm ngặt (Strict Vertical Slices)**, và **ABP Framework (Modular Monolith)**.

---

## 🤖 Hướng dẫn dành cho AI Agents (ĐẶC BIỆT QUAN TRỌNG)

Nếu bạn là một AI Agent đang hoạt động trong workspace này, bạn PHẢI coi thư mục `/c#/` là Nguồn Chân lý (Source of Truth) tuyệt đối của mình.

1. **Tải Ngữ Cảnh (Context Loading)**: Luôn đọc các file `.md` liên quan trong thư mục `/c#/` trước khi viết hoặc sửa đổi bất kỳ đoạn code nào.
2. **Tính Tất định (Determinism)**: Không tự bịa ra các đường dẫn file (hallucinate file paths). Tuân thủ nghiêm ngặt các quy tắc đặt tên và cấu trúc thư mục để hành động của bạn luôn có thể dự đoán được.
3. **Cô lập Tính năng (Feature Isolation)**: Mỗi tính năng PHẢI được chứa hoàn toàn trong một thư mục duy nhất đi kèm với file `feature-manifest.json` (Vertical Slice).
4. **Tính Rõ ràng (Explicitness)**: Không bao giờ sử dụng các đoạn code giữ chỗ (placeholder) như `TODO`, `...`, hoặc `throw new NotImplementedException()`. Phải viết code hoàn chỉnh.
5. **Tuân thủ ABP (ABP Compliance)**: Tuân thủ tuyệt đối cơ chế tiêm phụ thuộc (`[Dependency]`), phân quyền (`[Authorize]`), và pipeline xác thực (validation) của ABP.

---

## 🏛️ Các Trụ Cột Kiến Trúc Cốt Lõi

1. **.NET 8 & ABP Framework 8.x**: Nền tảng của hệ thống. Chúng ta phụ thuộc nhiều vào tính mô-đun, DI, và các lớp cơ sở theo mô hình Domain-Driven Design (DDD) của ABP.
2. **Deterministic Vertical Slices**: Thay vì tách file theo loại (Controllers, Services, Repositories) sang nhiều project khác nhau, chúng ta gom tất cả theo **Feature (Tính năng)**. Một AI Agent có thể nhìn vào một thư mục và hiểu toàn bộ vòng đời của một request.
3. **CQRS (Command Query Responsibility Segregation)**: Các thao tác Đọc và Ghi được tách biệt. Mỗi feature thường đại diện cho một Command hoặc một Query.
4. **Không Ràng buộc UI giữa các Module**: Các module giao tiếp độc quyền thông qua **Distributed Event Bus** (bất đồng bộ) hoặc các **AppService Interfaces** được định nghĩa rõ ràng ở tầng `Contracts` (đồng bộ).

---

## 📚 Mục Lục Sổ Tay AI (The AI Rulebook Index)

Để hiểu rõ cách hoạt động tại đây, hãy tham khảo các tài liệu sống trong thư mục `/c#/`:

- 🏗️ **[Quy tắc Kiến trúc (Architecture Rules)](c#/architecture-rules.md)**: Phân tầng, công nghệ, và ranh giới các module.
- 🔗 **[Quy tắc Phụ thuộc (Dependency Rules)](c#/dependency-rules.md)**: Quy tắc cho `[DependsOn]`, Cô lập Tầng (Layer Isolation), và Injection.
- 🔤 **[Quy ước Đặt tên (Naming Conventions)](c#/naming-conventions.md)**: Quy tắc PascalCase/camelCase nghiêm ngặt để đảm bảo tính dự đoán.
- 🚫 **[Anti-Patterns](c#/anti-patterns.md)**: Những điều bạn KHÔNG BAO GIỜ được làm (VD: God Services, Lộ Entities).
- 📦 **[Mẫu Feature (Feature Template)](c#/feature-template.md)**: Cấu trúc thư mục chính xác và manifest bắt buộc cho mỗi feature mới.
- 🗺️ **[Bản đồ Module (Module Map)](c#/module-map.md)**: Các module đang hoạt động và ranh giới của chúng.
- 🤖 **[Prompts](c#/prompts/)**: Các câu lệnh mẫu (VD: `feature-generator.md`) dùng để điều khiển AI.
- 🔄 **[Quy trình (Workflows)](c#/workflows/)**: Các Quy trình thao tác chuẩn (SOPs) từng bước cho các tác vụ phổ biến như tạo feature.
- 🏢 **[Đặc thù Dự án (Projects Specifics)](c#/projects/)**: Ràng buộc riêng của từng domain (VD: quy tắc của `payment-hub`).
- 🛠️ **[Chiến lược Sửa Lỗi (Repair Strategies)](c#/repair-strategies/)**: Hướng dẫn tự động debug (VD: cách fix `compile-errors.md`).

---

## 👨‍💻 Dành cho Lập trình viên Con người

**Cách sử dụng hệ thống này:**
Thay vì tự tay viết những đoạn code boilerplate, công việc của bạn là điều hướng AI.
1. Định nghĩa logic nghiệp vụ của bạn bằng ngôn ngữ tự nhiên.
2. Trỏ AI vào file `/c#/prompts/feature-generator.md` để khởi tạo một tính năng mới.
3. Để AI tự động sinh code theo Vertical Slice.
4. Review code được sinh ra, chạy `dotnet build`, và kiểm tra các logic nghiệp vụ.
