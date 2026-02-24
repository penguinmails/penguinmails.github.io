---
title: "API Key Listing & Details"
description: "Route specifications for viewing the list of tenant API keys and their detailed usage metadata."
last_modified_date: "2026-02-24"
level: "2"
---

# API Key Listing & Details

## Route: API Key List

**Path**: `/dashboard/settings/developers/api-keys`

### UI Components

- **Page Header**: Title "API Keys", Description, and "Create API Key" button.
- **API Key Table**: Columns for Name, Masked Key, Permissions, Rate Limit, Status, and Last Used.
- **Empty State**: Displayed when no keys exist, encouraging the user to create one.

### Table Row Actions

- **Copy**: Copies the masked key to the clipboard.
- **Regenerate**: Opens the regeneration confirmation modal.
- **Revoke**: Opens the revocation confirmation modal.

## Route: API Key Details Modal

**Trigger**: Clicking on an API key row in the table.

### Modal Overview

- **Overview Tab**: Displays key metadata (ID, masked value, permissions) and usage statistics.
- **Usage Tab**: Visualizes requests per day and error rate trends over the last 30 days.
- **Security Tab**: Showcases an audit log of the last 50 events and unique IP addresses used.

### API Specifications

- **List Keys**: `GET /api/v1/platform/api-keys`
- **Get Key Detail**: `GET /api/v1/platform/api-keys/{key_id}`
