# Payment Hub - AI-Native Rulebook

Tài liệu này đóng vai trò là "chân lý" (Source of Truth) cho các AI Agents và Developer khi tham gia phát triển, bảo trì hoặc gỡ lỗi dự án **Payment Hub**. Hệ thống này là một nền tảng thanh toán tập trung (Orchestration/Integration layer) phục vụ tất cả các tenants (ICT, Nhà Thuốc, Vaccine, LAB), giúp onboarding nhà cung cấp thanh toán mới chỉ trong 1-2 ngày.

> **⚠️ CTO MANDATE**: Payment Hub CHỈ làm nhiệm vụ điều phối (Orchestration). KHÔNG giữ tiền, KHÔNG đối soát dòng tiền (settle), KHÔNG lưu trữ Full PAN / CVV (Chuẩn PCI-DSS).

---

## 📂 Cấu Trúc Rulebook

Thư mục này chứa các quy tắc kiến trúc (Architectural Rules) và Ràng buộc vận hành (Operational Constraints) bắt buộc tuân thủ:

1. **[`module-map.md`](./module-map.md)**
   - Bản đồ kiến trúc 10 thành phần cốt lõi của Hub (API Gateway, Orchestrator, Provider Adapter Registry, Webhook Ingress, v.v.).
   - Khai báo Tech Stack tiêu chuẩn (Kafka, SQL Server 2022, Redis, KMS).

2. **[`adapter-rules.md`](./adapter-rules.md)**
   - Quy tắc thiết kế Plugin (Provider Adapter).
   - Validation dữ liệu (VND không có số thập phân), ánh xạ trạng thái chuẩn (Canonical State Mapping), và Circuit Breaker.

3. **[`idempotency-rules.md`](./idempotency-rules.md)**
   - Cơ chế xử lý Webhook an toàn (chống trùng lặp, chống Replay Attack qua Timestamp & Nonce).
   - Triển khai **Outbox/Inbox Pattern** để bảo toàn exactly-once effect giữa Database và Kafka.

4. **[`state-machine.md`](./state-machine.md)**
   - Sơ đồ chuyển đổi vòng đời giao dịch (State Machine) với 9 Canonical States cố định.
   - Nguyên tắc khóa State (Terminal States) và ghi log kiểm toán qua Event Sourcing.

5. **[`security-rules.md`](./security-rules.md)**
   - Giới hạn Scope PCI-DSS (SAQ A / SAQ A-EP).
   - Mã hóa dữ liệu nhạy cảm bằng hệ thống quản lý khóa tập trung (KMS Envelope Encryption). 
   - Đảm bảo cách ly dữ liệu giữa các chuỗi kinh doanh (Tenant Isolation qua Row-Level Security).

6. **[`observability-rules.md`](./observability-rules.md)**
   - Quy chuẩn Distributed Tracing (truy vết `trace_id` xuyên suốt qua các components).
   - Các chỉ số đo lường hiệu năng (Golden Signals) và cấu hình Fallback Router (failover về hệ cũ <= 30s khi có sự cố).

---

## 🚀 Mục Tiêu Nền Tảng

- **Loại bỏ trùng lặp**: Thay thế 8 services rời rạc hiện tại (giảm 60-70% code trùng).
- **Event-Driven**: Chuyển đổi giao tiếp HTTP đồng bộ rủi ro cao sang bất đồng bộ an toàn qua Event Bus (Apache Kafka với CloudEvents 1.0).
- **Fault Tolerance**: Một Provider sập sẽ không kéo sập toàn hệ thống (nhờ Circuit Breaker & Bulkhead cô lập lỗi).
- **Tốc độ Onboarding**: Thêm Provider mới mất 1-2 ngày, thêm Tenant mới chỉ mất 1 ngày (config-only).

---

## 🤖 Hướng Dẫn Dành Cho AI Agent

Khi nhận Task liên quan đến việc triển khai tính năng mới hoặc sửa lỗi tại `payment-hub`, Agent **PHẢI**:
1. Đối chiếu tính năng với danh sách 10 components tại `module-map.md`.
2. Kiểm tra các rào cản bảo mật tại `security-rules.md` (Đặc biệt cẩn trọng với Logging và Data Access).
3. Bất kỳ API hoặc Webhook nào liên quan đến việc cập nhật trạng thái đều phải tuân thủ chuẩn Idempotency (`idempotency-rules.md`).
4. Mọi cập nhật trạng thái giao dịch phải được thực hiện thông qua Outbox Pattern theo đúng vòng đời (`state-machine.md`).
