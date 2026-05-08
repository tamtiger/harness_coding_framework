# Payment Hub - AI-Native Rulebook

Tài liệu này đóng vai trò là "nguồn chân lý" (Source of Truth) cho các AI Agent và Lập trình viên khi tham gia phát triển, bảo trì hoặc gỡ lỗi dự án **Payment Hub**. Hệ thống này là một nền tảng điều phối thanh toán tập trung (Orchestration/Integration layer) phục vụ tất cả các đối tác/khách hàng (ICT, Nhà Thuốc, Vaccine, LAB), giúp tích hợp nhà cung cấp thanh toán mới chỉ trong 1-2 ngày.

> **⚠️ CHỈ THỊ TỪ CTO (CTO MANDATE)**: Payment Hub CHỈ làm nhiệm vụ điều phối (Orchestration). KHÔNG giữ tiền, KHÔNG đối soát dòng tiền (settle), KHÔNG lưu trữ toàn bộ số thẻ (Full PAN) hay mã bảo mật (CVV) theo đúng Chuẩn bảo mật PCI-DSS.

---

## 📂 Cấu Trúc Rulebook

Thư mục này chứa các quy tắc kiến trúc (Architectural Rules) và ràng buộc vận hành (Operational Constraints) bắt buộc phải tuân thủ:

1. **[`module-map.md`](./module-map.md)**
   - Bản đồ kiến trúc 10 thành phần cốt lõi của Hub (API Gateway, Orchestrator, Provider Adapter Registry, Webhook Ingress, v.v.).
   - Khai báo công nghệ tiêu chuẩn (Kafka, SQL Server 2022, Redis, KMS).

2. **[`adapter-rules.md`](./adapter-rules.md)**
   - Quy tắc thiết kế Plugin (Provider Adapter) cho nhà cung cấp thanh toán.
   - Kiểm tra dữ liệu hợp lệ (VND không có số thập phân), ánh xạ trạng thái chuẩn (Canonical State Mapping), và cơ chế ngắt mạch (Circuit Breaker).

3. **[`idempotency-rules.md`](./idempotency-rules.md)**
   - Cơ chế xử lý Webhook an toàn (chống trùng lặp, chống tấn công phát lại - Replay Attack qua Timestamp & Nonce).
   - Triển khai **Outbox/Inbox Pattern** để bảo toàn tính nhất quán (exactly-once) giữa Database và Kafka.

4. **[`state-machine.md`](./state-machine.md)**
   - Sơ đồ chuyển đổi vòng đời giao dịch (State Machine) với 9 trạng thái chuẩn (Canonical States) cố định.
   - Nguyên tắc khóa trạng thái (Terminal States) và ghi log kiểm toán qua Event Sourcing.

5. **[`security-rules.md`](./security-rules.md)**
   - Giới hạn phạm vi bảo mật PCI-DSS (SAQ A / SAQ A-EP).
   - Mã hóa dữ liệu nhạy cảm bằng hệ thống quản lý khóa tập trung (KMS Envelope Encryption). 
   - Đảm bảo cách ly dữ liệu giữa các chuỗi kinh doanh (Tenant Isolation qua Row-Level Security).

6. **[`observability-rules.md`](./observability-rules.md)**
   - Quy chuẩn theo dõi phân tán (Distributed Tracing - truy vết `trace_id` xuyên suốt qua các components).
   - Các chỉ số đo lường hiệu năng (Golden Signals) và cấu hình định tuyến dự phòng (Fallback Router - failover về hệ cũ <= 30s khi có sự cố).

7. **[`api-contract-rules.md`](./api-contract-rules.md)**
   - Quy tắc đánh version, các header bắt buộc, định dạng dữ liệu lỗi (error response shape) và danh mục mã lỗi (error code catalog).

8. **[`messaging-rules.md`](./messaging-rules.md)**
   - Định dạng chuẩn CloudEvents, cách đặt tên Kafka topic và event type, cơ chế phân vùng (partitioning) và Outbox publishing.

9. **[`data-rules.md`](./data-rules.md)**
   - Quản lý Transaction Store, Outbox Store, Inbox Store, chính sách lưu trữ (retention) và các hàng rào bảo vệ cơ sở dữ liệu (persistence guardrails).

10. **[`testing-rules.md`](./testing-rules.md)**
    - Yêu cầu Unit, Integration, Contract tests và kịch bản lỗi rẽ nhánh (failure-path).

11. **[`ci-rules.md`](./ci-rules.md)**
    - Các yêu cầu kiểm tra (CI gates) bắt buộc và chính sách thất bại (failure policy).

---

## 🚀 Mục Tiêu Nền Tảng

- **Loại bỏ trùng lặp**: Thay thế 8 services rời rạc hiện tại (giảm 60-70% code trùng).
- **Hướng sự kiện (Event-Driven)**: Chuyển đổi giao tiếp HTTP đồng bộ rủi ro cao sang bất đồng bộ an toàn qua Event Bus (Apache Kafka với CloudEvents 1.0).
- **Khả năng chịu lỗi (Fault Tolerance)**: Một Provider sập sẽ không kéo sập toàn hệ thống (nhờ Circuit Breaker & Bulkhead cô lập lỗi).
- **Tốc độ tích hợp (Onboarding)**: Thêm Provider mới mất 1-2 ngày, thêm nghiệp vụ mới chỉ mất 1 ngày (chỉ cần cấu hình).

---

## 🤖 Hướng Dẫn Dành Cho AI Agent

Khi nhận tác vụ liên quan đến việc triển khai tính năng mới hoặc sửa lỗi tại `payment-hub`, Agent **PHẢI**:
1. Đối chiếu tính năng với danh sách 10 thành phần tại `module-map.md`.
2. Kiểm tra các rào cản bảo mật tại `security-rules.md` (Đặc biệt cẩn trọng với Logging và Data Access).
3. Bất kỳ API hoặc Webhook nào liên quan đến việc cập nhật trạng thái đều phải tuân thủ chuẩn Idempotency (`idempotency-rules.md`).
4. Mọi cập nhật trạng thái giao dịch phải được thực hiện thông qua Outbox Pattern theo đúng vòng đời (`state-machine.md`).
5. Mọi API công khai (public API) phải tuân thủ `api-contract-rules.md`.
6. Mọi Kafka event phải tuân thủ `messaging-rules.md`.
7. Mọi thay đổi về cơ sở dữ liệu (persistence) phải đối chiếu `data-rules.md`.
