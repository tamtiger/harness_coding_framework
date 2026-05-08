# Payment Hub: Module Map

## Core Components (The 10 Components)
1. **API Gateway**: Unified REST API entry point. Rate limit per tenant.
2. **Compatibility Layer**: Legacy API mapping (backward compatibility). Map route cũ → unified API.
3. **Payment Orchestrator**: The central State Machine and flow controller.
4. **Provider Adapter Registry**: Plugin system for external providers (VNPay, MoMo, ZaloPay, etc.).
5. **Webhook Ingress**: Secure entry for provider callbacks. Idempotent, IP whitelist, signature verify, anti-replay.
6. **Tenant Notifier**: Reliable callback system to tenant backends (ICT, NT, etc.). Retry 5 lần, signed payload, DLQ.
7. **Transaction Store**: Event-sourcing storage for all transaction events. 
8. **Tenant Config Service**: Secure management of credentials and settings. KMS envelope encryption, rotation 90d.
9. **Fallback Router**: Health-checking and auto-failover logic (failover ≤ 30s).
10. **Unified Checkout**: Hosted checkout pages and Mobile SDKs.

## Additional CTO Mandated Components
- **Event Bus**: Apache Kafka 3.x with CloudEvents 1.0 envelope and Schema Registry (Confluent/Apicurio).
- **Outbox/Inbox Store**: Exactly-once effect for Kafka publishing and consumer dedup.
- **KMS / HSM**: For Secret Management (Vault or Azure Key Vault).
- **Transaction Integrity Reconciliation**: Daily T+1 job to reconcile Hub state ↔ Provider ↔ Tenant.

## Contract Rule Files
- Public HTTP APIs: `api-contract-rules.md`
- Kafka events and CloudEvents: `messaging-rules.md`
- Transaction Store, Outbox, and Inbox persistence: `data-rules.md`

## Project Structure
src/
 ├── Harness.PaymentHub.Domain.Shared/ (Enums, constants, error codes, shared primitives)
 ├── Harness.PaymentHub.Domain/ (Entities, State Machine, Outbox/Inbox Interfaces)
 ├── Harness.PaymentHub.Application.Contracts/ (DTOs, AppService interfaces, permissions)
 ├── Harness.PaymentHub.Application/ (Features, Orchestration, Notification)
 │    └── Features/ (Vertical Slices per feature)
 ├── Harness.PaymentHub.Adapters/ (Provider Implementations, Plugin Architecture)
 ├── Harness.PaymentHub.EntityFrameworkCore/ (SQL Server 2022, Transaction Store, Outbox/Inbox Schema)
 ├── Harness.PaymentHub.HttpApi/ (Controllers and HTTP API contracts)
 └── Harness.PaymentHub.HttpApi.Host/ (Composition root, API Gateway, Ingress, Fallback Router)

test/
 ├── Harness.PaymentHub.Domain.Tests/
 ├── Harness.PaymentHub.Application.Tests/
 ├── Harness.PaymentHub.EntityFrameworkCore.Tests/
 ├── Harness.PaymentHub.HttpApi.Tests/
 └── Harness.PaymentHub.ContractTests/ (Provider adapter and webhook contract tests)

## Tech Stack Note
- **Database**: SQL Server 2022 (Project Specific).
- **Messaging**: Apache Kafka 3.x.
- **Cache**: Redis 7.x (State caching, rate limiting, nonce dedup).
- **Circuit Breaker**: Polly 8.x.
- **Observability**: OpenTelemetry 1.x → Grafana + Tempo + Loki.
