# Anti-Patterns (NEVER DO THESE)

## AI-Native Agent Rules
1. **Hallucination of State**: Do not assume a file exists. Always check the file system.
2. **Scope Creep**: Never modify code outside the specific `Feature` folder unless instructed or required for cross-cutting registration (e.g., DI, Permissions).
3. **Placeholders**: Never use `TODO`, `implement later`, or `throw new NotImplementedException()` unless explicitly asked to draft. Write the full implementation.

## Architectural & ABP Rules
4. **God Services**: Do not create generic CRUD services handling multiple entities (e.g., `GeneralAppService`). One feature = one service/handler.
5. **Business Logic in Controllers**: Controllers must ONLY delegate to AppServices or MediatR. No `if/else` business rules here.
6. **Business Logic in AppServices**: AppServices must ONLY orchestrate (Call Repository -> Call Domain Service -> Return DTO). Core logic must be in the Domain model or Domain Services.
7. **Generic Exceptions**: Do not `throw new Exception()`. Always use ABP's `BusinessException` with a specific error code defined in the `Domain.Shared` layer.
8. **Manual Validation**: Do not use `if (dto == null)`. Use ABP's validation system (`IValidationEnabled`) or `FluentValidation`.
9. **Leaking Entities**: Never return Domain Entities in AppServices or Controllers. Always map to a DTO.
10. **Direct DB Access**: Never inject `DbContext` into AppServices. Always use `IRepository<TEntity, TKey>`.
11. **Hidden Dependencies**: Always be explicit with `[Dependency]`, `[Authorize]`, etc. No hidden service locators (`ServiceLocator.Resolve()`).
