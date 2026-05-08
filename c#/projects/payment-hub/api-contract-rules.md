# Payment Hub: API Contract Rules

## Versioning
- Public HTTP APIs MUST be versioned with `/api/payment-hub/v{version}/`.
- Phase 1 uses `v1`.
- Breaking changes require a new version or an explicit compatibility mapping in
  the Compatibility Layer.

## Required Headers
- State-changing tenant APIs MUST require `Idempotency-Key`.
- Tenant-authenticated APIs MUST resolve tenant identity from credentials or
  trusted gateway context, not from a user-supplied `tenantId` alone.
- Responses SHOULD include `X-PaymentHub-TraceId`.

## Error Response Shape
All public errors MUST use a deterministic shape:

```json
{
  "error": {
    "code": "payment_hub.error_code",
    "message": "Human-readable safe message",
    "traceId": "hub_trace_id",
    "details": {}
  }
}
```

## Error Codes
- `payment_hub.validation_failed`
- `payment_hub.unauthorized`
- `payment_hub.forbidden_tenant`
- `payment_hub.idempotency_key_required`
- `payment_hub.idempotency_key_conflict`
- `payment_hub.invalid_provider_signature`
- `payment_hub.timestamp_out_of_window`
- `payment_hub.nonce_replay`
- `payment_hub.provider_unavailable`
- `payment_hub.invalid_state_transition`

## Agent Checklist
- Do not expose provider-specific status codes in public responses.
- Do not return raw provider payloads unless a project-specific support API
  explicitly allows redacted diagnostic output.
- Add HttpApi tests for headers, error codes, authorization, and idempotency.
