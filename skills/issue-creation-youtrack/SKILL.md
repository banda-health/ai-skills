---
name: issue-creation-youtrack
description: Create a well-structured YouTrack issue with clear context, acceptance criteria, and enough detail for developers to estimate and implement. Use when turning requirements or bugs into actionable tickets.
---

# Issue Creation: YouTrack

Create a well-structured YouTrack issue that developers can estimate and implement without follow-up questions.

## When to Use

Use this skill when:
- Turning a specification or requirement into a development task
- Reporting a bug that needs fixing
- Requesting a feature or configuration change
- Documenting technical debt or improvement work

## Prerequisites

- Clear understanding of the requirement or problem
- Specification or detailed notes (if applicable)
- Examples or steps to reproduce (for bugs)

## Instructions

### Step 1: Choose the Issue Type

Select the appropriate YouTrack issue type:

- **Feature**: New functionality or capability
- **Bug**: Something broken or not working as expected
- **Task**: Work that isn't a bug or feature (configuration, documentation, cleanup)
- **Improvement**: Enhancement to existing functionality

### Step 2: Write a Clear Summary

The summary is the issue title. Make it:
- **Specific**: Include what and where
- **Action-oriented**: Start with a verb
- **Concise**: Under 10 words if possible

**Good examples:**
- "Add vitals recording tab to Visit window"
- "Fix inventory calculation error in stock reports"
- "Configure consultation service product in product master"

**Bad examples:**
- "Vitals" (too vague)
- "Need to add a way for users to enter patient vitals during check-in so doctors can see them" (too long)
- "Issue with reports" (not specific)

### Step 3: Describe the Context

In the description field, provide background:

**For features:**
```
**Background**: [Why does this need to exist? What problem does it solve?]

**Users**: [Who will use this?]

**Current state**: [What happens now?]

**Desired state**: [What should happen after implementation?]
```

**For bugs:**
```
**Summary**: [One sentence describing the problem]

**Steps to reproduce**:
1. [First action]
2. [Second action]
3. [Third action]

**Expected result**: [What should happen]

**Actual result**: [What actually happens]

**Environment**: [Version, clinic, device, etc.]
```

### Step 4: Define Acceptance Criteria

List the conditions that must be true for this issue to be considered done. Use checkboxes:

```
Acceptance Criteria:
- [ ] Nurses can open a Visit and see a Vitals tab
- [ ] Vitals fields (weight, BP, temp, pulse) are required
- [ ] Saved vitals appear on the visit summary for doctors
- [ ] Only nurses can edit vitals; doctors have read-only access
```

Be specific and testable. Avoid vague criteria like "works well" or "is user-friendly."

### Step 5: Attach Supporting Materials

Include anything that helps developers understand:

- Specification document (link or attach)
- Screenshots or mockups
- Example data or test cases
- Links to related issues
- Links to relevant documentation

In YouTrack, attach files or paste links in the description.

### Step 6: Set Priority and Labels

**Priority**:
- **Critical**: System down, data loss, blocking work
- **High**: Major feature, serious bug, impacting users
- **Normal**: Standard feature or fix
- **Low**: Nice-to-have, minor issue

**Labels/Tags**: Add relevant tags (discuss with your team's conventions):
- Feature area: `vitals`, `inventory`, `billing`
- Component: `window`, `process`, `report`
- Clinic or deployment: `clinic-ABC` (only if specific to one clinic)

### Step 7: Assign or Leave Unassigned

- **Assign to a person** if you know who should work on this
- **Leave unassigned** if the team will triage and pick it up
- **Assign to yourself** if you're tracking it but need someone else to implement

### Step 8: Link Related Issues

If this issue depends on or relates to others:
- "Depends on #123" (this can't start until #123 is done)
- "Blocks #456" (issue #456 can't start until this is done)
- "Related to #789" (connected but not blocking)

YouTrack has a "Links" section for this.

### Step 9: Review Before Submitting

Check:
- [ ] Summary is clear and specific
- [ ] Context explains why this matters
- [ ] Acceptance criteria are testable
- [ ] Supporting materials attached
- [ ] Priority and labels set
- [ ] Related issues linked

## Output Format

A YouTrack issue with:

1. **Summary**: Clear title (under 10 words)
2. **Description**: Context, background, steps to reproduce (for bugs)
3. **Acceptance Criteria**: Checklist of done conditions
4. **Attachments**: Specs, screenshots, examples
5. **Priority**: Critical, High, Normal, or Low
6. **Labels**: Feature area, component, etc.
7. **Links**: Related or blocking issues

## Example Issue

**Summary**: Add vitals recording tab to Visit window

**Description**:

```
**Background**: Clinic staff need to record patient vitals (weight, BP, temperature, pulse) during check-in so doctors have current health data during consultations.

**Users**: Nurses (data entry), Doctors (read-only view)

**Current state**: Nurses record vitals on paper, and doctors don't have access to this data in BandaHealth Go.

**Desired state**: Nurses can record vitals in a Vitals tab in the Visit window. Doctors can view the most recent vitals on the visit summary screen.

**Specification**: [Link to design spec document]
```

**Acceptance Criteria**:
```
- [ ] Visit window has a new Vitals tab
- [ ] Vitals tab contains fields: Weight (kg), BP, Temperature (°C), Pulse (bpm)
- [ ] All vitals fields are required
- [ ] Saved vitals are stored and linked to the visit
- [ ] Most recent vitals appear on the visit summary screen
- [ ] Only nurses can edit vitals; doctors have read-only access
- [ ] Invalid BP format shows validation error
```

**Attachments**: `vitals-mockup.png`, `vitals-specification.pdf`

**Priority**: High

**Labels**: `vitals`, `visit-window`, `feature`

**Links**: Depends on #234 (User roles and permissions)

## Tips

- Write from the developer's perspective, not your own
- Include why this matters, not just what to do
- Be specific about field names, values, and labels
- Avoid assumptions; if it's not written, it won't be built
- Test your acceptance criteria by asking "how would I verify this?"
- If you can't write clear criteria, the spec may need more work

## Common Pitfalls

- **Too vague**: "Make vitals work" (work how? where?)
- **Mixing multiple issues**: One issue per feature or bug
- **Missing context**: Developers don't understand why this matters
- **Untestable criteria**: "Should be easy to use" (who decides? how to test?)

## Related Skills

- `/design-specification`: Write the detailed spec first
- `/design-requirement-gathering`: Gather requirements to inform the issue

## References

- TODO: Link to YouTrack instance and team conventions (internal)
- TODO: Link to issue template examples (internal)
