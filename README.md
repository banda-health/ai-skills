# Banda Health AI Skills

AI agent skills for Banda Health workflows. Organized into three folders for different audiences.

## What's Inside

- **`implementers/`**: Skills for clinic implementers (non-developers)
- **`dev/`**: Skills for the development team
- **`shared/`**: Skills used by both audiences

## Getting the Skills

### Download Without a GitHub Account

1. Visit https://github.com/banda-health/ai-skills
2. Click "Code" → "Download ZIP"
3. Extract the ZIP
4. Copy the skills you need

Or download a single folder using a tool like DownGit.

### Using the Skills

Copy skill folders into your AI tool's skills directory:

- **Cursor**: `.cursor/skills/` (project) or `~/.cursor/skills/` (user)
- **Claude Desktop/Code**: `.claude/skills/` (project) or `~/.claude/skills/` (user)
- **Other tools**: Check your tool's documentation for skills directories

Once installed, skills appear as slash commands (e.g., `/issue-creation-youtrack`).

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
