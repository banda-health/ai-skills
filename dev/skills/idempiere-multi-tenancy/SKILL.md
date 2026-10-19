---
name: idempiere-multi-tenancy
description: Design with multi-tenancy and data isolation in mind. Use when multiple clinics share one iDempiere instance and data must be isolated by tenant (AD_Client_ID) and organization (AD_Org_ID).
---

# iDempiere: Multi-Tenancy Design

Design features with proper tenant isolation so multiple clinics can safely share one iDempiere instance without seeing each other's data.

## When to Use

Use this skill when:
- Designing data models that must respect tenant boundaries
- Building features for a multi-tenant deployment
- Reviewing code or designs for tenant isolation issues
- Planning role-based access across organizations

## Prerequisites

- Understanding of iDempiere's data model
- Familiarity with `AD_Client_ID` and `AD_Org_ID` concepts
- Knowledge of the feature or module you're designing

## Key Concepts

### AD_Client_ID (Tenant)

The `AD_Client_ID` column identifies which clinic (tenant) owns a piece of data. In a multi-tenant deployment:
- Each clinic has a unique `AD_Client_ID`
- Users can only access data with their own `AD_Client_ID`
- System data (shared reference tables) uses `AD_Client_ID = 0`

### AD_Org_ID (Organization)

The `AD_Org_ID` column identifies sub-organizations within a tenant:
- A clinic might have multiple departments, branches, or cost centers
- Roles can be restricted to specific organizations
- Organization hierarchies allow parent orgs to see child org data

### System-Level Data

Reference data shared across all tenants:
- Countries, currencies, units of measure
- `AD_Client_ID = 0` and `AD_Org_ID = 0`
- Users from any tenant can read, but not modify

## Instructions

### Step 1: Classify Your Data

For each entity in your design, decide:

**Tenant-owned data** (most common):
- Each record belongs to one clinic
- Users can only see data from their clinic
- Examples: Patients, visits, inventory, invoices
- Use the tenant's `AD_Client_ID` and a valid `AD_Org_ID`

**System-level reference data**:
- Shared lookup lists or configuration
- Examples: Countries, product categories (if shared), standard diagnosis codes
- Use `AD_Client_ID = 0` and `AD_Org_ID = 0`

**Tenant-specific reference data**:
- Custom lookup lists or configuration per clinic
- Examples: Clinic-specific service products, local diagnosis codes
- Use the tenant's `AD_Client_ID` and `AD_Org_ID = 0` (or the org that owns it)

### Step 2: Always Include AD_Client_ID and AD_Org_ID

Every table must have:

```
- AD_Client_ID (Table Direct → AD_Client, Mandatory, Default from context)
- AD_Org_ID (Table Direct → AD_Org, Mandatory, Default from context)
```

iDempiere automatically:
- Fills these from the user's session context on insert
- Filters queries so users only see data for their `AD_Client_ID`
- Enforces organization access based on role assignments

**Never omit these columns.** Even if you think "this table doesn't need multi-tenancy," include them. Future requirements may change.

### Step 3: Design for Tenant Isolation

Ensure data cannot leak across tenants:

**In queries:**
- iDempiere's `PO` (Persistent Object) layer automatically filters by `AD_Client_ID`
- Custom SQL queries must explicitly filter: `WHERE AD_Client_ID = ?`
- Never hardcode `AD_Client_ID` values in queries; use `Env.getAD_Client_ID(ctx)`

**In joins:**
- When joining tables, both sides must have matching `AD_Client_ID`
- Do not join tenant data to system data without careful validation

**In reports:**
- Reports inherit tenant context from the user session
- Do not allow reports to accept `AD_Client_ID` as a parameter; always use session context

### Step 4: Handle Organization Hierarchies

Organizations can have parent-child relationships:
- Parent org roles can see child org data
- Child org roles cannot see parent or sibling data
- Design features to respect this hierarchy

**Example:**
```
Clinic has two branches (organizations):
- AD_Org_ID = 100 (Main Clinic, parent)
- AD_Org_ID = 101 (Branch A, child of 100)
- AD_Org_ID = 102 (Branch B, child of 100)

A user with role "Main Clinic Manager" (org 100) can see data from all three orgs.
A user with role "Branch A Nurse" (org 101) can only see Branch A data (org 101).
```

**In your design:**
- Use `AD_Org_ID` when data should be restricted to a branch or department
- Use organization `= 0` for tenant-wide reference data (visible to all orgs in that tenant)

### Step 5: Security Rules

Define access rules:

**Row-level security** (default in iDempiere):
- Users can only access rows matching their `AD_Client_ID`
- Organization access depends on role assignment and hierarchy

**Role-based access:**
- Define which roles can Create, Read, Update, Delete each table
- Assign roles to organizations or the whole tenant
- Use iDempiere's Role → Window Access and Role → Table Access settings

**Field-level security:**
- Some fields may be read-only or hidden for certain roles
- Use Field Groups or custom logic to restrict access

### Step 6: Test Tenant Isolation

Verify that tenant isolation works:

**Test scenarios:**
1. Create data as User A (Tenant 1)
2. Log in as User B (Tenant 2)
3. Verify User B cannot see, edit, or delete User A's data
4. Verify reports and searches respect tenant boundaries
5. Verify organization hierarchy access (parent can see child, child cannot see sibling)

**Common isolation bugs:**
- Direct SQL queries that skip the `AD_Client_ID` filter
- Reports that query across tenants
- Hardcoded `AD_Client_ID` values
- Caching that leaks data across sessions

### Step 7: Design Cross-Tenant Features (Rare)

Most features must NOT cross tenant boundaries. However, rare cases exist:

**Legitimate cross-tenant features:**
- System-wide reporting for a hosting provider
- Shared product catalogs (if allowed by business rules)

**How to implement safely:**
- Use a dedicated system user with `AD_Client_ID = 0` (system tenant)
- Explicitly filter by `AD_Client_ID` list, never return all tenants
- Require strong authorization (superuser role only)
- Audit all cross-tenant access

**Never allow:**
- Clinic A users to see Clinic B patient data
- Clinic A users to modify Clinic B configuration
- Unintentional data leakage through shared reference tables

## Output Format

Document your multi-tenancy design:

```
## Multi-Tenancy Design

**Entities and Classification:**

1. Patient (Tenant-owned)
   - AD_Client_ID: Clinic tenant
   - AD_Org_ID: Registration organization
   - Visibility: Only users from the same clinic

2. Patient_Vitals (Tenant-owned)
   - AD_Client_ID: Inherits from Visit
   - AD_Org_ID: Inherits from Visit
   - Visibility: Only users from the same clinic and authorized orgs

3. Diagnosis_Code (Tenant-specific reference data)
   - AD_Client_ID: Clinic tenant (each clinic may have custom codes)
   - AD_Org_ID: 0 (visible to all orgs in this clinic)
   - Visibility: Clinic-specific lookup

**Isolation Rules:**

- All queries filter by AD_Client_ID (session context)
- No direct SQL queries without AD_Client_ID filter
- Reports do not cross tenant boundaries
- No hardcoded client or org IDs in code

**Organization Hierarchy:**

- Main Clinic (org 100, parent)
- Branch A (org 101, child of 100)
- Branch B (org 102, child of 100)

Users with Main Clinic role can see all branches.
Users with branch-specific roles see only their branch.

**Testing:**

- Create test data as Clinic A user
- Log in as Clinic B user
- Verify no data leakage in windows, processes, reports
```

## Tips

- Default to tenant-owned data unless there's a clear reason for system-level
- Always use session context for `AD_Client_ID`, never hardcode
- Test with multiple tenant users before deploying multi-tenant features
- Review all custom SQL queries for proper `AD_Client_ID` filtering
- Use iDempiere's `PO` layer (Persistent Objects) to leverage automatic tenant filtering

## Common Pitfalls

- **Forgetting AD_Client_ID in custom SQL**: Always filter by client
- **Hardcoding tenant IDs**: Use `Env.getAD_Client_ID(ctx)` instead
- **Joining tenant and system data incorrectly**: Validate joins carefully
- **Bypassing iDempiere's security layer**: Don't use raw JDBC without filtering
- **Caching data across sessions**: Cache must be tenant-aware

## Related Skills

- `/idempiere-model-design`: Design tables with proper multi-tenancy columns
- `/integration-api-design`: Ensure API integrations respect tenant boundaries

## References

- iDempiere Multi-Tenancy Documentation (TODO: internal link)
- iDempiere Security Model (TODO: internal link)
- Banda Health Tenant Setup Guide (TODO: internal link)
