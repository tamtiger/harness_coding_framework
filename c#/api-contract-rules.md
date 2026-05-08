# API Contract Rules

## Public API Boundaries
- Public DTOs, AppService interfaces, permissions, constants, and error codes
  belong in `{Module}.Application.Contracts` or `{Module}.Domain.Shared`.
- Controllers belong in `{Module}.HttpApi` unless the project deliberately uses
  ABP conventional controllers only.
- Host projects are composition roots. They MUST NOT contain business logic.

## HTTP Conventions
- State-changing endpoints MUST validate authorization, tenant scope, and
  idempotency requirements before executing domain behavior.
- Error responses MUST be deterministic and use project-defined error codes.
- Validation errors MUST identify the failing field or contract rule.
- APIs MUST NOT expose domain entities directly. Always return DTOs.
- Public routes MUST be stable. Any breaking change requires a project-specific
  versioning or compatibility plan.

## Event Contracts
- Integration events MUST use explicit DTOs or ETOs and stable schema names.
- Event payloads MUST include correlation or trace identifiers when the project
  uses distributed tracing.
- Breaking event changes require versioned event contracts and a migration plan.

## Agent Checklist
- Put request/response DTOs in `Application.Contracts`, not Application implementation folders.
- Define permissions before adding `[Authorize]` usage.
- Document new public routes or event contracts in the feature README or the
  project-specific API documentation.
- Add HTTP or contract tests for new public API behavior.
