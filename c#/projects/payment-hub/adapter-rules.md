# Payment Hub: Provider Adapter Rules

## Interface Requirement
All adapters MUST implement `IPaymentProviderAdapter`:
- `CreateOrderAsync`: Initiates payment with provider.
- `QueryOrderAsync`: Syncs state with provider.
- `RefundAsync`: Processes refund.
- `VerifyWebhookAsync`: Validates signatures (HMAC-SHA256/RSA-SHA256) and IPs.
- `ParseCallbackAsync`: Extracts data from provider response into `NormalizedCallbackData`.
- `MapProviderStatus`: Maps provider status to canonical `TransactionState`.

## Capabilities
Adapters must expose their capabilities via boolean properties:
- `SupportsQrPayment`
- `SupportsTokenization`
- `SupportsRefund`

## Validation & Business Rules
- **Amount**: Must be handled as integer (minor units, e.g., VND does not have decimals). Reject if amount is not an integer.
- **Currency**: Must be "VND" (Phase 1).
- **CallbackUrl**: Must be validated for HTTPS and TLS 1.2+.
- **OrderCode**: Must match regex `^[A-Z0-9\-_]{6,50}$`.

## State Mapping & Contract
- **Canonical State Model**: Every provider adapter must have a state mapping table. Provider-specific status MUST NOT be exposed to the outside (API or callback).
- **Contract Testing**: Each provider must have a contract test suite (Pact/WireMock) running weekly against the provider's sandbox to detect payload drift.

## Resilience & Performance
- **Circuit Breaker**: Use `Polly` with hysteresis (min duration open ≥ 30s, half-open probe = 1 request).
- **Bulkhead**: Thread pool/connection pool must be isolated per provider.
- **Latency**: P99 latency (excluding provider call) should be ≤ 300ms. Provider timeout should be set around 30s.
- **Retry**: Exponential backoff (5s, 15s, 45s) up to 3 times before marking as Failed.
