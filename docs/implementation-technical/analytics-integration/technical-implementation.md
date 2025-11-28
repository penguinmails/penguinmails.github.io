---
title: "Analytics Implementation Details"
description: "Technical specifications, code snippets, and architecture for the analytics views"
---


# Analytics Implementation Details

## 1. Technical Stack (MVP)

* **Frontend**: Next.js 15 (App Router) + TypeScript + Tailwind CSS

* **Backend**: Node.js + TypeScript + Hapi/Koa

* **Monorepo**: Turborepo for shared packages

* **Post-MVP Migration Path**: TanStack Router or React Router 7 (to reduce cloud function costs)

### Turborepo Structure

```bash
penguinmails/
├── apps/
│   ├── web/                    # Next.js 15 frontend (all user-facing UI)
│   │   ├── app/
│   │   │   ├── dashboard/
│   │   │   ├── analytics/
│   │   │   └── actions/        # Server actions (BFF pattern, MVP)
│   │   └── middleware.ts       # Auth & RBAC
│   ├── api/                    # Tenant-facing REST API (Node + Hapi/Koa)
│   │   ├── src/
│   │   │   ├── routes/         # Tenant operations, campaign management
│   │   │   ├── middleware/     # Auth, rate limiting
│   │   │   └── services/
│   │   └── server.ts
│   ├── smtp-server/            # Central SMTP operations server
│   │   ├── src/
│   │   │   ├── routes/         # IP management, pool routing
│   │   │   ├── operations/     # Reputation tracking
│   │   │   └── admin/          # Internal SMTP admin endpoints
│   │   └── server.ts
│   ├── queue-server/           # Event processing & job queue server
│   │   ├── src/
│   │   │   ├── workers/        # Queue job processors
│   │   │   ├── events/         # Event handlers
│   │   │   ├── routes/         # Queue & events REST API
│   │   │   └── notifications/  # Notification system
│   │   └── server.ts
│   └── executive-api/          # Executive & analytics aggregation API
│       ├── src/
│       │   ├── routes/         # System overview, BI endpoints
│       │   ├── aggregators/    # Data aggregation from backbone
│       │   └── intelligence/   # Analytics processing
│       └── server.ts
├── packages/
│   ├── database/               # Shared Drizzle ORM client
│   ├── auth/                   # RBAC utilities
│   ├── types/                  # Shared TypeScript types
│   ├── config/                 # Shared secrets/env
│   └── queue/                  # Shared queue client
└── turbo.json


```

### Server Responsibilities

| Server | Purpose | Port | Access |
|--------|---------|------|--------|
| **web** | Next.js frontend + Server Actions | 3000 | Public (customers, agencies, internal) |
| **api** | Tenant-facing REST API | 4000 | Public (authenticated tenants) |
| **smtp-server** | SMTP infrastructure management | 4001 | Internal only (admins, ops) |
| **queue-server** | Event processing & notifications | 4002 | Internal only |
| **executive-api** | Analytics aggregation & BI | 4003 | Internal only (exec, ops, analysts) |

## 2. RBAC Implementation with Next.js 15

### Shared Type Definitions (`packages/types/src/rbac.ts`)

```typescript
export type UserRole =
  | 'admin'
  | 'ops'
  | 'exec'
  | 'customer'
  | 'agency'
  | 'investor'
  | 'public';

export interface UserSession {
  userId: string;
  roles: UserRole[];
  permissions: string[];
  tenantId?: string; // For multi-tenant agency view
}

export interface DashboardViewConfig {
  role: UserRole;
  allowedRoutes: string[];
  defaultRedirect: string;
}


```

### Next.js Middleware (`apps/web/middleware.ts`)

```typescript
import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';
import { getSession } from '@penguinmails/auth';

export async function middleware(request: NextRequest) {
  const session = await getSession(request);

  // Public routes
  if (request.nextUrl.pathname.startsWith('/status')) {
    return NextResponse.next();
  }

  // Protected routes require authentication
  if (!session) {
    return NextResponse.redirect(new URL('/login', request.url));
  }

  // RBAC: Check if user has required role for route
  const routeRoleMap: Record<string, UserRole[]> = {
    '/analytics/executive': ['admin', 'exec'],
    '/ops': ['admin', 'ops'],
    '/clients': ['agency'],
  };

  const requiredRoles = routeRoleMap[request.nextUrl.pathname];
  if (requiredRoles && !session.roles.some(r => requiredRoles.includes(r))) {
    return NextResponse.redirect(new URL('/unauthorized', request.url));
  }

  return NextResponse.next();
}

export const config = {
  matcher: ['/((?!_next|api|favicon.ico).*)'],
};


```

### Server Actions (BFF Pattern) (`apps/web/app/actions/analytics.ts`)

```typescript
'use server';

import { getSession } from '@penguinmails/auth';
import { db } from '@penguinmails/database';
import { redirect } from 'next/navigation';

export async function getExecutiveDashboard() {
  const session = await getSession();

  // Authorization check
  if (!session?.roles.includes('admin') && !session?.roles.includes('exec')) {
    redirect('/unauthorized');
  }

  // Fetch data - only accessible to admin/exec
  const metrics = await db.analytics.aggregate({
    where: { type: 'executive' },
    _sum: { mrr: true, users: true },
  });

  return {
    mrr: metrics._sum.mrr,
    users: metrics._sum.users,
    growth: await calculateGrowthRate(),
  };
}

export async function getCampaignAnalytics(campaignId: string) {
  const session = await getSession();

  // Check ownership: customer can only see their own campaigns
  const campaign = await db.campaign.findUnique({
    where: { id: campaignId },
    include: { tenant: true },
  });

  if (campaign.tenant.userId !== session.userId && !session.roles.includes('admin')) {
    throw new Error('Forbidden');
  }

  return {
    sent: campaign.sentCount,
    delivered: campaign.deliveredCount,
    opened: campaign.openedCount,
  };
}


```

### Role-Based UI Rendering (`apps/web/app/dashboard/page.tsx`)

```typescript
import { getSession } from '@penguinmails/auth';
import { ExecutivePulse } from '@/components/dashboards/executive';
import { CampaignDashboard } from '@/components/dashboards/campaign';
import { AgencyCommandCenter } from '@/components/dashboards/agency';

export default async function DashboardPage() {
  const session = await getSession();

  // Render different dashboard based on primary role
  if (session.roles.includes('admin') || session.roles.includes('exec')) {
    return <ExecutivePulse />;
  }

  if (session.roles.includes('agency')) {
    return <AgencyCommandCenter />;
  }

  if (session.roles.includes('customer')) {
    return <CampaignDashboard />;
  }

  return <div>No dashboard available for your role</div>;
}


```

### Central API Server (Post-MVP Migration Target) (`apps/api/src/routes/analytics.ts`)

```typescript
import Hapi from '@hapi/hapi';
import { requireRole } from '../middleware/auth';

export const analyticsRoutes: Hapi.ServerRoute[] = [
  {
    method: 'GET',
    path: '/analytics/executive',
    options: {
      pre: [{ method: requireRole(['admin', 'exec']) }],
    },
    handler: async (request, h) => {
      const metrics = await getExecutiveMetrics();
      return h.response(metrics).code(200);
    },
  },
];


```

## 3. Navigation Implementation

### Global Navigation Structure

```typescript
// Navigation items shown based on user roles
const navigationConfig = {
  admin: ['Dashboard', 'Analytics', 'Ops Monitor', 'Users', 'Settings'],
  exec: ['Dashboard', 'Analytics', 'Reports'],
  ops: ['Dashboard', 'Ops Monitor', 'Incidents', 'Logs'],
  customer: ['Dashboard', 'Campaigns', 'Analytics', 'Settings'],
  agency: ['Dashboard', 'Campaigns', 'Clients', 'Analytics', 'Reports'],
  investor: ['Dashboard', 'Metrics', 'Reports'],
  public: ['Status'],
};

// Frontend conditionally renders navigation
const AppNav = ({ userRoles }) => {
  const navItems = userRoles.flatMap(role => navigationConfig[role]);
  return <Nav items={[...new Set(navItems)]} />;
};


```

### Security Implementation

```typescript
// Frontend: Route protection
<ProtectedRoute
  path="/analytics/executive"
  allowedRoles={['admin', 'exec']}
  component={ExecutiveDashboard}
/>

// Backend: API authorization
router.get('/analytics/executive',
  authenticate, // Verify JWT token
  authorize(['admin', 'exec']), // Check user roles
  async (req, res) => {
    const data = await getExecutiveMetrics(req.user.roles);
    res.json(data);
  }
);


```
