---
name: design-workflow-mapping
description: Map a clinic's current workflow to BandaHealth Go screens, processes, and features. Use when understanding how clinic operations translate to software functionality.
---

# Design: Workflow Mapping

Map a clinic's current workflow to BandaHealth Go screens and processes. Helps you understand how clinic staff work today and identify which parts of BandaHealth Go support each step.

## When to Use

Use this skill when:
- Starting implementation at a new clinic
- Documenting how a clinic currently operates
- Identifying which BandaHealth Go features match clinic needs
- Finding gaps between clinic workflow and software capabilities

## Prerequisites

- Access to clinic staff who can describe their workflow
- Basic understanding of BandaHealth Go features (windows, processes)
- Permission to observe or interview clinic operations

## Instructions

### Step 1: Identify the Workflow

Choose one clinical or operational workflow to map. Start with high-impact workflows:
- Patient registration and check-in
- Outpatient visit flow
- Pharmacy dispensing
- Lab test ordering and results
- Billing and payment collection
- Inventory receiving

Document the workflow scope:
- **Name**: What is this workflow called?
- **Trigger**: What starts this workflow?
- **End point**: When is this workflow complete?
- **Staff involved**: Which roles participate?

### Step 2: Document Current Steps

For each step in the clinic's current process:

1. **Step name**: Brief description (e.g., "Register new patient")
2. **Who**: Which staff role performs this step
3. **What**: What information is captured or action is taken
4. **Where**: Physical location or system used (paper form, spreadsheet, etc.)
5. **Why**: Purpose of this step

List all steps in sequence. Note any parallel branches or decision points.

### Step 3: Map to BandaHealth Go

For each workflow step, identify the corresponding BandaHealth Go functionality:

**BandaHealth Go Window**: Name the window where this data is entered or viewed (e.g., "Patient Window", "Sales Order Window", "Visit Window")

**Process**: If this is an action (not data entry), name the process (e.g., "Complete Visit", "Generate Invoice", "Post Inventory")

**Fields captured**: List which specific fields in the window correspond to the clinic's data points

**Gaps**: Note anything the clinic does that BandaHealth Go does not directly support

### Step 4: Document the Mapping

Create a table with these columns:

| Clinic Step | Staff Role | BandaHealth Go Window/Process | Fields/Actions | Gaps or Notes |
|-------------|-----------|-------------------------------|----------------|---------------|
| Register patient | Receptionist | Patient Window | Name, ID, phone, address | Need to capture village name |
| Collect payment | Cashier | Sales Order → Complete button | Payment method, amount received | No receipt printer configured |

### Step 5: Identify Configuration Needs

Based on the mapping, list what needs to be configured:
- Custom fields to add
- Workflows to enable or adjust
- Reports or documents to customize
- Training or process changes for clinic staff

## Output Format

Produce:

1. **Workflow diagram** (or bulleted list) of the current clinic process
2. **Mapping table** showing clinic steps matched to BandaHealth Go
3. **Gap analysis**: Features the clinic needs that require configuration, customization, or process change
4. **Next steps**: Configuration tasks or design decisions needed

## Example

**Workflow**: Outpatient visit at TODO clinic

**Current Clinic Steps**:
1. Patient arrives, receptionist checks registration
2. Nurse takes vitals (weight, BP, temperature)
3. Doctor sees patient, writes diagnosis and prescriptions
4. Cashier collects consultation fee
5. Patient goes to pharmacy to collect medicine

**Mapping to BandaHealth Go**:

| Clinic Step | Role | BandaHealth Go | Fields/Actions | Gaps |
|-------------|------|----------------|----------------|------|
| Check registration | Receptionist | Patient Window (search) | Patient ID, name | None |
| Take vitals | Nurse | Visit Window → Vitals tab | Weight, BP, temp, pulse | Need to enable vitals entry |
| Doctor visit | Doctor | Visit Window → Diagnosis tab | Diagnosis, prescriptions | Prescription template TODO |
| Collect fee | Cashier | Sales Order (service line), complete | Payment amount, method | Configure consultation product |
| Pharmacy dispense | Pharmacist | Sales Order (product lines), complete | Drug product, quantity | Inventory must be up to date |

**Gaps identified**:
- Vitals entry tab may need to be enabled in Visit Window configuration
- Prescription printing template needs design
- Consultation service product needs to be created in product master
- Pharmacy workflow depends on accurate inventory

**Next steps**:
1. Enable vitals tab in system configuration
2. Create consultation service product and price
3. Design prescription print format
4. Verify inventory setup and dispensing process

## Tips

- Start with one workflow, not the entire clinic at once
- Observe the workflow in action if possible, not just described
- Ask "why" to understand the purpose behind each step
- Note workarounds or pain points in the current process
- Be specific about which BandaHealth Go window/process applies

## Related Skills

- `/design-requirement-gathering`: Gather detailed requirements from staff
- `/design-specification`: Write a specification for developers to implement

## References

- TODO: Link to BandaHealth Go window and process documentation (internal)
