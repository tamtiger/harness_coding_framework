# Repair Strategy: Test Failures

## Workflow
1. **Read Output**: Capture the test name, assertion message, expected vs actual
   values, and stack trace.
2. **Classify**: Determine if the failure is a true regression, a flaky test, a
   setup/teardown issue, or an intentional behavior change.
3. **Reproduce**: Run the single failing test in isolation to confirm it is not
   order-dependent.
4. **Context Check**: Review `feature-manifest.json` and `testing-rules.md` to
   verify test expectations match the current domain rules.
5. **Isolated Fix**: Fix the test or the production code, not both at the same
   time unless the change is trivial. If the test expectation is wrong, update
   the test. If the production code is wrong, fix the code and confirm the test
   passes.
6. **Verify**: Re-run the single test, then the full test project.

## Common C# / ABP Test Issues

### Assertion Failure (Expected vs Actual Mismatch)
- **Likely Cause**: Production behavior changed but test was not updated, or a
  domain rule was incorrectly implemented.
- **Fix**:
  1. Check if the production change was intentional (read recent commits or
     prompt spec).
  2. If intentional: update the test assertion and document why.
  3. If unintentional: fix the production code.

### DI / Service Resolution Failure in Tests
- **Likely Cause**: Test module does not declare `[DependsOn]` for the required
  ABP module, or a mock/fake is not registered.
- **Fix**:
  1. Verify the test module inherits from the correct ABP test module.
  2. Register missing mocks in `ConfigureServices` of the test module.
  3. Do not add production services to test DI unless the test is an
     integration test.

### Database / EF Core Test Failure
- **Likely Cause**: In-memory database does not support the query, or test data
  setup is incomplete.
- **Fix**:
  1. For in-memory limitations (e.g., raw SQL, stored procedures), switch to
     SQLite in-memory or skip with `[Fact(Skip = "...")]` and document why.
  2. Verify seed data matches test expectations.
  3. Check that `DbContext` entity configurations are loaded in the test host.

### Flaky / Order-Dependent Tests
- **Likely Cause**: Shared mutable state, time-dependent logic, or async race
  conditions.
- **Fix**:
  1. Isolate the test by running it alone: `dotnet test --filter "FullyQualifiedName=..."`.
  2. Replace `DateTime.Now` with `IClock` (ABP's clock abstraction).
  3. Use deterministic data builders instead of random or shared fixtures.
  4. Ensure `IUnitOfWork` scope is properly managed per test.

### Permission / Authorization Test Failure
- **Likely Cause**: Test user does not have the required permission, or the
  permission constant changed.
- **Fix**:
  1. Verify the test user/role setup grants the required permission.
  2. Confirm permission constant matches `{Module}Permissions.cs`.
  3. For negative tests (expect 403), verify the test explicitly uses an
     unauthorized user.

### AutoMapper / Mapping Failure
- **Likely Cause**: Missing `CreateMap<>` in the feature profile, or DTO
  property name mismatch.
- **Fix**:
  1. Verify `{FeatureName}Profile.cs` has the correct mapping.
  2. Run `mapper.ConfigurationProvider.AssertConfigurationIsValid()` in a test.
  3. Check for property name or type mismatches between entity and DTO.

## Agent Checklist
- Always read the full assertion message before changing code.
- Run the single test first, then the full project suite.
- Do not delete or skip tests without documenting the reason.
- Prefer fixing production code if the test expectation is correct.
- Prefer fixing test expectations if the production change was intentional.
- For flaky tests, aim for deterministic root cause fix, not retry loops.
