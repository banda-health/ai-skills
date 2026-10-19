# Banda Health AI Skills

AI agent skills for Banda Health's hospital and clinic software workflows. These skills help teams design, implement, and maintain BandaHealth Go (built on iDempiere ERP) and integrate with OpenMRS and FHIR systems.

## What's Inside

This repository contains three skill collections:

### 1. Implementers (`implementers/`)

Skills for Banda implementers working with clinics. Useful for gathering requirements, mapping workflows, writing specifications, and creating clear issues. No development experience required.

**Key skills include:**
- Clinic workflow mapping
- Requirement gathering
- Design specification writing
- Issue creation guidelines

### 2. Development (`dev/`)

Skills for the Banda development team. Design patterns, architecture decisions, iDempiere conventions, and integration planning.

**Key skills include:**
- iDempiere architecture patterns
- Multi-tenancy considerations
- API and FHIR integration design
- Data modeling guidelines

### 3. Shared (`shared/`)

Common skills used by both implementers and developers. Terminology, templates, and shared conventions.

**Key skills include:**
- Banda Health glossary
- Design document templates
- Terminology reference

## Installation

### For Cursor Users (with GitHub accounts)

Install any plugin collection directly in Cursor:

```bash
# Implementers plugin
/add-plugin https://github.com/banda-health/ai-skills implementers

# Dev plugin
/add-plugin https://github.com/banda-health/ai-skills dev

# Shared plugin
/add-plugin https://github.com/banda-health/ai-skills shared
```

Or add to your Cursor settings in `.cursor/settings.json`:

```json
{
  "plugins": [
    {
      "name": "banda-implementers",
      "source": "https://github.com/banda-health/ai-skills",
      "path": "implementers"
    }
  ]
}
```

### For Implementers (without GitHub accounts)

Download the skills you need as a ZIP file:

1. Go to https://github.com/banda-health/ai-skills
2. Click the green "Code" button
3. Select "Download ZIP"
4. Extract the ZIP file
5. Copy the `implementers/skills/` folder to one of these locations:
   - `~/.cursor/skills/` (for all your Cursor projects)
   - Your project's `.cursor/skills/` folder (for one project only)
   - Your project's `.claude/skills/` folder (for Claude Desktop/Code)

### For Other AI Tools (Claude Desktop, Claude Code, etc.)

Copy the skill folders to your tool's skills directory:

**Claude Desktop / Claude Code:**
```bash
# Copy implementers skills
cp -r implementers/skills/* ~/.claude/skills/

# Or copy dev skills
cp -r dev/skills/* ~/.claude/skills/

# Or copy shared skills
cp -r shared/skills/* ~/.claude/skills/
```

**Cursor (manual installation):**
```bash
# Copy to your project
cp -r implementers/skills/* .cursor/skills/

# Or copy to global skills
cp -r implementers/skills/* ~/.cursor/skills/
```

## Using the Skills

Once installed, skills appear as slash commands in your AI assistant:

```
/design-workflow-mapping
/design-specification
/idempiere-model-design
/terminology-banda
```

Each skill provides specialized guidance for its task. Type the slash command and follow the prompts.

## Skill Naming Convention

Skills use domain prefixes for easy discovery:

- `design-*`: Design and planning tasks
- `workflow-*`: Workflow analysis and mapping
- `idempiere-*`: iDempiere-specific patterns
- `integration-*`: API and system integration
- `terminology-*`: Glossary and reference

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on adding or improving skills.

## Security Notice

This is a **public repository**. Never commit:
- Patient data or PHI
- Clinic or customer names
- Credentials, tokens, or API keys
- Server hostnames or IP addresses
- Internal-only implementation details

Sensitive skills belong in a separate private repository.

## License

MIT License - see [LICENSE](LICENSE) for details.

## Support

For questions or issues with these skills, contact the Banda Health development team through internal channels.
