---
name: design-document-template
description: Standard template for design documents at Banda Health. Provides structured outline for specifications, implementation plans, and design decisions. Use when creating new design documents.
---

# Design Document Template

Standard template for design documents at Banda Health. Provides a structured outline for specifications, implementation plans, and design decisions.

## When to Use

Use this template when:
- Writing a design specification for a new feature
- Documenting an architectural decision
- Planning an implementation or integration
- Recording design trade-offs and decisions

## How to Use

Copy the template below and fill in each section. Omit sections that don't apply. Tailor to your audience (implementers, developers, or both).

---

## Design Document Template

```markdown
# [Feature or Component Name]

**Author**: [Your Name]
**Date**: [YYYY-MM-DD]
**Status**: [Draft | Under Review | Approved | Implemented]
**Audience**: [Implementers | Developers | Both]

---

## 1. Overview

**Purpose**: One paragraph explaining why this exists and what problem it solves.

**Users**: Who will use this feature or system?

**Success Criteria**: How will we know this is working? List 2-3 measurable outcomes.

---

## 2. Background / Context

**Current State**: What happens now? What is the problem or gap?

**Desired State**: What should happen after implementation?

**Assumptions**: What are we assuming is true?

**Constraints**: Technical, regulatory, or policy limits.

---

## 3. Requirements

### 3.1 Functional Requirements

List what the system must do. Use this format:

```
As a [role],
I need to [action or capability],
So that [business value or outcome].
```

**Priority**: Mark each as Must-have, Should-have, or Nice-to-have.

**Example:**
```
1. (Must-have) As a nurse, I need to record patient vitals during check-in, so that the doctor has current health data.
2. (Should-have) As a doctor, I need to see the most recent vitals at the top of the visit screen, so I don't have to search.
```

### 3.2 Non-Functional Requirements

- **Performance**: Response time, throughput, or load requirements
- **Security**: Authentication, authorization, data protection
- **Scalability**: Expected growth or scale
- **Usability**: User experience goals
- **Reliability**: Uptime, error handling, data integrity

---

## 4. Design

### 4.1 Data Model

Describe entities, tables, columns, relationships.

**For developers**: Full table and column specifications (see `/idempiere-model-design`).

**For implementers**: High-level entity descriptions and relationships.

**Example:**
```
Entities:
- Patient Vitals: Records weight, BP, temperature, pulse
- Belongs to: Visit (one visit has many vitals records)
```

### 4.2 User Interface

Describe screens, windows, fields, buttons.

**For implementers**: Mockups or descriptions of what users will see and do.

**For developers**: Window/tab structure, field names and types, validation rules.

**Example:**
```
Visit Window → Vitals Tab

Fields:
- Weight (kg): Number, required, range 1-300
- Blood Pressure: Text, required, format "NNN/NNN"
- Temperature (°C): Number, required, range 30-45
- Pulse (bpm): Number, required, range 30-200

Buttons:
- Save: Validate and store vitals
- Cancel: Discard changes
```

### 4.3 Business Logic / Rules

List validation rules, calculations, workflows, access control.

**Example:**
```
- Blood pressure must match format NNN/NNN (e.g., 120/80)
- All vitals fields are required
- Only nurses can enter vitals; doctors have read-only access
- Vitals are saved immediately on Save button click
```

### 4.4 Integration (if applicable)

Describe API endpoints, external systems, data exchange.

**See**: `/integration-api-design` for detailed integration planning.

**Example:**
```
Integration: Sync vitals to OpenMRS
- API: POST to /openmrs/ws/rest/v1/obs
- Auth: Basic auth with clinic credentials
- Trigger: On vitals save
- Error handling: Retry 3 times, log failures
```

---

## 5. Implementation Plan

Break work into phases or tasks. Identify dependencies and estimates.

**See**: `/design-implementation-plan` for detailed planning guidance.

**Example:**
```
Phase 1: Data model (1 week)
- Create BH_Patient_Vitals table
- Migration script

Phase 2: Business logic (1 week)
- Model class and validation
- Unit tests

Phase 3: User interface (1 week)
- Add vitals tab to Visit window
- Manual testing

Phase 4: Testing and deployment (1 week)
- End-to-end testing
- Documentation
- Deploy to production
```

---

## 6. Testing Plan

Describe how to test this feature.

**Unit Tests**: What logic is tested programmatically?

**Integration Tests**: What end-to-end flows are tested?

**Manual Tests**: What test cases must be run by hand?

**Example:**
```
Unit Tests:
- Validate weight > 0
- Validate BP format "NNN/NNN"
- Validate temp range 30-45

Manual Tests:
1. Open Visit, enter valid vitals, save → Success
2. Open Visit, enter invalid BP, save → Error shown
3. Log in as doctor, view visit → Vitals displayed, fields read-only
```

---

## 7. Edge Cases and Exceptions

List unusual scenarios and how the system handles them.

**Example:**
```
- Patient refuses vitals: Allow saving with "Refused" checkbox
- Invalid BP format: Show error message, do not save
- Network failure during save: Retry once, then show error
```

---

## 8. Security and Multi-Tenancy

(For developers) Ensure tenant isolation and access control.

**See**: `/idempiere-multi-tenancy` for multi-tenancy guidelines.

**Example:**
```
- All vitals data is tenant-owned (AD_Client_ID = clinic tenant)
- Only nurses and doctors can access vitals
- Doctors have read-only access
- Data cannot leak across clinics
```

---

## 9. Open Questions

List unresolved decisions or unknowns.

**Example:**
```
- Should vitals be editable after the visit is closed?
- Do we need to track which device (scale, BP cuff) was used?
- Should the system alert on abnormal vitals?
```

---

## 10. Out of Scope

Be clear about what this design does NOT include.

**Example:**
```
Out of scope for this phase:
- Automatic import from vitals devices (future)
- Trend charts or historical vitals reports (future)
- Alerts for abnormal vitals (may be added later)
```

---

## 11. References

Link to related documents, external resources, or internal tools.

**Example:**
```
- Specification: [Link to spec doc]
- iDempiere Application Dictionary: [Internal link]
- User guide: [Link when available]
- YouTrack issue: [Link to issue]
```

---

## 12. Glossary (Optional)

Define domain-specific terms used in this document.

**See**: `/terminology-banda` for standard Banda Health terms.

**Example:**
```
- Vitals: Basic health measurements (weight, BP, temp, pulse)
- Visit: A patient encounter at the clinic
- iDempiere: The ERP platform BandaHealth Go is built on
```

---

## 13. Appendix (Optional)

Include mockups, diagrams, sample data, or detailed technical notes.

```

---

## Tips

- Write for your audience (adjust technical depth accordingly)
- Keep it concise but complete
- Use examples to illustrate complex ideas
- Mark open questions and out-of-scope clearly
- Update the document as decisions are made
- Review with stakeholders before implementation

## Related Skills

- `/design-specification`: Write a detailed spec using this template
- `/design-implementation-plan`: Plan the implementation phases
- `/terminology-banda`: Use consistent terminology
- `/idempiere-model-design`: Design the data model section
- `/integration-api-design`: Design the integration section

## References

- Banda Health Design Standards (TODO: internal link)
- iDempiere Documentation: http://wiki.idempiere.org/
