# Contributing to Banda Health AI Skills

Thank you for contributing! This guide explains how to add or improve skills in this repository.

## ⚠️ PUBLIC REPOSITORY RULE

**This repository is public.** Never include:

- **Patient data or PHI** (Protected Health Information)
- **Clinic or customer names** (even in examples)
- **Credentials, tokens, or API keys**
- **Server hostnames or IP addresses**
- **Internal-only implementation details**
- **Proprietary business logic or algorithms**

Sensitive skills that reference specific clinics, internal systems, or proprietary details belong in a separate **private repository**.

When in doubt, mark sensitive details with `TODO: [Internal team to fill]` and keep the skill generic.

## Adding a New Skill

### 1. Choose the Right Plugin

- **`implementers/`**: Skills for non-developers doing clinic work, requirements, workflow design
- **`dev/`**: Skills for developers doing architecture, coding, iDempiere design
- **`shared/`**: Skills both audiences use (glossary, templates, common conventions)

### 2. Pick a Domain Prefix

Group related skills with consistent prefixes:

- `design-*`: Design and specification work
- `workflow-*`: Workflow analysis and mapping
- `idempiere-*`: iDempiere architecture and conventions
- `integration-*`: API and FHIR integration
- `terminology-*`: Glossary and reference
- `issue-*`: Issue creation and tracking

Examples:
- `design-specification` (write a design spec)
- `workflow-mapping` (map clinic workflow to BandaHealth Go)
- `idempiere-model-design` (design iDempiere models)

### 3. Create the Skill Folder and File

Create `skills/<skill-name>/SKILL.md` in the appropriate plugin folder:

```bash
# Example: adding a new design skill to implementers
mkdir -p implementers/skills/design-requirement-gathering
touch implementers/skills/design-requirement-gathering/SKILL.md
```

### 4. Use the Template

Copy `templates/SKILL.template.md` as your starting point. Every skill needs:

**Required YAML frontmatter:**
```yaml
---
name: skill-name-here
description: One sentence explaining when to use this skill.
---
```

**Required sections:**
- Purpose statement
- When to use this skill
- Step-by-step guidance
- Examples (when helpful)
- Output format or deliverables

### 5. Write for Your Audience

**For implementers skills:**
- Use plain language, no jargon
- Explain acronyms on first use
- Provide concrete examples
- Focus on outcomes, not technical details

**For dev skills:**
- Assume iDempiere and software design knowledge
- Link to relevant iDempiere documentation
- Include code patterns when relevant
- Cover edge cases and trade-offs

**For shared skills:**
- Be accessible to both audiences
- Define terms used by both groups
- Focus on cross-functional understanding

### 6. Keep Skills Focused

One skill, one job. Break complex workflows into multiple focused skills rather than creating one giant skill.

Good:
- `design-specification` (write a spec)
- `workflow-mapping` (map workflow)
- `issue-creation` (create an issue)

Bad:
- `design-everything` (spec + workflow + issue in one)

### 7. Test the Skill

Before submitting:

1. Install it locally in Cursor or your AI tool
2. Try the skill on a realistic task
3. Verify the guidance is clear and actionable
4. Check that outputs match expectations
5. Confirm no sensitive data leaked into examples

### 8. Update the Plugin README

Add your new skill to the plugin's README.md skill list with a one-line description.

## Improving Existing Skills

Follow the same rules:
- Keep the focus narrow
- Maintain the existing naming convention
- Test your changes
- No sensitive data

## File Structure

```
banda-health/ai-skills/
├── LICENSE
├── README.md
├── CONTRIBUTING.md
├── .cursor-plugin/
│   └── marketplace.json
├── templates/
│   └── SKILL.template.md
├── implementers/
│   ├── .cursor-plugin/
│   │   └── plugin.json
│   ├── README.md
│   └── skills/
│       ├── design-specification/
│       │   └── SKILL.md
│       └── workflow-mapping/
│           └── SKILL.md
├── dev/
│   ├── .cursor-plugin/
│   │   └── plugin.json
│   ├── README.md
│   └── skills/
│       ├── idempiere-model-design/
│       │   └── SKILL.md
│       └── integration-api-design/
│           └── SKILL.md
└── shared/
    ├── .cursor-plugin/
    │   └── plugin.json
    ├── README.md
    └── skills/
        └── terminology-banda/
            └── SKILL.md
```

## Naming Conventions

### Skill Names

- Use lowercase
- Use hyphens (kebab-case)
- Start with domain prefix
- Be descriptive but concise
- Folder name must match skill `name` in frontmatter

Examples:
- `design-specification`
- `workflow-clinic-mapping`
- `idempiere-callout-design`
- `integration-fhir-mapping`

### Folder Structure

- One folder per skill: `skills/<skill-name>/`
- One SKILL.md file per folder: `skills/<skill-name>/SKILL.md`
- Supporting files can go in the same folder

## Pull Request Guidelines

1. One skill per PR (or related group of skills)
2. Fill out the PR template
3. Describe the skill's purpose and audience
4. List any TODOs for internal team
5. Confirm no sensitive data included

## CI Validation

The repository runs a CI check that validates:
- Every `SKILL.md` has `name` and `description` frontmatter
- Frontmatter `name` matches the folder name
- No common sensitive patterns (API keys, IP addresses)

Fix any CI failures before merging.

## Questions?

Ask the Banda Health development team through internal channels.
