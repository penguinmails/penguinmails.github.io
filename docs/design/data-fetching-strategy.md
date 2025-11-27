---
title: "Frontend Data Fetching & State Strategy"
description: "Strategy for data fetching, caching, real-time updates, and state management in the Next.js 15 frontend"
last_modified_date: "2025-11-20"
level: "2"
persona: "Developers"
---


# Frontend Data Fetching & State Strategy

**Purpose**: This document defines how the frontend application fetches, caches, and manages data, ensuring performance and consistency across complex user journeys.

---

## 1. Core Principles

* **Server-First**: Leverage Next.js Server Components for initial data fetching.

* **Stale-While-Revalidate**: Use `swr` or React Query (TanStack Query) for client-side revalidation and polling.

* **Optimistic UI**: Implement optimistic updates for high-interaction areas (Inbox, Editors).

## 2. Fetching Strategies by Route Type

### 2.1 Static / Low-Frequency Data

* **Strategy**: Server Components with standard `fetch` caching.

* **Revalidation**: On-demand (Server Actions) or Time-based (e.g., 1 hour).

### 2.2 Interactive Data (MVP Strategy)

* **Routes**: `/dashboard/inbox`, `/dashboard/workspaces/[slug]/campaigns/[id]`

* **Strategy**:

    1. **Initial Load**: Server Component fetches current state (Snapshot).

    2. **Updates**: User-initiated "Refresh" button re-runs the Server Action or router refresh.

    3. **Note**: Real-time WebSockets/SSE are planned for Post-MVP.

* **Specifics**:

  * **Inbox**: Fetches latest threads on load. No auto-update for new emails while open.

  * **Campaign Stats**: Daily/Hourly aggregated stats. Not live counters.

  * **Infra Status**: Health check performed on page load.

### 2.3 Dashboard & Analytics

* **Routes**: `/dashboard` (Executive/Agency views)

* **Strategy**: Parallel fetching with React Suspense.

* **Data Freshness**: Data is typically aggregated (e.g., "Last 24 Hours" or "Yesterday").

* **Caching**: Heavy caching (1-24 hours) for expensive analytical queries.

## 3. Complex Component Requirements

### 3.1 Unified Inbox (`/dashboard/inbox`)

* **Data**:

  * `threads`: Paginated list (Infinite Scroll).

  * `threadDetail`: Full message history.

  * `templates`: Cached locally.

* **State**:

  * `optimisticMessage`: Show sent message immediately before server confirmation.

  * `readStatus`: Optimistic update on click.

### 3.2 Campaign Editor (`/dashboard/workspaces/[slug]/campaigns/[id]/edit`)

* **Data**:

  * `campaignDraft`: JSON structure of the email.

* **State**:

  * **Local Storage**: Save draft every keystroke/change to `localStorage`.

  * **Auto-Save**: Debounced Server Action (every 5s) to backend.

### 3.3 Ops Monitor (`/dashboard/system/queues`)

* **Data**:

  * `jobCounts`: Snapshot of current queue depths.

* **Strategy**: Fetch on load. Manual "Refresh Stats" button for operators.

## 4. Error & Loading States

* **Global Loading**: Top-level progress bar (NProgress equivalent).

* **Skeleton Screens**: Required for all Dashboard and Inbox views.

* **Error Boundaries**: Per-widget error handling in Dashboards (one failed widget shouldn't crash the page).

## 5. Integration with Backend

* **BFF Pattern**: Next.js Server Actions act as the Backend-for-Frontend, aggregating calls to `api`, `smtp-server`, and `executive-api`.

* **Type Safety**: Shared types package ensures frontend/backend contract alignment.
