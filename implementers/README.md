# Banda Implementers Skills

AI skills for Banda Health clinic implementers. These skills help you gather requirements, map workflows, write specifications, and create clear issues, no development experience required.

## Installation

### In Cursor

```bash
/add-plugin https://github.com/banda-health/ai-skills implementers
```

### Manual Installation

Copy the `skills/` folder to:
- `~/.cursor/skills/` (all projects)
- `.cursor/skills/` (one project)
- `.claude/skills/` (Claude Desktop/Code)

## Available Skills

### Design Skills

- **`/design-workflow-mapping`**: Map a clinic's workflow to BandaHealth Go screens and processes. Helps you understand how clinic staff work today and which parts of BandaHealth Go match each step.

- **`/design-requirement-gathering`**: Gather requirements from clinic staff systematically. Provides a structured interview approach to understand needs, constraints, and success criteria.

- **`/design-specification`**: Write a clear design or configuration specification. Produces a document that developers can implement without back-and-forth questions.

### Issue Skills

- **`/issue-creation-youtrack`**: Create a well-structured YouTrack issue. Ensures issues have clear context, acceptance criteria, and enough detail for developers to estimate and implement.

## Using Skills

Once installed, type the skill name (like `/design-workflow-mapping`) in your AI assistant and follow the prompts. Each skill provides step-by-step guidance tailored to its task.

## Skill Conventions

Skills use domain prefixes:
- `design-*`: Design and specification work
- `workflow-*`: Workflow analysis
- `issue-*`: Issue creation and tracking

## For Non-Developers

These skills are designed for implementers without technical backgrounds. They:
- Use plain language
- Explain acronyms
- Focus on outcomes
- Provide concrete examples

## Support

Questions? Contact the Banda Health development team through internal channels.

## Contributing

See the repository root [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines.

## License

MIT License - see [LICENSE](../LICENSE)
