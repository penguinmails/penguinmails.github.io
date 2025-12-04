---
title: "User Workflows"
description: "User workflows for API key management"
level: "3"
keywords: "workflows, user guide, operations"
---

# User Workflows

## User Workflows

### 1. Create API Key

**Actor:** Tenant User (Developer, Admin)

**Preconditions:**

- User is authenticated and has API key management permissions

- Tenant has active subscription

**Steps:**

1. Navigate to `/dashboard/settings/developers/api-keys`

2. Click "Create API Key" button

3. Enter API key name (e.g., "Production Server", "Staging Environment")

4. Select permission scopes:

   - `send_email` - Send emails via API

   - `read_analytics` - Read campaign and email analytics

   - `manage_contacts` - Create, update, delete contacts

   - `manage_campaigns` - Create, update, delete campaigns

5. Review rate limit for current subscription tier

6. Click "Generate Key"

7. **CRITICAL:** Copy API key immediately (shown only once)

8. Store API key securely in application environment variables

9. Test API key with sample request

**Postconditions:**

- API key created and stored in Vault (hashed)

- API key displayed once in UI (never shown again)

- Audit log entry created

- User can authenticate API requests with new key

### 2. View API Keys

**Actor:** Tenant User

**Steps:**

1. Navigate to `/dashboard/settings/developers/api-keys`

2. View list of all API keys with:

   - Key name

   - Masked key value (`pm_live_abc...xyz`)

   - Permission scopes (badges)

   - Created date

   - Last used timestamp

   - Request count

   - Error count

   - Status (Active, Revoked)

3. Click "Copy" to copy masked key (for reference only)

4. Click key row to view detailed usage statistics

**Postconditions:**

- User can see all API keys and their usage

- Cannot view full API key value (security)

### 3. Regenerate API Key

**Actor:** Tenant User

**Preconditions:**

- API key exists and is active

- User suspects key compromise or needs rotation

**Steps:**

1. Navigate to API key list

2. Click "Regenerate" button for specific key

3. Confirm regeneration (warning: old key will be revoked immediately)

4. New API key generated and displayed once

5. Copy new API key immediately

6. Update application with new key

7. Old key revoked (cannot be used for authentication)

**Postconditions:**

- New API key created with same permissions

- Old API key revoked and marked inactive

- Audit log entry created

- Application must use new key

### 4. Revoke API Key

**Actor:** Tenant User

**Preconditions:**

- API key exists

- User wants to permanently disable key

**Steps:**

1. Navigate to API key list

2. Click "Revoke" button for specific key

3. Confirm revocation (warning: cannot be undone)

4. API key marked as revoked

5. All subsequent API requests with this key return 401 Unauthorized

**Postconditions:**

- API key revoked and cannot be used

- Audit log entry created

- Key remains visible in UI (for audit purposes) but marked as "Revoked"

### 5. Monitor API Key Usage

**Actor:** Tenant User

**Steps:**

1. Navigate to API key list

2. View usage metrics for each key:

   - Total requests (lifetime)

   - Error count (4xx, 5xx responses)

   - Last used timestamp

   - Rate limit status (requests remaining this minute)

3. Click key row to view detailed usage chart:

   - Requests per day (last 30 days)

   - Error rate trend

   - Most common endpoints accessed

   - Geographic distribution of requests

**Postconditions:**

- User understands API key usage patterns

- Can identify anomalies or abuse

---

