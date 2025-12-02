# Platform Admin - Plan Management

## 1. Purpose & Context

- **Goal**: Enable platform administrators to manage subscription plans, pricing, and feature limits without code changes.
- **Feature References**:
  - [Billing Schema](/docs/implementation-technical/database-infrastructure/oltp-database/schema-guide)
  - [Stripe Integration](/docs/features/payments/stripe-integration)
- **User Journey**: Admin needs to launch a "Black Friday" plan → Creates Stripe Product → Adds Plan in Admin Dashboard → Sets as Active.

## 2. Route Specifications

| Route | Access | Purpose | State/Data Requirements |
|---|---|---|---|
| `/dashboard/admin/plans` | Super Admin | Plan List | List all plans (active & inactive). Actions: Create, Edit, Toggle Status. |
| `/dashboard/admin/plans/new` | Super Admin | Create Plan | Form to define new plan limits and Stripe mapping. |
| `/dashboard/admin/plans/[id]` | Super Admin | Edit Plan | Update plan details, limits, or status. |

## 3. Detailed View Descriptions

### `/dashboard/admin/plans` - Plan List

**User Story**: *"As a product manager, I want to see all available plans and their status, so I can manage our pricing strategy."*

**What You'll Find**:

#### Plans Table

- **Columns**: Name, Slug, Price (Monthly/Yearly), Stripe Product ID, Status (Active/Inactive), Subscribers, Actions.
- **Status Indicators**:
  - Green: Active (Publicly purchasable)
  - Grey: Inactive (Hidden, but renewable)
- **Actions**:
  - **"Create New Plan" Button**: Navigates to creation form.
  - **Row Actions**: Edit, Toggle Status.

### `/dashboard/admin/plans/[id]` - Edit Plan

**User Story**: *"As an admin, I want to update the feature limits for the Pro plan or deactivate a seasonal plan."*

**What You'll Find**:

#### Plan Details Form

- **General Info**: Name, Slug, Description.
- **Stripe Mapping**:
  - `stripe_product_id` (Required): Links to Stripe Product.
  - **Note**: Prices are managed in Stripe, but displayed here for reference if synced, or manually entered for UI display (`price_monthly`, `price_yearly`).
- **Feature Limits**:
  - Max Users, Max Domains, Max Campaigns/Month.
  - Max Emails/Month, Storage Limit.
- **Feature Flags**:
  - API Access, Priority Support, White Label, Advanced Analytics.
- **Lifecycle**:
  - **Is Active Toggle**: Controls visibility in purchase UI.

**Validation**:

- `slug` must be unique.
- `stripe_product_id` format validation.

## 4. Related API Endpoints

| Route | Related API | Description |
|---|---|---|
| `/dashboard/admin/plans` | [Admin Plans API](/docs/implementation-technical/api/platform-api/plans) | `GET /api/v1/platform/admin/plans` (List) |
| `/dashboard/admin/plans/new` | [Admin Plans API](/docs/implementation-technical/api/platform-api/plans) | `POST /api/v1/platform/admin/plans` (Create) |
| `/dashboard/admin/plans/[id]` | [Admin Plans API](/docs/implementation-technical/api/platform-api/plans) | `PUT /api/v1/platform/admin/plans/{id}` (Update) |

## 5. Data Strategy

- **Fetching**: Server Components for list view, Client Components for form interactivity.
- **Caching**: Plan data is heavily cached (public facing), admin updates must invalidate cache tags (`plans-list`, `plan-{slug}`).
