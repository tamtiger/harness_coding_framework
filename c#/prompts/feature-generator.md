# Prompt: C# Feature Generator

Use this prompt when generating or modifying a production-grade vertical slice
for an ABP Framework project in the `c#/` stack.

## Inputs

- **Project**: `{ProjectName}`
- **Module**: `{ModuleName}`
- **Feature**: `{FeatureName}`
- **Action**: `{Create|Update|Delete|Get|List|Process|Sync|Webhook}`
- **Feature Type**: `{Command|Query}`
- **Business Request**: `{ConcreteUserRequest}`
- **Source Ticket**: `{thoughts/shared/01-tickets/...}` when available
- **Approved Plan**: `{thoughts/shared/03-plans/...}` when available

## Required Context Loading

Read these files before designing or changing implementation files:

1. `AGENTS.md`
2. `c#/README.md`
3. `c#/workflows/feature-implementation.md`
4. `c#/architecture-rules.md`
5. `c#/dependency-rules.md`
6. `c#/naming-conventions.md`
7. `c#/error-code-conventions.md`
8. `c#/api-contract-rules.md`
9. `c#/testing-rules.md`
10. `c#/ci-rules.md`
11. `c#/anti-patterns.md`
12. `c#/feature-template.md`
13. `c#/prompt-spec-template.md`
14. `c#/examples/CreateProduct/` (reference exemplar for prompt-spec + manifest
    + error code mapping pattern)

If the work belongs to a concrete project, also read
`c#/projects/{ProjectName}/README.md` and every project-specific rule file that
applies to the feature.

## Workflow

1. Establish the project, module, feature name, action, and affected ABP layers.
2. Locate existing source and test projects. Do not infer paths when the
   repository can be inspected.
3. Create or update `{Module}.Application/Features/{FeatureName}/prompt-spec.md`
   from `c#/prompt-spec-template.md`.
4. Create or update `{Module}.Application/Features/{FeatureName}/feature-manifest.json`
   using `c#/feature-manifest.schema.json` as the contract.
5. Implement contracts, domain, application, infrastructure, HTTP API, and tests
   only in their owning ABP projects.
6. Run focused build/test/validation commands.
7. Update agent memory when the work is part of a long-running module, epic, or
   project-specific thread.

## Output Contract

Application-level feature artifacts belong in:

`{Module}.Application/Features/{FeatureName}/`

Cross-layer artifacts belong in their owning ABP projects:

- DTOs, AppService interfaces, and permissions:
  `{Module}.Application.Contracts`
- Entities, value objects, domain services, repository interfaces, and error
  codes:
  `{Module}.Domain` or `{Module}.Domain.Shared`
- EF Core mappings, migrations, and repository implementations:
  `{Module}.EntityFrameworkCore`
- Controllers:
  `{Module}.HttpApi` only when conventional ABP controllers are insufficient
- Tests:
  the matching test project for the touched layer

Every feature must include:

- `prompt-spec.md`
- `feature-manifest.json`
- focused tests for meaningful behavior
- full file contents or direct file edits with no incomplete implementations

## Manifest Requirements

`feature-manifest.json` must include:

- `feature`
- `module`
- `type`
- `dependencies`
- `layers_touched`
- `permissions`
- `events`
- `ai_status`

Set `ai_status` to:

- `Draft` while unresolved product or architecture questions remain.
- `NeedsReview` when implementation exists but requires human decision.
- `Complete` only after implementation and validation are done.

## ABP Constraints

- Maximum 300 LOC per file. Push complex business logic to Domain Services.
- Entities must use `FullAuditedEntity<Guid>` unless an existing project rule
  explicitly overrides the base entity type.
- Use FluentValidation for request validation.
- Use explicit `[Authorize]`, `[UnitOfWork]`, and `[Dependency]` attributes where
  required by the C# rulebook.
- Do not use service locator patterns or hidden runtime dependencies.
- Throw ABP `BusinessException` for business-rule failures.
- Keep DTOs and AppService contracts out of the Application implementation
  project.

## Error Code Handling

Every feature that can fail with a business rule violation MUST define error
codes at **two layers**:

1. **Internal domain error code** — define in `{Module}.Domain.Shared/{Module}ErrorCodes.cs`
   using format `{Module}:{Entity}:{NumericCode}` BEFORE throwing. Always throw
   via `new BusinessException(ErrorCodeConstant)`.
2. **Public API error code** — define in the project's `api-contract-rules.md`
   (e.g., `payment_hub.transaction_not_found`). This is the code clients see in
   the HTTP response body.

The mapping from internal → public is configured in the module's HTTP pipeline
(ABP `IHttpExceptionStatusCodeFinder` or custom middleware). See
`c#/error-code-conventions.md` § "Two Layers of Error Codes" for the full
pattern and `c#/examples/CreateProduct/prompt-spec.md` § "Error Code Mapping"
for a concrete example.

## Project-Specific Decisions

Never invent product-specific infrastructure choices. For Payment Hub and other
concrete projects, consult the project rulebook before deciding:

- database and persistence behavior
- messaging and event envelopes
- idempotency, inbox, and outbox behavior
- security, sensitive data, and tenant isolation
- observability, trace, metric, and audit requirements
- state machine transitions and terminal states
- external provider adapter contracts

## Validation

Run the most focused applicable checks:

```powershell
./scripts/validate-harness.ps1
dotnet build
dotnet test
```

If a full build or test run is not possible, run the narrowest available project
or solution command and report the reason full validation was not run.

## Failure Recovery

- For compile errors, follow `c#/repair-strategies/compile-errors.md`.
- For manifest/spec issues, run `./scripts/validate-harness.ps1` and repair the
  reported files.
- For project-specific uncertainty, stop before implementation and record the
  open question in `prompt-spec.md`.
