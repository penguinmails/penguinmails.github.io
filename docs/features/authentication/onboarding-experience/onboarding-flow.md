---
title: "Onboarding Flow Walkthrough"
description: "Step-by-step guide through the PenguinMails user onboarding experience."
last_modified_date: "2026-02-24"
level: "2"
persona: "All Users"
---

## Level 1: Core Onboarding Flow

The onboarding flow is designed to get users from signup to their first sent campaign as quickly as possible.

### Step 1: Account Creation & Profile

- **Goal:** Gather basic user information and set expectations.
- **Workflow:**
  - Standard signup with email/password or OAuth.
  - Profile completion (name, role, company size).
  - Use-case selection (Internal Communications, Sales Outreach, Marketing).
- **UI Element:** Multi-step progress bar at the top of the viewport.

### Step 2: Workspace Setup

- **Goal:** Create a logical container for tenant resources.
- **Workflow:**
  - Workspace name and URL selection (slug).
  - Team member invitation (optional).
  - Integration selection (Stripe for billing, Hestia for email).
- **UI Element:** Animated workspace cards with clear selection indicators.

### Step 3: Domain Verification

- **Goal:** Establish sending authority.
- **Workflow:**
  - Add domain (e.g., `company.com`).
  - Retrieve DNS records (TXT, MX, CNAME).
  - Verify records via the HestiaCP integration.
- **UI Element:** Copy-to-clipboard DNS record table with real-time verification status.

### Step 4: First Mailbox Creation

- **Goal:** Set up an active sending address.
- **Workflow:**
  - Select verified domain.
  - Choose email address (e.g., `hello@company.com`).
  - Set display name and signature.
- **UI Element:** Simple form with live preview of the mailbox in an "Inbox" view.

### Step 5: Initial Lead Import

- **Goal:** Provide targets for the first campaign.
- **Workflow:**
  - CSV upload or manual entry.
  - Basic mapping (Email, First Name, Last Name).
  - Audience group creation.
- **UI Element:** Drag-and-drop file uploader with a column mapping table.

### Step 6: First Campaign Creation

- **Goal:** The "Aha!" moment of sending outreach.
- **Workflow:**
  - Select audience group.
  - Choose mailbox.
  - Write subject line and body (or use AI template).
  - Review and send.
- **UI Element:** Simplified campaign builder with "Quick Start" templates.
