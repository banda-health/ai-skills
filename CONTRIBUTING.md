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

## How Skills Reach People

This repo is a Claude Code plugin marketplace. There is no separate publishing
step: Claude Code clones this repo on the user's machine and reads the skills
out of it. A merged pull request is a release.

Two files do the wiring:

- `.claude-plugin/marketplace.json` — the catalog. One entry per audience folder.
- `<audience>/.claude-plugin/plugin.json` — makes that folder a plugin.

An audience folder is already shaped like a plugin, because a plugin looks for
`skills/<name>/SKILL.md`. So `implementers/skills/demo-page/` needs no move.

### Why plugin.json has no `version`

Claude Code gives a user a new copy only when the plugin's version changes. With
no `version`, users track our commits, so a merged PR reaches them on their next
marketplace update. **Do not add a `version` field** unless you want to gate
releases by hand — a pinned version means pushed changes never arrive. Never set
`version` in both `plugin.json` and the marketplace entry; Claude Code uses the
`plugin.json` value and ignores the other.

A skill can still carry its own internal version. The `demo-page` skill stamps
`Assets version:` into each page it builds. That is separate from the plugin.

### Publishing the dev/ or shared/ folder

Those folders hold no skills yet, so no entry lists them. When you add the first
one:

1. Create `<audience>/.claude-plugin/plugin.json` with a `name`, a
   `displayName`, and a `description`. Copy `implementers/` as a model.
2. Add an entry to `.claude-plugin/marketplace.json` whose `name` matches the
   `name` in that `plugin.json`, with `"source": "./<audience>"`.
3. Validate both files:

```bash
claude plugin validate ./<audience>
claude plugin validate .
```

CI fails if a folder holds skills that no entry publishes. That check exists
because an unpublished skill reaches nobody, and nothing else would say so.

### Cutting a release for claude.ai users

Claude Code users need no release — they track commits. People who work in
claude.ai upload a `.zip` by hand, so they need one. After a change merges:

```bash
scripts/package-skill.sh implementers/skills/demo-page
```

Attach the file from `dist/` to a GitHub release. `dist/` is git-ignored, so
never commit the archive. For a skill that stamps its own version, the archive
name carries it (`demo-page-v3.zip`), which keeps the release name and the
skill's own output in step.

### What the plugin name does to a skill's name

A plugin skill runs with the plugin name as a prefix:
`/banda-implementers:demo-page`. A skill someone copies into `~/.claude/skills/`
by hand has no prefix. Both work; only the typed name differs.

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
- CI validates skill frontmatter, validates the marketplace manifests, and
  checks for common sensitive patterns

## Questions?

Contact the Banda Health development team through internal channels.
