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

Sử dụng thư mục `thoughts/` cho các công việc cần lưu trữ dài hạn (vượt qua phạm vi của một phiên chat).

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

Quy trình (flow) được khuyến nghị:

1. Tạo một Ticket từ `thoughts/templates/ticket-template.md`.
2. Tạo một Plan từ `thoughts/templates/plan-template.md`.
3. Bắt tay vào viết code theo đúng Plan đã được duyệt.
4. Đối với các tính năng C#, tạo mới hoặc cập nhật `prompt-spec.md` và `feature-manifest.json`.
5. Chạy test (validate) và cập nhật checklist trong Plan trước khi báo xong.

Kế hoạch cải tiến harness hiện tại đang được theo dõi tại
[thoughts/shared/03-plans/harness-improvement-plan.md](thoughts/shared/03-plans/harness-improvement-plan.md).

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

- File gốc `AGENTS.md`
- `c#/README.md`
- Thư mục `thoughts/` và các file templates
- Các file bắt buộc trong C# project rulebook
- Định dạng và các giá trị hợp lệ của `feature-manifest.json`
- Sự tồn tại của file `prompt-spec.md` song song với mỗi feature manifest
- Các tiêu đề (headings) bắt buộc trong prompt specs


## Dành Cho Con Người (Human Usage)

Khi bạn muốn giao việc cho một AI agent:

1. Nêu rõ đích đến: stack, project, module, và kết quả mong muốn.
2. Yêu cầu agent đọc `AGENTS.md` và các rulebooks liên quan.
3. Đối với các tác vụ phức tạp, yêu cầu agent tạo một Plan nằm trong `thoughts/shared/03-plans/`.
4. Đối với việc phát triển tính năng C#, yêu cầu agent sử dụng feature generator prompt và duy trì file `prompt-spec.md` cộng với `feature-manifest.json`.
5. Bắt buộc agent phải chạy `scripts/validate-harness.ps1` thành công trước khi chấp nhận hoàn thành tác vụ.

## Trạng Thái Triển Khai Hiện Tại (Current Implementation Status)

Giai đoạn cải tiến harness đã được triển khai xong và đánh dấu hoàn tất trong
`thoughts/shared/03-plans/harness-improvement-plan.md`. Script kiểm tra (Harness validation) đang pass 100% trên môi trường local.
