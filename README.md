# Seego

A tool-agnostic layout for agent configuration. This repository provides a blueprint for structuring AI agent memory, skills, and behavior in a standard, predictable way.

## Why Seego?
Currently, switching between different agentic IDEs or CLIs (Claude Code, Copilot, Cursor) means losing custom rules or memory context. Seego solves this by standardizing how agents interact with a codebase, removing the need to maintain duplicate system prompts and configurations for each specific tool.

- **Unified Memory Management**: Top-down hierarchy (`passive_memory/` -> `active_memory.md` -> `scratchpad.md`) prevents context window flooding.
- **Standardized Capabilities**: Clear separation between "Skills" (narrow procedures) and "Agents" (orchestration).
- **Prompt Agnostic**: Uses neutral markdown files so that any tool can read and write state.

## Initialization

**To initialize a new project:** Prompt your AI coding assistant to read and execute `bootstrapping/AGENTS_INIT.md`.

## Conventions & Rules
- [seed_agentic_env.md](architecture/seed_agentic_env.md): Explains the layout.
- [agents_convention.md](architecture/agents_convention.md): Explains the rules for writing, structuring, and maintaining the environment.
- [initialization_sequence.md](bootstrapping/initialization_sequence.md): Details the bootstrapping logic.
- [meta_skills_templates.md](bootstrapping/meta_skills_templates.md): Contains the templates for self-expanding skills.
