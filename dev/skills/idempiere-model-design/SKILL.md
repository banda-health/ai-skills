---
name: idempiere-model-design
description: Design iDempiere data models (tables, columns, validation rules). Use when extending the data dictionary or creating custom entities for BandaHealth Go features.
---

# iDempiere: Model Design

Design iDempiere data models following best practices for table naming, column types, validation, and data dictionary extension.

## When to Use

Use this skill when:
- Designing new tables or columns for a custom feature
- Extending iDempiere's data model
- Reviewing data model changes in a specification
- Planning database schema for a new module

## Prerequisites

- Understanding of the feature or domain you're modeling
- Familiarity with iDempiere's Application Dictionary
- Knowledge of relational database design

## Instructions

### Step 1: Identify Entities

List the main entities (business objects) you need to model:

**For each entity, define:**
- **Name**: What is this entity called in the domain?
- **Purpose**: What does it represent?
- **Key attributes**: What data does it hold?
- **Relationships**: How does it relate to other entities?

**Example:**
```
Entity: Patient Vitals
Purpose: Records vital signs taken during a clinic visit
Key attributes: Weight, blood pressure, temperature, pulse, recorded timestamp
Relationships: Belongs to a Visit, recorded by a User
```

### Step 2: Follow iDempiere Table Naming Conventions

**Standard table naming:**
- Use uppercase with underscores: `BH_Patient_Vitals`
- Prefix custom tables with a namespace (e.g., `BH_` for Banda Health)
- Use singular nouns for the entity name
- Avoid abbreviations unless standard (e.g., `AD_` for Application Dictionary)

**Common prefixes:**
- `AD_`: Application Dictionary (core iDempiere tables, do not use for custom tables)
- `C_`: Core business documents (Order, Invoice, Payment)
- `M_`: Material Management (Product, Inventory)
- `BH_`: Banda Health custom tables (recommended prefix for all Banda extensions)

### Step 3: Design Columns

For each table, define columns with proper types and constraints:

**Required system columns** (iDempiere standard, include in every table):
- `<TableName>_ID`: Primary key (Table Direct type, mandatory)
- `AD_Client_ID`: Tenant ID (Table Direct, mandatory, default from context)
- `AD_Org_ID`: Organization ID (Table Direct, mandatory, default from context)
- `IsActive`: Active flag (Yes/No, default Y)
- `Created`: Creation timestamp (DateTime, auto-filled)
- `CreatedBy`: User who created (Table reference to AD_User, auto-filled)
- `Updated`: Last update timestamp (DateTime, auto-updated)
- `UpdatedBy`: User who updated (Table reference to AD_User, auto-updated)

**Business columns** (specific to your entity):
- Choose the right column type: String, Integer, Number, Amount, Date, DateTime, Yes/No, Table, List
- Set length for String columns (e.g., 60 for names, 255 for descriptions)
- Mark columns as Mandatory where applicable
- Define default values where appropriate
- Use Table Direct references for foreign keys to other entities

**Example:**
```
Table: BH_Patient_Vitals

Columns:
- BH_Patient_Vitals_ID (ID, mandatory, primary key)
- AD_Client_ID (Table Direct → AD_Client, mandatory)
- AD_Org_ID (Table Direct → AD_Org, mandatory)
- IsActive (Yes/No, default Y)
- Created, CreatedBy, Updated, UpdatedBy (standard audit fields)
- BH_Visit_ID (Table Direct → BH_Visit, mandatory)
- Weight_Kg (Number, mandatory)
- BloodPressure (String, length 20, mandatory)
- Temperature_C (Number, mandatory)
- Pulse_BPM (Integer, mandatory)
- Recorded_Date (DateTime, mandatory, default current timestamp)
```

### Step 4: Define Validation Rules

Specify validation rules for columns:

**Column-level validation:**
- Required fields (Mandatory flag)
- Value ranges (e.g., Weight > 0, Temperature between 30-45)
- Format patterns (e.g., Blood Pressure as "NNN/NNN")
- Reference validation (foreign keys must exist)

**Table-level validation:**
- Unique constraints (e.g., one vitals record per visit per timestamp)
- Business rules that span multiple columns

**Example validation rules:**
```
- Weight_Kg: Must be > 0 and < 500
- BloodPressure: Format "NNN/NNN" (e.g., "120/80")
- Temperature_C: Must be between 30.0 and 45.0
- Pulse_BPM: Must be between 30 and 250
- Unique constraint: (BH_Visit_ID, Recorded_Date) must be unique
```

### Step 5: Design Relationships

Map foreign key relationships to other tables:

**One-to-many relationships:**
- Use a foreign key column in the child table
- Example: `BH_Patient_Vitals` has `BH_Visit_ID` (many vitals per visit)

**Many-to-one relationships:**
- Same as one-to-many from the other direction
- Example: Many vitals records belong to one visit

**Many-to-many relationships:**
- Create a junction table with foreign keys to both sides
- Example: `BH_Patient_Condition` links patients to conditions

**Parent-child hierarchies:**
- Use `Parent_ID` column of the same table type
- Example: Organizations have parent organizations

### Step 6: Consider Multi-Tenancy

Ensure proper tenant isolation (see `/idempiere-multi-tenancy` skill):

**Every table must have:**
- `AD_Client_ID`: Ensures data belongs to one clinic/tenant
- `AD_Org_ID`: Sub-organization within the tenant

**Security rules:**
- Users can only access data for their `AD_Client_ID`
- Role-based access may further restrict by `AD_Org_ID`

**Shared reference data:**
- System-level lookup lists (e.g., countries, units of measure) have `AD_Client_ID = 0`
- Custom lookup lists should use the tenant's `AD_Client_ID`

### Step 7: Plan Indexes

Identify columns that need indexes for query performance:

**Automatically indexed:**
- Primary key (`<TableName>_ID`)
- `AD_Client_ID` and `AD_Org_ID` (iDempiere standards)

**Add indexes for:**
- Foreign keys (e.g., `BH_Visit_ID`)
- Frequently queried columns (e.g., `Recorded_Date`)
- Columns used in WHERE clauses or JOIN conditions

**Example:**
```
Indexes for BH_Patient_Vitals:
- Primary key: BH_Patient_Vitals_ID (auto)
- Foreign key: BH_Visit_ID
- Query index: (AD_Client_ID, Recorded_Date) for time-based queries
```

### Step 8: Document the Design

Write up the model design:

1. **Entity diagram**: Show tables and relationships
2. **Table definitions**: List each table with all columns, types, constraints
3. **Validation rules**: Document all constraints and business rules
4. **Indexes**: List indexes beyond the defaults
5. **Migration script**: Outline the SQL DDL or iDempiere migration steps

## Output Format

**Table Definition:**

```
Table: BH_Patient_Vitals
Purpose: Records patient vital signs during clinic visits

Columns:
- BH_Patient_Vitals_ID (ID, Primary Key)
- AD_Client_ID (Table → AD_Client, Mandatory)
- AD_Org_ID (Table → AD_Org, Mandatory)
- IsActive (Yes/No, Default Y)
- Created, CreatedBy, Updated, UpdatedBy (Audit)
- BH_Visit_ID (Table → BH_Visit, Mandatory, FK)
- Weight_Kg (Number, Mandatory, > 0)
- BloodPressure (String(20), Mandatory, format NNN/NNN)
- Temperature_C (Number, Mandatory, 30-45)
- Pulse_BPM (Integer, Mandatory, 30-250)
- Recorded_Date (DateTime, Mandatory, Default Now)

Relationships:
- Belongs to BH_Visit (many-to-one via BH_Visit_ID)
- Recorded by AD_User (many-to-one via CreatedBy)

Validation:
- Weight_Kg > 0 AND Weight_Kg < 500
- BloodPressure matches regex "\\d{2,3}/\\d{2,3}"
- Temperature_C BETWEEN 30 AND 45
- Pulse_BPM BETWEEN 30 AND 250
- Unique (BH_Visit_ID, Recorded_Date)

Indexes:
- BH_Patient_Vitals_ID (PK, auto)
- BH_Visit_ID (FK index)
- (AD_Client_ID, Recorded_Date) for date queries
```

## Tips

- Model the domain first, then map to tables (avoid designing directly in SQL)
- Keep table and column names readable, not abbreviated
- Always include the standard iDempiere system columns
- Design for multi-tenancy from the start (`AD_Client_ID`, `AD_Org_ID`)
- Use iDempiere reference types (Table, List) instead of raw integers for foreign keys
- Plan indexes for common queries early
- Review existing iDempiere core tables for naming and design patterns

## Common Pitfalls

- **Forgetting system columns**: Every table needs `AD_Client_ID`, `AD_Org_ID`, `IsActive`, and audit fields
- **Weak foreign keys**: Use Table Direct references, not plain integers
- **Missing validation**: Define constraints early, not in application code
- **Poor naming**: Avoid abbreviations, use clear descriptive names
- **Skipping multi-tenancy**: Tenant isolation must be baked into the schema

## Related Skills

- `/idempiere-multi-tenancy`: Ensure tenant isolation in your design
- `/design-specification`: Translate requirements into this model design

## References

- iDempiere Wiki: Application Dictionary (TODO: internal link)
- iDempiere Table and Column Naming Conventions (TODO: internal link)
- Banda Health Data Model Documentation (TODO: internal link)
