# Prompt: Feature Generator

## Objective
Generate a complete, production-grade vertical slice for an ABP 8.x project based on the Deterministic AI-Native rules.

## Context
- Project: {ProjectName}
- Module: {ModuleName}
- Action: {Action} (Create/Update/Delete/Get)

## Output Format & Rules
- Generate Application-level feature files inside
  `{Module}.Application/Features/{FeatureName}/`.
- Generate cross-layer artifacts in their owning ABP projects:
  - DTOs, AppService interfaces, and permissions in `{Module}.Application.Contracts`.
  - Entities, value objects, domain services, repository interfaces, and error
    codes in `{Module}.Domain` or `{Module}.Domain.Shared`.
  - EF Core mappings, migrations, and repository implementations in
    `{Module}.EntityFrameworkCore`.
  - Controllers in `{Module}.HttpApi` only when conventional ABP controllers
    are insufficient.
- Output the full file contents for each component. No placeholders like `// TODO`.
- Strictly follow the conventions in `c#/naming-conventions.md` and `c#/architecture-rules.md`.
- MUST include `feature-manifest.json` in the Application feature folder with
  `"ai_status": "Complete"` and a complete `layers_touched` list.
- MUST read and follow `c#/projects/{ProjectName}/README.md` and project rules
  before making project-specific technology or domain decisions.

## Constraints
- Max 300 LOC per file. If it exceeds, push logic to Domain Services.
- Entities must use `FullAuditedEntity<Guid>`.
- Use `FluentValidation` injected automatically by ABP.
- Explicit attributes: `[Authorize]`, `[UnitOfWork]`, `[Dependency]` (No hidden locators).
