---
name: design-requirement-gathering
description: Gather requirements from clinic staff using a structured interview approach. Use when you need to understand needs, constraints, and success criteria for a feature or configuration.
---

# Design: Requirement Gathering

Systematically gather requirements from clinic staff to understand their needs, constraints, and success criteria.

## When to Use

Use this skill when:
- Planning a new feature or configuration
- Clinic staff report a problem or gap
- Designing customizations for a specific clinic
- Validating whether a proposed solution meets needs

## Prerequisites

- Scheduled time with the right clinic stakeholders
- Understanding of the workflow or problem area
- Permission to ask questions and take notes

## Instructions

### Step 1: Identify Stakeholders

List who you need to talk to:
- **Users**: People who will directly use the feature (nurses, doctors, cashiers, etc.)
- **Managers**: People who oversee the process or area
- **Admin staff**: People who handle setup or configuration
- **Patients** (if relevant): People affected by the change

For each stakeholder, note:
- Their role
- How they relate to this requirement
- When you can meet with them

### Step 2: Understand the Current State

Ask open-ended questions:

**About the process:**
- "Walk me through how you do [this task] today."
- "What happens before this step? What happens after?"
- "How often do you do this?"
- "Who else is involved?"

**About problems or needs:**
- "What is difficult about the current process?"
- "What takes the most time?"
- "What causes errors or rework?"
- "What information do you wish you had?"

**About workarounds:**
- "How do you handle [edge case]?"
- "What do you do when [exception] happens?"
- "Do you use paper, spreadsheets, or other tools outside BandaHealth Go for this?"

### Step 3: Define the Desired State

Ask future-focused questions:

**About goals:**
- "What would success look like?"
- "How would you know this feature is working well?"
- "What would you be able to do that you can't do now?"

**About constraints:**
- "How much time can this step take?"
- "Who must be able to access this information?"
- "Are there regulations or policies that apply?"
- "What devices or locations will this be used from?"

**About data:**
- "What information needs to be captured?"
- "What information needs to be displayed or reported?"
- "How accurate does [field] need to be?"
- "Who enters this data? Who reads it?"

### Step 4: Clarify Edge Cases and Rules

Ask about exceptions and business logic:

**Edge cases:**
- "What happens if [unusual situation]?"
- "Who decides when [exception] applies?"
- "How often does [edge case] occur?"

**Business rules:**
- "Can [field] ever be blank?"
- "What are valid values for [field]?"
- "Who is allowed to [action]?"
- "Under what conditions can [action] be reversed?"

### Step 5: Document Requirements

Write down each requirement clearly:

**Format:**
```
As a [role],
I need to [action or capability],
So that [business value or outcome].
```

**Example:**
```
As a nurse,
I need to record patient vitals (weight, BP, temperature) during check-in,
So that the doctor has current health data before the consultation.
```

For each requirement, also note:
- **Priority**: Must-have, should-have, or nice-to-have
- **Frequency**: How often this happens (daily, weekly, rarely)
- **Dependencies**: What must exist for this to work (other features, data, training)

### Step 6: Validate Understanding

Repeat back what you heard:

- "So if I understand correctly, you need [summary]?"
- "Let me confirm: this happens [frequency], and involves [roles]."
- "The main problem is [problem], and success means [outcome]. Is that right?"

Ask for examples:
- "Can you show me a real example of this?"
- "What happened the last time you did this?"

Identify risks:
- "What could go wrong if we implement this?"
- "What should we definitely avoid?"

## Output Format

Produce:

1. **Stakeholder list**: Who you talked to and their roles
2. **Requirements list**: Prioritized user stories or requirement statements
3. **Success criteria**: How to know the solution works
4. **Constraints**: Technical, policy, or regulatory limits
5. **Open questions**: Anything unresolved that needs follow-up

## Example

**Feature**: Enable nurses to record patient vitals during check-in

**Stakeholders interviewed**:
- 2 nurses (primary users)
- 1 clinic manager (oversees patient flow)
- 1 doctor (consumer of vitals data)

**Requirements**:

1. (Must-have) As a nurse, I need to record weight, blood pressure, temperature, and pulse during patient check-in, so that the doctor has current data.
2. (Must-have) As a doctor, I need to see the most recent vitals at the top of the visit screen, so I don't have to search for them.
3. (Should-have) As a nurse, I need the system to flag abnormal vitals (e.g., high BP), so I can alert the doctor immediately.
4. (Nice-to-have) As a clinic manager, I need a report of average patient vitals over time, so I can track population health trends.

**Success criteria**:
- Nurses can record vitals in under 1 minute
- Doctors can view vitals without scrolling or opening another window
- No vitals data is lost or entered incorrectly

**Constraints**:
- Must work on the existing tablets nurses use
- No additional hardware (scales, BP cuffs) budget this year
- Only nurses should be able to edit vitals (doctors view-only)

**Open questions**:
- Should the system allow editing vitals after the visit is closed?
- What happens if a patient refuses to have vitals taken?
- Do we need to capture which device (scale model, BP cuff model) was used?

## Tips

- Listen more than you talk
- Ask "why" to understand the real need behind requests
- Observe the workflow in person if possible
- Be skeptical of "we've always done it this way"
- Document exact field names, values, and labels staff use
- Capture workarounds, they reveal unmet needs

## Related Skills

- `/design-workflow-mapping`: Map the broader workflow first
- `/design-specification`: Write up the requirements as a specification

## References

- TODO: Link to BandaHealth requirement template (internal)
