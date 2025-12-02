---
title: "Frontend Routing Map & Architecture"
description: "Comprehensive map of the application's routing structure, access control, and content requirements for Next.js 15"
last_modified_date: "2025-11-20"
level: "2"
persona: "Product Designers & Developers"
---

# Frontend Routing Map & Architecture

**Purpose**: This document defines the complete routing structure for the PenguinMails frontend application (Next.js 15). It serves as the blueprint for navigation, access control, and page-level requirements.

---

## 1. Routing Philosophy

* **Single Application**: One Next.js application serves all user types (Super Admin, Admin, Tenant).

* **Role-Based Rendering**: Routes are protected by middleware; content adapts based on the user's role.

* **Dashboard Layout**: The `/dashboard` path serves as the layout wrapper for all authenticated/private routes.

* **Internationalization (i18n)**: Non-English routes are prefixed with the language code (e.g., `/es/dashboard/...`). The default language (English) uses the root path.

* **Dynamic Dashboards**: The `/dashboard` home route is a smart traffic controller that renders the appropriate view for the user's primary role.

* **Resource-Oriented**: URLs follow a RESTful resource pattern (e.g., `/dashboard/campaigns/[id]`).

---

## 2. Route Reference Map

### 2.1 [Public & Authentication Routes](/docs/design/routes/public-auth)

| Path | Access | Purpose | Key Data/Components & Strategy |
|---|---|---|---|
| `/` | Public | Marketing landing page | **Static Generation (SSG)**<br>Hero, Features, Pricing, "Get Started" |
| `/login` | Public | User sign-in | **Client Component**<br>Email/Password form, SSO buttons, "Forgot Password" |
| `/register` | Public | New account creation | **Client Component**<br>Registration form, Plan selection |
| `/forgot-password` | Public | Password recovery request | Email input field |
| `/reset-password` | Public | Password reset execution | New password form (requires token) |
| `/verify-email` | Public | Email verification | Verification status message, "Continue" button |
| `/status` | Public | System health status | **Revalidate: 60s**<br>Component status (API, SMTP), Incident history |
| `/unauthorized` | Public | Access Denied page | Generic "403 Forbidden" message, "Back to Dashboard" button |

### 2.2 [Core Application Routes](/docs/design/routes/core-app-structure)

| Path | Access | Purpose | Key Data/Components & Strategy |
|---|---|---|---|
| `/dashboard` | **All Authenticated** | Primary landing. Renders role-specific view. | **Server Component + Suspense**<br>**Super Admin**: Executive Pulse (Metrics)<br>**Admin**: Ops Watchtower (Queues/Logs)<br>**Tenant**: Campaign Stats, Recent Activity<br>**Agency**: Client Health Matrix |
| `/dashboard/onboarding` | **Tenant** | Initial setup for new tenants. | **Wizard State (Client)**<br>1. Workspace Creation<br>2. Domain Setup<br>3. Email Account Setup<br>4. Payment/Plan |

### 2.3 [Workspace: Campaigns](/docs/design/routes/workspace-campaigns)

Scoped to a specific workspace (`/dashboard/workspaces/[slug]/...`).

| Path | Access | Purpose | Key Data/Components & Strategy |
|---|---|---|---|
| `/dashboard/workspaces/[slug]` | Agency, Tenant | Workspace Dashboard. | **Context Switch**<br>Workspace Health, Recent Activity |
| `/dashboard/workspaces/[slug]/campaigns` | Agency, Tenant | List workspace campaigns. | **Paginated Server Data**<br>Data Table, Filters, "Create New" |
| `/dashboard/workspaces/[slug]/campaigns/new` | Agency, Tenant | Create new campaign. | **Client State**<br>Template selector, Settings form |
| `/dashboard/workspaces/[slug]/campaigns/[id]` | Agency, Tenant | Campaign Analytics. | **Aggregated Data (Daily)**<br>Engagement charts, Heatmap |
| `/dashboard/workspaces/[slug]/campaigns/[id]/edit` | Agency, Tenant | Campaign Editor. | **Local State + Auto-Save**<br>Sequence builder, Subject line |
| `/dashboard/workspaces/[slug]/campaigns/[id]/settings` | Agency, Tenant | Campaign configuration. | Schedule settings, Audience selection, Sender profile |

### 2.4 [Workspace: Templates](/docs/design/routes/workspace-templates)

Scoped to a specific workspace.

| Path | Access | Purpose | Key Data/Components & Strategy |
|---|---|---|---|
| `/dashboard/workspaces/[slug]/templates` | Agency, Tenant | Workspace Templates. | **Filtered Server Data**<br>Grid view, Categories, Search |
| `/dashboard/workspaces/[slug]/templates/new` | Agency, Tenant | Create a new template. | Easy to use editor, Metadata form |
| `/dashboard/workspaces/[slug]/templates/[id]` | Agency, Tenant | Preview template details. | Template preview (Iframe), Usage stats |
| `/dashboard/workspaces/[slug]/templates/[id]/edit` | Agency, Tenant | Edit template content. | **Auto-Save**<br>Editor, Tag management, Version history |

### 2.5 [Workspace: Domains & Infrastructure](/docs/design/routes/workspace-domains)

Scoped to a specific workspace.

| Path | Access | Purpose | Key Data/Components & Strategy |
|---|---|---|---|
| `/dashboard/workspaces/[slug]/domains` | Agency, Tenant | Workspace Domains. | **Cached Server Data**<br>Domain table, Deliverability stats |
| `/dashboard/workspaces/[slug]/domains/new` | Agency, Tenant | Register a new domain. | Domain input, DNS instruction wizard |
| `/dashboard/workspaces/[slug]/domains/[id]` | Agency, Tenant | Domain Details. | DNS Status, Email Accounts list |
| `/dashboard/workspaces/[slug]/domains/[id]/settings` | Agency, Tenant | Domain configuration. | DNS records, Tracking settings, DKIM/SPF rotation |
| `/dashboard/workspaces/[slug]/domains/[id]/emails/new` | Agency, Tenant | Create email account. | Username input, Password/Access setup |
| `/dashboard/workspaces/[slug]/domains/[id]/emails/[emailId]` | Agency, Tenant | Email account status. | Health score, Sending limits, Daily stats |
| `/dashboard/workspaces/[slug]/domains/[id]/emails/[emailId]/warmup` | Agency, Tenant | Warmup management. | Warmup progress graph, Ramp-up settings |

### 2.6 [Tenant: Leads (Global)](/docs/design/routes/tenant-leads)

Global to the tenant account.

| Path | Access | Purpose | Key Data/Components & Strategy |
|---|---|---|---|
| `/dashboard/leads` | Agency, Tenant | Global Leads Management. | All leads across all workspaces (or filtered) |
| `/dashboard/leads/[id]` | Agency, Tenant | View lead details. | Lead profile, Activity history, List memberships |
| `/dashboard/leads/[id]/edit` | Agency, Tenant | Edit lead information. | Lead details form, Custom fields, Tags |
| `/dashboard/leads/segments` | Agency, Tenant | Manage lead segments. | List of segments, Segment builder (Rules engine) |
| `/dashboard/leads/lists` | Agency, Tenant | Static lists management. | List of static lists, "Create List" |

### 2.7 [Tenant: Unified Inbox](/docs/design/routes/tenant-inbox)

Aggregated from all workspaces.

| Path | Access | Purpose | Key Data/Components & Strategy |
|---|---|---|---|
| `/dashboard/inbox` | Agency, Tenant | Unified Inbox. | **Fetch on Load**<br>Aggregated replies, "Refresh" button |
| `/dashboard/inbox/[threadId]` | Agency, Tenant | Thread View. | **Optimistic UI**<br>Message history, Reply editor |
| `/dashboard/inbox/[threadId]/reply` | Agency, Tenant | Send a reply. | Reply editor, Template selector, Attachment uploader |

### 2.8 [Workspace Management](/docs/design/routes/workspace-management)

Management of the workspaces themselves.

| Path | Access | Purpose | Key Data/Components & Strategy |
|---|---|---|---|
| `/dashboard/workspaces` | Agency | List of managed workspaces. | **Tenant Command Center**<br>Client Health Matrix, Revenue Aggregation |
| `/dashboard/workspaces/new` | Agency, Tenant | Create a new workspace. | Workspace details form, Plan selection |
| `/dashboard/workspaces/[slug]/settings` | Agency, Tenant | Workspace configuration. | Branding settings, Billing settings, Member management |

### 2.9 [Settings & Organization](/docs/design/routes/settings)

| Path | Access | Purpose | Key Data/Components & Strategy |
|---|---|---|---|
| `/dashboard/settings/profile` | All Authenticated | Personal user settings. | Name, Email, Password, 2FA, Notifications |
| `/dashboard/settings/organization` | Admin, Owner | Organization details. | Company Name, Logo, Timezone, Domain verification |
| `/dashboard/settings/team` | Admin, Owner | Team member management. | User list, Invite modal, Role assignment |
| `/dashboard/settings/billing` | Admin, Owner | Subscription and payment. | Current plan, Invoices, Payment methods |
| `/dashboard/settings/infrastructure` | Admin, Owner | Dedicated Infrastructure management. | **Snapshot on Load**<br>SMTP Server Health, IP Reputation |

### 2.10 [Platform Administration (Internal Only)](/docs/design/routes/platform-admin)

| Path | Access | Purpose | Key Data/Components & Strategy |
|---|---|---|---|
| `/dashboard/users` | Internal (Admin) | Global user management. | User search, Audit Trail Viewer, Ban/Suspend |
| `/dashboard/tenants` | Internal (Admin) | Global tenant/org management. | Tenant list, Plan overrides, Feature flags |
| `/dashboard/finance` | Internal (Finance) | Revenue and billing ops. | Stripe sync status, MRR breakdown, Refund tools |
| `/dashboard/system/queues` | Internal (Ops) | Background job monitoring. | **Snapshot + Manual Refresh**<br>Hybrid PostgreSQL + Redis queue system (Jobs processing, Failed, Delayed) |
| `/dashboard/system/infrastructure` | Internal (Ops) | Global Infrastructure Health. | **Snapshot on Load**<br>Problematic Nodes, IP Blacklist Monitor |
| `/dashboard/system/logs` | Internal (Ops) | System logs and errors. | **Paginated History**<br>Log viewer, Error aggregation (Sentry feed) |
| `/dashboard/system/maintenance` | Internal (Ops) | Maintenance controls. | "Maintenance Mode" toggle, Cache clearing |

---

## 3. Navigation Structure

### 3.1 Sidebar Navigation (Context-Aware)

The sidebar changes based on the user's role and current context (Global vs. Workspace).

## Global Context (Tenant/Agency Root)

* Dashboard (Overview)

* Inbox (Unified)

* Leads (Global)

* Workspaces (List)

* Settings

## Workspace Context (Inside a Workspace)

* *Back to Global Dashboard*

* **[Workspace Name]**

* Dashboard (Workspace Stats)

* Campaigns

* Templates

* Domains

* Settings (Workspace)

## Super Admin View

* Dashboard (Executive Pulse)

* User Management

* Tenant Management

* System Ops

  * Queues

  * Logs

* Finance

### 3.2 Top Navigation

* **Breadcrumbs**: Contextual navigation (e.g., `Campaigns > Summer Sale > Edit`).

* **Global Search**: Search for campaigns, contacts, or (for admins) users.

* **User Menu**: Profile, Organization Switcher (if multi-tenant), Logout.

* **Help/Support**: Link to documentation or support chat.

---

## 4. Implementation Notes

### 4.1 Middleware Protection

All routes under `/dashboard` must be protected by Next.js middleware:

1. **Authentication**: Is the user logged in?

2. **Authorization**: Does the user have the required role?

3. **Tenant Context**: Does the user have access to the requested resource ID?

### 4.2 Dynamic Routing & Context

* **Resource IDs**: `app/campaigns/[campaignId]/page.tsx`

* **Workspace Context**: For agencies accessing a client workspace (`/dashboard/workspaces/[slug]`), the UI should visually indicate the context switch (e.g., "Viewing as [Client Name]").

### 4.3 Layouts

* **Public Layout**: Simple header/footer.

* **App Layout**: Sidebar, Topbar, Auth Context.

* **Admin Layout**: Distinct visual theme (e.g., red accent) for privileged context.
