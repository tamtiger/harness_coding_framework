# Architecture Rules

## Core Principles
1. **Deterministic Vertical Slices**: Application-level feature artifacts MUST be self-contained in a single folder within the Application layer. Cross-layer artifacts MUST stay in their owning ABP layers (`Application.Contracts`, `Domain`, `Domain.Shared`, `EntityFrameworkCore`, `HttpApi`). The agent must be able to infer all file paths based on the `FeatureName`, module name, and project-specific module map.
2. **Modular Monolith (ABP)**: Maintain strict boundaries between modules. Use `Domain.Shared` for cross-cutting constants/enums and `IDistributedEventBus` for inter-module communication.
3. **CQRS / Command Pattern**: Separate Read (Queries) and Write (Commands). Each feature should ideally be a single Command or Query with its own Request/Response pair.
4. **Thin Application Services**: Logic resides in Domain Entities, Domain Services, or Handlers. AppServices are purely orchestrators (load, execute, save).

## Baseline Stack
These are the default expectations for C# projects unless a project-specific
rulebook under `c#/projects/{ProjectName}/` overrides them explicitly.

- .NET 8
- ABP Framework 8.x
- EF Core
- Redis-compatible distributed cache

## Project-Specific Overrides
- Project rulebooks under `c#/projects/{ProjectName}/` are the source of truth
  for infrastructure choices such as database engine, message broker,
  observability stack, security constraints, and domain-specific workflows.
- When a project-specific rule conflicts with this generic harness, follow the
  project-specific rule and keep the decision documented in that project's
  README or module map.
- The generic harness MUST define architecture invariants. It MUST NOT force
  product-specific technology choices such as PostgreSQL versus SQL Server.

## Layering Strictness
- **Domain**: Entities, Value Objects, Domain Services, Repository Interfaces, Exceptions. *No dependencies on external infrastructure.*
- **Application**: Features (Commands, Queries, Handlers, Validators), AppServices. *Depends on Domain and Application.Contracts.*
- **EntityFrameworkCore**: DB Context, Migrations, Repository Implementations, Entity Mappings. *Depends on Domain.*
- **HttpApi**: Controllers, API Routing. *Depends on Application.Contracts (and rarely Application).*
- **Application.Contracts**: DTOs, AppService Interfaces, Permissions, API constants. *Used by Clients and HttpApi.*
- **Domain.Shared**: Domain enums, error codes, shared constants, and primitive cross-layer concepts.
