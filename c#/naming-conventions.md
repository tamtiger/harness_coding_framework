# Naming Conventions

## General Rules
- Use full, descriptive names. No abbreviations (e.g., `ProductRepository`, not `ProdRepo`).
- Follow `PascalCase` for classes, interfaces, methods, and properties.
- Follow `camelCase` for local variables and method arguments.
- Follow `_camelCase` (with underscore prefix) for private fields.

## Feature & CQRS Components
- **Command**: `{Action}{Entity}Command` (e.g., `CreateProductCommand`)
- **Query**: `Get{Entity}ListQuery` or `Get{Entity}Query` (e.g., `GetProductListQuery`)
- **Handler**: `{Command/Query}Handler` (e.g., `CreateProductCommandHandler`)
- **Validator**: `{Command/Query}Validator` (e.g., `CreateProductCommandValidator`)
- **Request/Response DTOs**: `{Action}{Entity}Dto` or `{Action}{Entity}Request` (e.g., `CreateProductDto`, `ProductDto`)

## ABP Specific Components
- **AppService**: `{Action}{Entity}AppService` (Feature-specific) or `{Entity}AppService` (General). Interface must be `I{Entity}AppService`.
- **Repository**: `I{Entity}Repository` (Interface in Domain) and `EfCore{Entity}Repository` (Implementation in EF Core project).
- **Domain Service**: `{Entity}Manager` (e.g., `ProductManager`).
- **Permissions**: Defined as `const string` fields in a static `{Module}Permissions` class.

## Events
- **Eto (Event Transfer Object)**: `{Entity}{Action}Eto` (e.g., `ProductCreatedEto`) - Used for Distributed Events.
- **Eto Mapping**: Create `AutoMapper` profiles inside `{Module}ApplicationAutoMapperProfile`.
