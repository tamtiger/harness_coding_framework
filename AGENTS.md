# AI Agent Global Instructions

You are operating within the `harness_coding_framework` repository, an **AI-Native Engineering Harness** that supports polyglot architecture (multiple technology stacks like C#, Node, Frontend).
This is the single source of routing instructions for all AI Agents (Cursor, Windsurf, Claude, GitHub Copilot, etc.).

## ⚠️ MANDATORY DIRECTIVE
This repository is organized by technology stacks. Before writing any code or answering architecture questions, you MUST identify the correct ecosystem you are working in (e.g., `/c#/`, `/frontend/`) and consult its specific rulebook.

Technology-stack rulebooks define the baseline architecture and agent workflow.
Project-specific rulebooks under `/{stack}/projects/{ProjectName}/` define
product/domain decisions such as database engine, messaging, security,
observability, state machines, external adapters, and operational workflows.
When a project-specific rule conflicts with the generic stack rule on a
product-specific detail, the project-specific rule takes precedence.

### Routing Mechanism:
1. **If working with C# / .NET / ABP Framework**:
   - MUST read: `/c#/README.md`
   - Use rules in `/c#/architecture-rules.md`, `/c#/dependency-rules.md`, `/c#/api-contract-rules.md`, `/c#/testing-rules.md`, `/c#/ci-rules.md`, etc.
   - If working on a concrete project, MUST also read `/c#/projects/{ProjectName}/README.md` and the relevant project-specific rule files.
   
2. **If working with other stacks**:
   - Locate the root folder for that stack (e.g., `/frontend/`) and read its `README.md` for specific architectural boundaries.
   - If that stack contains a `projects/{ProjectName}/` rulebook for the task, read it after the stack README.

### Enhanced Workflows & Agent Memory:
- **Agent Memory**: You are expected to maintain an understanding of what has been done. If working in `/c#/`, use `/c#/workflows/agent-memory-workflow.md` to log your plan or refer to existing contexts.
- **Prompt-Driven Architecture**: Adhere to the rule that each feature must start with a `prompt-spec.md` based on `/c#/prompt-spec-template.md` where applicable and must keep `feature-manifest.json` aligned with the touched layers.

Do not hallucinate paths or use placeholders like `TODO` or `NotImplementedException`. All generated code must be complete and adhere to the architectural rules of the respective stack.
