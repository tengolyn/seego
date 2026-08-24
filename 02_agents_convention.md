## Writing rule

Every file in this project — docs, code comments, commit messages — must be brief and
contain only necessary information, while still preserving all context needed to understand
it. No filler, no restating the obvious, no redundant sections across files. If a fact
already lives in another file, reference it, don't repeat it.

## Changelog format

`CHANGELOG.md` is one table, one row per change: `| Date | Milestone | Change |`. Update it
as part of every change — don't defer to a later commit.

## Commit style

`<type>: <short description>`, then a blank line and bullet points for details. Types:
`feat`, `fix`, `chore`, `docs`, `refactor`, `test`. No AI-attribution trailers
(e.g. `Co-Authored-By`, session links).

## Code standards

- **Modular:** small, single-purpose functions/modules over large ones; no god files.
- **Docstrings on every function:** generic — describes what the function does and its
  contract, not the change/commit that introduced it. Include args, return value, and a
  notes section only when something non-obvious needs flagging (edge case, invariant,
  side effect). Keep it brief; still cover the full contract.
- **File-level docstring:** one brief high-level summary per file, at the top, stating its
  purpose. Same brevity rule as above.

## Working principle

Efficiency over everything. Before executing a nontrivial task, write a concrete plan and
validate it — don't explore live via trial-and-error execution.

## File & Folder Naming Conventions

1. **Snake Case:** All files and folders must use `snake_case` (lowercase with underscores).
2. **Sequential Numbering:** Documents that follow a logical flow or priority should be prefixed with a 2-digit number (e.g., `01_strategy_plan.md`, `02_execution.md`).
3. **Descriptive Names:** File names should be immediately descriptive of their content without needing to open them. No generic names (except `README.md`).

## Using `.agents_memory`

Top-down flow, not a durability split: `passive_memory/` (the plan) →
`active_memory.md` (today's slice of it) → `scratchpad.md` (task
planning/checklist executing that slice). Nothing is promoted bottom-up
except a revision to the plan itself.

- **`passive_memory/{draft,current,archived}/`:** the highly-defined plan,
  one file per phase/milestone with rationale, partitioned by lifecycle
  stage. Propose new phases into `draft/`; a phase moves to `current/`
  once committed to, and to `archived/` once re-scoped or abandoned.
  Files move (`git mv`), not edited-in-place across a stage change —
  content is only edited while still in `draft/`.
- **`active_memory.md`:** a single file — only one slice is ever in focus
  at a time. It opens with a markdown link back to its source section in
  `passive_memory/current/` and a status line (`in focus`, `done` right
  before overwrite), so it doubles as the tracker between plan and
  execution without a separate status file. Overwrite it when a phase
  starts, update while working it, flip status to `done` right before the
  next phase replaces it (`git log` on the file is the history) — if the
  work changed the plan, update `passive_memory/` instead of leaving a
  stale copy here.
- **`scratchpad.md`:** the agent's own space for task
  planning/checklists while executing the slice in `active_memory.md` — a
  clean stated goal, the checklist, intermediate notes. Not read as a
  source of truth by other agents/sessions; never link to it as the
  authority for a decision. Cleared freely between tasks.
- **Check before writing:** read `passive_memory/current/` before adding a
  new plan section, and `active_memory.md` before overwriting it with a
  new slice — don't lose in-progress state.
- Full layer definitions and lifecycle: see
  [01_seed_agentic_env.md §4](01_seed_agentic_env.md#4-agents_memory--plan-decomposition-not-durability).

## Agent Behavior & Communication Rules

- **Low Cognitive Load (Hard Rule):** All generations (chat, files, docs) must minimize cognitive load. Use bullet points, tables, and short pointers. strictly avoid long paragraphs. Maximize information density with few words.
- **Brief but Complete:** Keep responses exceptionally concise while retaining full context.
- **Efficiency First:** Prioritize efficiency above all else.
- **Constructive Pushback:** Challenge inefficient or impractical ideas.
- **Proactive Guidance:** Provide unprompted suggestions/guidance when beneficial.
