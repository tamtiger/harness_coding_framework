# Workflow: Feature Implementation

## Step 0: Context Loading (AI Agent)
- Read `c#/architecture-rules.md` and `c#/naming-conventions.md`.
- Read `c#/dependency-rules.md`, `c#/feature-template.md`,
  `c#/api-contract-rules.md`, `c#/testing-rules.md`, `c#/ci-rules.md`, and
  `c#/anti-patterns.md`.
- If the task belongs to a concrete project, read
  `c#/projects/{ProjectName}/README.md` and all project-specific rules that
  apply to the feature.
- Ensure you are working inside the correct project and module boundaries.

## Step 1: Analysis
- Draft or update `prompt-spec.md` before generating implementation files.
- Use `c#/prompt-spec-template.md` as the baseline structure for `prompt-spec.md`.
- Review `feature-manifest.json` when it exists; create it before completing
  the feature if it does not exist yet.
- Identify required Domain Services and Entities.
- Identify every ABP layer that will be touched and record it in
  `feature-manifest.json`.

## Step 2: Contracts & Domain
1. Define permissions in `{Module}.Application.Contracts` (`{Module}Permissions.cs`).
2. Define DTOs and AppService interfaces in `{Module}.Application.Contracts`.
3. Implement/update entities, value objects, domain errors, and repository
   interfaces in `{Module}.Domain` or `{Module}.Domain.Shared`.
4. Create/update Domain Services in `{Module}.Domain` (`{Entity}Manager.cs`).

## Step 3: Application (Vertical Slice)
1. Create folder `{Module}.Application/Features/{FeatureName}/`.
2. Implement `Command/Query`, `Handler`, and `Validator` (FluentValidation).
3. Create `AppService` to orchestrate (Delegate to Handler/Manager).
4. Add `AutoMapper` Profile specific to this feature.
5. Create or update `feature-manifest.json`.
6. Validate `feature-manifest.json` against `c#/feature-manifest.schema.json`
   when schema tooling is available.

## Step 4: Infrastructure
1. Update `DbContext` and create Migrations (if Entity changed).
2. Implement Custom Repositories in `EntityFrameworkCore` if generic `IRepository` is insufficient.

## Step 5: Exposure
1. Create/Update Controller in `HttpApi` to expose the new AppService.

## Step 6: Validation
1. Run `dotnet build` to verify compilation.
2. Run the relevant unit, integration, and contract tests for the touched layers.
3. Verify AI manifest `ai_status` is updated to `Complete`.
4. Update `AGENT_MEMORY.md` when the feature is part of a long-running module,
   epic, or project-specific implementation thread.
