# Agent Initialization Protocol

Follow these strict steps to initialize the Seego environment in this repository.

## Steps

1. **Scaffold dirs**
   Run the initialization script from the root of the repository to deterministically scaffold the agent directories and memory files:
   ```bash
   bash bootstrapping/init.sh
   ```

2. **Write `AGENTS.md`** (repo root)
   The initialization script above automatically copies the template from `bootstrapping/AGENTS_template.md` to the repository root. Verify that this file exists and populate it with any missing project context.

3. **Seed `.agents_memory/passive_memory/current/`** — write the
   highly-defined plan here, one file per phase/milestone, with rationale
   (writing/commit/code/naming rules from `architecture/agents_convention.md`, prior
   `agents.md`, or equivalent fold in as plan context). This is the one
   durable artifact everything else derives from. Leave `draft/` and
   `archived/` empty until a phase is proposed or re-scoped.

4. **Init empty execution state**
   - `.agents_memory/active_memory.md` — empty until a phase/milestone is
     pulled from the plan into focus; once written, it links back to its
     `passive_memory/current/` section with status inline
   - `.agents_memory/scratchpad.md` — empty until a task against
     the active slice starts

5. **Leave `.agents/agents/` empty** until a real agent is needed.

6. **Retire duplicates** — delete any pre-existing tool-specific
   convention files (e.g. old `agents.md`) once their content is folded
   into `passive_memory/current/`, so there's one source of truth.

7. **Seed Meta-Skills**: Read `meta_skills_templates.md`. If the `create_skill` or `create_agent` templates have content, create them in `.agents/skills/create_skill/SKILL.md` and `.agents/skills/create_agent/SKILL.md` respectively. If a template is empty or missing, silently ignore it.
