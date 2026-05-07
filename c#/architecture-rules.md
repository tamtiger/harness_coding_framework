# Architecture Rules

## Core Principles
1. **Deterministic Vertical Slices**: Every feature MUST be self-contained in a single folder within the Application layer. The agent must be able to infer all file paths based on the `FeatureName`.
2. **Modular Monolith (ABP)**: Maintain strict boundaries between modules. Use `Domain.Shared` for cross-cutting constants/enums and `IDistributedEventBus` for inter-module communication.
3. **CQRS / Command Pattern**: Separate Read (Queries) and Write (Commands). Each feature should ideally be a single Command or Query with its own Request/Response pair.
4. **Thin Application Services**: Logic resides in Domain Entities, Domain Services, or Handlers. AppServices are purely orchestrators (load, execute, save).

## Mandatory Stack
- .NET 8
- ABP Framework 8.x
- PostgreSQL
- EF Core
- Redis

## Layering Strictness
- **Domain**: Entities, Value Objects, Domain Services, Repository Interfaces, Exceptions. *No dependencies on external infrastructure.*
- **Application**: Features (Commands, Queries, Handlers, Validators), AppServices. *Depends on Domain and Contracts.*
- **EntityFrameworkCore**: DB Context, Migrations, Repository Implementations, Entity Mappings. *Depends on Domain.*
- **HttpApi**: Controllers, API Routing. *Depends on Contracts (and rarely Application).*
- **Contracts**: DTOs, AppService Interfaces, Permissions, Constants. *Used by Clients and HttpApi.*
