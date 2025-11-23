# Platform Administration (Internal)

## 1. Purpose & Context (The "Why")

- **Goal**: Internal tools for PenguinMails staff to manage the platform, support users, and monitor health.
- **Feature References**:
  - [Internal Views](/docs/core-features/analytics/specs/internal-views)
  - [Operations Analytics](/docs/operations-analytics/overview)
- **User Journey**: Support ticket → Admin looks up user → Reviews audit trail to debug.

## 2. UI Patterns & Components (The "How")

- **Core Components**:
  - `AdminTable`: High-density table with raw data views.
  - `JSONViewer`: For viewing raw logs/payloads.
  - `StatusIndicator`: Traffic light system for service health.
- **Analytics Patterns**:
  - `ExecutiveDashboard`: See [Internal Views](/docs/core-features/analytics/specs/internal-views).
- **Layout**: Admin Context (Distinct visual theme).

## 3. Route Specifications

| Route | Access | Purpose | State/Data Requirements |
|---|---|---|---|
| `/dashboard/users` | Super Admin | Global Users | Searchable list of ALL users. Actions: Ban, Reset Password, **View Audit Trail**. |
| `/dashboard/tenants` | Super Admin | Global Tenants | List of organizations. Plan overrides, Feature flags management. |
| `/dashboard/finance` | Finance | Revenue Ops | Stripe sync status, MRR dashboard. |
| `/dashboard/system/queues` | Ops | Queue Health Monitor | Custom UI for hybrid PostgreSQL + Redis queue system. Job retry controls. |
| `/dashboard/system/logs` | Ops | System Logs | Log viewer (Elasticsearch/ClickHouse interface). |

## 4. Detailed View Descriptions

### `/dashboard/users` - Global User Management

**User Story**: *"As a support admin, I want to quickly look up any user, view their account details, and review their audit trail to debug issues, so I can resolve tickets faster."*

**What You'll Find**:

#### Search & Filter

- **Global Search Bar** (Prominent):
  - Placeholder: "Search by email, name, or user ID".
  - **Autocomplete**: Shows results as you type.

- **Filters**:
  - Role: All, Owner, Admin, Member.
  - Status: Active, Suspended, Deleted.
  - Plan: Free, Pro, Enterprise.

#### Users Table

- **Columns**: UserID, Name, Email, Plan, Tenant, Status, Created Date, Last Login, Actions.
- **Color Coding**:
  - Suspended users: Red background.
  - Churned users (plan expired): Orange.

- **Row Actions** (Gear icon):
  - **View Details**: Opens modal with full user profile, activity log.
  - **View Audit Trail**: Opens comprehensive audit viewer.
    - **Audit Viewer Modal**: Shows complete user action history with filters.
    - **Searchable Timeline**: Logins, campaign actions, settings changes, API calls.
    - **Export Capability**: Download audit trail as CSV for detailed analysis.
  - **Reset Password**: Sends reset email.
  - **Suspend Account**: Confirmation modal, reason required.
  - **Delete Account** (GDPR): Hard delete, irreversible.

#### Audit Trail Viewer

- **Modal or Slide-over** when clicking "View Audit Trail":
  - **Activity Timeline**: Logins, Campaign Creates, Settings Changes, API Calls.
  - **Support Access Log**: Admin views and support ticket references.
  - **Filters**: Date range, action type, IP address.
  - **Search**: Full-text search across all audit entries.
  - **Export**: Download filtered results as CSV.

> [!NOTE]
> **Database Schema**: References audit log table from database documentation (verification needed - see Phase 4).
> **API Endpoint**: Requires executive/platform API endpoint for audit trail retrieval (verification needed - see Phase 4).

**User Journey Context**: Reactive (support-driven). Must be fast and auditable.

**Related Documentation**:

- [Support Processes](/docs/customer-success/support-playbooks/account-lookup)
- [GDPR Compliance](/docs/compliance-security/data-privacy/gdpr)

**Technical Integration**:

- **Audit Trail**: Comprehensive logging of all user actions with retention policy.
- **Search**: Elasticsearch for fast full-text search across millions of users and audit entries.
- **Database Reference**: Audit log table schema (to be verified in Phase 4).
- **API Reference**: Executive/Platform API audit trail endpoint (to be verified in Phase 4).

---

### `/dashboard/tenants` - Tenant (Organization) Management

**User Story**: *"As a platform admin, I want to manage tenant accounts, override plans, and enable beta features, so I can support sales and customer success."*

**What You'll Find**:

#### Tenants Table

- **Columns**: Tenant ID, Company Name, Owner Email, Plan, MRR, Workspaces, Users, Status, Created, Actions.
- **MRR Column**: Monthly Recurring Revenue (sortable).

- **Filters**:
  - Plan: All, Free, Pro, Enterprise.
  - Status: Active, Trial, Churned.

#### Row Actions

- **View Details**: Opens tenant's workspace overview and audit trail in read-only mode.
- **Edit Plan**:
  - **Modal**: Override plan (e.g., upgrade to Enterprise, add custom limits).
  - **"Apply Custom Pricing" Checkbox**: For negotiated deals.
- **Feature Flags**:
  - **Modal**: List of beta features with toggles.
  - Example: "Enable Advanced Analytics", "Allow 100k Emails/month".
- **Billing Override**:
  - Comps (free service), Extended trial, Custom billing cycle.

#### Quick Actions (Top Bar)

- **"Create Test Tenant" Button**: Provisions sandbox account for demos.

**User Journey Context**: Account management and  sales support.

**Related Documentation**:

- [Feature Flags](/docs/technical/feature-management/flags)
- [Sales SLA](/docs/business/sales/contract-management)

**Technical Integration**:

- **Feature Flags**: LaunchDarkly or internal flags table.
- **Plan Overrides**: Stored in `tenant_overrides` table, checked before billing.

---

### `/dashboard/finance` - Revenue Operations

**User Story**: *"As a finance admin, I want to monitor Stripe sync status and MRR trends, so I can reconcile revenue and forecast growth."*

**What You'll Find**:

#### MRR Dashboard (see [Analytics UI Patterns](/docs/design/analytics-ui-patterns#data-cards))

- **Headline Metrics**:
  - **Current MRR**: $45,230.
  - **MRR Growth**: +12% MoM.
  - **Active Subscriptions**: 234.
  - **Churn Rate**: 3.2%.

- **MRR Trend Chart**:
  - **Line Chart**: Monthly MRR for last 12 months.
  - **Drill-down**: Click to see breakdown by plan.

#### Stripe Sync Status

- **Last Sync**: "5 minutes ago".
- **Sync Health**:
  - ✅ All invoices synced.
  - ⚠️ 3 failed payments (links to details).

- **"Force Sync Now" Button**: Manually triggers webhook replay.

#### Financial Reports

- **Export Buttons**:
  - "Export MRR Report (CSV)".
  - "Export Invoice Summary (PDF)".

- **Filters**:
  - Date range.
  - Plan type.

**User Journey Context**: Monthly financial close and ad-hoc analysis.

**Related Documentation**:

- [Finance Processes](/docs/finance/reporting/mrr-calculation)
- [Stripe Webhooks](/docs/technical/integrations/stripe)

**Technical Integration**:

- **Stripe Webhook Events**: `invoice.paid`, `customer.subscription.deleted`, etc.
- **MRR Calculation**: Aggregated from subscriptions table, cached daily.

---

### `/dashboard/system/queues` - Background Job Monitoring

**User Story**: *"As an ops engineer, I want to monitor the hybrid PostgreSQL + Redis job queues for failures and delays, so I can ensure system reliability."*

**What You'll Find**:

#### Queue Dashboard

##### Custom UI for Hybrid Queue System

- **Queue List** (PostgreSQL + Redis monitoring):
  - Columns: Queue Name, Active Jobs, Waiting, Completed (last hour), Failed, Actions.
  - **Queue Names**: `queue:email-sending:high`, `queue:email-sending`, `queue:email-sending:low`, `queue:analytics:daily-aggregate`, `queue:warmup:process`, etc.

- **Per-Queue Actions**:
  - **View Details**: Shows job list.
  - **Pause Queue**: Emergency stop.
  - **Resume Queue**.

#### Job Details (Click on failed job)

- **JSON Viewer**:
  - Shows job data (e.g., campaign ID, recipient list).
  - Error stack trace.

- **Actions**:
  - **Retry Job**: Re-queues the job.
  - **Delete Job**: Removes from queue.

**User Journey Context**: Reactive troubleshooting. Accessed during incidents.

**Related Documentation**:

- [Queue System Implementation](/docs/technical/architecture/detailed-technical/queue-system-implementation)
- [Incident Response](/docs/operations/incident-management/runbooks)

**Technical Integration**:

- **Hybrid Architecture**: PostgreSQL for durable state + Redis for fast processing.
- **Monitoring**: Real-time queue depth tracking and job status monitoring.
- **Database Tables**: `jobs`, `job_queues`, `job_logs` (reference to be verified in Phase 4).
- **API Endpoint**: Executive/Platform API queue monitoring endpoint (to be verified in Phase 4).
- **Alerting**: PagerDuty integration for critical failures.

---

### `/dashboard/system/infrastructure` - System Health Monitoring

**User Story**: *"As an ops engineer, I want a real-time view of server health and IP reputation, so I can detect and resolve issues before they impact users."*

**What You'll Find**:

#### Service Health Grid (see [Analytics UI Patterns](/docs/design/analytics-ui-patterns))

- **Status Cards** (Traffic light):
  - **API Server**: ✅ Healthy (Response time: 120ms).
  - **SMTP Service**: ⚠️ Degraded (Queue backlog: 5,000 emails).
  - **Database (OLTP)**: ✅ Healthy.
  - **Database (OLAP)**: ✅ Healthy.

#### IP Reputation Monitor

- **Table**: IP Address, Provider, Reputation Score, Blacklists, Daily Volume, Status.
- **Alerts**: "IP 203.0.113.12 listed on Spamhaus (detected 2 hours ago)".

#### Infrastructure Alerts

- **Alert Feed** (Last 24 hours):
  - Timestamp, Severity, Service, Message.
  - Example: "ERROR | SMTP | Queue size exceeded 10k threshold".

**User Journey Context**: Proactive monitoring. Reviewed multiple times daily.

**Related Documentation**:

- [Infrastructure Overview](/docs/technical/infrastructure/server-architecture)
- [Monitoring Setup](/docs/operations/monitoring/prometheus-grafana)

**Technical Integration**:

- **Prometheus + Grafana**: Metrics collection and visualization.
- **ClickHouse**: Stores historical metrics.
- **PagerDuty**: Alerts for critical issues.

---

### `/dashboard/system/logs` - System Log Viewer

**User Story**: *"As a developer debugging a production issue, I want to search and filter application logs, so I can trace errors to their source."*

**What You'll Find**:

#### Log Search Interface

- **Search Bar**:
  - Placeholder: "Search logs (e.g., errors, user email, request ID)".
  - Supports regex.

- **Filters** (Sidebar):
  - **Level**: Error, Warning, Info, Debug.
  - **Service**: API, SMTP, Queue, Web.
  - **Time Range**: Last hour, Last 24 hours, Custom.

#### Log Results

- **Table or List View**:
  - Columns: Timestamp, Level, Service, Message, User/Request ID.
  - **Color Coding**: Errors (Red), Warnings (Yellow).

- **Expandable Rows**:
  - Click to see full log entry with metadata (stack trace, context).

#### Export

- **"Export to CSV" Button**: For further analysis.

**User Journey Context**: Debugging production issues. High-stress, time-sensitive.

**Related Documentation**:

- [Logging Standards](/docs/technical/observability/logging)
- [Error Tracking](/docs/operations/monitoring/sentry-integration)

**Technical Integration**:

- **Elasticsearch**: Centralized log aggregation.
- **Sentry**: Error tracking and alerting (linked from error logs).

---

### Admin-Specific UI Theme

**User Story**: *"As an admin, I want a visually distinct interface, so I always know when I'm in admin mode and avoid accidental changes."*

**Visual Differences**:

- **Color Scheme**: Dark orange accent (vs. blue for users).
- **Sidebar Header**: "Admin Panel" label.
- **Context Indicator**: Banner showing current admin context (e.g., "Viewing as Admin").

**Related Documentation**:

- [Design Tokens](/docs/design/design-tokens)

## 5. Related API Endpoints

| Route | Related API | Description |
|---|---|---|
| `/users` | [Admin API](/docs/implementation-technical/api/platform-api/admin) | `GET /api/v1/platform/admin/users` (List), `GET .../audit` (Audit Trail). |
| `/tenants` | [Admin API](/docs/implementation-technical/api/platform-api/admin) | `GET /api/v1/platform/admin/tenants` (List), `PATCH` (Overrides). |
| `/finance` | [Subscriptions API](/docs/implementation-technical/api/platform-api/subscriptions) | `GET /api/v1/platform/subscriptions/mrr` (Revenue stats). |
| `/system/queues` | [Queue API](/docs/implementation-technical/api/queue/jobs) | `GET /api/v1/queue/stats` (Monitor), `POST .../retry` (Actions). |

## 6. Data Strategy

- **Fetching Method**:
  - **Tables (Users/Tenants)**: Server Components with searchParams.
  - **Real-time Dashboards (Queues/Logs)**: Client Components with polling (every 5s) or WebSocket.
- **Caching**:
  - **Aggregated Metrics (MRR)**: Cached for 1 hour.
  - **Logs**: No caching (live stream).
- **Pagination**:
  - **Offset-based** for admin tables (need "Jump to page X").
- **Access Control**:
  - Strict RBAC checks on every data fetch (Super Admin vs Support vs Finance).

## 7. Edge Cases & Error Handling

- **Tenant Not Found**: Accessing `/tenants/[id]` with invalid ID → 404 Page.
- **Insufficient Permissions**: Support role accessing Finance dashboard → 403 Forbidden.
- **Queue Action Failures**: If "Retry All Failed Jobs" partially fails, show "Retried 45/50. 5 jobs still stuck."
- **Log Stream Overflow**: If logs exceed buffer, show "Logs truncated. Download full logs?" with export link.

## 8. Component Architecture

### Page Components

- **`AdminDataTable`** (Server/Client)
  - Generic table with sorting, filtering, and bulk actions.
  - Props: `data: T[]`, `columns: ColumnDef<T>[]`.
- **`QueueMonitor`** (Client)
  - Features: Real-time polling of job counts, "Retry" actions.
  - Sub-components: `QueueCard`, `JobList`.
- **`LogViewer`** (Client)
  - Features: Virtualized scroll, regex search, "Follow tail" mode.

### Shared Components

- **`JSONViewer`**: For inspecting job payloads and audit logs.
- **`StatusDot`**: Real-time health indicator (Green/Red/Blinking).
