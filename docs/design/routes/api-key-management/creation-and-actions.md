---
title: "API Key Management Actions"
description: "Workflows for creating, regenerating, and revoking API keys, including success and confirmation modals."
last_modified_date: "2026-02-24"
level: "2"
---

# API Key Management Actions

## Create API Key Workflow

### Step 1: Create Modal

- **Form Fields**: Name (1-50 chars) and multi-select Permissions (e.g., `send_email`, `read_analytics`).
- **Logic**: Validates that at least one permission is selected.
- **API Call**: `POST /api/v1/platform/api-keys`

### Step 2: Success Modal (The "Reveal")

- **Visuals**: Displays the full plaintext API key exactly once.
- **Warning**: "Store this key securely. It will not be shown again."
- **Tools**: Copy button, "Download .env" button, and code examples (cURL, Node.js, etc.).

## Maintenance Actions

### Regenerate API Key

- **Trigger**: "Regenerate" button in the list or detail view.
- **Warning**: Informs the user that the old key will be immediately revoked.
- **Outcome**: Generates a new key and opens the success modal.
- **API Call**: `POST /api/v1/platform/api-keys/{key_id}/regenerate`

### Revoke API Key

- **Trigger**: "Revoke" button.
- **Confirmation**: Required step to prevent accidental deletion.
- **Status**: Once revoked, the key remains visible in the list as "Revoked" but cannot be used for any API calls.
- **API Call**: `DELETE /api/v1/platform/api-keys/{key_id}`
