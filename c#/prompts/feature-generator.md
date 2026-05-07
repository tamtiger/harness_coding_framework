# Prompt: Feature Generator

## Objective
Generate a complete, production-grade vertical slice for an ABP 8.x project based on the Deterministic AI-Native rules.

## Context
- Project: {ProjectName}
- Module: {ModuleName}
- Action: {Action} (Create/Update/Delete/Get)

## Output Format & Rules
- Generate all files inside a single `Application/Features/{FeatureName}/` folder.
- Output the full file contents for each component. No placeholders like `// TODO`.
- Strictly follow the conventions in `c#/naming-conventions.md` and `c#/architecture-rules.md`.
- MUST include `feature-manifest.json` with `"ai_status": "Complete"`.

## Constraints
- Max 300 LOC per file. If it exceeds, push logic to Domain Services.
- Entities must use `FullAuditedEntity<Guid>`.
- Use `FluentValidation` injected automatically by ABP.
- Explicit attributes: `[Authorize]`, `[UnitOfWork]`, `[Dependency]` (No hidden locators).
