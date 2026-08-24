# Seed Env — Setup Procedure

Applies the layout from [01_seed_agentic_env.md](01_seed_agentic_env.md) and the
conventions in [02_agents_convention.md](02_agents_convention.md) to a repo.

## Steps

1. **Scaffold dirs**
   ```
   mkdir -p .agents/skills .agents/agents .agents_memory
   ```

2. **Write `AGENTS.md`** (repo root) — thin router only:
   - link to `.agents_memory/passive_memory.md` (conventions)
   - link to `.agents_memory/active_memory.md` (current state)
   - link to `.agents_memory/agents_scratchpad.md` (in-progress task)
   - link to `.agents/skills/` and `.agents/agents/`
   - short project context / other key docs

3. **Seed `.agents_memory/passive_memory.md`** — move durable conventions
   here (writing/commit/code/naming rules from `02_agents_convention.md`, prior
   `agents.md`, or equivalent). This is what future agents read before
   writing any file.

4. **Init empty state files**
   - `.agents_memory/active_memory.md` — open work items (empty until any exist)
   - `.agents_memory/agents_scratchpad.md` — ephemeral task state (empty until a task is active)

5. **Leave `.agents/skills/` and `.agents/agents/` empty** until a real
   skill or sub-agent is needed — don't pre-populate placeholders.

6. **Retire duplicates** — delete any pre-existing tool-specific
   convention files (e.g. old `agents.md`) once their content is folded
   into `passive_memory.md`, so there's one source of truth.

## Rule of thumb

Ask how long the fact stays true before it goes stale:

- Stale within the hour (task-local) → scratchpad.
- Stale within days/weeks (project-current) → active memory.
- Still accurate next quarter (durable) → passive memory.
