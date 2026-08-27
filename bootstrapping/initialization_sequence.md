# Initialization Sequence

This document defines the bootstrapping process for the agentic environment.

## Logic and Safety Rules

1. **Safety First**: Before scaffolding, agents must verify the environment to avoid destructive overwrites. If `.agents/` or `.agents_memory/` already exist and contain data, the agent should not blindly run `mkdir` and `touch` without ensuring it doesn't overwrite current memory states.
2. **Meta-Skill Seeding**: To make the environment self-expanding, initialization includes injecting core meta-skills (`create_skill`, `create_agent`) from `meta_skills_templates.md`.
3. **Empty File Fallback**: If a meta-skill template in `meta_skills_templates.md` is empty during the seed phase, it is skipped safely. This prevents the creation of empty, useless `.agents/skills/<name>/SKILL.md` files.

By standardizing this logic in `AGENTS_INIT.md`, we ensure the repository can self-replicate without human intervention.
