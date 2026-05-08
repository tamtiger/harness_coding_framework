# Thoughts Workspace

`thoughts/` stores context-engineering artifacts that help AI agents and humans
carry work across sessions without overloading root instructions.

## Structure

```
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

## Usage

- Use `shared/01-tickets/` for feature requests, bugs, and architecture tasks.
- Use `shared/03-plans/` for implementation plans that can be reviewed before code
  changes.
- Use `shared/02-research/` for codebase or external research that should be reused.
- Keep files concrete: record the real stack, project, module, decisions, risks,
  and validation commands.
- For C# feature work, the approved plan should point to the feature
  `prompt-spec.md` and `feature-manifest.json`.
