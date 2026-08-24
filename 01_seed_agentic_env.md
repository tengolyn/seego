# Seed Agentic Env

A tool-agnostic layout for agent configuration, so the same project works
sensibly whether it's opened by Claude Code, Copilot, or another agentic tool.

## 0. Overview

Any agentic tool that opens this repo should be able to (1) find its
bearings, (2) find reusable procedures and specialized agents, and
(3) find/leave durable state — without the project hand-maintaining a
separate setup per tool. Three pieces carry that:

- **`AGENTS.md`** is the router — where every agent starts.
- **`.agents/`** holds *how to do things* — narrow skills and the
  sub-agents that compose them.
- **`.agents_memory/`** holds *what's currently true* — state layered by
  how long it stays true.

Principle: maintain **one neutral source of truth** for all three, and let
each tool's native format (Claude's YAML frontmatter, Copilot's
instructions file, etc.) be generated or manually derived from it — don't
hand-maintain N divergent copies. Keep tool-specific quirks (e.g. Claude's
`tools: *` wildcard) out of the shared prose; they belong only in the
per-tool adapter/output.

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
        ├── AGENT.md          # role-specialized sub-agent spec (name, description, tools, model)
        └── reference/        # optional, loaded on demand — schemas, long examples, docs
.agents_memory/
├── agents_scratchpad.md      # ephemeral, in-progress state
├── active_memory.md          # current, fast-changing project state
└── passive_memory.md         # durable, slow-changing knowledge
```

Per-tool native formats (Claude Code frontmatter, Copilot instructions,
etc.) are generated or derived from these neutral files — they aren't
hand-maintained copies living elsewhere in the tree.

## 2. Lookup order

1. **`AGENTS.md`** — every agent starts here, regardless of tool, to learn
   project context, conventions, and where else to look. Stays a thin
   router — links and short context, not a dumping ground.
2. **`.agents/`** — once oriented, the agent looks here for skills and
   sub-agent definitions (structure in §3).
3. **`.agents_memory/`** — for state that outlives a single task (structure
   in §4).

## 3. `.agents/` — skills vs. sub-agents

### Skills: narrow, single-purpose procedures

One well-defined procedure per skill — not a broad catch-all with internal
branching. If a skill starts needing "if X do A, if Y do B" logic to cover
more ground, that's the signal to split it into multiple narrow skills
instead of widening one.

Each skill folder may carry an optional `reference/` subfolder for material
too heavy to keep inline — schemas, long examples, API docs, lookup tables.
The skill body stays short and loads eagerly; `reference/` is pulled in
only on demand when the task actually needs that depth. This keeps skills
narrow without forcing a choice between omitting detail and bloating every
invocation.

Skills are described in neutral prose so any tool's skill-invocation
mechanism (Claude Code's `skills/`, or another tool's equivalent) can wrap
them.

### Sub-agents: the orchestration layer

Sub-agents compose skills; they aren't just bigger skills. Reach for a
sub-agent when the task needs:
- a different trust/tool boundary,
- disposable context (e.g. a search pass whose raw output shouldn't
  pollute the caller's context),
- parallelism across independent subtasks, or
- a role-specialized pass (write vs. review vs. verify).

Don't spawn a sub-agent for small, sequential, context-dependent steps —
that's pure re-derivation overhead with no isolation benefit. A sub-agent
(or the top-level agent) invokes several narrow skills in sequence when a
task needs more than one procedure; that composition belongs at the agent
level, never folded into one sprawling skill.

Agent definitions shouldn't be duplicated per tool: author a neutral spec
(prose instructions + a small metadata schema — name, description, tools,
model) and generate each tool's native format via a thin per-tool adapter.

Like skills, each agent gets its own folder with an optional `reference/`
subfolder for the same reason — keep the agent spec itself short and
eagerly loadable, and push heavy material (domain docs, examples, schemas
the agent needs mid-task) into `reference/`, pulled in only on demand.

### Hooks

Event models genuinely differ across tools (some have real lifecycle
hooks, others largely don't), so hooks resist full unification. Practical
split:
- **Hard/enforceable invariants** (secret scanning, destructive-command
  blocks) → push into git hooks/CI, which bind regardless of agent tool.
- **Editor/agent-level conveniences** → generate each tool's native hook
  config from one neutral event manifest (`{event, condition, script}`).
- **Tools with no hook concept** → fall back to advisory prose in that
  tool's instruction file, accepting it's weaker (advisory, not enforced).

Core principle: be honest about where a target tool is weaker rather than
pretending equivalence.

## 4. `.agents_memory/` — three-layer split

Partitioned by how long information should live and who/what writes to it:

### `agents_scratchpad.md`
- **What goes here**: ephemeral, in-progress state — current task
  breakdown, intermediate findings, half-finished notes, anything only
  useful for the task actively running.
- **Lifecycle**: cleared or overwritten freely between tasks; not expected
  to survive a session boundary.
- **Written by**: the active agent, continuously during a task.

### `active_memory.md`
- **What goes here**: current project state that changes often but matters
  right now — open work items, in-flight decisions, who's doing what,
  known bugs being tracked, current constraints/deadlines.
- **Lifecycle**: reviewed/updated at the start or end of a session; entries
  get promoted to passive memory once resolved, or dropped once stale.
- **Written by**: the active agent, at natural checkpoints (task completion,
  session end) — not on every tool call.

### `passive_memory.md`
- **What goes here**: durable, slow-changing knowledge — user
  preferences/feedback ("don't do X", "always do Y"), architectural
  decisions and their rationale, stable reference pointers (where bugs are
  tracked, which dashboard matters). Not derivable by re-reading the code.
- **Lifecycle**: long-lived; updated rarely, only on explicit correction/
  confirmation or a settled architectural decision.
- **Written by**: any agent, but sparingly — this is the layer future
  sessions rely on to avoid re-litigating settled questions.

**Split rule of thumb**: if it will be wrong an hour from now, it's
scratchpad. If it will be wrong next week, it's active. If it's still true
next quarter, it's passive.
