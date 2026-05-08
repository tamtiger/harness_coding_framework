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

## Retention Summary

All retention requirements consolidated from `security-rules.md` and
`idempotency-rules.md`:

| Data Type | Minimum Retention | Source Rule |
| --- | --- | --- |
| Transaction audit events | 5 years | `security-rules.md` |
| Audit logs | 5 years | `security-rules.md` |
| Transaction metadata | 5 years | `security-rules.md` |
| Customer PII | Per tenant contract | `security-rules.md` |
| Webhook raw payloads | 90 days (redacted) | `security-rules.md` |
| Idempotency keys (Inbox) | 24 hours minimum | `idempotency-rules.md` |
| Webhook nonce records | 24 hours minimum | `idempotency-rules.md` |
| Provider credentials | Until rotated (≤ 90 days DEK) | `security-rules.md` |

Agents MUST consult this table before implementing any data cleanup, archival,
or TTL logic. When in doubt, follow the longer retention period.

## Agent Checklist
- Do not update terminal transaction states in place.
- Do not publish events without an Outbox record.
- Do not process duplicate Inbox keys with different payload hashes.
- Add EF Core tests for indexes, unique constraints, and tenant filters.
