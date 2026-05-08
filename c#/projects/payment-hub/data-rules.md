# Payment Hub: Data And Persistence Rules

## Transaction Store
Transaction state changes MUST be stored as immutable events with at least:

- `EventId`
- `TenantId`
- `TransactionId`
- `ProviderId`
- `EventType`
- `EventVersion`
- `EventData`
- `Source`
- `OccurredAt`
- `CorrelationId`
- `TraceParent`

The current transaction state MAY be projected into a read model, but the event
store remains the audit source for state transitions.

## Outbox Store
Outbox records MUST include at least:

- `OutboxId`
- `AggregateId`
- `TenantId`
- `Topic`
- `EventType`
- `EventVersion`
- `Payload`
- `Headers`
- `TraceParent`
- `OccurredAt`
- `PublishedAt`
- `RetryCount`
- `Status`

## Inbox Store
Inbox records MUST include at least:

- `InboxId`
- `IdempotencyKey`
- `PayloadHash`
- `ConsumerName`
- `TenantId`
- `ReceivedAt`
- `ProcessedAt`
- `ResponsePayload`
- `Status`
- `ExpiresAt`

## Retention
- Idempotency and webhook nonce records MUST be retained for at least 24 hours.
- Webhook raw payloads MUST be redacted and retained according to
  `security-rules.md`.
- Transaction audit events MUST follow the project retention requirement in
  `security-rules.md`.

## Agent Checklist
- Do not update terminal transaction states in place.
- Do not publish events without an Outbox record.
- Do not process duplicate Inbox keys with different payload hashes.
- Add EF Core tests for indexes, unique constraints, and tenant filters.
