---
name: design-implementation-plan
description: Turn a specification into a phased implementation plan. Breaks work into logical units, identifies dependencies, and sequences tasks for safe delivery.
---

# Design: Implementation Plan

Turn a specification into a phased implementation plan that breaks work into logical units, identifies dependencies, and sequences tasks for safe delivery.

## When to Use

Use this skill when:
- A specification is approved and needs to be implemented
- Work is too large to complete in one iteration
- Multiple developers will work on different parts
- You need to estimate effort or timeline
- Stakeholders need visibility into delivery milestones

## Prerequisites

- Approved specification or design document
- Understanding of the system architecture
- Knowledge of team capacity and skills

## Instructions

### Step 1: Break Down the Work

Decompose the specification into implementation tasks:

**Types of tasks:**
- **Data model**: Create or modify tables, columns, constraints
- **Business logic**: Write model classes, callouts, validators
- **UI**: Create or modify windows, fields, tabs
- **Process**: Implement processes, reports, or batch jobs
- **Integration**: API or external system connections
- **Testing**: Unit tests, integration tests, manual test scripts
- **Documentation**: User guides, developer notes
- **Deployment**: Migration scripts, configuration

List all tasks with brief descriptions.

### Step 2: Identify Dependencies

For each task, note what must be completed first:

**Examples:**
- "Create Patient_Vitals table" must happen before "Add vitals tab to Visit window"
- "Write patient sync API" must happen before "Add sync button to Patient window"
- "Deploy new table" must happen before "Deploy business logic that uses the table"

**Dependency types:**
- **Hard dependencies**: Task B cannot start until Task A is done
- **Soft dependencies**: Task B is easier if Task A is done first, but not blocked
- **Parallel tasks**: No dependencies, can be worked on simultaneously

### Step 3: Group into Phases

Organize tasks into phases (or iterations, sprints, milestones):

**Phase guidelines:**
- Each phase should deliver something testable and demonstrable
- Early phases establish foundation (data model, core logic)
- Later phases build on top (UI, integrations, polish)
- Aim for 1-2 weeks of work per phase (adjust based on team size)

**Example phases:**

**Phase 1: Data Foundation**
- Create tables and columns
- Write migration scripts
- Deploy to staging

**Phase 2: Core Business Logic**
- Implement model classes
- Add validation rules
- Write unit tests

**Phase 3: User Interface**
- Add windows, tabs, fields
- Wire UI to business logic
- Manual UI testing

**Phase 4: Integration and Polish**
- Implement API integration
- Add reports or processes
- Documentation

### Step 4: Estimate Effort

For each task, estimate effort:

**Estimation units:**
- Hours (for small tasks: 1-8 hours)
- Days (for medium tasks: 1-5 days)
- Weeks (for large tasks: 1-2 weeks)

**Estimation factors:**
- Complexity of the logic
- Familiarity with the codebase area
- Amount of testing needed
- Unknowns or research required

**Example:**
```
Task: Create BH_Patient_Vitals table
Effort: 4 hours (straightforward data model)

Task: Implement vitals validation rules
Effort: 1 day (some complexity, testing needed)

Task: Add vitals tab to Visit window
Effort: 1 day (UI work, manual testing)

Task: Write unit tests for vitals validation
Effort: 4 hours
```

Sum up estimates per phase to understand the total timeline.

### Step 5: Assign Owners

For each task or phase, identify:
- **Owner**: The person responsible for completing the task
- **Reviewer**: The person who will review the code or output
- **Tester**: The person who will test the feature (may be QA, product owner, or developer)

If owners are not yet assigned, note the skills required:
- "Requires iDempiere data modeling experience"
- "Requires knowledge of FHIR API"

### Step 6: Define Success Criteria per Phase

For each phase, list what "done" means:

**Acceptance criteria:**
- Code complete, reviewed, and merged
- Unit tests written and passing
- Manual testing complete (with test cases)
- Documentation updated
- Deployed to staging environment (if applicable)

**Deliverables:**
- Which features are visible or testable
- What stakeholders can review or try

**Example:**
```
Phase 2 Done:
- BH_Patient_Vitals table deployed to staging
- Model classes written, reviewed, merged
- Validation rules enforced (unit tests prove it)
- Code coverage >80% for vitals logic
- Deployable migration script ready
```

### Step 7: Identify Risks

List potential risks and mitigation strategies:

**Common risks:**
- **Technical unknowns**: Unclear how to integrate with external system (mitigate: spike or research task in early phase)
- **Dependency on external team**: Waiting for API credentials (mitigate: mock the API until ready)
- **Scope creep**: Stakeholders add requirements mid-implementation (mitigate: freeze scope per phase, add new requests to future phase)
- **Resource availability**: Developer unavailable (mitigate: cross-train, document well)

### Step 8: Document the Plan

Write up the implementation plan:

1. **Overview**: Summary of the feature and implementation approach
2. **Phases**: List of phases with tasks, estimates, dependencies
3. **Timeline**: When each phase is expected to complete (if deadlines apply)
4. **Owners**: Who owns each task or phase
5. **Success criteria**: What "done" means per phase
6. **Risks**: Potential blockers and mitigation plans

## Output Format

```
## Implementation Plan: Patient Vitals Feature

**Overview:**
Implement patient vitals recording in BandaHealth Go. Nurses will record vitals during check-in, and doctors will view them during consultations.

**Approach:**
- Phase 1: Data model and foundation
- Phase 2: Business logic and validation
- Phase 3: User interface
- Phase 4: Testing and documentation

---

### Phase 1: Data Foundation (Week 1)

**Tasks:**
1. Create BH_Patient_Vitals table (4 hours, @dev1)
   - Columns: Weight, BP, Temp, Pulse, Visit FK, timestamps
   - Migration script for staging and production
2. Create audit/log table for vitals changes (2 hours, @dev1)
3. Deploy to staging environment (1 hour, @devops)

**Dependencies:** None (foundational work)

**Acceptance Criteria:**
- Tables deployed to staging
- Migration script tested and verified
- Data dictionary entries visible in iDempiere

**Deliverable:** Database schema ready for business logic

---

### Phase 2: Core Business Logic (Week 2)

**Tasks:**
1. Write BH_PatientVitals model class (1 day, @dev2)
   - Getters, setters, save, load
   - beforeSave validation hooks
2. Implement vitals validation rules (1 day, @dev2)
   - Weight > 0, BP format check, temp/pulse ranges
   - Unit tests for validation
3. Write unit tests (4 hours, @dev2)

**Dependencies:**
- Requires Phase 1 complete (table exists)

**Acceptance Criteria:**
- Model class complete, reviewed, merged
- All validation rules enforced
- Unit tests passing, >80% code coverage
- Code reviewed by @dev-lead

**Deliverable:** Vitals data can be saved programmatically with validation

---

### Phase 3: User Interface (Week 3)

**Tasks:**
1. Add Vitals tab to Visit window (1 day, @dev3)
   - Fields: Weight, BP, Temperature, Pulse
   - Save and Cancel buttons
2. Wire UI to business logic (4 hours, @dev3)
3. Manual UI testing (4 hours, @qa)
   - Test valid and invalid inputs
   - Test save/cancel workflows

**Dependencies:**
- Requires Phase 2 complete (business logic ready)

**Acceptance Criteria:**
- Vitals tab visible in Visit window
- Nurses can enter and save vitals
- Validation errors display correctly
- Manual test cases documented and passed

**Deliverable:** Feature usable by nurses in staging environment

---

### Phase 4: Integration and Polish (Week 4)

**Tasks:**
1. Add vitals summary to Visit summary screen (4 hours, @dev3)
   - Display most recent vitals for doctors to view
2. Write user documentation (4 hours, @doc-writer)
3. Final end-to-end testing (1 day, @qa)
4. Deploy to production (1 hour, @devops)

**Dependencies:**
- Requires Phase 3 complete (UI working)

**Acceptance Criteria:**
- Doctors can view vitals on visit summary
- User guide published
- End-to-end test cases passed
- Deployed to production without errors

**Deliverable:** Feature live in production, fully documented

---

**Total Effort:** ~3-4 weeks (1 dev full-time, or 2 devs part-time)

**Risks:**
1. **Risk**: Validation rules more complex than expected
   - **Mitigation**: Allocate buffer time in Phase 2, spike complex rules early
2. **Risk**: UI changes blocked by iDempiere version limitations
   - **Mitigation**: Prototype UI in Phase 1, confirm feasibility

**Owners:**
- @dev1: Data model and migrations
- @dev2: Business logic and validation
- @dev3: User interface
- @qa: Testing
- @devops: Deployment
- @dev-lead: Code review and oversight
```

## Tips

- Start with data model and core logic before UI (foundation first)
- Each phase should be independently testable
- Keep phases small (1-2 weeks max) for frequent feedback
- Front-load risk (spike unknowns in early phases)
- Leave buffer time for unexpected complexity
- Communicate the plan to stakeholders and team before starting

## Common Pitfalls

- **Too many phases**: Keep it simple, 3-5 phases for most features
- **Monolithic phases**: Each phase should deliver something testable
- **Ignoring dependencies**: Tasks out of order waste time
- **Vague success criteria**: "Done" must be clear and measurable
- **Underestimating testing**: Always include testing tasks and time

## Related Skills

- `/design-specification`: Write the spec before planning implementation
- `/idempiere-model-design`: Plan the data model as Phase 1
- `/integration-api-design`: Plan integration work as a separate phase

## References

- Banda Health Development Process (TODO: internal link)
- iDempiere Migration Scripts Guide (TODO: internal link)
