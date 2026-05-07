# AI Agent Global Instructions

You are operating within the `harness_coding_framework` repository, an **AI-Native Engineering Harness** that supports polyglot architecture (multiple technology stacks like C#, Node, Frontend).
This is the single source of routing instructions for all AI Agents (Cursor, Windsurf, Claude, GitHub Copilot, etc.).

## ⚠️ MANDATORY DIRECTIVE
This repository is organized by technology stacks. Before writing any code or answering architecture questions, you MUST identify the correct ecosystem you are working in (e.g., `/c#/`, `/frontend/`) and consult its specific rulebook.

### Routing Mechanism:
1. **If working with C# / .NET / ABP Framework**:
   - MUST read: `/c#/README.md`
   - Use rules in `/c#/architecture-rules.md`, `/c#/dependency-rules.md`, etc.
   
2. **If working with other stacks**:
   - Locate the root folder for that stack (e.g., `/frontend/`) and read its `README.md` for specific architectural boundaries.

### Enhanced Workflows & Agent Memory:
- **Agent Memory**: You are expected to maintain an understanding of what has been done. If working in `/c#/`, use `/c#/workflows/agent-memory-workflow.md` to log your plan or refer to existing contexts.
- **Prompt-Driven Architecture**: Adhere to the rule that each feature must start with a `prompt-spec.md` where applicable.

Do not hallucinate paths or use placeholders like `TODO` or `NotImplementedException`. All generated code must be complete and adhere to the architectural rules of the respective stack.
