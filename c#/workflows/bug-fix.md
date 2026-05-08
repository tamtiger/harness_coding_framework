# Workflow: Bug Fix

Use this workflow when fixing a bug, investigating an incident, or applying a
hotfix to an existing C# / ABP feature.

## Step 0: Context Loading
- Read `c#/README.md` and relevant project rulebook
  (`c#/projects/{ProjectName}/README.md`).
- If a ticket exists, read it from `thoughts/shared/01-tickets/`.
- If no ticket exists and the fix touches more than 2 files, create one using
  `thoughts/templates/ticket-template.md` with the naming convention
  `YYYYMMDD_HHMM_task-name.md`.

## Step 1: Reproduce
1. Identify the failing behavior: error message, stack trace, API response,
   or test output.
2. Write or locate a test that reproduces the bug. If a test already exists and
   passes, the bug may be in an untested code path.
3. Run the reproducing test or scenario and confirm it fails as expected.
4. If reproduction is not possible, document what was tried and escalate to the
   requester.

## Step 2: Root Cause Analysis
1. Trace the failure from the error surface (controller, handler, test) down to
   the root cause (domain logic, DI, data, config).
2. Check `feature-manifest.json` for the affected feature's boundaries and
   dependencies.
3. Consult repair strategies:
   - `c#/repair-strategies/compile-errors.md` for build failures.
   - `c#/repair-strategies/runtime-errors.md` for runtime exceptions.
   - `c#/repair-strategies/test-failures.md` for test assertion failures.
4. Identify the minimum set of files that need to change.

## Step 3: Minimal Fix
1. Apply the fix strictly to the affected code path.
2. Do not refactor unrelated code, even if it looks improvable.
3. Do not change public API contracts unless the bug is in the contract itself.
4. If the fix requires a domain rule change, update the entity or domain
   service, not the application layer.
5. Follow `error-code-conventions.md` if adding or changing error codes.

## Step 4: Regression Test
1. Verify the reproducing test now passes.
2. Add a new test if no existing test covered the bug scenario.
3. Name the test descriptively:
   `{Method}_Should{ExpectedBehavior}_When{Condition}` (e.g.,
   `CreatePayment_ShouldFail_WhenIdempotencyKeyIsReused`).
4. Run the full test suite for the touched layers.

## Step 5: Validate
1. Run `dotnet build` on the affected solution or project.
2. Run `dotnet test` for the touched layers.
3. Run `./scripts/validate-harness.ps1` if any manifest or spec file was
   changed.
4. Update `feature-manifest.json` `ai_status` if the fix changes feature
   boundaries.
5. Update the ticket status to `Done` and close the plan if one exists.
6. Update `AGENT_MEMORY.md` if the fix is part of a long-running module or
   epic.
