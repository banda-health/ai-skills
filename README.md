# Banda Health AI Skills

AI agent skills for Banda Health workflows. Every skill lives in `skills/`.

## What's Inside

- **`skills/demo-page/`**: Build demo pages that match the Banda web UI
- **`skills/issue-creation-youtrack/`**: Write YouTrack issues in the house format

## Getting the Skills

### Claude Code — install from this repo (recommended)

This repo is a Claude Code plugin marketplace, and the repo root is the plugin.
One install gives you every skill:

```bash
claude plugin marketplace add banda-health/ai-skills
claude plugin install banda-skills@banda-health
```

Claude triggers a skill on its own when your request matches it. You can also
run one by name. Plugin skills carry the plugin name as a prefix, so the
demo-page skill is `/banda-skills:demo-page`.

**Updates are not automatic.** Run this to get the newest skills:

```bash
claude plugin marketplace update banda-health
```

To receive them without asking, run `/plugin` in a session, open
**Marketplaces**, select **banda-health**, and choose **Enable auto-update**.

### claude.ai — upload one skill

claude.ai takes a single skill as a `.zip`.

1. Download the skill's `.zip` from
   [Releases](https://github.com/banda-health/ai-skills/releases)
2. In claude.ai, open **Settings → Capabilities → Skills**
3. Upload the file

Re-upload when a new release appears. This path has no auto-update.

If the skill you need has no release yet, ask the maintainers to cut one. They
build it with `scripts/package-skill.sh`.

### Cursor and other tools — copy the folder

1. Visit https://github.com/banda-health/ai-skills
2. Click "Code" → "Download ZIP", then extract it
3. Copy the folders you need out of `skills/` into your tool's skills directory:
   - **Cursor**: `.cursor/skills/` (project) or `~/.cursor/skills/` (user)
   - **Claude Desktop/Code**: `.claude/skills/` (project) or `~/.claude/skills/` (user)
   - **Other tools**: check your tool's documentation

Skills installed this way appear as plain slash commands, without the plugin
prefix (e.g. `/issue-creation-youtrack`). Nothing tells you when they go stale,
so prefer the marketplace if you use Claude Code.

## PUBLIC REPOSITORY RULE

**Never commit:**
- Patient data or PHI
- Clinic or customer names
- Credentials, tokens, or API keys
- Server hostnames or IP addresses
- Internal-only implementation details

Sensitive skills belong in a private repository.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

MIT License - see [LICENSE](LICENSE).
