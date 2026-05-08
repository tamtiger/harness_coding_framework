# CI Rules

## Required Validation
Every concrete C# project SHOULD define CI jobs for:

1. Restore dependencies.
2. Build the solution with warnings visible.
3. Run unit tests.
4. Run integration tests that do not require live external providers.
5. Validate formatting and analyzers when configured.
6. Validate EF Core migrations when persistence changes are present.

Project-specific rulebooks MAY add jobs for contract tests, containerized
infrastructure, security scanning, performance smoke tests, or sandbox provider
drift detection.

## Agent Validation Policy
- Run `dotnet build` after code changes whenever a solution or project exists.
- Run relevant `dotnet test` commands for touched layers.
- If a command cannot be run because the solution is not scaffolded yet, report
  that explicitly and do not claim runtime verification.
- Do not introduce CI-only behavior that differs from local developer commands
  unless the project rulebook requires it.

## Minimum Local Commands
Concrete projects SHOULD document their exact commands in the project README:

```powershell
dotnet restore
dotnet build
dotnet test
```
