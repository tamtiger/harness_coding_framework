# Plan: Harness Improvement Roadmap

## Source Ticket
- [`thoughts/shared/01-tickets/20260508_1006_harness-improvement-ticket.md`](../../01-tickets/20260508_1006_harness-improvement-ticket.md)
- Research: [`thoughts/shared/02-research/20260508_1006_harness-improvement-research.md`](../../02-research/20260508_1006_harness-improvement-research.md)

## Scope Summary
Improve this repository as an AI-native engineering harness while preserving
`AGENTS.md` as the single shared entrypoint for all AI coding tools.

## Rulebooks Read
- [x] `AGENTS.md`
- [x] `c#/README.md`
- [x] `c#/projects/payment-hub/README.md`
- [x] `c#/workflows/feature-implementation.md`
- [x] `c#/workflows/agent-memory-workflow.md`
- [x] `c#/workflows/project-onboarding.md`

## Implementation Steps
- [x] Keep one tool-agnostic root `AGENTS.md`.
- [x] Add `thoughts/` workspace with ticket, plan, and research templates.
- [x] Add initial harness validation script for root instructions, manifests,
  and prompt specs.
- [x] Upgrade `c#/prompts/feature-generator.md` into a structured workflow
  prompt.
- [x] Add reusable `AGENT_MEMORY.md` template and link it from the memory
  workflow.
- [x] Harden C# project onboarding with a deterministic required-rulebook list.
- [x] Extend `scripts/validate-harness.ps1` to validate `thoughts/` templates
  and C# project rulebooks.
- [x] Add CI workflow to run harness validation automatically.
- [x] Run validation and update this plan with completed status.

## Files Expected To Change
- `AGENTS.md`
- `c#/prompts/feature-generator.md`
- `c#/workflows/feature-implementation.md`
- `c#/workflows/agent-memory-workflow.md`
- `c#/workflows/project-onboarding.md`
- `scripts/validate-harness.ps1`
- `c#/projects/payment-hub/testing-rules.md`
- `c#/projects/payment-hub/ci-rules.md`
- `thoughts/README.md`
- `thoughts/templates/*.md`
- `thoughts/templates/agent-memory-template.md`
- `thoughts/shared/03-plans/harness-improvement-plan.md`

## Validation Plan
- Run `./scripts/validate-harness.ps1`.
- Run `git diff --check`.

## Risks And Mitigations
- **Risk**: Root instructions become too verbose and consume context.
- **Mitigation**: Keep `AGENTS.md` as a routing table and move detail into
  workflows/templates/scripts.
- **Risk**: Validation becomes too strict before real projects exist.
- **Mitigation**: Validate harness metadata and rulebooks, not generated product
  code details.
- **Risk**: CI fails on repositories without .NET source yet.
- **Mitigation**: Add a harness-only workflow first; leave `dotnet` gates to
  project CI rules.

## Open Questions
- None for this phase.
