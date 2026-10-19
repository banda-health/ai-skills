---
name: terminology-banda
description: Banda Health terminology and glossary. Explains common terms used in BandaHealth Go, iDempiere, clinic workflows, and healthcare IT. Use when you need definitions or consistent terminology.
---

# Terminology: Banda Health Glossary

Banda Health terminology and glossary for common terms used in BandaHealth Go, iDempiere, clinic workflows, and healthcare IT.

## When to Use

Use this skill when:
- You encounter an unfamiliar term in documentation or discussion
- Writing specifications or documentation and want consistent terminology
- Explaining concepts to stakeholders from different backgrounds
- Translating between clinical and technical language

## How to Use

Refer to this glossary to look up terms. If a term is missing, suggest adding it to the team.

---

## BandaHealth Go Terms

**BandaHealth Go**
The hospital and clinic management software built by Banda Health on top of iDempiere ERP. Used by clinics in Africa for patient management, inventory, billing, and clinical workflows.

**Visit**
A patient encounter at the clinic. Includes registration, vitals, consultation, diagnosis, prescriptions, lab orders, and billing. A visit is the core workflow unit in BandaHealth Go.

**Patient**
An individual receiving care at the clinic. Identified by a unique patient ID. Patient records include demographics, medical history, visits, and billing.

**Vitals**
Basic health measurements taken at the start of a visit: weight, blood pressure, temperature, pulse. Recorded by nurses during patient check-in.

**Diagnosis**
The medical condition identified by the clinician during a visit. Recorded using diagnosis codes (ICD-10 or clinic-specific codes).

**Prescription**
Medication ordered by the clinician during a visit. Includes drug name, dosage, quantity, and instructions. Dispensed by the pharmacy.

**Dispensing**
The act of giving medication to the patient from the pharmacy. Linked to a prescription and reduces inventory.

---

## iDempiere Terms

**iDempiere**
Open-source ERP (Enterprise Resource Planning) system. BandaHealth Go is built on iDempiere, extending it with healthcare-specific features.

**Application Dictionary (AD)**
iDempiere's metadata layer. Defines tables, columns, windows, processes, and other system elements. Changes to the Application Dictionary are how you extend iDempiere.

**Window**
A user interface screen in iDempiere. Displays data from one or more tables. Examples: Patient Window, Sales Order Window, Product Window.

**Tab**
A section within a window. Tabs organize related data. Example: The Patient Window has tabs for patient details, visits, and billing history.

**Process**
An action or batch operation in iDempiere. Examples: "Complete Order" process, "Generate Invoice" process, "Post Inventory" process.

**Document**
A business transaction record in iDempiere. Examples: Sales Order, Invoice, Payment, Inventory Receipt. Documents have statuses (Draft, Completed, Voided) and often go through approval workflows.

**AD_Client_ID**
The tenant identifier in iDempiere. Each clinic has a unique `AD_Client_ID`. Data is isolated by tenant so clinics cannot see each other's data.

**AD_Org_ID**
The organization identifier within a tenant. A clinic may have multiple organizations (e.g., main branch, sub-branch). Used for hierarchical access control.

**Table**
A database table in iDempiere. Defined in the Application Dictionary. Examples: `C_BPartner` (business partner), `M_Product` (product), `BH_Visit` (Banda Health visit).

**Column**
A field in a table. Examples: `Name`, `Description`, `Qty`, `Price`. Each column has a type (String, Integer, Date, etc.) and validation rules.

---

## Clinical Workflow Terms

**Check-in**
The first step of a visit. Patient arrives, receptionist verifies or updates registration, and nurse records vitals.

**Consultation**
The doctor or clinician sees the patient, takes medical history, performs examination, and makes a diagnosis.

**Pharmacy**
The dispensing area where patients collect prescribed medications. Pharmacy staff verify prescriptions, dispense drugs, and update inventory.

**Lab**
The laboratory where tests are ordered and results are recorded. Examples: blood tests, X-rays, urine analysis.

**Triage**
The process of assessing patient urgency. In some clinics, nurses triage patients to determine priority for seeing the doctor.

**Billing / Cashier**
The step where the patient pays for services and medications. Handled by the cashier role. Payment may occur before or after the visit depending on clinic policy.

---

## Technical Terms

**REST API**
A web API using HTTP requests (GET, POST, PUT, DELETE) to exchange data. Used for integrations between BandaHealth Go and external systems.

**FHIR (Fast Healthcare Interoperability Resources)**
A standard for exchanging healthcare data electronically. Defines resource types (Patient, Observation, Encounter, etc.) and REST API conventions.

**OpenMRS**
Open-source medical record system. Some clinics integrate BandaHealth Go with OpenMRS for clinical data exchange.

**Multi-tenancy**
The architectural pattern where one software instance serves multiple clinics (tenants). Data is isolated by `AD_Client_ID` so clinics cannot access each other's data.

**Migration Script**
A script (SQL or XML) that updates the database schema or data. Used to deploy new tables, columns, or data changes to iDempiere.

**Callout**
An iDempiere mechanism for executing logic when a field changes in the UI. Example: When quantity changes, recalculate total price.

**Model Validator**
An iDempiere extension point for adding custom business logic. Fires on events like `beforeSave`, `afterSave`, `beforeDelete`.

---

## Roles and Users

**Implementer**
A Banda Health team member who works with clinics to gather requirements, configure the system, and train users. May not be a software developer.

**Developer**
A Banda Health software engineer who writes code, extends iDempiere, and builds custom features.

**Clinician**
A healthcare provider (doctor, nurse, clinical officer) who uses BandaHealth Go to deliver patient care.

**Receptionist**
Clinic staff who handle patient registration, scheduling, and check-in.

**Cashier**
Clinic staff who collect payments and manage billing.

**Pharmacist**
Clinic staff who dispense medications and manage pharmacy inventory.

**Admin**
A user with elevated permissions in BandaHealth Go. Can configure the system, manage users, and access all data.

---

## Data and Integration Terms

**Tenant**
A clinic or customer in a multi-tenant system. Each tenant has its own `AD_Client_ID` and isolated data.

**Sync / Synchronization**
The process of exchanging data between BandaHealth Go and an external system (e.g., syncing patients from OpenMRS).

**Batch Job**
A scheduled background process that runs at intervals (e.g., nightly inventory reports, daily data sync).

**Idempotent**
An operation that can be safely repeated without causing duplicate or inconsistent data. Important for retries and integrations.

**Webhook**
A callback mechanism where an external system sends a request to BandaHealth Go when an event occurs (e.g., new patient created in external system).

---

## Common Acronyms

- **AD**: Application Dictionary (iDempiere)
- **API**: Application Programming Interface
- **BP**: Business Partner (iDempiere term for customer, vendor, or patient)
- **ERP**: Enterprise Resource Planning
- **FHIR**: Fast Healthcare Interoperability Resources
- **HL7**: Health Level 7 (healthcare data standards)
- **ID**: Identifier (unique key)
- **PHI**: Protected Health Information (sensitive patient data)
- **REST**: Representational State Transfer (web API style)
- **UI**: User Interface

---

## Adding New Terms

If you encounter a term not listed here, propose adding it:

1. Define the term clearly
2. Explain where it's used (BandaHealth Go, iDempiere, clinical workflow, integration)
3. Provide an example if helpful
4. Submit via internal team process (e.g., PR to this repository)

---

## Related Skills

- `/design-specification`: Use consistent terminology when writing specs
- `/design-document-template`: Include a glossary section in design documents
- `/issue-creation-youtrack`: Use standard terminology in issues

## References

- iDempiere Wiki: http://wiki.idempiere.org/
- FHIR Specification: https://www.hl7.org/fhir/
- TODO: Link to Banda Health internal glossary (if exists)
