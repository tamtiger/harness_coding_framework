# Testing Rules

## Test Project Layout
Every concrete project SHOULD define test projects that mirror the production
layers:

```
test/
 ├── {Module}.Domain.Tests/
 ├── {Module}.Application.Tests/
 ├── {Module}.EntityFrameworkCore.Tests/
 ├── {Module}.HttpApi.Tests/
 └── {Module}.ContractTests/ (when external contracts exist)
```

Project-specific rulebooks MAY add specialized test projects for adapters,
messaging, security, performance, or migration validation.

## Required Coverage by Layer
- **Domain.Tests**: entity invariants, value objects, domain services, state
  transitions, domain exceptions.
- **Application.Tests**: command/query handlers, validators, permissions,
  idempotency behavior, orchestration without infrastructure leakage.
- **EntityFrameworkCore.Tests**: mappings, repository implementations,
  query filters, migrations, transaction boundaries, outbox/inbox persistence.
- **HttpApi.Tests**: route contracts, authorization, error responses, headers,
  model validation.
- **ContractTests**: external provider payloads, webhook signatures, schema
  compatibility, callback parsing.

## Agent Checklist
- Add tests with every feature that changes behavior.
- Test success, validation failure, authorization failure, and relevant domain
  failure paths.
- Prefer deterministic data builders over inline object graphs when setup is
  repeated.
- Do not require live external services in default CI. Use fakes, containers,
  or contract fixtures unless the project rulebook explicitly defines a live
  sandbox job.
- Run the narrowest relevant tests first, then the full project test suite when
  the touched surface is broad.
