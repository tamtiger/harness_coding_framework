# Prompt Spec Template: {FeatureName}

`prompt-spec.md` is the human-reviewed source request for a feature. It MUST be
created before implementation files and kept with the Application feature slice.

## Metadata
- **Project**: `{ProjectName}`
- **Module**: `{ModuleName}`
- **Feature**: `{FeatureName}`
- **Type**: `Command|Query`
- **Owner**: `{HumanOwnerOrTeam}`
- **Status**: `Draft|Reviewed|Approved|Implemented`

## Business Goal
Describe the business outcome in concrete terms.

## Scope
### In Scope
- List behavior the feature must implement.

### Out of Scope
- List behavior the feature must not implement.

## Inputs
- Request DTO fields, headers, route parameters, tenant context, idempotency
  keys, or external event fields.

## Outputs
- Response DTO fields, events, side effects, audit records, or error responses.

## Domain Rules
- Invariants, state transitions, validation rules, and domain errors.

## Security And Compliance
- Permissions, tenant isolation, sensitive data handling, logging restrictions,
  and project-specific compliance rules.

## Integration Contracts
- HTTP routes, AppService methods, integration events, external provider
  contracts, and backward compatibility requirements.

## Data And Persistence
- Entities, value objects, repositories, EF mappings, migrations, outbox/inbox
  requirements, and retention rules.

## Observability
- Logs, metrics, traces, correlation identifiers, audit events, and alerts.

## Tests Required
- Unit tests, integration tests, contract tests, property-based tests, and
  explicit failure scenarios.

## Acceptance Criteria
- Use concrete, testable statements. Avoid vague wording.

## Open Questions
- List unresolved decisions. A feature SHOULD NOT move to `Approved` while
  product or architecture questions remain unresolved.
