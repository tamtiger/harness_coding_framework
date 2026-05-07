# Workflow: Feature Implementation

## Step 0: Context Loading (AI Agent)
- Read `c#/architecture-rules.md` and `c#/naming-conventions.md`.
- Ensure you are working inside the correct Module boundaries.

## Step 1: Analysis
- Review `feature-manifest.json` and requirements.
- Identify required Domain Services and Entities.

## Step 2: Contracts & Domain
1. Define Permissions in `Contracts` (`{Module}Permissions.cs`).
2. Define DTOs (Request/Response) in `Contracts`.
3. Implement/Update Entities in `Domain`.
4. Create/Update Domain Services in `Domain` (`{Entity}Manager.cs`).

## Step 3: Application (Vertical Slice)
1. Create folder `Application/Features/{FeatureName}/`.
2. Implement `Command/Query`, `Handler`, and `Validator` (FluentValidation).
3. Create `AppService` to orchestrate (Delegate to Handler/Manager).
4. Add `AutoMapper` Profile specific to this feature.
5. Create or update `feature-manifest.json`.

## Step 4: Infrastructure
1. Update `DbContext` and create Migrations (if Entity changed).
2. Implement Custom Repositories in `EntityFrameworkCore` if generic `IRepository` is insufficient.

## Step 5: Exposure
1. Create/Update Controller in `HttpApi` to expose the new AppService.

## Step 6: Validation
1. Run `dotnet build` to verify compilation.
2. Verify AI manifest `ai_status` is updated to `Complete`.
