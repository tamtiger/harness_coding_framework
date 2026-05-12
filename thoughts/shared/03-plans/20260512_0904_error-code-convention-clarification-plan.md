# Plan: Làm Rõ Hai Loại Error Code (Internal vs Public API)

## Source Ticket
- [`thoughts/shared/01-tickets/20260512_0904_error-code-convention-clarification-ticket.md`](../01-tickets/20260512_0904_error-code-convention-clarification-ticket.md)

## Scope Summary

- **Stack**: C# generic rulebook + payment-hub project rulebook.
- **Project**: Harness-wide documentation refactor (không ảnh hưởng code
  implementation vì harness chỉ chứa docs).
- **Module**: None.
- **Expected Outcome**: Agent phân biệt rõ ràng *internal domain error code*
  (dùng để `throw BusinessException`) với *public API error code* (code mà
  client nhận trong HTTP response body); Payment Hub API code được hiểu đúng
  là project-specific override cho **public layer**, không phải thay thế
  generic internal rule.

## Rulebooks Read
- [x] `AGENTS.md`
- [x] `c#/README.md`
- [x] `c#/error-code-conventions.md`
- [x] `c#/projects/payment-hub/README.md`
- [x] `c#/projects/payment-hub/api-contract-rules.md`
- [x] `c#/examples/CreateProduct/prompt-spec.md`
- [x] `c#/examples/CreateProduct/feature-manifest.json`
- [x] `c#/prompts/feature-generator.md`
- [x] `c#/workflows/feature-implementation.md`
- [x] `c#/workflows/code-review.md`
- [x] `c#/workflows/bug-fix.md`
- [x] `thoughts/README.md`

## Design Decisions

### Two-Layer Model

Harness định nghĩa chính thức hai layer error code:

| Layer | Where | Format (default) | Example | Consumer |
|---|---|---|---|---|
| **Internal Domain Error Code** | `{Module}.Domain.Shared` | `{Module}:{Entity}:{NumericCode}` | `PaymentHub:Transaction:0001` | `BusinessException`, internal logs, audit |
| **Public API Error Code** | HTTP response body | Project-defined (e.g. `payment_hub.<snake_case>`) | `payment_hub.invalid_state_transition` | External clients/SDK, API doc |

### Ánh Xạ Internal → Public

ABP `IHttpExceptionStatusCodeFinder` và custom middleware sẽ:

1. Bắt `BusinessException` với internal code (`PaymentHub:Transaction:0001`).
2. Map sang HTTP status code (theo bảng trong `error-code-conventions.md`).
3. Transform internal code sang public code theo project convention
   (ví dụ `PaymentHub:Transaction:0001` → `payment_hub.transaction_not_found`).
4. Trả response body theo shape `api-contract-rules.md`.

### Precedence Rule
- **Internal code format**: Generic rule trong `c#/error-code-conventions.md`
  là default. Project chỉ được override khi có lý do business rõ ràng và
  phải ghi trong project rulebook.
- **Public API code format**: Mỗi project TỰ QUYẾT format public code vì đây
  là public contract với client. Generic rule KHÔNG ép format này.

## Implementation Steps

### Wave 1: Generic Rule Refactor
- [x] 1.1 Refactor `c#/error-code-conventions.md`:
  - [x] Thêm section đầu "Two Error Code Layers" giải thích internal vs public.
  - [x] Giữ nguyên format cũ cho internal code.
  - [x] Thêm subsection "Mapping Internal → Public API Error Code" với code
        snippet minh hoạ ABP `IHttpExceptionStatusCodeFinder` hoặc middleware
        pattern chuyển đổi.
  - [x] Thêm section "Project-Specific Overrides" nhắc lại precedence rule:
    - Internal code format: project có thể override khi có lý do.
    - Public API code format: project TỰ QUYẾT (generic không ép).
    - Link về `AGENTS.md` "Thứ Tự Ưu Tiên Của Project Rulebook".

### Wave 2: Project Rule Clarification
- [x] 2.1 Cập nhật `c#/projects/payment-hub/api-contract-rules.md`:
  - [x] Thêm note ở đầu section "Error Codes": đây là **public API error
        code catalog**, khác với internal `BusinessException` error code
        được định nghĩa trong `{Module}.Domain.Shared`.
  - [x] Link đến `c#/error-code-conventions.md` cho internal convention.
  - [x] Thêm ví dụ ánh xạ: 1-2 internal code từ `PaymentHubErrorCodes` sang
        public code (ví dụ `PaymentHub:Transaction:0001` →
        `payment_hub.transaction_not_found`, HTTP 404).

### Wave 3: Exemplar Update
- [x] 3.1 Cập nhật `c#/examples/CreateProduct/prompt-spec.md`:
  - [x] Trong section "Domain Rules", giữ nguyên internal codes
        (`Catalog:Product:0001`).
  - [x] Trong section "Integration Contracts" (hoặc section mới "Error
        Mapping"), thêm bảng ánh xạ:
    - Internal code → HTTP status → public API code.
  - [x] Ví dụ:
    - `Catalog:Product:0001` (SkuAlreadyExists) → HTTP 409 →
      `catalog.sku_conflict`.
    - `Catalog:Product:0002` (PriceTooLow) → HTTP 400 →
      `catalog.validation_failed`.

### Wave 4: Feature Generator Integration
- [x] 4.1 Cập nhật `c#/prompts/feature-generator.md`:
  - [x] Thêm `c#/error-code-conventions.md` vào "Required Context Loading"
        (hiện list có 12 files, thêm vào thành 13).
  - [x] Thêm `c#/examples/CreateProduct/` vào "Required Context Loading" như
        reference exemplar.
  - [x] Trong section "Manifest Requirements" hoặc section mới "Error Code
        Handling", nhắc agent phải define internal code trong `Domain.Shared`
        TRƯỚC khi throw, và define public code trong project API contract.

### Wave 5: Changelog & Validation
- [x] 5.1 Thêm entry vào `CHANGELOG.md`:
  - [x] Section "Unreleased" hoặc "[Phase 3]".
  - [x] Changed: `c#/error-code-conventions.md` — phân biệt internal vs
        public API error code.
  - [x] Changed: `c#/projects/payment-hub/api-contract-rules.md` — clarify
        public API error code layer.
  - [x] Changed: `c#/examples/CreateProduct/prompt-spec.md` — thêm error
        mapping example.
  - [x] Changed: `c#/prompts/feature-generator.md` — thêm error-code và
        exemplar vào context loading.
- [x] 5.2 Chạy `./scripts/validate-harness.ps1`.
- [x] 5.3 Đọc lại toàn bộ các file đã sửa, verify flow hiểu được trong ≤ 2
      phút.

## Files Expected To Change

- `c#/error-code-conventions.md` (edit — thêm 2 sections mới)
- `c#/projects/payment-hub/api-contract-rules.md` (edit — thêm clarifying note
  + mapping example)
- `c#/examples/CreateProduct/prompt-spec.md` (edit — thêm error mapping bảng)
- `c#/prompts/feature-generator.md` (edit — thêm entries vào context loading)
- `CHANGELOG.md` (edit — thêm entry)

Không tạo file mới, không xoá file, không đổi tên file.

## Validation Plan

- [x] `./scripts/validate-harness.ps1` pass 100%.
- [x] Manual review: mở 5 file đã sửa, đọc tuần tự
  `c#/error-code-conventions.md` → `c#/projects/payment-hub/api-contract-rules.md`
  → exemplar, verify logic flow.
- [x] "Fresh-agent test" (mental): giả định một agent chưa đọc harness bao giờ,
  liệu có hiểu đúng hai layer và khi nào dùng format nào?
- [x] Link integrity: các cross-reference link trong các file đã sửa phải tồn
  tại (validation script đã check routing table, manual check thêm cho link
  trong body).

## Risks And Mitigations

- **Risk**: Thay đổi wording trong generic rule vô tình làm lỏng constraint
  cho internal code format.
- **Mitigation**: Giữ nguyên section "Naming Pattern" và "Numbering Ranges"
  của internal code. Chỉ thêm section mới, không xoá section cũ.

- **Risk**: Agent đọc hai layer rồi vẫn nhầm vì không có ví dụ cụ thể.
- **Mitigation**: Bắt buộc Wave 3 update exemplar với bảng mapping rõ ràng.
  Exemplar là nơi agent học pattern, không phải đọc rule suông.

- **Risk**: Payment Hub api-contract-rules.md hiện có list error code ngắn
  (~10 codes), thêm mapping 1-2 ví dụ có thể tạo cảm giác incomplete.
- **Mitigation**: Note rõ "ví dụ minh hoạ", không yêu cầu list đầy đủ mapping
  table (đó là việc của Payment Hub domain team khi implement thật).

- **Risk**: Validation script không catch được logic mismatch (ví dụ quên
  update exemplar).
- **Mitigation**: Dùng manual checklist + fresh-agent test ở Validation Plan.

## Open Questions

- Public API error code format cho các project tương lai khác Payment Hub có
  nên được gợi ý chuẩn chung không (ví dụ `<project>.<snake_case>`)? Hay để
  mỗi project tự quyết hoàn toàn?
  - **Proposed answer**: Để mỗi project tự quyết, nhưng generic rule đề xuất
    "recommended pattern: `<project_snake>.<error_name_snake>`" ở dạng
    khuyến nghị, không bắt buộc.
- Có cần tạo utility class generic để map internal → public code, hay để
  mỗi project tự implement?
  - **Proposed answer**: Để mỗi project tự implement vì mapping rule có thể
    phụ thuộc business (ví dụ Payment Hub không expose provider-specific
    code ra ngoài). Chỉ document pattern, không cung cấp code chung.

Các câu hỏi trên có thể giải quyết trong implementation phase hoặc defer —
không block plan được duyệt.
