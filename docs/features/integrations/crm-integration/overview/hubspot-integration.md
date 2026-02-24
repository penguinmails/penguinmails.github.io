---
title: "HubSpot Integration"
description: "Bi-directional integration patterns for HubSpot CRM."
last_modified_date: "2026-02-24"
level: "2"
persona: "Admins, Developers"
---

## OAuth Authentication Flow

1. Redirect to `app.hubspot.com` to select the target portal.
2. Grant `contacts`, `timeline`, and `automation` scopes.
3. OAuth refresh tokens are handled automatically by the integration microservice.

## Property Mapping

### Contacts

- **Direct**: Email, First Name, Last Name, Job Title.
- **Custom**: PenguinMails Lead Score, Total Opens, Total Clicks.

### Companies

- **Sync**: Automatically link contacts to companies based on domain matching (`company_domain` → HubSpot `domain`).
- **Intelligence**: Sync industry and company size into PenguinMails for segmentation.

## Timeline Events

Marketing activities are synced to the HubSpot contact timeline as specialized event types:

- `penguinmails_email_sent`
- `penguinmails_email_opened`
- `penguinmails_email_clicked`

## Automation Sync

- **Workflow Enrollment**: High lead scores in PenguinMails can automatically enroll the HubSpot contact into sales workflows (e.g., "SQL Priority Queue").
- **Segment Sync**: HubSpot list membership changes trigger segment updates within PenguinMails.
