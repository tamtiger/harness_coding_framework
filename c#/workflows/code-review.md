# Workflow: Code Review

Use this workflow when an AI agent is asked to review code, provide feedback on
a pull request, or evaluate implementation quality for a C# / ABP feature.

## Step 0: Context Loading
- Read `c#/README.md` and the relevant project rulebook.
- Read `c#/architecture-rules.md`, `c#/naming-conventions.md`,
  `c#/dependency-rules.md`, `c#/anti-patterns.md`, and
  `c#/error-code-conventions.md`.
- If the review is for a specific feature, read its `prompt-spec.md` and
  `feature-manifest.json`.

## Step 1: Scope The Review
1. Identify all changed files and their ABP layers.
2. Classify the change type: new feature, bug fix, refactor, or config change.
3. Note which modules and features are affected.

## Step 2: Architecture And Layering
1. Verify files are in the correct ABP layer project.
2. Check that domain logic is NOT in controllers or AppServices.
3. Verify cross-module communication uses `IDistributedEventBus` or
   `Application.Contracts` interfaces, never direct repository injection.
4. Check `dependency-rules.md` compliance: no illegal layer references.
5. Verify entities extend the correct ABP base class (e.g.,
   `FullAuditedEntity<Guid>`).

## Step 3: Naming And Conventions
1. Verify classes, methods, DTOs, and files follow `naming-conventions.md`.
2. Check error codes follow `error-code-conventions.md`.
3. Verify permissions are named as `{Module}.{Entity}.{Action}`.
4. Verify feature folder structure matches `feature-template.md`.

## Step 4: Business Logic Quality
1. Verify domain rules are in entities or domain services, not in handlers.
2. Check that exceptions are ABP `BusinessException` with proper error codes.
3. Verify state transitions follow the project state machine if applicable.
4. Check for missing null guards on legitimately optional values.
5. Verify idempotency requirements if the feature involves state changes.

## Step 5: Contracts And API
1. Verify DTOs are in `Application.Contracts`, not the Application project.
2. Check that public API changes are backward compatible or versioned.
3. Verify `[Authorize]` attributes match defined permissions.
4. Check FluentValidation rules for completeness.
5. Verify AutoMapper profiles exist and map all required fields.

## Step 6: Testing
1. Verify tests exist for success, validation failure, authorization failure,
   and domain error paths.
2. Check test names follow `{Method}_Should{Expected}_When{Condition}`.
3. Verify no tests depend on execution order or shared mutable state.
4. Check that mocks are appropriate (no mocking everything).

## Step 7: Manifest And Spec Sync
1. Verify `feature-manifest.json` lists all touched layers.
2. Verify `ai_status` reflects the current state.
3. Verify `prompt-spec.md` acceptance criteria match the implementation.

## Review Output Format

Structure feedback as:

```markdown
### Summary
One-sentence assessment of the change.

### Must Fix (Blocking)
- [ ] Issue description with file reference and line number.

### Should Fix (Non-Blocking)
- [ ] Improvement suggestion with rationale.

### Observations (Informational)
- Positive patterns worth noting or minor style preferences.
```

## Agent Checklist
- Read the full diff before commenting.
- Reference specific rulebook rules when flagging issues.
- Distinguish blocking issues from suggestions.
- Do not suggest refactors outside the scope of the change.
- Acknowledge good patterns, not just problems.
