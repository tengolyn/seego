# Seed Env — Setup Procedure

Applies the layout from [01_seed_agentic_env.md](01_seed_agentic_env.md) and the
conventions in [02_agents_convention.md](02_agents_convention.md) to a repo.

## Steps

1. **Scaffold dirs**
   ```
   mkdir -p .agents/skills .agents/agents \
     .agents_memory/passive_memory/{draft,current,archived}
   touch .agents_memory/active_memory.md .agents_memory/scratchpad.md
   ```

2. **Write `AGENTS.md`** (repo root) — thin router only:
   - link to `.agents_memory/passive_memory/` (the master plan)
   - link to `.agents_memory/active_memory.md` (slice in focus)
   - link to `.agents_memory/scratchpad.md` (task planning/checklist)
   - link to `.agents/skills/` and `.agents/agents/`
   - short project context / other key docs

3. **Seed `.agents_memory/passive_memory/current/`** — write the
   highly-defined plan here, one file per phase/milestone, with rationale
   (writing/commit/code/naming rules from `02_agents_convention.md`, prior
   `agents.md`, or equivalent fold in as plan context). This is the one
   durable artifact everything else derives from. Leave `draft/` and
   `archived/` empty until a phase is proposed or re-scoped.

4. **Init empty execution state**
   - `.agents_memory/active_memory.md` — empty until a phase/milestone is
     pulled from the plan into focus; once written, it links back to its
     `passive_memory/current/` section with status inline
   - `.agents_memory/scratchpad.md` — empty until a task against
     the active slice starts

5. **Leave `.agents/skills/` and `.agents/agents/` empty** until a real
   skill or sub-agent is needed — don't pre-populate placeholders.

6. **Retire duplicates** — delete any pre-existing tool-specific
   convention files (e.g. old `agents.md`) once their content is folded
   into `passive_memory/current/`, so there's one source of truth.

## Rule of thumb

`passive_memory/` is the plan. `active_memory.md` is the one slice being
worked right now — it links back to its plan section and carries status
inline, so it doubles as the tracker without a separate status file.
`scratchpad.md` is the agent's own space for task planning and
checklists while executing that slice. Work flows top-down; nothing is
promoted back up except a revision to the plan itself.
