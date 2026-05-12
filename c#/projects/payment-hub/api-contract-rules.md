# Payment Hub: API Contract Rules

> **Scope Note**: This file defines the **public API error codes** — the codes
> that HTTP clients and tenant SDKs see in response bodies. These are NOT the
> same as the internal `BusinessException` error codes thrown in C# code.
>
> - Internal domain error codes (e.g., `PaymentHub:Transaction:0001`) are
>   defined per the generic rule at `c#/error-code-conventions.md`.
> - Public API error codes (e.g., `payment_hub.invalid_state_transition`) are
>   the client-facing contract defined below.
> - ABP middleware maps internal → public before the response leaves the server.
>
> See `c#/error-code-conventions.md` § "Two Layers of Error Codes" for the full
> explanation and mapping flow.

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
