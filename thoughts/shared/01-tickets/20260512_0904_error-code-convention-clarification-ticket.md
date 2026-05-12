# Ticket: Làm Rõ Hai Loại Error Code (Internal vs Public API)

## Metadata
- **Ticket ID**: `harness-003`
- **Stack**: `c#`
- **Project**: `None (generic harness) + payment-hub`
- **Module**: `None`
- **Requester**: `User`
- **Priority**: `High`
- **Estimated Effort**: `S`
- **Status**: `Done`

## Problem

Hiện tại harness có hai loại "error code" nhưng chưa phân biệt rõ ràng, dẫn
tới nguy cơ AI agent nhầm lẫn và dùng sai format:

1. **Internal domain error code** — code để throw `BusinessException` trong
   domain/application layer:
   - Định nghĩa tại `c#/error-code-conventions.md`.
   - Format: `{Module}:{Entity}:{NumericCode}` (ví dụ `PaymentHub:Transaction:0001`).
   - Sống ở `{Module}.Domain.Shared/{Module}ErrorCodes.cs`.
   - Dùng cho `throw new BusinessException(PaymentHubErrorCodes.TransactionNotFound)`.

2. **Public HTTP API error code** — code trả ra client trong response body:
   - Định nghĩa tại `c#/projects/payment-hub/api-contract-rules.md`.
   - Format: `payment_hub.<snake_case>` (ví dụ `payment_hub.validation_failed`).
   - Là public contract, ảnh hưởng SDK/client của tenant.
   - Được ABP map từ `BusinessException` code qua `IHttpExceptionStatusCodeFinder`
     hoặc custom middleware.

### Triệu chứng

- `c#/error-code-conventions.md` không nhắc đến public API error code nào cả,
  cũng không nói rõ các project được override format.
- `c#/projects/payment-hub/api-contract-rules.md` liệt kê list error code
  `payment_hub.*` mà không giải thích đây là HTTP response code (khác với
  internal `BusinessException` code).
- `c#/examples/CreateProduct/prompt-spec.md` throw `Catalog:Product:0001` với
  HTTP 409 — nhưng không thể hiện ánh xạ tới public API error code nào.
- Agent khi đọc cả hai file sẽ bối rối:
  - "Format nào đúng?"
  - "Có phải Payment Hub không tuân thủ generic rule?"
  - "Khi throw exception, dùng `PaymentHub:Transaction:0001` hay
    `payment_hub.validation_failed`?"

## Desired Outcome

- Harness phân biệt rõ ràng **hai layer** error code:
  - Internal domain error code (throw in code).
  - Public API error code (emit to client).
- Generic `c#/error-code-conventions.md` giải thích:
  - Cả hai concern tồn tại.
  - Default format cho internal code.
  - Cho phép project override public API format.
  - Cách map từ internal → public (ABP pattern).
- Project-specific `api-contract-rules.md` nói rõ đây là **public API contract
  layer** và trỏ về generic rule khi throw internal exception.
- AI agent đọc xong hiểu đúng: throw `PaymentHub:Transaction:0001` trong code,
  nhưng client thấy `payment_hub.transaction_not_found` trong HTTP response.

## Scope

### In Scope
- Refactor `c#/error-code-conventions.md` thêm section "Internal vs Public API
  Error Codes" và "Project Overrides".
- Thêm reference section trong `c#/projects/payment-hub/api-contract-rules.md`
  để link về generic rule.
- Cập nhật `c#/examples/CreateProduct/prompt-spec.md` show example đầy đủ:
  internal code `Catalog:Product:0001` → HTTP error code `catalog.sku_conflict`.
- Cập nhật `c#/prompts/feature-generator.md` để list `error-code-conventions.md`
  trong context loading (hiện đã có ở workflow bug-fix nhưng chưa có trong
  feature-generator).
- Cập nhật `CHANGELOG.md`.

### Out Of Scope
- Đổi format error code đã được code (không có code C# thật trong harness).
- Thêm project rulebook mới.
- Thay đổi ABP mapping infrastructure (chỉ document, không implement).

## Constraints
- Không phá vỡ rule precedence đã thiết lập: project-specific ưu tiên hơn
  generic khi có conflict (theo `AGENTS.md`).
- Giữ backward compatible với validation script hiện tại.
- Validation script phải pass 100% sau thay đổi.
- Không di chuyển file, không đổi tên file (chỉ edit nội dung + thêm nếu cần).
- Giữ language policy: generic rulebook English, navigation tiếng Việt.

## Acceptance Criteria

- [x] `c#/error-code-conventions.md` có section giải thích rõ hai loại error
      code với ví dụ code minh hoạ ánh xạ giữa chúng.
- [x] `c#/error-code-conventions.md` có section "Project-Specific Overrides"
      nhắc agent về precedence rule.
- [x] `c#/projects/payment-hub/api-contract-rules.md` có note ở đầu file giải
      thích đây là **public API error code**, không thay thế internal
      `BusinessException` code, và reference tới generic rule.
- [x] `c#/examples/CreateProduct/prompt-spec.md` có ví dụ end-to-end: internal
      error code → HTTP status code → public API error code.
- [x] `c#/prompts/feature-generator.md` list `error-code-conventions.md` trong
      required context loading.
- [x] `CHANGELOG.md` có entry cho thay đổi này.
- [x] `scripts/validate-harness.ps1` pass 100%.
- [x] Đọc lại các file đã sửa, một agent mới hiểu được 2 concept tách biệt trong
      ≤ 2 phút đọc.

## References

- Review chat với user (2026-05-12) thảo luận toàn bộ project.
- `c#/error-code-conventions.md`
- `c#/projects/payment-hub/api-contract-rules.md`
- `c#/examples/CreateProduct/prompt-spec.md`
- `AGENTS.md` — section "Thứ Tự Ưu Tiên Của Project Rulebook".
- `c#/README.md` — "Project Rulebook Precedence".
