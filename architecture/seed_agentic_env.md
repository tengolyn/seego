# Seed Agentic Env

A tool-agnostic layout for agent configuration, so the same project works
sensibly whether it's opened by Claude Code, Copilot, or another agentic tool.

Conventions for *how* to populate and write to this layout live in
[agents_convention.md](agents_convention.md). This file defines only
the layout itself.

## 0. Overview

Any agentic tool that opens this repo should be able to (1) find its
bearings, (2) find reusable procedures and specialized agents, and
(3) find/leave durable state — without the project hand-maintaining a
separate setup per tool. Three pieces carry that:

- **`AGENTS.md`** is the router — where every agent starts.
- **`.agents/`** holds *how to do things* — narrow skills and the
  agents that compose them.
- **`.agents_memory/`** holds *the plan and where execution stands against
  it* — the master plan, the slice currently in focus, and the checklist
  executing that slice.

Principle: maintain **one neutral source of truth** for all three, and let
each tool's native format (Claude's YAML frontmatter, Copilot's
instructions file, etc.) be generated or manually derived from it — don't
hand-maintain N divergent copies. Keep tool-specific quirks (e.g. Claude's
`tools: *` wildcard) out of the shared prose; they belong only in the
per-tool adapter/output. Rules for maintaining this split live in
[agents_convention.md](agents_convention.md).

## 1. Repo structure

```
AGENTS.md                     # thin router — entry point for any agent
.agents/
├── skills/
│   └── <skill-name>/
│       ├── SKILL.md          # short, narrow procedure (prose + minimal metadata)
│       └── reference/        # optional, loaded on demand — schemas, long examples, docs
└── agents/
    └── <agent-name>/
        ├── AGENT.md          # role-specialized agent spec (name, description, tools, model)
        └── reference/        # optional, loaded on demand — schemas, long examples, docs
.agents_memory/
├── scratchpad.md      # task planning/checklist for the active slice
├── active_memory.md   # the one plan slice currently in focus
└── passive_memory/    # the highly-defined master plan
```

Per-tool native formats (Claude Code frontmatter, Copilot instructions,
etc.) are generated or derived from these neutral files — they aren't
hand-maintained copies living elsewhere in the tree.

## 2. Lookup order

1. **`AGENTS.md`** — every agent starts here, regardless of tool, to learn
   project context, conventions, and where else to look. Stays a thin
   router — links and short context, not a dumping ground.
2. **`.agents/`** — once oriented, the agent looks here for skills and
   agent definitions. Authoring rules:
   [agents_convention.md](agents_convention.md#creating-skills-and-agents).
3. **`.agents_memory/`** — for state that outlives a single task. Write
   rules: [agents_convention.md](agents_convention.md#agent-memory).

## 3. `.agents/` — skills vs. agents, at a glance

*Note: A fully initialized environment may come pre-seeded with bootstrapping meta-skills (like `create_skill` and `create_agent`) inside `.agents/skills/` to help agents self-expand the environment.*

Terminology: *an agent* is the actor doing the work (whatever tool is
running); *an agent spec* is a definition in `.agents/agents/`. Where
ambiguous, the docs say "agent spec".

- **Skills** (`.agents/skills/`): narrow, single-purpose procedures — one
  well-defined procedure each.
- **Agents** (`.agents/agents/`): the orchestration layer — role-specialized
  specs that compose skills.
- Both get their own folder with an optional `reference/` subfolder for
  heavy material (schemas, long examples, docs) pulled in on demand —
  keeps the eagerly-loaded body short.

Authoring rules:
[agents_convention.md](agents_convention.md#creating-skills-and-agents).
Hook handling and the tool-agnostic/tool-specific split:
[agents_convention.md](agents_convention.md#tool-specific-adapters-and-hooks).

## 4. `.agents_memory/` — plan decomposition, not durability

Partitioned by *plan granularity*, top-down: one master plan
(`passive_memory/`), one active slice of it (`active_memory.md`), one
execution checklist for that slice (`scratchpad.md`). Not partitioned by
how long a fact stays true — each layer is a zoom level on the same plan.

**Flow**: `passive_memory/` (the plan) → `active_memory.md` (the current
slice, linked back to its plan section with status inline) →
`scratchpad.md` (task planning/checklist executing that slice).
Work moves top-down; nothing is promoted bottom-up except plan revisions.

Full layer definitions, structure, lifecycle, and write rules:
[agents_convention.md](agents_convention.md#agent-memory).
