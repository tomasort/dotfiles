---
name: skill-authoring
description: >
  Create or update reusable agent skills for GitHub Copilot CLI and OpenCode. Use this when asked
  to make a new SKILL.md, port an existing skill, or improve a skill's instructions or layout.
license: MIT
---

# Skill Authoring

You create and update reusable agent skills.

## Default behavior

- Prefer a shared `.agents/skills/<skill-name>/SKILL.md` location when the user wants one skill to
  work in both GitHub Copilot CLI and OpenCode.
- Use a project-local `.agents/skills/` path when the skill should only apply to the current repo.
- Use a global `~/.agents/skills/` path when the skill should be available across projects.
- Only use tool-specific locations such as `~/.copilot/skills/` or `.github/skills/` if the user
  explicitly wants a Copilot-only skill or already has an established layout to preserve.

## Naming rules

- The directory name and frontmatter `name` must match exactly.
- Use lowercase letters, numbers, and single hyphens only.
- Valid pattern: `^[a-z0-9]+(-[a-z0-9]+)*$`
- Keep names between 1 and 64 characters.

## Frontmatter rules

Every `SKILL.md` must start with YAML frontmatter.

Required:

- `name`
- `description`

Optional and portable:

- `license`
- `compatibility`
- `metadata`

Compatibility notes:

- OpenCode recognizes `name`, `description`, `license`, `compatibility`, and `metadata`.
- GitHub Copilot CLI also supports skill frontmatter and may tolerate extra fields.
- When targeting both tools, prefer the shared subset above unless there is a clear need for a
  tool-specific field.
- Be conservative with any field that pre-approves tool usage. Only add it when the user wants
  that behavior and the referenced scripts are trusted.

## What a good skill should contain

Write clear, compact instructions that help a smaller model succeed without guessing:

1. What the skill does.
2. When to use it.
3. Required constraints and safety rules.
4. Exact workflow steps.
5. Concrete examples or templates.
6. Any file paths, scripts, or resources the skill depends on.

## Workflow

When asked to create or update a skill:

1. Determine whether it should be **shared**, **project-local**, or **tool-specific**.
2. If the name or scope is ambiguous, ask the user before writing files.
3. Inspect nearby existing skills and reuse their style when appropriate.
4. Create the directory named after the skill.
5. Create or update `SKILL.md`.
6. If the skill needs scripts or examples, place them in the same skill directory and reference
   them by exact filename in `SKILL.md`.
7. Verify that:
   - the file is named exactly `SKILL.md`
   - the frontmatter `name` matches the directory
   - the description is specific enough for the agent to choose correctly
   - the instructions explain how to execute the task, not just what the task is
8. Tell the user where the skill was written and whether they may need to reload skills or restart
   their session to pick it up.

## Shared-skill template

Use this template when creating a new shared skill:

```md
---
name: example-skill
description: >
  One-sentence description of what the skill does and when the agent should use it.
license: MIT
---

# Example Skill

## What I do

- Describe the main tasks this skill handles.

## When to use me

- Describe the prompts or situations that should trigger this skill.

## Rules

- List important requirements, limitations, and safety constraints.

## Workflow

1. Step one.
2. Step two.
3. Step three.

## Examples

- Provide a concrete example when useful.
```

## Porting an existing skill

When converting an existing Copilot or OpenCode skill into a shared skill:

1. Reuse the existing instructions unless they are tool-specific.
2. Move or copy the skill into `.agents/skills/<skill-name>/SKILL.md`.
3. Remove or minimize tool-specific frontmatter unless it is intentionally required.
4. Keep any referenced helper files beside `SKILL.md`.
5. Verify the shared copy still contains the important operational details.

## Output expectations

When you finish, clearly state:

- the skill name
- the path you created or updated
- whether it is shared across Copilot CLI and OpenCode or limited to one tool
