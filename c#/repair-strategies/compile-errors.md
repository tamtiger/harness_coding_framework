# Repair Strategy: Compile Errors

## Workflow
1. **Analyze**: Read the full error message, identify the file, line number, and C# compiler error code (e.g., CS0246).
2. **Reproduce**: Run `dotnet build` on the specific module/project to confirm the error output.
3. **Context Check**: Check `feature-manifest.json` and `dependency-rules.md` to see if the error is due to a structural rule violation (e.g., illegal cross-module reference).
4. **Isolated Fix**: Apply the fix strictly to the affected block. Do not perform massive unprompted refactoring.
5. **Dependency & Reference Verification**:
   - Are the required NuGet packages installed in the `.csproj`?
   - Is there a missing project reference (`<ProjectReference>`)?
   - Is the namespace `using` directive missing?
6. **Verify Fix**: Re-run `dotnet build` to ensure the compilation error is resolved and no new errors are introduced.

## Common C# / ABP Compile Issues
- **CS0246 (Type or namespace not found)**:
  - *Fix*: Add missing `using` directives, verify NuGet package installation, or ensure the `.csproj` references the correct target project.
- **CS0535 (Does not implement interface member)**:
  - *Fix*: Ensure the Application Service or Repository fully implements all methods defined in its interface (e.g., `Contracts` project mismatch).
- **Missing [Authorize] / Permission Errors**:
  - *Fix*: Ensure permissions are explicitly defined in the `Contracts` project and properly checked via `[Authorize]` in the `Application` project.
- **AutoMapper Profile Errors**:
  - *Fix*: Verify that DTOs match Domain entities. Ensure `CreateMap<Entity, DTO>()` is defined in the correct module's `Profile` class.
- **Unit of Work Violations**:
  - *Fix*: Ensure database-modifying operations (Updates, Inserts) are properly scoped within a `[UnitOfWork]` if not inherently managed by the repository.
- **Dependency Injection Failures (Module Registration)**:
  - *Fix*: Ensure services implement standard interfaces (e.g., `ITransientDependency`) and module classes correctly declare `[DependsOn(typeof(OtherModule))]`.
