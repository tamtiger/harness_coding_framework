# Payment Hub: Idempotency Rules

## Global Requirement
- All state-changing APIs (POST/PUT/PATCH, create, cancel, refund) MUST require the `Idempotency-Key` header.
- Accepted formats: UUID v4 or ULID.

## Backend Logic (Inbox/Outbox Pattern)
1. **Cache Look-up**: Use `InboxStore.TryAcquireAsync(idempotencyKey, ttl)`.
2. **Deterministic Response**:
   - If key exists AND payload matches (Inbox GetResult returns value): Return the previous response (HTTP 200).
   - If key exists AND payload DOES NOT match: Return HTTP 422 (`idempotency_key_conflict`).
3. **Storage & TTL**:
   - TTL for idempotency keys: Minimum 24 hours.
   - For Webhooks: Idempotency key = `SHA256(providerId + "|" + callbackData.ProviderTransactionId)`.

## Webhook Ingress Hardening
- **Timestamp check**: Reject if webhook timestamp is > 5 minutes from server time (`timestamp_out_of_window`) to prevent replay attacks.
- **Nonce check**: Reject if nonce was reused within 24h (`nonce_replay`).
- **Signature Verify**: Must verify via Adapter's `VerifyWebhookAsync`. Invalid signature returns HTTP 400.
- **IP Whitelist**: Reject IP not in provider's whitelist (HTTP 403).
- **Body & Rate Limiting**: Body size limit ≤ 64KB. Rate limit per source IP ≤ 100 req/s.

## Exactly-Once Effect
- Enforce the Outbox + Inbox pattern to ensure exactly-once effect between DB commit and Kafka publish:
  1. `BEGIN TRANSACTION`
  2. Write transaction state
  3. Write outbox message
  4. `COMMIT`
  5. Process webhook safely using Inbox dedup.
