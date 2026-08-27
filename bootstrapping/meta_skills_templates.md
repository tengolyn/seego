# Meta-Skills Templates

These templates provide the blueprints for the environment's bootstrapping meta-skills.

## create_skill

```markdown
# Skill: create_skill

**Description:** Scaffolds a new skill directory and SKILL.md file adhering strictly to agent conventions.

## Procedure
1. Ask the user for the narrow purpose of the skill.
2. Check if the logic branches too much (if yes, suggest splitting into multiple skills).
3. Generate the directory `.agents/skills/<skill_name>/` using `snake_case`.
4. Create `.agents/skills/<skill_name>/SKILL.md` populated with brief, dense instructions on how to execute the skill.
5. Scaffold a `reference/` directory alongside `SKILL.md` for any long code examples or schemas.
```

## create_agent

```markdown
# Skill: create_agent

**Description:** Scaffolds a new agent directory and AGENT.md file.

## Procedure
1. Define the agent's role (e.g., "Reviewer", "Planner").
2. Identify which existing skills from `.agents/skills/` this agent will need to compose to achieve its role.
3. Generate the directory `.agents/agents/<agent_name>/` using `snake_case`.
4. Create `.agents/agents/<agent_name>/AGENT.md`.
5. Link the necessary skills inside `AGENT.md` and define the operational boundaries and instructions for the agent.
```
