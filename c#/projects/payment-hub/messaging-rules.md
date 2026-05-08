# Payment Hub: Messaging Rules

## Event Envelope
- Kafka integration events MUST use CloudEvents 1.0.
- Events MUST include `id`, `source`, `specversion`, `type`, `time`,
  `subject`, `datacontenttype`, `traceparent`, and `data`.
- `datacontenttype` MUST be `application/json`.
- Event schemas MUST be registered in the configured Schema Registry before
  production use.

## Topic Naming
Use deterministic topic names:

```
payment-hub.{environment}.{bounded-context}.{event-name}.v{major}
```

Examples:
- `payment-hub.prod.transaction.transaction-state-changed.v1`
- `payment-hub.prod.webhook.provider-callback-received.v1`
- `payment-hub.prod.notification.tenant-notification-requested.v1`

## Event Type Naming
Use reverse-DNS-style CloudEvents types:

```
com.fpt.paymenthub.{boundedContext}.{eventName}.v{major}
```

Example:
`com.fpt.paymenthub.transaction.stateChanged.v1`

## Partitioning
- Transaction lifecycle events MUST partition by `tenantId:providerId`.
- Events that require strict per-transaction ordering SHOULD include
  `transactionId` in the partition key or event subject.

## Outbox Publishing
- Domain/application transactions MUST write integration events to the Outbox in
  the same database transaction as state changes.
- Kafka publishers MUST publish from Outbox records only.
- Consumers MUST deduplicate through Inbox records before applying side effects.

## Agent Checklist
- Include `traceparent` and hub trace identifiers on every event.
- Do not publish directly to Kafka from Domain or Application handlers.
- Add contract tests for event shape and schema compatibility.
