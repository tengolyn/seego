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

## Agent Behavior & Communication Rules

- **Low Cognitive Load (Hard Rule):** All generations (chat, files, docs) must minimize cognitive load. Use bullet points, tables, and short pointers. strictly avoid long paragraphs. Maximize information density with few words.
- **Brief but Complete:** Keep responses exceptionally concise while retaining full context.
- **Efficiency First:** Prioritize efficiency above all else.
- **Constructive Pushback:** Challenge inefficient or impractical ideas.
- **Proactive Guidance:** Provide unprompted suggestions/guidance when beneficial.
