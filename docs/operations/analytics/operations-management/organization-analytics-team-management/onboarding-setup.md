---
title: "Company Onboarding & Setup"
description: "Step-by-step guide for company creation, initial configuration, and team invitation journey."
last_modified_date: "2026-02-24"
level: "3"
persona: "Documentation Users"
---

# Company Onboarding & Setup

### **Journey Flow**

`Company Setup → Team Invitation → Role Assignment → Active Collaboration`

**Overview:** Organization and team management with multi-tenant architecture, role-based access control, and collaborative workflows.

### **Normal Team Operations**

#### 1. **Company Setup & Onboarding**

**Journey Flow:** `Onboarding Modal → Company Details → Team Size → Initial Owner → Company Created`

##### Company Information Collection (`)

- **Modal Elements**:
  - Company name input field (required)
  - Industry dropdown selection
  - Team size range selector (1-10, 11-50, 51-200, 200+)
  - Company workspace name (URL-friendly, unique identifier)
  - Company logo URL (optional)
  - Company website URL (optional)
  - Company description textarea
- **Validation**: Real-time company name uniqueness check
- **Progress**: Step indicator shows 1 of 4 completed

##### Initial Team Configuration

- **Owner Assignment**: Current user automatically becomes Owner
- **Team Size Confirmation**: Affects plan recommendations and feature limits
- **Optional Team Invites**: Can add initial team members immediately or skip

##### Company Creation & Database Setup

- **Backend Process**: Company record creation with tenant association
- **Multi-tenant Setup**: RLS policies configured for company isolation
- **Feature Provisioning**: Base plan features activated at tenant level
- **Email Notification**: Company creation confirmation

#### 2. **Team Invitation & Onboarding**

**Journey Flow:** `Team Dashboard → Invite Form → Email Sent → Recipient Journey → Team Integration`

##### Invitation Initiation (`/team` or `/settings)

- **Page Access**: Team management section in settings
- **Permission Check**: Only Owner/Admin can send invites
- **Invite Button**: Prominent "Invite Team Member" CTA

##### Invitation Form

- **Form Elements**:
  - Email address input (required)
  - Role selection dropdown (Member, Admin, Owner)
  - Personal message textarea (optional)
  - "Send Invitation" button
- **Validation**: Email format, domain checks, duplicate prevention
- **Bulk Invites**: Option to upload CSV for multiple invites

##### Invitation Email & Token Generation

- **Email Content**: Personalized invite with company branding
- **Security Token**: Time-limited invitation link (7 days expiration)
- **Tracking**: Invitation status monitoring (sent, viewed, accepted, expired)

##### Recipient Invitation Journey

- **Email Reception**: Invitation email with clear subject line
- **Link Click**: Directs to invitation acceptance page
- **Account Check**: System checks if email already has an account
- **New User Flow**: Redirects to signup if needed
- **Existing User Flow**: Adds company association if account exists

##### Invitation Acceptance & Role Assignment

- **Acceptance Page**: Clean confirmation screen
- **Role Confirmation**: Shows assigned role and permissions
- **Company Integration**: User added to company tenant
- **Welcome Email**: Confirmation of team membership
