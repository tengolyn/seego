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
- **`.agents_memory/`** holds *the plan and where execution stands against
  it* — the master plan, the slice currently in focus, and the checklist
  executing that slice.

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

## 4. `.agents_memory/` — plan decomposition, not durability

Partitioned by *plan granularity*, top-down: one master plan, one active
slice of it, one execution checklist for that slice. Not partitioned by how
long a fact stays true — each layer is a zoom level on the same plan.

### `passive_memory/`
- **What goes here**: the highly-defined plan itself — the full breakdown
  of the project/initiative into phases or milestones, with rationale.
  This is the one durable artifact; everything else derives from it.
- **Structure**: a folder, partitioned by lifecycle stage:
  ```
  passive_memory/
  ├── draft/     # proposed phases/milestones — not yet committed to
  ├── current/   # active, authoritative
  └── archived/  # superseded or abandoned — kept for history
  ```
  One file per phase/milestone within each stage, split further as the
  plan grows.
- **Lifecycle**: long-lived; a phase moves `draft/` → `current/` when
  committed to, and `current/` → `archived/` when re-scoped or abandoned.
  Files move unedited (`git mv`) — a stage change is a location change,
  not a content edit. Content is only edited while still in `draft/`.
- **Written by**: any agent, but sparingly, and only to revise the plan
  itself, not to log work against it.

### `active_memory.md`
- **What goes here**: the *specific slice* of the plan currently being
  executed — one phase/milestone pulled out of `passive_memory/` into
  focus right now, plus any decisions made while executing it. A single
  file, not a folder: only one slice is ever in focus at a time, so there's
  nothing to partition.
- **Structure**: opens with a link back to its source section in
  `passive_memory/` and a status line, then the slice content, e.g.:
  ```markdown
  # Phase 2: <name>
  Plan: [passive_memory/current/02_<name>.md](passive_memory/current/02_<name>.md) — status: in focus
  ```
  It doubles as the tracker between plan and execution this way — status
  lives next to the content it's tracking, not in a separate file that can
  drift out of sync.
- **Lifecycle**: overwritten (pulled from `passive_memory/`, with the link
  and `in focus` status) when a new phase starts; status flips to `done`
  right before the next phase overwrites it — `git log` on the file is the
  history if it's needed. If the work changed the plan, update
  `passive_memory/` too.
- **Written by**: the active agent, when starting, updating, or finishing
  the current slice.

### `scratchpad.md`
- **What goes here**: the agent's own working-around space for the task at
  hand — task planning, a checklist derived from `active_memory.md`, a
  clean stated goal, intermediate findings, half-finished notes.
- **Lifecycle**: cleared or overwritten freely per task; never expected to
  survive past the slice it was built for.
- **Written by**: the active agent, continuously during execution.

**Flow**: `passive_memory/` (the plan) → `active_memory.md` (the current
slice, linked back to its plan section with status inline) →
`scratchpad.md` (task planning/checklist executing that slice).
Work moves top-down; nothing is promoted bottom-up except plan revisions.
