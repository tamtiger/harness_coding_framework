# Workflow: Agent Memory

Use Agent Memory when C# work spans multiple sessions, modules, epics, or
project-specific implementation threads. Keep memory factual, compact, and
actionable.

## Memory Location

Use the narrowest stable location:

1. Project-level memory:
   `c#/projects/{ProjectName}/AGENT_MEMORY.md`
2. Feature-level memory:
   `{Module}.Application/Features/{FeatureName}/AGENT_MEMORY.md`
3. Repository-level memory only for cross-stack harness work:
   `AGENT_MEMORY.md`

Create new memory files from `thoughts/templates/agent-memory-template.md`.

## When To Create Or Read Memory

- Read existing memory before changing long-running work.
- Create memory when a task is part of an epic, migration, architecture rollout,
  or multi-session project.
- Do not create memory for small, self-contained edits that are fully captured
  by the ticket, plan, prompt spec, and git diff.

## What To Record

- Current goal and scope.
- Completed and in-progress work.
- Product or architecture decisions that future agents must preserve.
- Approved deviations from default rules.
- Errors encountered and the fix that worked.
- Validation commands and outcomes.
- Next steps that are concrete enough for another agent to resume.

## What Not To Record

- Full chat transcripts.
- Repeated copies of rulebook content.
- Speculation that has not been accepted as a decision.
- Sensitive data, secrets, tokens, credentials, or full payment card data.

## Update Loop

1. At task start, read the relevant memory file if it exists.
2. During implementation, update memory immediately after important approved
   decisions or non-obvious repair steps.
3. Before final response, update memory when the work should carry into a later
   session.
4. Link related `thoughts/shared/01-tickets/`, `thoughts/shared/03-plans/`,
   `prompt-spec.md`, and `feature-manifest.json` files instead of duplicating
   them.
