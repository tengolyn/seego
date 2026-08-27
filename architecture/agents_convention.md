# Agent Conventions

Rules for writing, structuring, and maintaining this agentic environment. The
layout itself is defined in [seed_agentic_env.md](seed_agentic_env.md).

## Contents

- [Writing and execution](#writing-and-execution)
  - [Writing rule](#writing-rule)
  - [Changelog format](#changelog-format)
  - [Commit style](#commit-style)
  - [Code standards](#code-standards)
  - [Working principle](#working-principle)
- [Naming](#naming)
- [Agent memory](#agent-memory)
  - [`passive_memory/`](#passive_memory)
  - [`active_memory.md`](#active_memorymd)
  - [`scratchpad.md`](#scratchpadmd)
  - [Check before writing](#check-before-writing)
- [Creating skills and agents](#creating-skills-and-agents)
- [Tool-specific adapters and hooks](#tool-specific-adapters-and-hooks)
  - [Tool-agnostic vs. tool-specific](#tool-agnostic-vs-tool-specific-claude-et-al)
  - [Hooks](#hooks)
- [Agent behavior and communication](#agent-behavior-and-communication)

## Writing and execution

### Writing rule

Every file in this project — docs, code comments, commit messages — must be brief and
contain only necessary information, while still preserving all context needed to understand
it. No filler, no restating the obvious, no redundant sections across files. If a fact
already lives in another file, reference it, don't repeat it.

### Changelog format

`CHANGELOG.md` is one table, one row per change: `| Date | Milestone | Change |`. Update it
as part of every change — don't defer to a later commit.

### Commit style

`<type>: <short description>`, then a blank line and bullet points for details. Types:
`feat`, `fix`, `chore`, `docs`, `refactor`, `test`. No AI-attribution trailers
(e.g. `Co-Authored-By`, session links).

### Code standards

- **Modular:** small, single-purpose functions/modules over large ones; no god files.
- **Docstrings on every function:** generic — describes what the function does and its
  contract, not the change/commit that introduced it. Include args, return value, and a
  notes section only when something non-obvious needs flagging (edge case, invariant,
  side effect). Keep it brief; still cover the full contract.
- **File-level docstring:** one brief high-level summary per file, at the top, stating its
  purpose. Same brevity rule as above.

### Working principle

Efficiency over everything. Before executing a nontrivial task, write a concrete plan and
validate it — don't explore live via trial-and-error execution.

## Naming

1. **Snake Case:** All files and folders must use `snake_case` (lowercase with underscores).
2. **Descriptive Names:** File names should be immediately descriptive of their content without needing to open them. No generic names (except `README.md`).

## Agent memory

Layout and top-down flow defined in
[seed_agentic_env.md §4](seed_agentic_env.md#4-agents_memory--plan-decomposition-not-durability).
Write rules per layer below.

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
  file, not a folder: only one slice is ever in focus at a time, so
  there's nothing to partition.
- **Structure**: opens with a link back to its source section in
  `passive_memory/` and a status line, then the slice content, e.g.:
  ```markdown
  # Phase 2: <name>
  Plan: [passive_memory/current/02_<name>.md](passive_memory/current/02_<name>.md) — status: in focus
  ```
  It doubles as the tracker between plan and execution this way — status
  lives next to the content it's tracking, not in a separate file that
  can drift out of sync.
- **Lifecycle**: overwritten (pulled from `passive_memory/`, with the
  link and `in focus` status) when a new phase starts; status flips to
  `done` right before the next phase overwrites it — `git log` on the
  file is the history if it's needed. If the work changed the plan,
  update `passive_memory/` too.
- **Written by**: the active agent, when starting, updating, or finishing
  the current slice.

### `scratchpad.md`
- **What goes here**: the agent's own working-around space for the task
  at hand — task planning, a checklist derived from `active_memory.md`,
  a clean stated goal, intermediate findings, half-finished notes.
- **Lifecycle**: cleared or overwritten freely per task; never expected
  to survive past the slice it was built for.
- **Written by**: the active agent, continuously during execution. Not
  read as a source of truth by other agents/sessions; never link to it
  as the authority for a decision.

### Check before writing
Read `passive_memory/current/` before adding a new plan section, and
`active_memory.md` before overwriting it with a new slice — don't lose
in-progress state.

## Creating skills and agents

Neutral source lives under `.agents/skills/<name>/SKILL.md` and
`.agents/agents/<name>/AGENT.md` — layout defined in
[seed_agentic_env.md §3](seed_agentic_env.md#3-agents--skills-vs-agents-at-a-glance).
Rules when authoring one:

- **Use Meta-Skills:** Always use the `create_skill` and `create_agent` meta-skills to scaffold new capabilities (if they exist in `.agents/skills/`) to ensure perfect compliance with these conventions.
- **Skill vs. agent — decide first.** One narrow procedure → skill. Needs
  its own trust/tool boundary, disposable context, parallelism, or a
  role-specialized pass (write/review/verify) → agent. Don't build an
  agent for sequential steps that don't need isolation.
- **Skills stay single-purpose.** If it needs `if X do A, if Y do B`
  branching, split it into separate skills instead of widening one.
- **Agents compose skills**, invoked in sequence when a task needs more
  than one procedure; that composition belongs at the agent level, never
  folded into one sprawling skill.
- **Write the neutral file first**, in tool-agnostic prose + the minimal
  shared metadata (name, description, tools, model for agents). Never
  author a tool's native format (e.g. `.claude/skills/`,
  `.claude/agents/`) as the source of truth — it's a generated/derived
  adapter.
- **Push heavy material to `reference/`.** Schemas, long examples, API
  docs go in the skill/agent's `reference/` folder, pulled in on demand —
  keep the eagerly-loaded body short.
- **Naming:** `snake_case` folder/file names per the naming convention
  above; the folder name is the skill/agent name.

## Tool-specific adapters and hooks

### Tool-agnostic vs. tool-specific (`.claude` et al.)

- **Neutral content** (what the skill/agent does, when to use it, its
  procedure) lives only in `.agents/`. Never duplicate this prose into a
  tool-specific file.
- **Tool-specific adapters** (`.claude/skills/`, `.claude/agents/`,
  Copilot instructions, etc.) are thin, generated or hand-derived wrappers
  that add only what that tool's format requires (YAML frontmatter, a
  tool's own field names like Claude's `tools: *` wildcard) and then
  point to or inline the neutral body. Regenerate them from `.agents/`
  when the neutral source changes — don't hand-edit drift into them.
- **Tool quirks stay local to the adapter.** A wildcard, a tool-call
  syntax, a model-selection field specific to one runtime never leaks
  into `.agents/` prose.

### Hooks

Event models genuinely differ across tools (some have real lifecycle
hooks, others largely don't), so hooks resist full unification. Practical
split:
- **Hard/enforceable invariants** (secret scanning, destructive-command
  blocks) → push into git hooks/CI, which bind regardless of agent tool.
- **Editor/agent-level conveniences** → generate each tool's native hook
  config from one neutral event manifest (`{event, condition, script}`).
- **Tools with no hook concept** → fall back to advisory prose in that
  tool's instruction file, accepting it's weaker (advisory, not
  enforced) — be honest about where a target tool is weaker rather than
  pretending equivalence.

## Agent behavior and communication

- **Low Cognitive Load (Hard Rule):** All generations (chat, files, docs) must minimize cognitive load. Use bullet points, tables, and short pointers. strictly avoid long paragraphs. Maximize information density with few words.
- **Brief but Complete:** Keep responses exceptionally concise while retaining full context.
- **Efficiency First:** Prioritize efficiency above all else.
- **Constructive Pushback:** Challenge inefficient or impractical ideas.
- **Proactive Guidance:** Provide unprompted suggestions/guidance when beneficial.
