# Contributing to Banda Health AI Skills

## Adding a New Skill

### 1. Create the Skill

Every skill lives in `skills/<name>/`. Copy `templates/SKILL.template.md` to
start:

```bash
mkdir -p skills/my-skill-name
cp templates/SKILL.template.md skills/my-skill-name/SKILL.md
```

### 2. Follow the Rules

**Folder name must match frontmatter `name`:**
- Folder: `skills/issue-creation-youtrack/`
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

Two files do the wiring, both in `.claude-plugin/`:

- `marketplace.json` — the catalog. One entry, `banda-skills`, with
  `"source": "./"`.
- `plugin.json` — makes the repo root itself the plugin.

The root is already shaped like a plugin, because a plugin looks for
`skills/<name>/SKILL.md`. So a new skill needs no manifest change at all.

### Why plugin.json has no `version`

Claude Code gives a user a new copy only when the plugin's version changes. With
no `version`, users track our commits, so a merged PR reaches them on their next
marketplace update. **Do not add a `version` field** unless you want to gate
releases by hand — a pinned version means pushed changes never arrive. Never set
`version` in both `plugin.json` and the marketplace entry; Claude Code uses the
`plugin.json` value and ignores the other.

A skill can still carry its own internal version. The `demo-page` skill stamps
`Assets version:` into each page it builds. That is separate from the plugin.

### One plugin means everyone gets every skill

There is one plugin, so an install hands the user all of `skills/`. That is the
point: implementers and developers get the same copy, and nobody has to pick an
audience. The cost is that a skill cannot be given to one audience only.

If you ever need that, add a second plugin in a subfolder:

1. Move its skills to `<plugin>/skills/<name>/`.
2. Add `<plugin>/.claude-plugin/plugin.json` with a `name`, a `displayName`,
   and a `description`.
3. Add an entry to `.claude-plugin/marketplace.json` whose `name` matches that
   `name`, with `"source": "./<plugin>"`.
4. Validate: `claude plugin validate .`

Renaming or removing the existing `banda-skills` plugin breaks every install, so
it needs a `renames` map in `marketplace.json`. Read
[Rename or remove a plugin](https://code.claude.com/docs/en/plugins/host-marketplace#rename-or-remove-a-plugin)
first.

CI fails if a `SKILL.md` sits outside every published plugin. That check exists
because an unpublished skill reaches nobody, and nothing else would say so.

### Cutting a release for claude.ai users

Claude Code users need no release — they track commits. People who work in
claude.ai upload a `.zip` by hand, so they need one. After a change merges:

```bash
scripts/package-skill.sh skills/demo-page
```

Attach the file from `dist/` to a GitHub release. `dist/` is git-ignored, so
never commit the archive. For a skill that stamps its own version, the archive
name carries it (`demo-page-v4.zip`), which keeps the release name and the
skill's own output in step.

### What the plugin name does to a skill's name

A plugin skill runs with the plugin name as a prefix:
`/banda-skills:demo-page`. A skill someone copies into `~/.claude/skills/` by
hand has no prefix. Both work; only the typed name differs.

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
