---
title: "Authentication Flows"
description: "Detailed specifications for signup, login, logout, email verification, and password recovery."
last_modified_date: "2026-02-24"
level: "2"
persona: "Developers"
---

# Authentication Flows

The PenguinMails authentication system provides secure entry points for users and tenants, powered by NileDB.

## 1. Registration (Signup)

The signup process initializes a new tenant and an owner user.

**Process:**

1. User submits registration form (Email, Name, Password, Company Name).
2. Backend creates tenant + owner user.
3. Email verification sent.
4. User clicks verification link.
5. Account activated.

**API Endpoint:**

```javascript
POST /api/v1/auth/signup
{
  "email": "user@example.com",
  "name": "John Doe",
  "password": "SecurePass123!",
  "company_name": "Acme Corp"
}

Response:
{
  "user_id": "user_abc123",
  "tenant_id": "tenant_xyz789",
  "email": "user@example.com",
  "email_verified": false,
  "verification_sent": true
}
```

## 2. Login

Supports secure email/password authentication via NileDB SDK.

**Login Flow:**

1. User enters email/password.
2. NileDB validates credentials.
3. JWT token generated (includes `tenant_id`).
4. Session established.

**API Endpoint:**

```javascript
POST /api/v1/auth/login
{
  "email": "user@example.com",
  "password": "SecurePass123!"
}

Response:
{
  "access_token": "eyJhbGciOiJIUzI1NiIs...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIs...",
  "user": {
    "id": "user_abc123",
    "email": "user@example.com",
    "name": "John Doe",
    "tenant_id": "tenant_xyz789",
    "role": "owner"
  },
  "expires_in": 3600 // 1 hour
}
```

## 3. Logout

Secure termination of user sessions.

```javascript
POST /api/v1/auth/logout
Authorization: Bearer {access_token}

Response:
{
  "success": true,
  "message": "Successfully logged out"
}
```

**Internal Logic:**

- Invalidate access token.
- Revoke refresh token in the database.
- Clear server-side session registry.
- Clear client-side state and local storage.

## 4. Email Verification

Ensures users have access to the provided email address.

**API Endpoint:**
`GET /api/v1/auth/verify-email?token={verification_token}`

**Re-send Verification:**

```javascript
POST /api/v1/auth/resend-verification
{
  "email": "user@example.com"
}
```

## 5. Password Recovery

Secure workflow for lost account access.

**Request Reset:**
`POST /api/v1/auth/forgot-password` (Note: Response does not reveal if account exists).

**Reset Password:**

```javascript
POST /api/v1/auth/reset-password
{
  "token": "reset_token_abc123",
  "new_password": "NewSecurePass456!"
}
```

 Successful reset triggers an auto-login with a new session.
