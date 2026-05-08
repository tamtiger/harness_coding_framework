# AI Agent Global Instructions

This repository is an AI-Native Engineering Harness for polyglot software
delivery. `AGENTS.md` is the single shared entrypoint for every AI coding tool:
Codex, Cursor, Windsurf, Claude, GitHub Copilot, Gemini, and future agents.
Do not create tool-specific root instruction files unless a human explicitly
asks for them.

## Mandatory Routing

Before writing code, changing architecture, or answering implementation
questions, identify the technology stack and load the matching rulebook.

| Work Area | Read First |
| --- | --- |
| C# / .NET / ABP Framework | `c#/README.md` |
| C# project-specific work | `c#/projects/{ProjectName}/README.md` after `c#/README.md` |
| Other stacks | `{stack}/README.md` when that stack folder exists |
| New C# project rulebook | `c#/workflows/project-onboarding.md` |
| New C# feature | `c#/workflows/feature-implementation.md` |
| Long-running C# work | `c#/workflows/agent-memory-workflow.md` |

Stack rulebooks define baseline architecture, dependency boundaries, naming,
testing, CI, and agent workflow. Project rulebooks define product-specific
decisions such as database engine, messaging, security, observability, state
machines, external adapters, and operational workflows.

When a project-specific rule conflicts with a generic stack rule on a
product-specific detail, the project-specific rulebook takes precedence. Generic
architecture and layer boundaries still apply unless the project rulebook records
an explicit override.

## Current Stack Inventory

- `c#/`: C# / .NET / ABP Framework baseline rulebook.
- `c#/projects/payment-hub/`: Payment Hub product rulebook.

## Agent Workflow

Use the repository as a context-engineering system, not only as a prompt folder.

1. Establish scope: stack, project, module, feature, action, and affected layers.
2. Load only the rulebooks required for that scope.
3. For substantial work, create or update a ticket/plan under `thoughts/`.
4. For C# feature work, create or update `prompt-spec.md` before implementation.
5. Keep `feature-manifest.json` aligned with dependencies, permissions, events,
   touched layers, and `ai_status`.
6. Validate with the relevant build, tests, and harness validation scripts before
   reporting completion.

## Non-Negotiable Constraints

- Do not hallucinate paths. Inspect the repository when uncertain.
- Do not generate incomplete code, placeholder implementations, or
  `NotImplementedException`.
- Do not refactor unrelated files or cross module boundaries without a task
  requirement.
- Do not make product-specific infrastructure decisions outside the relevant
  project rulebook.
- Keep this file concise. Detailed rules belong in stack/project rulebooks,
  workflows, templates, or scripts that agents load on demand.
