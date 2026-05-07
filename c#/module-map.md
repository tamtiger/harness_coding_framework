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

## Inter-Module Boundaries (AI Rules)
1. **Physical Isolation**: Each module MUST reside in its own solution folder `modules/{ModuleName}/`.
2. **Strict No-UI Coupling**: Cross-module UI dependencies are forbidden.
3. **API Contracts**: If Module A needs Module B, Module A must reference `Module B.Contracts` project ONLY.
4. **Shared Kernel**: Use `Domain.Shared` projects to share Enums or primitive Constants if absolutely necessary, but prefer duplicating small DTOs over creating heavy shared dependencies.
5. **Registration**: When creating a new Module, the agent MUST update this `module-map.md` to reflect the new boundaries.
