# Repair Strategy: Runtime Errors

## Workflow
1. **Capture**: Read the full exception message, type, stack trace, and inner
   exceptions. Identify the throwing file, line number, and method.
2. **Reproduce**: Run the failing scenario (test, API call, or startup) and
   confirm the exact same exception occurs.
3. **Context Check**: Consult `feature-manifest.json`, `dependency-rules.md`,
   and the project rulebook to verify whether the runtime context (DI, config,
   permissions, tenant scope) is correctly wired.
4. **Isolated Fix**: Apply the fix strictly to the affected code path. Do not
   refactor unrelated files.
5. **Verify Fix**: Re-run the failing scenario and relevant tests. Confirm no
   new exceptions are introduced.

## Common C# / ABP Runtime Issues

### NullReferenceException
- **Likely Cause**: Missing DI registration, unresolved optional dependency, or
  entity loaded without required navigation property.
- **Fix**:
  1. Verify the service is registered (`ITransientDependency`,
     `ISingletonDependency`, or explicit module registration).
  2. Check repository queries for missing `Include()` or `WithDetails()`.
  3. Add null guards only when the value is legitimately optional; otherwise
     fix the root cause.

### InvalidOperationException (Dependency Injection)
- **Likely Cause**: Missing `[DependsOn(typeof(OtherModule))]` in the ABP
  module class, or a service registered with the wrong lifetime.
- **Fix**:
  1. Verify the ABP module chain declares all required dependencies.
  2. Confirm the service lifetime matches its usage (scoped services cannot be
     injected into singletons).

### DbUpdateException / DbUpdateConcurrencyException
- **Likely Cause**: Entity constraint violation, optimistic concurrency
  conflict, or migration drift.
- **Fix**:
  1. Check entity configuration for unique indexes, foreign keys, and required
     fields.
  2. For concurrency: verify `ConcurrencyStamp` handling in the domain entity.
  3. Run `dotnet ef migrations list` to confirm migrations are up to date.

### TimeoutException / TaskCanceledException
- **Likely Cause**: External provider not responding, missing circuit breaker,
  or `HttpClient` without timeout configuration.
- **Fix**:
  1. Verify `HttpClient` has explicit `Timeout` set.
  2. Check circuit breaker / retry policy (Polly) configuration.
  3. For database timeouts, check query performance and connection pool limits.

### UnauthorizedAccessException / AbpAuthorizationException
- **Likely Cause**: Missing `[Authorize]` attribute, permission not defined in
  `Application.Contracts`, or tenant context not set.
- **Fix**:
  1. Confirm the permission constant exists in `{Module}Permissions.cs`.
  2. Confirm the permission is granted to the test user or role.
  3. For multi-tenant, verify `ICurrentTenant` is populated.

### BusinessException (Domain Errors)
- **Likely Cause**: Domain rule violation is expected behavior, but the error
  code or message is incorrect.
- **Fix**:
  1. Verify the error code follows `error-code-conventions.md`.
  2. Confirm the error code is defined in `{Module}.Domain.Shared`.
  3. Check that the exception is caught and mapped correctly in the API layer.

## Agent Checklist
- Read the full stack trace before guessing.
- Check DI registrations and ABP module dependencies first.
- Prefer fixing root cause over adding null guards.
- Run the narrowest failing test, then the full suite.
- If the error is in a project-specific adapter or provider, consult the
  project rulebook before applying a fix.
