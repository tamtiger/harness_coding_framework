# Feature Template: {FeatureName}

## Folder Structure
All feature files MUST be co-located within a single folder. Do not scatter them across different layers unless absolutely necessary (e.g., Domain Entities or EF Core mappings).

```
Application/Features/
 └── {FeatureName}/
      ├── {FeatureName}AppService.cs (Orchestrator)
      ├── {FeatureName}Command.cs (or Query.cs)
      ├── {FeatureName}Handler.cs (Business Logic)
      ├── {FeatureName}Request.cs (Input DTO)
      ├── {FeatureName}Response.cs (Output DTO)
      ├── {FeatureName}Validator.cs (FluentValidation)
      ├── {FeatureName}Permissions.cs (Local Permissions)
      ├── {FeatureName}Profile.cs (AutoMapper)
      ├── README.md (AI generated summary)
      └── feature-manifest.json
```

## AI Agent Contract: `feature-manifest.json`
Every feature MUST include this manifest. The AI agent uses this to understand boundaries and dependencies before modifying files.

```json
{
  "feature": "{FeatureName}",
  "module": "{ModuleName}",
  "type": "Command|Query",
  "dependencies": [
    "I{Entity}Repository",
    "{Entity}Manager"
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
- [ ] Read `feature-manifest.json` before touching files.
- [ ] Handler contains business orchestration and CQRS logic.
- [ ] Core business rules are pushed down to Domain Services (`{Entity}Manager`).
- [ ] Validator uses `FluentValidation` and is injected automatically by ABP.
- [ ] Mapping is defined in local `{FeatureName}Profile.cs`.
- [ ] Permissions are strictly enforced via `[Authorize]` on the AppService/Handler.
- [ ] Exceptions thrown are strictly ABP `BusinessException`.
