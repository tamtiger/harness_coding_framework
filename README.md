# AI-Native Engineering Harness

`harness_coding_framework` là một framework phát triển phần mềm đa ngôn ngữ (polyglot) được thiết kế tối ưu cho AI (agent-native). Nó lưu trữ các chỉ thị điều hướng (routing instructions), quy tắc (rulebooks), luồng công việc (workflows), mẫu prompt, kịch bản kiểm tra (validation scripts) và các tài liệu lập kế hoạch mà các AI Agent cần đọc trước khi chạm vào mã nguồn thực tế.

Repository này được thiết kế xoay quanh nguyên lý "Tải Ngữ Cảnh Tất Định" (deterministic context loading): các agent sẽ bắt đầu từ một điểm vào chung duy nhất, sau đó điều hướng đến đúng technology stack, tuân thủ các quy tắc riêng của dự án (project-specific rulebook) nếu có, và cuối cùng phải tự chạy test/validate công việc trước khi báo cáo hoàn thành.

## Điểm Vào Cho Agent (Agent Entrypoint)

[AGENTS.md](AGENTS.md) là file chỉ thị chung duy nhất dành cho TẤT CẢ các công cụ AI (Antigravity, Cursor, GitHub Copilot, v.v.). Tuyệt đối không thêm các file root đặc thù cho từng công cụ (ví dụ: `CLAUDE.md`, `.cursorrules`...) trừ khi team quyết định hỗ trợ chúng sau này.

Luồng làm việc của Agent:

1. Đọc `AGENTS.md`.
2. Xác định stack và project đang làm việc.
3. Đọc file `README.md` tương ứng của stack đó.
4. Đọc rulebook của project nếu tác vụ thuộc về một project cụ thể.
5. Sử dụng workflow, prompt, bản kế hoạch (plan) và validation script tương ứng.

## Bản Đồ Repository (Repository Map)

| Đường dẫn (Path) | Mục đích (Purpose) |
| --- | --- |
| `AGENTS.md` | Điểm vào định tuyến chung không phụ thuộc công cụ dành cho AI agents |
| `c#/` | Rulebook kiến trúc cơ sở cho C# / .NET / ABP Framework |
| `c#/prompts/` | Các prompt đặc thù, bao gồm C# feature generator |
| `c#/workflows/` | Các luồng công việc: triển khai (implementation), khởi tạo dự án (onboarding), ghi nhớ (memory) và sửa lỗi (repair) |
| `c#/projects/payment-hub/` | Rulebook đặc thù cho dự án Payment Hub |
| `thoughts/` | Workspace chứa templates và các file Tickets, Plans, Research, Memory |
| `scripts/validate-harness.ps1` | Script kiểm tra tính hợp lệ của metadata và rulebooks |

## Các Stack Được Hỗ Trợ (Supported Stack)

### C# / .NET / ABP Framework

Bắt đầu với [c#/README.md](c#/README.md). Rulebook này định nghĩa các baseline về ABP, vertical slices, ranh giới DDD, API contracts, testing, CI, naming conventions, dependencies và quy trình làm việc của agent.

Các rulebook đặc thù của project nằm ở `c#/projects/{ProjectName}/`. Project rulebook hiện tại là [Payment Hub](c#/projects/payment-hub/README.md), trong đó bổ sung thêm các quy tắc điều phối thanh toán về bảo mật (security), tính lũy đẳng (idempotency), máy trạng thái (state machines), messaging, lưu trữ (persistence), observability, provider adapters, testing và CI.

Các stack khác có thể được thêm vào sau với cùng một cấu trúc (pattern):

```text
{stack}/
 ├── README.md
 ├── workflows/
 ├── prompts/
 └── projects/{ProjectName}/
```

## Luồng Ngữ Cảnh (Context Workflow)

**Thoughts First (Bắt Buộc)**: Sử dụng thư mục `thoughts/` cho MỌI công việc (ngoại trừ các thay đổi cực nhỏ) để lưu lại lịch sử (history), kế hoạch và các quyết định thiết kế. Điều này giúp duy trì ngữ cảnh xuyên suốt các phiên chat.

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

Tất cả file trong `shared/` phải đặt tên theo format `YYYYMMDD_HHMM_task-name.md` (ví dụ: `20260508_1335_harness-phase2-plan.md`). Chi tiết xem tại [thoughts/README.md](thoughts/README.md).

Quy trình (flow) bắt buộc **EPCC** (Mandatory):

1. **Explore**: Tạo một Ticket từ `thoughts/templates/ticket-template.md` và làm rõ yêu cầu.
2. **Plan**: Tạo một Plan từ `thoughts/templates/plan-template.md` với các task nhỏ.
3. **Code**: Triển khai theo TDD (test trước, code sau). Đối với C#, cập nhật `prompt-spec.md` và `feature-manifest.json`.
4. **Check**: Chạy validation script, verify toàn bộ và cập nhật checklist/changelog.

Kế hoạch cải tiến harness hiện tại đang được theo dõi tại:
- Phase 1: [20260508_0931_harness-improvement-plan.md](thoughts/shared/03-plans/20260508_0931_harness-improvement-plan.md) ✅ Hoàn tất
- Phase 2: [20260508_1335_harness-phase2-plan.md](thoughts/shared/03-plans/20260508_1335_harness-phase2-plan.md) ✅ Hoàn tất

## Khởi Tạo Tính Năng C# (C# Feature Generation)

Sử dụng [c#/prompts/feature-generator.md](c#/prompts/feature-generator.md) cho các tính năng ABP. Yêu cầu:

- Đọc tải rulebook của stack và project
- Cần có `prompt-spec.md` trước khi triển khai
- Cập nhật `feature-manifest.json` khớp với các layer bị ảnh hưởng
- Đặt đúng vị trí các thành phần (contracts, domain, application, infrastructure, HTTP API, tests) vào các project ABP tương ứng
- Phải kiểm tra/validate thật kỹ trước khi đánh dấu tác vụ hoàn thành

## Kiểm Tra Hợp Lệ (Validation)

Chạy script kiểm tra (harness validation) từ thư mục gốc của repository:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/validate-harness.ps1
```

Script hiện đang kiểm tra:

- File gốc `AGENTS.md` và `c#/README.md`
- **Cross-reference**: Các file được reference trong bảng routing của `AGENTS.md` phải thực sự tồn tại
- Thư mục `thoughts/` và các file templates
- Các file bắt buộc trong C# project rulebook
- Định dạng và các giá trị hợp lệ của `feature-manifest.json`
- Sự tồn tại của file `prompt-spec.md` song song với mỗi feature manifest
- Các tiêu đề (headings) bắt buộc trong prompt specs
- **Agent Memory**: Nếu tồn tại `AGENT_MEMORY.md`, kiểm tra các headings bắt buộc
- **Summary output**: In chi tiết số lượng từng loại file đã kiểm tra


## Dành Cho Con Người (Human Usage)

Khi bạn muốn giao việc cho một AI agent:

1. Nêu rõ đích đến: stack, project, module, và kết quả mong muốn.
2. Yêu cầu agent đọc `AGENTS.md` và các rulebooks liên quan.
3. Đối với các tác vụ phức tạp, yêu cầu agent tạo một Plan nằm trong `thoughts/shared/03-plans/`.
4. Đối với việc phát triển tính năng C#, yêu cầu agent sử dụng feature generator prompt và duy trì file `prompt-spec.md` cộng với `feature-manifest.json`.
5. Bắt buộc agent phải chạy `scripts/validate-harness.ps1` thành công trước khi chấp nhận hoàn thành tác vụ.

## Chính Sách Ngôn Ngữ (Language Policy)

- **Tiếng Việt**: Dùng cho các tài liệu điều hướng cấp cao (root `README.md`, `AGENTS.md`, `thoughts/README.md`, project `README.md`).
- **Tiếng Anh**: Dùng cho các rulebook kỹ thuật chi tiết (`architecture-rules.md`, `naming-conventions.md`, v.v.) và templates — vì các thuật ngữ kỹ thuật (technical terms) giữ nguyên tiếng Anh giúp AI agent xử lý chính xác hơn.

Quy tắc này là chủ ý (intentional) nhằm cân bằng giữa khả năng đọc hiểu của con người (tiếng Việt) và độ chính xác kỹ thuật cho AI agent (tiếng Anh).

## Trạng Thái Triển Khai Hiện Tại (Current Implementation Status)

- **Phase 1** (cấu trúc cơ bản): Hoàn tất — `thoughts/shared/03-plans/20260508_0931_harness-improvement-plan.md`.
- **Phase 2** (defensive hardening & agent productivity): Hoàn tất — `thoughts/shared/03-plans/20260508_1335_harness-phase2-plan.md`.
- Script kiểm tra (Harness validation) đang pass 100% trên môi trường local.
