# Module Map

## Core Framework Modules (ABP Built-in)
- **Identity**: ABP default identity management (Users, Roles).
- **Account**: Login, registration, profile UI/APIs.
- **AuditLogging**: Systematic auditing of API calls and Entity changes.
- **SettingManagement**: Tenant and global configuration settings.
- **TenantManagement**: SaaS tenant management.

## Custom Modules (Business Domains)
- `{ModuleName}`: Description of the custom business domain.
  - *Dependencies*: List other modules this module depends on.
  - *Events Published*: List integration events this module broadcasts.

## Project-Specific Module Maps
- This file defines the generic C# harness conventions for module boundaries.
- Each concrete project SHOULD maintain its own module map at
  `c#/projects/{ProjectName}/module-map.md`.
- Project-specific module maps are authoritative for concrete components,
  infrastructure, and domain workflows inside that project.
- If this generic map conflicts with a project-specific module map on product
  details, follow the project-specific map.

## Inter-Module Boundaries (AI Rules)
1. **Physical Isolation**: In multi-module solutions, each module SHOULD reside in its own solution folder `modules/{ModuleName}/`. Concrete projects MAY override this with a `src/{ModuleProjectName}/` structure in their project-specific module map.
2. **Strict No-UI Coupling**: Cross-module UI dependencies are forbidden.
3. **API Contracts**: If Module A needs Module B, Module A must reference `ModuleB.Application.Contracts` project ONLY.
4. **Shared Kernel**: Use `Domain.Shared` projects to share Enums or primitive Constants if absolutely necessary, but prefer duplicating small DTOs over creating heavy shared dependencies.
5. **Registration**: When creating a new generic module, the agent MUST update this `module-map.md`. When creating or changing a concrete project component, update `c#/projects/{ProjectName}/module-map.md`.
