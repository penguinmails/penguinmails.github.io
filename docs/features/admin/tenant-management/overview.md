---
title: "Tenant Management"
description: "Platform-wide organization management, plan overrides, and feature flags for PenguinMails internal staff"
last_modified_date: "2025-12-04"
level: "2"
persona: "Platform Administrators, Sales Operations"
status: "ACTIVE"
category: "Admin"
---

# Tenant Management

**Comprehensive tenant account management, plan customization, and beta feature enablement.**

---

## Overview

The Tenant Management feature enables PenguinMails internal staff to manage organizational accounts (tenants) across the platform. It provides tools for account oversight, custom pricing negotiations, feature flag management, and sales support.

### Key Capabilities

- **Tenant Discovery**: Search and filter all organizational accounts
- **Plan Overrides**: Apply custom pricing and limits for enterprise deals
- **Feature Flags**: Enable beta features and experimental functionality per tenant
- **Billing Customization**: Comps, extended trials, custom billing cycles
- **Test Tenant Provisioning**: Create sandbox accounts for demos and testing

---

## User Stories

### Sales Operations

> *"As a sales ops admin, I need to upgrade a prospect to Enterprise plan with custom pricing after they signed a contract for 15% off list price."*
>
> **Workflow**:
>
> 1. Navigate to `/dashboard/tenants`
> 2. Search for tenant by company name
> 3. Click "Edit Plan" action
> 4. Select "Enterprise" plan
> 5. Check "Apply Custom Pricing"
> 6. Enter negotiated pricing details
> 7. Save changes

### Product Manager

> *"As a product manager, I want to enable the new Advanced Analytics feature for 5 beta customers to gather feedback before general release."*
>
> **Workflow**:
>
> 1. Navigate to tenant list
> 2. For each beta customer:
>    - Click "Feature Flags"
>    - Toggle "Advanced Analytics" to ON
>    - Save changes
> 3. Monitor feature usage and feedback

### Customer Success

> *"As a customer success manager, I need to extend a trial by 14 days for a prospect who needs more time to evaluate the platform."*
>
> **Workflow**:
>
> 1. Search for tenant
> 2. Click "Billing Override"
> 3. Select "Extended Trial"
> 4. Set new trial end date (+14 days)
> 5. Add reason: "Requested by prospect for POC completion"
> 6. Save override

---

## Feature Components

### Tenant Discovery

- **Search Bar**: Search by tenant ID, company name, or owner email
- **Filters**:
  - Plan (Free, Pro, Enterprise)
  - Status (Active, Trial, Churned)
  - MRR range
  - Created date

### Tenant Table

- **Columns**: Tenant ID, Company Name, Owner Email, Plan, MRR, Workspaces, Users, Status, Created Date
- **Sortable**: By MRR, users, created date
- **Color Coding**:
  - Green: Active paying customers
  - Blue: Trial accounts
  - Grey: Churned/inactive

### Plan Override Management

- **Standard Plans**: Free, Pro, Enterprise
- **Custom Pricing**: Negotiated discounts and custom limits
- **Limit Overrides**:
  - Max users per tenant
  - Max domains
  - Max campaigns/month
  - Max emails/month
  - Storage limits

### Feature Flags

- **Beta Features**: Enable/disable experimental features
- **Enterprise Features**: Unlock advanced capabilities
- **Custom Features**: Per-tenant feature customization
- **Flag Types**:
  - Boolean toggles (on/off)
  - Percentage rollouts (e.g., 25% of users)
  - Allowlist-based (specific tenant IDs)

### Billing Overrides

- **Comps**: Grant free service for partnerships or marketing
- **Extended Trials**: Add days to trial period
- **Custom Billing Cycles**: Quarterly, annual, custom dates
- **Payment Method Overrides**: Invoice, ACH, wire transfer

### Test Tenant Provisioning

- **Quick Actions**: "Create Test Tenant" button
- **Sandbox Accounts**: Isolated environments for demos
- **Auto-Cleanup**: Scheduled deletion after expiration
- **Pre-Configured Data**: Sample campaigns and templates

---

## Integration Architecture

### Database Integration

- **Tenants Table**: Primary tenant metadata (OLTP)
- **Tenant Overrides Table**: Custom pricing and limits
- **Feature Flags Table**: Per-tenant feature toggles
- **Subscriptions Table**: Billing and plan information

### Feature Flag System

- **LaunchDarkly Integration** (optional): External feature flag management
- **Internal Flags Table**: Database-backed feature toggles
- **Evaluation**: Checked at request time with caching
- **Cache Strategy**: 5-minute TTL for flag state

### Billing Integration

- **Stripe**: Plan overrides don't affect Stripe directly
- **Application Logic**: Overrides checked before billing enforcement
- **Grandfathering**: Existing subscriptions unaffected by plan changes

---

## Technical Considerations

### Performance

- **Search**: Elasticsearch for fast tenant lookup *(2026 Spike)*
- **Caching**: Tenant metadata and flags cached for 5 minutes
- **Pagination**: Offset-based for large tenant lists (enables "Jump to page X" navigation)

### Security

- **Access Control**: Super Admin and Admin roles only
- **Audit Logging**: All tenant modifications logged
- **Change Tracking**: History of plan changes and flag updates

### Data Consistency

- **Override Validation**: Ensure custom limits are valid
- **Flag Propagation**: 5-minute delay for flag changes (cache invalidation)
- **Billing Sync**: Manual verification of Stripe vs internal state

---

## Related Documentation

### Route Specifications

- [Platform Admin Routes - Tenant Management](/docs/design/routes/platform-admin#dashboard-tenants) - UI specification

### API Documentation

- [Platform Admin API](/docs/implementation-technical/api/platform-api/admin) - Tenant management endpoints

### Related Features

- [Plan Management](/docs/features/admin/plan-management/) - Subscription plan configuration
- [Subscription Management](/docs/features/payments/subscription-management) - Billing and payments

### Operations

- [Sales Contract Management](/docs/business/sales/contract-management) - Enterprise deal processes
- [Customer Success SLA](/docs/business/customer-success/sla-tiers) - Support commitments

---

## Future Enhancements

### Q2 2026

- **Tenant Analytics**: Usage patterns, feature adoption, engagement metrics
- **Automated Upsell Detection**: Identify tenants exceeding plan limits
- **Bulk Operations**: Apply feature flags to multiple tenants at once

### Q3 2026

- **Tenant Health Score**: Risk indicators for churn prevention
- **Custom Onboarding Flows**: Per-tenant onboarding customization
- **White Label Support**: Custom branding and domain management
