# Feature Template: {FeatureName}

## Folder Structure
Application-level feature artifacts MUST be co-located within a single
`Application/Features/{FeatureName}/` folder. Cross-layer artifacts MUST stay in
their owning ABP layer so the vertical slice remains discoverable without
breaking layer boundaries.

```
{Module}.Application/
 └── Features/
      └── {FeatureName}/
           ├── {FeatureName}AppService.cs (Orchestrator)
           ├── {FeatureName}Command.cs (or Query.cs)
           ├── {FeatureName}Handler.cs (Application orchestration)
           ├── {FeatureName}Validator.cs (FluentValidation)
           ├── {FeatureName}Profile.cs (AutoMapper)
           ├── README.md (AI generated summary)
           ├── prompt-spec.md (Prompt-as-Code Spec based on c#/prompt-spec-template.md)
           └── feature-manifest.json

{Module}.Application.Contracts/
 ├── Features/{FeatureName}/
 │    ├── {FeatureName}Request.cs (Input DTO)
 │    └── {FeatureName}Response.cs (Output DTO)
 ├── I{Entity}AppService.cs
 └── Permissions/{Module}Permissions.cs

{Module}.Domain/
 ├── {Entity}.cs
 ├── {Entity}Manager.cs
 └── Repositories/I{Entity}Repository.cs (only when generic IRepository is insufficient)

{Module}.EntityFrameworkCore/
 ├── EntityFrameworkCore/{Module}DbContext.cs
 ├── EntityFrameworkCore/{Entity}EntityTypeConfiguration.cs
 └── Repositories/EfCore{Entity}Repository.cs (only when custom repository exists)

{Module}.HttpApi/
 └── Controllers/{Entity}Controller.cs (only when conventional ABP controllers are insufficient)
```

## AI Agent Contract: `feature-manifest.json`
Every feature MUST include this manifest. The AI agent uses this to understand
boundaries and dependencies before modifying files. The manifest SHOULD validate
against `c#/feature-manifest.schema.json`.

```json
{
  "feature": "{FeatureName}",
  "module": "{ModuleName}",
  "type": "Command|Query",
  "dependencies": [
    "I{Entity}Repository",
    "{Entity}Manager"
  ],
  "layers_touched": [
    "Application",
    "Application.Contracts",
    "Domain",
    "EntityFrameworkCore",
    "HttpApi"
  ],
  "permissions": [
    "{Module}.{Entity}.{Action}"
  ],
  "events": [
    "{Entity}{Action}Eto"
  ],
  "ai_status": "Complete|Draft|NeedsReview"
}
```

## Implementation Checklist for Agents
- [ ] Ensure `prompt-spec.md` is drafted and reviewed before generating the feature code.
- [ ] Read `feature-manifest.json` before touching files.
- [ ] Follow `c#/prompt-spec-template.md` when creating or updating `prompt-spec.md`.
- [ ] Keep DTOs, AppService interfaces, and permissions in `Application.Contracts`.
- [ ] Keep entities, value objects, domain services, repository interfaces, and error codes in `Domain` or `Domain.Shared`.
- [ ] Keep EF Core mappings, migrations, and repository implementations in `EntityFrameworkCore`.
- [ ] Handler contains business orchestration and CQRS logic.
- [ ] Core business rules are pushed down to Domain Services (`{Entity}Manager`).
- [ ] Validator uses `FluentValidation` and is injected automatically by ABP.
- [ ] Mapping is defined in local `{FeatureName}Profile.cs`.
- [ ] Local AutoMapper profiles are registered through the module's Application AutoMapper configuration.
- [ ] Permissions are strictly enforced via `[Authorize]` on the AppService/Handler.
- [ ] Exceptions thrown are strictly ABP `BusinessException`.
