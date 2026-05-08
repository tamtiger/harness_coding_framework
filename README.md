# AI-Native Engineering Harness

`harness_coding_framework` is a polyglot, agent-native engineering harness. It
stores the routing instructions, rulebooks, workflows, prompts, validation
scripts, and planning artifacts that AI coding agents need before touching a
real codebase.

The repository is designed around deterministic context loading: agents start at
one shared entrypoint, route into the correct technology stack, follow the
project-specific rulebook when one exists, then validate their work before
reporting completion.

## Agent Entrypoint

[AGENTS.md](AGENTS.md) is the single shared instruction file for all AI coding
tools. Do not add tool-specific root files such as `CLAUDE.md`, Cursor rules, or
Copilot instructions unless the team explicitly decides to support them later.

Agent flow:

1. Read `AGENTS.md`.
2. Identify the stack and project.
3. Read the matching stack `README.md`.
4. Read the matching project rulebook when the task belongs to a concrete
   project.
5. Use the relevant workflow, prompt, plan, and validation script.

## Repository Map

| Path | Purpose |
| --- | --- |
| `AGENTS.md` | Single tool-agnostic routing entrypoint for agents |
| `c#/` | C# / .NET / ABP Framework baseline rulebook |
| `c#/prompts/` | Task prompts, including the C# feature generator |
| `c#/workflows/` | Implementation, onboarding, memory, and repair workflows |
| `c#/projects/payment-hub/` | Payment Hub project-specific rulebook |
| `thoughts/` | Ticket, plan, research, and memory templates |
| `scripts/validate-harness.ps1` | Harness metadata and rulebook validation |

## Supported Stack

### C# / .NET / ABP Framework

Start with [c#/README.md](c#/README.md). This rulebook defines the baseline for
ABP, vertical slices, DDD boundaries, API contracts, testing, CI, naming,
dependencies, and agent workflow.

Project-specific rulebooks live under `c#/projects/{ProjectName}/`. The current
project rulebook is [Payment Hub](c#/projects/payment-hub/README.md), which
adds payment orchestration rules for security, idempotency, state machines,
messaging, persistence, observability, provider adapters, testing, and CI.

Other stacks can be added later with the same pattern:

```text
{stack}/
 ├── README.md
 ├── workflows/
 ├── prompts/
 └── projects/{ProjectName}/
```

## Context Workflow

Use `thoughts/` for work that should survive beyond a single chat message.

```text
thoughts/
 ├── shared/
 │    ├── 01-tickets/
 │    ├── 02-research/
 │    └── 03-plans/
 └── templates/
      ├── ticket-template.md
      ├── plan-template.md
      ├── research-template.md
      └── agent-memory-template.md
```

Recommended flow:

1. Create a ticket from `thoughts/templates/ticket-template.md`.
2. Create a plan from `thoughts/templates/plan-template.md`.
3. Implement against the approved plan.
4. For C# features, create or update `prompt-spec.md` and
   `feature-manifest.json`.
5. Validate and update the plan checklist before completion.

The current harness improvement plan is tracked at
[thoughts/shared/03-plans/harness-improvement-plan.md](thoughts/shared/03-plans/harness-improvement-plan.md).

## C# Feature Generation

Use [c#/prompts/feature-generator.md](c#/prompts/feature-generator.md) for ABP
feature work. It requires:

- stack and project rulebook loading
- `prompt-spec.md` before implementation
- `feature-manifest.json` aligned with touched layers
- contracts, domain, application, infrastructure, HTTP API, and tests in their
  owning ABP projects
- focused validation before marking work complete

## Validation

Run harness validation from the repository root:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/validate-harness.ps1
```

The script currently checks:

- root `AGENTS.md`
- `c#/README.md`
- `thoughts/` directory and templates
- required C# project rulebook files
- `feature-manifest.json` shape and allowed values
- sibling `prompt-spec.md` for each feature manifest
- required headings in prompt specs


## Human Usage

When directing an AI agent:

1. State the target stack, project, module, and desired outcome.
2. Ask the agent to read `AGENTS.md` and the relevant rulebooks.
3. For substantial work, ask it to create a plan under `thoughts/shared/03-plans/`.
4. For C# feature work, ask it to use the feature generator prompt and maintain
   `prompt-spec.md` plus `feature-manifest.json`.
5. Require `scripts/validate-harness.ps1` before accepting completion.

## Current Implementation Status

The harness improvement phase is implemented and checked off in
`thoughts/shared/03-plans/harness-improvement-plan.md`. Harness validation is
passing locally.
