# Chỉ Thị Chung Dành Cho AI Agent (AI Agent Global Instructions)

Repository này là một AI-Native Engineering Harness dành cho việc phát triển phần mềm đa ngôn ngữ (polyglot). `AGENTS.md` là điểm vào chung duy nhất cho mọi công cụ lập trình AI: Codex, Cursor, Windsurf, Claude, GitHub Copilot, Gemini, và các agent trong tương lai.
Tuyệt đối không tạo các file chỉ thị gốc đặc thù cho từng công cụ (ví dụ `.cursorrules`, `CLAUDE.md`) trừ khi con người yêu cầu rõ ràng.

## Định Tuyến Bắt Buộc (Mandatory Routing)

Trước khi viết code, thay đổi kiến trúc hoặc trả lời các câu hỏi về triển khai, hãy xác định technology stack và tải file rulebook tương ứng.

| Khu Vực Làm Việc (Work Area) | Đọc Trước Tiên (Read First) |
| --- | --- |
| C# / .NET / ABP Framework | `c#/README.md` |
| Các công việc đặc thù của dự án C# | `c#/projects/{ProjectName}/README.md` sau khi đọc `c#/README.md` |
| Các stack khác | `{stack}/README.md` nếu thư mục của stack đó tồn tại |
| Rulebook cho dự án C# mới | `c#/workflows/project-onboarding.md` |
| Tính năng C# mới | `c#/workflows/feature-implementation.md` |
| Sửa lỗi / Hotfix C# | `c#/workflows/bug-fix.md` |
| Review code C# | `c#/workflows/code-review.md` |
| Công việc C# kéo dài (Long-running) | `c#/workflows/agent-memory-workflow.md` |
| Nghiên cứu & Lập kế hoạch (Research & Planning) | `thoughts/README.md` |

Các rulebook của stack định nghĩa baseline về kiến trúc, ranh giới phụ thuộc (dependency boundaries), quy tắc đặt tên, testing, CI, và quy trình của agent. Các rulebook của dự án định nghĩa các quyết định đặc thù cho sản phẩm như database engine, messaging, bảo mật, observability, máy trạng thái (state machines), các adapter bên ngoài và quy trình vận hành.

Khi quy tắc đặc thù của dự án mâu thuẫn với quy tắc chung của stack về một chi tiết triển khai cụ thể, quy tắc của dự án sẽ được ưu tiên (take precedence). Các ranh giới kiến trúc và phân tầng chung vẫn được áp dụng trừ khi rulebook dự án có ghi nhận sự ghi đè (override) rõ ràng.

## Danh Mục Stack Hiện Tại (Current Stack Inventory)

- `c#/`: Rulebook cơ sở cho C# / .NET / ABP Framework.
- `c#/projects/payment-hub/`: Rulebook cho sản phẩm Payment Hub.
- `thoughts/`: Không gian tư duy (Workspace) chứa templates cho tickets, plans, research và agent memory.

## Luồng Làm Việc Của Agent (Agent Workflow)

Hãy sử dụng repository này như một hệ thống "Kỹ sư ngữ cảnh" (context-engineering system), không chỉ đơn thuần là một thư mục chứa prompt.

1. Xác định phạm vi (scope): stack, project, module, tính năng, hành động và các layer bị ảnh hưởng.
2. Chỉ tải (load) các rulebook cần thiết cho phạm vi đó.
3. **Thoughts First (Bắt Buộc)**: Đối với MỌI công việc không nhỏ (non-trivial), agent PHẢI tạo hoặc cập nhật ticket trong `thoughts/shared/01-tickets/` và plan trong `thoughts/shared/03-plans/` TRƯỚC KHI viết code. Chỉ được bỏ qua bước này khi tác vụ là sửa lỗi nhỏ (< 3 files), cập nhật tài liệu đơn lẻ, hoặc con người yêu cầu rõ ràng bỏ qua.
4. Đối với việc phát triển tính năng C#, tạo hoặc cập nhật `prompt-spec.md` trước khi bắt tay vào triển khai.
5. Giữ file `feature-manifest.json` luôn đồng bộ với các dependencies, quyền hạn (permissions), events, các layer bị chạm đến và trạng thái `ai_status`.
6. Tự động kiểm tra với các script build, tests và script harness validation phù hợp trước khi báo cáo hoàn thành.

## Các Ràng Buộc Không Thể Thương Lượng (Non-Negotiable Constraints)

- Không được ảo tưởng/đoán mò đường dẫn (hallucinate paths). Luôn kiểm tra (inspect) repository khi không chắc chắn.
- Không được sinh ra code chưa hoàn thiện, các bản triển khai giữ chỗ (placeholder implementations), hoặc `NotImplementedException`.
- Không được refactor các file không liên quan hoặc vượt qua ranh giới module nếu tác vụ không yêu cầu.
- Không được đưa ra các quyết định về cơ sở hạ tầng đặc thù của sản phẩm nếu nó không nằm trong rulebook của dự án đó.
- Giữ file này ngắn gọn. Các quy tắc chi tiết phải nằm trong rulebooks của stack/project, workflows, templates, hoặc các scripts mà agent có thể gọi tải theo nhu cầu (on demand).
