---
name: integration-api-design
description: Design API integrations with external systems (REST, FHIR, OpenMRS). Covers authentication, error handling, data mapping, retry logic, and testing strategies.
---

# Integration: API Design

Design API integrations with external systems, including authentication, error handling, data mapping, and testing.

## When to Use

Use this skill when:
- Integrating BandaHealth Go with an external system (OpenMRS, FHIR server, payment gateway, etc.)
- Designing REST or FHIR API endpoints
- Planning data synchronization or exchange workflows
- Reviewing or improving an existing integration

## Prerequisites

- Understanding of the external system you're integrating with
- API documentation for the external system
- Knowledge of the data you need to exchange

## Instructions

### Step 1: Define the Integration Scope

Answer these questions:

**What are you integrating with?**
- System name (e.g., OpenMRS, FHIR server, MPESA API)
- Purpose (e.g., sync patient data, send lab results, process payments)

**What direction does data flow?**
- **Outbound**: BandaHealth Go pushes data to external system
- **Inbound**: External system pushes data to BandaHealth Go
- **Bidirectional**: Two-way data exchange
- **Query**: BandaHealth Go queries external system on demand

**What triggers the integration?**
- Event-driven (e.g., when a visit is completed)
- Scheduled batch (e.g., nightly sync)
- On-demand (e.g., user clicks a button)

### Step 2: Understand the External API

Review the external system's API documentation:

**API type:**
- REST (JSON or XML)
- FHIR (HL7 FHIR standard)
- SOAP (older systems)
- Custom protocol

**Authentication:**
- API key or token
- OAuth 2.0
- Basic auth (username/password)
- Mutual TLS (client certificates)

**Endpoints:**
- List the endpoints you'll call (GET, POST, PUT, DELETE)
- Request and response formats
- Rate limits or throttling

**Error handling:**
- HTTP status codes used
- Error message format
- Retry recommendations

### Step 3: Design Authentication

Plan how BandaHealth Go will authenticate:

**Configuration:**
- Store credentials securely (encrypted in iDempiere or external secrets manager)
- Support per-tenant credentials (each clinic may have its own API key)
- Allow credential rotation without code changes

**Token management:**
- If using OAuth, implement token refresh logic
- Cache tokens with expiration tracking
- Handle 401 Unauthorized responses by re-authenticating

**Example:**
```
API: OpenMRS REST API
Auth: Basic auth with username/password
Storage: Encrypted credentials in iDempiere (per AD_Client_ID)
Retry: If 401, re-authenticate once and retry the request
```

### Step 4: Map Data Models

Define how data maps between BandaHealth Go and the external system:

**For each entity:**
- Source entity (e.g., `BH_Patient` in BandaHealth Go)
- Target entity (e.g., `Patient` resource in FHIR)
- Field-by-field mapping

**Example mapping:**

| BandaHealth Go Field | External System Field | Notes |
|----------------------|----------------------|-------|
| BH_Patient.Name | Patient.name.text | Combine first + last |
| BH_Patient.Value | Patient.identifier.value | Patient ID |
| BH_Patient.BirthDate | Patient.birthDate | ISO 8601 format |
| BH_Patient.Gender | Patient.gender | Map M→male, F→female |

**Handle missing or incompatible fields:**
- Required field in external system but not captured in BandaHealth Go? (Add to BandaHealth Go or provide a default)
- Field exists in BandaHealth Go but not in external system? (Omit or store in extension field if supported)

### Step 5: Design Error Handling

Plan for failures:

**Network errors:**
- Timeout settings (e.g., 30-second timeout)
- Retry logic (e.g., 3 retries with exponential backoff)
- Fallback behavior (e.g., queue for later, alert user)

**API errors:**
- 4xx client errors (bad request, unauthorized, not found): Log and alert, do not retry
- 5xx server errors (server down, unavailable): Retry with backoff
- Validation errors (e.g., missing required field): Log and alert, fix data or mapping

**Data integrity:**
- Idempotent operations (safe to retry without creating duplicates)
- Track synchronization state (which records have been sent, received, or failed)
- Provide manual retry or reconciliation tools for failed records

**Example:**
```
Error Handling:

- Network timeout: 30 seconds
- Retry: Up to 3 attempts with 5s, 10s, 20s delays
- 4xx errors: Log, alert admin, do not retry automatically
- 5xx errors: Retry up to 3 times, then queue for manual review
- Log all requests and responses for debugging
```

### Step 6: Design Request/Response Flow

Document the integration flow:

**For outbound integrations:**
1. Trigger: What event starts the integration? (e.g., visit completed)
2. Prepare: Transform BandaHealth Go data to external format
3. Authenticate: Get or refresh auth token
4. Send: HTTP request to external API
5. Handle response: Success (update status), Error (log and retry)
6. Audit: Log request, response, status

**For inbound integrations:**
1. Receive: External system calls BandaHealth Go endpoint
2. Authenticate: Verify caller (API key, IP whitelist, etc.)
3. Validate: Check request format and required fields
4. Transform: Map external data to BandaHealth Go format
5. Persist: Save to iDempiere tables (within transaction)
6. Respond: Return success or error response
7. Audit: Log request and outcome

### Step 7: Plan for Testing

Define how to test the integration:

**Unit tests:**
- Test data mapping logic (BandaHealth Go ↔ external format)
- Test error handling (simulate timeouts, 5xx errors, invalid responses)
- Mock the external API to avoid real calls

**Integration tests:**
- Test against a sandbox or staging environment of the external system
- Verify end-to-end flow (trigger → request → response → data persisted)
- Test authentication (valid and invalid credentials)

**Manual testing:**
- Test with real data in a test environment
- Verify idempotency (retry same request, no duplicates)
- Test error scenarios (network down, server error, bad data)

**Monitoring:**
- Log all API calls (request, response, duration, status)
- Alert on repeated failures or high error rates
- Dashboard showing integration health (success rate, avg latency)

### Step 8: Document the Integration

Write up the integration design:

1. **Overview**: System integrated, purpose, data flow direction
2. **API details**: Endpoints, auth, rate limits
3. **Data mapping**: Field-by-field mapping table
4. **Error handling**: Retry logic, logging, alerting
5. **Request/response flow**: Step-by-step sequence
6. **Configuration**: Credentials, endpoints, timeouts (per-tenant if applicable)
7. **Testing plan**: Unit, integration, manual test cases
8. **Monitoring**: Logs, alerts, dashboards

## Output Format

```
## Integration Design: BandaHealth Go ↔ OpenMRS

**Overview:**
- **System**: OpenMRS (medical records)
- **Purpose**: Sync patient demographics and visit data
- **Direction**: Bidirectional (patients from OpenMRS, visits to OpenMRS)
- **Trigger**: Real-time (on patient create/update, on visit complete)

**API Details:**
- **Type**: REST API (JSON)
- **Base URL**: https://<clinic>.openmrs.org/openmrs/ws/rest/v1
- **Auth**: Basic auth (username/password per clinic)
- **Rate limit**: 100 requests/minute

**Data Mapping: Patient (OpenMRS → BandaHealth Go)**

| OpenMRS Field | BandaHealth Go Field | Notes |
|---------------|---------------------|-------|
| person.display | BH_Patient.Name | Full name |
| identifiers[0].identifier | BH_Patient.Value | Patient ID |
| person.birthdate | BH_Patient.BirthDate | ISO 8601 |
| person.gender | BH_Patient.Gender | M/F |

**Error Handling:**
- Timeout: 30 seconds
- Retry: 3 attempts with 5s, 10s, 20s delays
- 4xx errors: Log and alert, no auto-retry
- 5xx errors: Retry up to 3 times, then queue for manual review

**Request Flow (Outbound: Visit → OpenMRS):**
1. Trigger: User completes visit in BandaHealth Go
2. Prepare: Transform visit data to OpenMRS JSON format
3. Authenticate: Use stored credentials, get token if needed
4. Send: POST to /openmrs/ws/rest/v1/encounter
5. Handle response: Success (log), Error (retry logic)
6. Audit: Log all requests to BH_Integration_Log table

**Configuration (per tenant):**
- OpenMRS base URL
- Username, password (encrypted)
- Timeout: 30s
- Retry count: 3

**Testing:**
- Unit tests: Data mapping, error handling (mocked API)
- Integration tests: OpenMRS sandbox environment
- Manual tests: Real clinic data in staging

**Monitoring:**
- Log table: BH_Integration_Log (request, response, status, timestamp)
- Alert: Email admin if >10 failures in 1 hour
- Dashboard: Success rate, avg latency, error breakdown
```

## Tips

- Test with sandbox/staging environments before connecting to production
- Design for idempotency (safe to retry)
- Log all requests and responses (sanitize sensitive data)
- Handle rate limits gracefully (back off, queue requests)
- Validate data before sending (catch errors early)
- Support per-tenant configuration (each clinic may use different credentials)

## Common Pitfalls

- **Hardcoded credentials**: Store securely, support per-tenant
- **No retry logic**: Network failures happen, always retry transient errors
- **Not idempotent**: Retries create duplicates (use idempotency keys if supported)
- **Ignoring rate limits**: Can get your API key banned
- **Poor error logging**: Makes debugging impossible
- **Testing only happy path**: Test failures, timeouts, bad data

## Related Skills

- `/idempiere-multi-tenancy`: Ensure per-tenant credentials and data isolation
- `/design-implementation-plan`: Plan the integration implementation in phases

## References

- FHIR Specification: https://www.hl7.org/fhir/
- OpenMRS REST API: TODO (internal or external link)
- Banda Health API Integration Patterns (TODO: internal link)
