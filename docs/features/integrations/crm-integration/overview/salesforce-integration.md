---
title: "Salesforce Integration"
description: "Bi-directional integration patterns for Salesforce CRM."
last_modified_date: "2026-02-24"
level: "2"
persona: "Admins, Developers"
---

## OAuth Authentication Flow

1. User clicks "Connect Salesforce" in PenguinMails settings.
2. Redirect to `login.salesforce.com` for authorization.
3. User grants `api`, `refresh_token`, and `full` scopes.
4. PenguinMails exchanges authorization code for encrypted tokens.

## Object Mapping

### Contacts & Leads

| Salesforce Field | PenguinMails Field | Direction |
|------------------|--------------------|-----------|
| `Email` | `email` | Bidirectional |
| `FirstName` | `first_name` | Bidirectional |
| `LeadSource` | `lead_source` | From CRM |
| `PenguinMails_Lead_Score__c` | `lead_score` | To CRM |

### Activities (Tasks)

PenguinMails logs marketing events as Salesforce Tasks:

- **Email Sent**: Logged with subject "Email: {campaign_name}".
- **Engagement**: Opens, clicks, and replies are updated as task status or custom engagement fields.

## Sync Rules

- **Bi-directional**: Real-time sync via webhooks for contact updates.
- **Engagement Push**: Marketing activity triggers (unsubscribes, high engagement) push immediate updates to the Salesforce record.
- **Conflict Strategy**: Default to "Salesforce Wins" for contact info; "PenguinMails Wins" for engagement state.
