# Dependency Rules

## Layer Dependencies
- **Application** -> **Domain**, **Contracts**
- **EntityFrameworkCore** -> **Domain**
- **HttpApi** -> **Contracts**
- **Domain.Shared** -> No specific ABP dependencies, used for primitive enums/constants.
- **Host** -> ALL

## Interaction Rules
1. **Strict Layer Isolation**: **Never** reference `EntityFrameworkCore` from `Application` or `Domain`. **Never** reference `HttpApi` from any other layer.
2. **Cross-Module Communication**:
   - MUST happen asynchronously via **Distributed Event Bus** (`IDistributedEventBus`) when possible to prevent coupling.
   - For synchronous reads, use **AppService Interfaces** from the other module's `Contracts` project. Never directly inject another module's `Repository` or `Domain Service`.
3. **Circular Dependencies**: Avoid at all costs. If Module A needs Module B, and Module B needs Module A, refactor the shared logic into a new Module C or use Events.

## Injection & Module Policy
- Always use **Constructor Injection**. Never use Service Locator (`IServiceProvider`) unless inside dynamic factory patterns.
- Mark dependencies as `private readonly`.
- Use ABP's explicit dependency interfaces (`ITransientDependency`, `ISingletonDependency`, `IScopedDependency`) on the implementation classes.
- **Module Registration**: Every new project MUST have an ABP module class inheriting from `AbpModule` with proper `[DependsOn(...)]` attributes to load dependencies correctly.
