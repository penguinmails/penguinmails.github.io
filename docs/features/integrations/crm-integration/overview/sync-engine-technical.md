---
title: "Sync Engine Technical Implementation"
description: "Architecture, Conflict Resolution, and Security for the CRM mapping system."
last_modified_date: "2026-02-24"
level: "3"
persona: "Developers"
---

## Engine Architecture

The CRM Sync Engine operates as a background microservice using a Node.js worker pool.

### Bi-Directional Logic

- **To CRM**: Pushes engagement events and lead score updates.
- **From CRM**: Pulls contact creation, deletion, and profile updates.
- **Polling vs Webhooks**: Real-time updates via webhooks are prioritized; hourly batch polling ensures consistency.

## Conflict Resolution Strategies

| Strategy | Description | Best For |
|----------|-------------|----------|
| **CRM Wins** | CRM data always overwrites local data. | Contact identity (Name/Email) |
| **Penguin Wins** | Local data overwrites CRM data. | Engagement metrics |
| **Newest Wins** | The most recent timestamp wins. | General field updates |
| **Field-Level** | Different rules for different fields. | Complex enterprise setups |

## Security & Reliability

- **Encryption**: All API keys and OAuth tokens are encrypted at rest using AES-256.
- **Rate Limiting**: Intelligent batching handles CRM API limits (e.g., Salesforce concurrent requests).
- **Token Rotation**: Automatic refresh token handling every 30 days.
- **Audit Logging**: Every sync operation (success or failure) is logged for troubleshooting.

## Field Mapping Service

A generic mapping abstraction allows users to define custom transformations:

- **Direct**: 1:1 field mapping.
- **Formula**: `{{first_name}} {{last_name}}` → `Full_Name`.
- **Conditional**: `lead_score >= 75` → `Status: Hot`.
