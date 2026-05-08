# Research: Harness Improvement

## Question
How to best structure an AI-Native Engineering Harness that supports multiple AI coding agents (Antigravity, Cursor, Copilot) without conflicting root instructions and context bloat?

## Scope
- Stack: Framework agnostic / Markdown
- Project: None
- Files, modules, repositories, or sources reviewed: Standard practices for AI-Native Repositories, Prompt Engineering techniques for autonomous agents.

## Findings
- Maintaining multiple tool-specific files (e.g., `.cursorrules`, `CLAUDE.md`, etc.) leads to fragmentation and out-of-sync instructions.
- AI agents perform best when given a single, authoritative entrypoint that routes them to stack-specific or project-specific rulebooks.
- Context windows are limited. Dumping all rules into one file causes context dilution. A modular approach (routing from `AGENTS.md` -> `c#/README.md` -> `c#/projects/...`) preserves context for the actual task.
- Agents lack long-term memory across sessions. A `thoughts/` workspace acts as an external brain.

## Recommendation
- Create a single `AGENTS.md` entrypoint.
- Define a `thoughts/` folder for tickets, plans, and research.
- Enforce the rules using a validation script to ensure that plans and rulebooks align with the expected structure.

## Sources
- Best practices from AI Engineering and Context Engineering guidelines.

## Follow-Up
- Implement the structure and templates defined in the recommendation.
- Create a plan (`harness-improvement-plan.md`) to execute these changes.
