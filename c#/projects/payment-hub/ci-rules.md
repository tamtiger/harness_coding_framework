# Payment Hub CI Rules

These rules extend the generic C# CI rules for Payment Hub. The generic baseline
in `c#/ci-rules.md` still applies.

## Required Gates

- Run repository harness validation:
  `./scripts/validate-harness.ps1`
- Run .NET restore, build, analyzers, and tests for all touched projects.
- Validate EF Core migrations whenever persistence changes.
- Validate contract tests whenever public APIs, webhooks, provider adapters, or
  integration events change.
- Validate security-sensitive changes with logging, tenant isolation, and
  sensitive-data assertions.

## Payment Hub Specific Checks

- State machine changes must be reviewed against `state-machine.md`.
- Webhook and payment command changes must be reviewed against
  `idempotency-rules.md`.
- Kafka/event changes must be reviewed against `messaging-rules.md`.
- Persistence changes must be reviewed against `data-rules.md`.
- Provider adapter changes must be reviewed against `adapter-rules.md`.
- Observability changes must preserve trace propagation and golden signals from
  `observability-rules.md`.

## CI Failure Policy

- Do not bypass failed tests, analyzers, manifest validation, or migration
  validation.
- If a full test run is unavailable, run the narrowest deterministic command and
  record the limitation in the implementation summary or plan.
