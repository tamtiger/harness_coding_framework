# Ticket: Harness Improvement

## Metadata
- **Ticket ID**: `harness-001`
- **Stack**: `other`
- **Project**: `None`
- **Module**: `None`
- **Requester**: `User`
- **Status**: `Done`

## Problem
The current repository needs to be structured as a robust AI-native engineering harness. AI coding tools (Antigravity, Cursor, GitHub Copilot) need a deterministic, context-loading entrypoint to avoid hallucination and ensure consistency across polyglot environments.

## Desired Outcome
The repository should have a single tool-agnostic entrypoint (`AGENTS.md`), well-defined rulebooks, a structured workspace (`thoughts/`) for context engineering (tickets, plans, research), and validation scripts to enforce the rules automatically.

## Scope
### In Scope
- Setup root `AGENTS.md`.
- Establish `thoughts/` directory and its templates.
- Update C# feature generator prompts to use this structure.
- Add validation scripts (`validate-harness.ps1`).

### Out Of Scope
- Implementation of product-specific business logic.
- Rewriting existing C# applications.

## Constraints
- Must maintain a single shared `AGENTS.md` file; do not create tool-specific root instructions.
- Must be friendly for both human usage and AI agents.

## Acceptance Criteria
- `AGENTS.md` exists and routes correctly.
- `thoughts/` directory is established with templates.
- Validation script runs successfully to verify harness structure.
- CI rules are configured to run validation.

## References
- Research on AI Engineering Harness patterns.
