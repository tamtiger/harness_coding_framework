# Payment Hub Testing Rules

These rules extend the generic C# testing rules for Payment Hub. The generic
baseline in `c#/testing-rules.md` still applies.

## Required Test Coverage

- Unit tests for domain invariants, state transitions, VND amount validation,
  provider status mapping, and terminal-state locking.
- Application tests for permissions, tenant isolation, idempotency behavior, and
  orchestration decisions.
- Integration tests for EF Core mappings, transaction store, inbox/outbox store,
  and repository behavior.
- Contract tests for public APIs, webhook ingress, CloudEvents envelopes, and
  provider adapter contracts.
- Failure-path tests for replay attacks, duplicate webhooks, invalid signatures,
  provider timeout, circuit breaker open state, and fallback routing.

## Test Data Rules

- Do not use real payment card data, full PAN, CVV, production secrets, or
  production provider credentials.
- Use deterministic test identifiers for tenants, providers, transactions,
  idempotency keys, nonces, and trace IDs.
- Test VND values as integer minor units with no decimal behavior.

## Validation Expectations

- Every state-changing API or webhook feature must include duplicate-request and
  replay tests.
- Every event-producing feature must assert the outbox record and CloudEvents
  envelope fields.
- Every sensitive-data feature must assert that logs and audit records exclude
  prohibited data.
