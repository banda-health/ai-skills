# Contributing to Banda Health AI Skills

## Adding a New Skill

### 1. Choose the Right Folder

- **`implementers/skills/`**: For clinic implementers (non-developers)
- **`dev/skills/`**: For the development team
- **`shared/skills/`**: For skills both audiences use

### 2. Create the Skill

Copy `templates/SKILL.template.md` to start:

```bash
mkdir -p implementers/skills/my-skill-name
cp templates/SKILL.template.md implementers/skills/my-skill-name/SKILL.md
```

### 3. Follow the Rules

**Folder name must match frontmatter `name`:**
- Folder: `implementers/skills/issue-creation-youtrack/`
- Frontmatter: `name: issue-creation-youtrack`

**Required YAML frontmatter:**
```yaml
---
name: skill-name-here
description: One sentence explaining when to use this skill.
---
```

**Keep it short and focused.** One skill, one job.

## ⚠️ PUBLIC REPOSITORY RULE

**Never commit:**

- **Patient data or PHI** (Protected Health Information)
- **Clinic or customer names** (even in examples)
- **Credentials, tokens, or API keys**
- **Server hostnames or IP addresses**
- **Internal-only implementation details**

Mark sensitive details with `TODO: [Internal team to fill]` and keep skills generic.

Sensitive skills belong in a **private repository**.

## Pull Requests

- One skill per PR (or related group)
- Test the skill locally before submitting
- CI validates frontmatter and checks for common sensitive patterns

## Questions?

Contact the Banda Health development team through internal channels.
