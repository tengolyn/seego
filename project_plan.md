# Project Plan: Seego MCP (ON HOLD)

## Overview
**Seego** defines a tool-agnostic layout for agent configuration. While the on-disk storage format will remain strictly **Markdown-based** for ultimate portability and LLM readability, the *management* and scaffolding of this environment will be packaged as an **MCP (Model Context Protocol) Server**.

This hybrid approach ensures that the environment is deeply readable by any AI, while eliminating the hallucination risks associated with asking LLMs to run complex scaffolding bash scripts from prompts.

## Phase 1: Solidify the Markdown Foundation (Current)
We will maintain the core layout defined in the repository:
- **`.agents/skills/`**: Narrow, single-purpose procedures.
- **`.agents/agents/`**: Role-specialized orchestration agents.
- **`.agents_memory/`**: Top-down execution state (`passive_memory/` -> `active_memory.md` -> `scratchpad.md`).
- **`AGENTS.md`**: The standard router entry point.

## Phase 2: The MCP Server (Next Steps)
We will build and package an MCP server that exposes deterministic tools to the LLM. Instead of reading an `AGENTS_INIT.md` file and guessing bash commands, the AI will simply call these exposed MCP tools.

### Proposed MCP Tools
1. **`seego_init`**
   - **Purpose**: Safely scaffolds the `.agents/` and `.agents_memory/` directories.
   - **Logic**: Performs pre-flight checks (ensuring it doesn't destructively overwrite existing `.agents` folders) and touches necessary base files.

2. **`seego_create_skill`**
   - **Arguments**: `skill_name`, `description`
   - **Purpose**: Enforces strict conventions when adding a skill.
   - **Logic**: Converts the name to `snake_case`, creates `.agents/skills/<skill_name>/SKILL.md`, and writes the standard boilerplate. Can also scaffold a `reference/` directory.

3. **`seego_create_agent`**
   - **Arguments**: `agent_name`, `role_description`, `required_skills`
   - **Purpose**: Scaffolds a new agent role.
   - **Logic**: Creates `.agents/agents/<agent_name>/AGENT.md` and wires up references to the required skills.

## Architectural Benefits
1. **Zero Hallucination Scaffolding:** An LLM calling `seego_create_skill` will always generate the exact folder structure required, rather than accidentally misnaming directories.
2. **Universal Compatibility:** Since MCP is an open standard, Claude Desktop, Cursor, and other modern agentic IDEs can natively consume these tools.
3. **Pure Markdown Output:** Because the MCP server simply outputs standard markdown files, the resulting repository remains completely readable to older or non-MCP tools. It retains its "prompt agnostic" identity.
