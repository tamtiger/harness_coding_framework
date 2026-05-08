# Workflow: Project Onboarding

Use this workflow when adding a new concrete C# project under `c#/projects/`.
The generic `/c#/` rulebook remains the baseline; the project rulebook captures
product-specific decisions.

## Step 0: Name And Scope
1. Choose a deterministic project slug: `{project-name}`.
2. Create `c#/projects/{project-name}/`.
3. Define the project mission, bounded context, and non-goals.

## Step 1: Required Rulebook Files
Create these files before implementation work begins:

```
c#/projects/{project-name}/
 ├── README.md
 ├── module-map.md
 ├── security-rules.md
 ├── observability-rules.md
 ├── api-contract-rules.md
 ├── testing-rules.md
 └── ci-rules.md
```

Add domain-specific files when relevant, such as `state-machine.md`,
`adapter-rules.md`, `idempotency-rules.md`, `messaging-rules.md`, or
`data-retention-rules.md`.

## Step 2: Project Structure
Define the concrete source and test layout in `module-map.md`. A standard ABP
layout SHOULD include:

```
src/
 ├── {Module}.Domain.Shared/
 ├── {Module}.Domain/
 ├── {Module}.Application.Contracts/
 ├── {Module}.Application/
 ├── {Module}.EntityFrameworkCore/
 ├── {Module}.HttpApi/
 └── {Module}.HttpApi.Host/

test/
 ├── {Module}.Domain.Tests/
 ├── {Module}.Application.Tests/
 ├── {Module}.EntityFrameworkCore.Tests/
 ├── {Module}.HttpApi.Tests/
 └── {Module}.ContractTests/
```

Project-specific structure MAY differ, but the project `module-map.md` must make
the differences explicit.

## Step 3: Technology Decisions
Document project-specific infrastructure choices:
- Database engine and migration policy.
- Message broker and event schema policy.
- Cache and distributed lock policy.
- Observability stack.
- Secret management and encryption.
- External adapters or providers.

## Step 4: Guardrails
Define:
- Public API versioning and error response rules.
- Permission model and tenant isolation rules.
- Test commands and CI expectations.
- Agent memory location for long-running work.
- Any forbidden behaviors or product mandates.

## Step 5: Validation
Before feature implementation starts:
1. Confirm `AGENTS.md`, root `README.md`, and `/c#/README.md` route agents to
   the new project rulebook.
2. Confirm the project rulebook does not conflict with generic C# invariants.
3. Record intentional overrides in the project README or module map.
