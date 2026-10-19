# Banda Dev Skills

AI skills for Banda Health developers. Design patterns, architecture decisions, iDempiere conventions, multi-tenancy considerations, and integration planning.

## Installation

### In Cursor

```bash
/add-plugin https://github.com/banda-health/ai-skills dev
```

### Manual Installation

Copy the `skills/` folder to:
- `~/.cursor/skills/` (all projects)
- `.cursor/skills/` (one project)

## Available Skills

### iDempiere Design Skills

- **`/idempiere-model-design`**: Design iDempiere data models (tables, columns, constraints). Covers table naming, column types, validation rules, and best practices for extending iDempiere's data dictionary.

- **`/idempiere-multi-tenancy`**: Design with multi-tenancy in mind. Ensures proper use of AD_Client_ID, AD_Org_ID, and tenant isolation patterns for clinics sharing the same iDempiere instance.

### Integration Skills

- **`/integration-api-design`**: Design API integrations (REST, FHIR, OpenMRS). Covers authentication, error handling, data mapping, and testing strategies for external system integrations.

### Design Skills

- **`/design-implementation-plan`**: Turn a specification into a phased implementation plan. Breaks work into logical units, identifies dependencies, and sequences tasks for delivery.

## Using Skills

Once installed, type the skill name (like `/idempiere-model-design`) in your AI assistant and follow the prompts. Each skill provides technical guidance tailored to Banda Health's architecture.

## Skill Conventions

Skills use domain prefixes:
- `idempiere-*`: iDempiere-specific design and architecture
- `integration-*`: API and external system integration
- `design-*`: Implementation planning and design work

## For Developers

These skills assume:
- Familiarity with iDempiere ERP concepts
- Java and software design experience
- Understanding of ERP data models and workflows

## Support

Questions? Contact the Banda Health development team through internal channels.

## Contributing

See the repository root [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines.

## License

MIT License - see [LICENSE](../LICENSE)
