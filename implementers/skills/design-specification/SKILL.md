---
name: design-specification
description: Write a clear design or configuration specification that developers can implement without back-and-forth. Use when requirements are gathered and you need a detailed implementation plan.
---

# Design: Specification Writing

Write a clear design or configuration specification that developers can implement without clarification questions.

## When to Use

Use this skill when:
- Requirements have been gathered and need to be written up
- A feature or customization needs developer implementation
- Configuration changes need to be documented
- You want developers to estimate work accurately

## Prerequisites

- Requirements gathered from stakeholders
- Understanding of the workflow or feature area
- List of success criteria and constraints

## Instructions

### Step 1: Write the Overview

Start with context:

**Feature name**: Short, descriptive name

**Purpose**: One paragraph explaining why this feature exists and what problem it solves.

**Users**: Who will use this feature? List roles.

**Success criteria**: How will we know this works? 2-3 measurable outcomes.

### Step 2: Document Functional Requirements

For each requirement, describe what the system must do:

**Use case format:**
```
When [trigger or condition],
The system should [action or behavior],
So that [outcome or value].
```

**Example:**
```
When a nurse opens a visit for a returning patient,
The system should display the patient's most recent vitals,
So that the nurse can compare to previous visits.
```

Be specific:
- Use exact field names and labels
- Specify required vs. optional fields
- Name the windows, tabs, or screens involved
- Describe validation rules (e.g., "Weight must be a positive number")

### Step 3: Describe User Interface

If this involves screens or forms:

**Window or screen name**: What is this called?

**Layout**: Describe or sketch the arrangement of fields, buttons, and sections.

**Fields**: For each field, specify:
- Label (what the user sees)
- Data type (text, number, date, dropdown, checkbox)
- Required or optional
- Default value (if any)
- Valid values or ranges
- Help text or tooltip (if needed)

**Buttons or actions**: What can the user do? What happens when each button is clicked?

**Example:**
```
Visit Vitals Tab

Fields:
- Weight (kg): Number, required, range 1-300, default blank
- Blood Pressure: Text, required, format "120/80", validation pattern
- Temperature (°C): Number, required, range 30-45, default blank
- Pulse (bpm): Number, required, range 30-200, default blank
- Recorded By: Auto-filled with current user, read-only
- Recorded At: Auto-filled with current timestamp, read-only

Buttons:
- Save: Stores vitals, shows success message
- Cancel: Discards changes, returns to visit summary
```

### Step 4: Define Business Rules

List the logic and rules the system must enforce:

**Validation rules:**
- "Blood pressure must be in format NNN/NNN"
- "Visit must have at least one diagnosis before it can be closed"

**Access rules:**
- "Only nurses and doctors can enter vitals"
- "Patients cannot view their own raw lab results"

**Workflow rules:**
- "A visit cannot be reopened after 24 hours"
- "Inventory cannot go negative"

**Calculations:**
- "Total invoice amount = sum of line items + tax"

### Step 5: Specify Data and Integration

If this involves data:

**Data model**: What data is stored?
- Table or entity name
- Key fields and their types
- Relationships to other data (e.g., "Visit vitals link to a Visit record")

**Existing data**: How does this interact with current data?
- "Pulls patient name from Patient table"
- "Writes to Visit table, new Vitals subtable"

**External systems**: Does this integrate with anything outside BandaHealth Go?
- APIs to call
- Data to import or export
- Timing or triggers

### Step 6: Document Edge Cases and Exceptions

List unusual situations and how the system should handle them:

**Edge cases:**
- "What if patient refuses vitals? Allow blank with a reason code."
- "What if two nurses enter vitals at the same time? Last save wins."

**Error handling:**
- "If vitals device fails, allow manual entry."
- "If connection is lost, save locally and sync later."

### Step 7: Add Examples and Mockups

Provide concrete examples:
- Sample data values
- Before/after screenshots (if applicable)
- Example reports or outputs

If you have mockups or sketches, include them or describe them clearly.

### Step 8: List Out-of-Scope Items

Be clear about what this spec does NOT include:
- Features deferred to a later phase
- Related but separate work
- Assumptions or dependencies

## Output Format

Structure the specification document:

```
# [Feature Name] Specification

## 1. Overview
- Purpose
- Users
- Success criteria

## 2. Functional Requirements
- Use cases (numbered list)

## 3. User Interface
- Windows/screens
- Fields and actions
- Layout description or mockup

## 4. Business Rules
- Validation rules
- Access rules
- Workflow rules
- Calculations

## 5. Data and Integration
- Data model
- Existing data usage
- External systems

## 6. Edge Cases and Exceptions
- Unusual scenarios
- Error handling

## 7. Examples
- Sample data
- Screenshots or mockups

## 8. Out of Scope
- What is NOT included

## 9. Open Questions
- Unresolved decisions
- Items needing stakeholder input
```

## Example Specification

**Feature**: Record Patient Vitals During Check-In

**1. Overview**

**Purpose**: Enable nurses to record patient vitals (weight, blood pressure, temperature, pulse) during check-in so doctors have current health data before consultations.

**Users**: Nurses (data entry), Doctors (read-only view)

**Success criteria**:
- Nurses can record vitals in under 1 minute
- Doctors can view most recent vitals on the visit screen without scrolling
- Zero data entry errors or lost vitals records

**2. Functional Requirements**

1. When a nurse opens a visit, the system should display a Vitals tab where vitals can be entered.
2. When a nurse saves vitals, the system should validate the data and store it linked to the visit.
3. When a doctor views a visit, the system should display the most recent vitals at the top of the summary.

**3. User Interface**

Visit Window → Vitals Tab

Fields:
- Weight (kg): Number, required, 1-300
- Blood Pressure: Text, required, format "NNN/NNN"
- Temperature (°C): Number, required, 30-45
- Pulse (bpm): Number, required, 30-200

Buttons:
- Save: Validate and store vitals
- Cancel: Discard changes

**4. Business Rules**

- Only nurses can enter vitals
- Doctors have read-only access
- Blood pressure must match format NNN/NNN (e.g., 120/80)
- All vitals fields are required unless patient refuses

**5. Data and Integration**

New table: Visit_Vitals
- Fields: Visit_ID (foreign key), Weight, BP, Temp, Pulse, Recorded_By, Recorded_At
- Relationship: Many vitals records per visit (historical tracking)

**6. Edge Cases**

- If patient refuses vitals, allow saving with a "Refused" checkbox
- If invalid BP format entered, show error message: "Please enter as NNN/NNN"

**7. Examples**

Sample vitals entry:
- Weight: 68 kg
- BP: 120/80
- Temperature: 36.7°C
- Pulse: 72 bpm

**8. Out of Scope**

- Automatic import from vitals devices (future phase)
- Trend charts or historical vitals reports (future phase)
- Alerts for abnormal values (may be added later)

**9. Open Questions**

- Should we allow editing vitals after the visit is closed?
- Do we need to track which device or cuff was used?

## Tips

- Write for developers who don't know the clinic context
- Be specific, not vague (avoid "user-friendly" or "intuitive")
- Include examples for every complex rule or format
- Mark TODOs clearly for decisions not yet made
- Review with one stakeholder before sending to developers

## Related Skills

- `/design-requirement-gathering`: Gather the requirements first
- `/design-workflow-mapping`: Understand the workflow context
- `/issue-creation-youtrack`: Create the implementation issue from this spec

## References

- TODO: Link to BandaHealth specification template (internal)
