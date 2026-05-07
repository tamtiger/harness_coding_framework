# Payment Hub: Observability & Resilience Rules

## Distributed Tracing & Correlation
- A `correlationId` (`trace_id`) MUST be present in all transaction events.
- Trace propagation chain: `tenant_request_id` → `hub_trace_id` → `provider_tx_id` → `tenant_notify_id`.
- Kafka events MUST use `CloudEvents 1.0` envelope with `traceparent`.

## Structured Logging
- Use Serilog for JSON structured logs: `timestamp`, `level`, `service`, `trace_id`, `message`, `context`.
- Audit log every `GetCredential()` with `trace_id` and caller identity.
- Redact all sensitive data (credentials, PII) in logs.

## Metrics & Golden Signals (OpenTelemetry)
- Metrics must be exported to Prometheus/Grafana.
- **Golden Signals**:
  - `payment_create_success_rate{tenant, provider}`
  - `webhook_processing_latency_p99{provider}` (Target ≤ 150ms)
  - `tenant_notify_success_rate{tenant}`
  - `duplicate_webhook_rate{provider}`
  - `circuit_breaker_state{provider}` (gauge 0/1)
  - `kafka_consumer_lag{topic, partition}`

## Resilience Rules
- **Kafka Partitioning**: Partition by `tenantId:providerId` for bulkheading.
- **Tenant Notifier**: Retry exponential backoff (10s, 30s, 2m, 10m, 30m) up to 5 times. Push to DLQ after max retries. Expose API for manual replay.
- **Fallback Router**: Health check LB must failover to legacy systems within 30 seconds if Hub is down. Flapping prevention: stabilize for ≥ 60s before routing back.
