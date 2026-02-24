---
title: "Access Control & Rate Limiting"
description: "Protecting the platform through authentication, session management, and DDoS protection."
last_modified_date: "2026-02-24"
level: "2"
persona: "Developers, Security Team"
---

# Access Control & Rate Limiting

PenguinMails implements multiple layers of protection to ensure that only authorized users can access the system and that the platform remains stable under load.

## 1. Authentication & Session Management

- **NileDB Integration**: Powered by NileDB for secure, multi-tenant authentication.
- **JWT Protocols**: Uses JSON Web Tokens with short-lived access tokens and long-lived, HttpOnly refresh tokens.
- **CSRF Protection**: Native protection on all state-changing API endpoints.

## 2. API Rate Limiting

To prevent abuse and ensure fair resource allocation, all API requests are subject to rate limiting based on the requester's identity.

| Tier | Limit (per minute) |
|------|--------------------|
| **Anonymous** | 100 requests |
| **Authenticated User** | 1,000 requests |
| **API Key (App-to-App)** | 10,000 requests |

**Implementation**:
We use `express-rate-limit` with a Redis store for distributed rate limiting across our server cluster.

## 3. DDoS & Brute Force Protection

- **Fail2ban**: Automatically bans IP addresses that exhibit suspicious behavior (e.g., 5 failed login attempts within 15 minutes).
- **IP Blocking**: Administrators can manually block malicious IPs globally or at the tenant level.
- **WAF (Web Application Firewall)**: Enterprise customers can configure custom WAF rules for advanced traffic filtering.

## 4. Multi-Factor Authentication (2FA)

*Status: Roadmap (Q1 2026)*

PenguinMails is currently implementing support for:

- **TOTP (Google Authenticator / Authy)**
- **SMS Verification Codes**
- **Hardware Keys (YubiKey / WebAuthn)**

## 5. IP Restrictions

- **Tenant Allowlists**: Restrict API key usage to specific corporate IP ranges.
- **SMTP Relay Restrictions**: Dedicated IP pools can be restricted to authorized sender IPs only.
