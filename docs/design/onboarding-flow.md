---
title: "Onboarding Flow"
description: "User onboarding experience design and flow"
last_modified_date: "2025-11-24"
type: "design"
status: "DRAFT"
---

# Onboarding Flow Design

**Design specification for the new user onboarding experience.**

---

## Goals

1. **Reduce Time to Value**: Get users sending their first email in < 5 minutes.
2. **Configuration**: Set up essential workspace settings (Domain, Sender).
3. **Education**: Introduce key concepts (Campaigns, Contacts).

---

## Flow Steps

### 1. Welcome & Intent

*Screen: "Welcome to PenguinMails"*

- **Goal**: Understand user persona.
- **Question**: "What do you want to do first?"
  - [ ] Send a Newsletter
  - [ ] Set up Transactional Emails
  - [ ] Cold Outreach

### 2. Workspace Setup

*Screen: "Name your Workspace"*

- **Input**: Workspace Name (e.g., "Acme Marketing")
- **Input**: Company Website
- **Action**: Auto-fetch logo from website favicon.

### 3. Domain Connection (Optional but Recommended)

*Screen: "Connect your Domain"*

- **Input**: Domain Name
- **Display**: DNS Records to copy.
- **Skip Option**: "I'll do this later" (Use shared domain for testing).

### 4. Import Contacts

*Screen: "Add your Audience"*

- **Action**: Upload CSV or Manual Entry.
- **Sample**: "Add me as a test contact" button.

### 5. First Campaign

*Screen: "Create your first email"*

- **Action**: Select a template.
- **Editor**: Simple text edit.
- **Send**: Send test email to self.

---

## UI Components

- **Progress Bar**: "Step 2 of 5"
- **Checklist**: "Setup Guide" widget in dashboard (persistent).
- **Tooltips**: Contextual help on first hover.

---

## Success Metrics

- **Activation Rate**: % of signups who send an email within 24 hours.
- **Setup Completion**: % of users who verify a domain within 7 days.

---

**Last Updated:** November 24, 2025
**Status:** In Design
