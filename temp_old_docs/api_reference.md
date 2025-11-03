---
last_modified_date: "2025-10-28"
---

# 🔌 API Reference

---

## Executive Summary

The PenguinMails API provides programmatic access to all platform functionality, enabling seamless integration with external systems, custom workflows, and third-party applications. This RESTful API follows industry best practices for security, reliability, and developer experience.

## API Overview

### Base URL
```
https://api.penguinmails.com/v1
```

### Authentication
- **Method**: Bearer Token (OAuth 2.0)
- **Header**: `Authorization: Bearer {token}`
- **Token Generation**: Through OAuth flow or API key management

### Response Format
- **Content-Type**: `application/json`
- **Encoding**: UTF-8
- **Error Format**: RFC 7807 Problem Details

### Rate Limiting
- **Authenticated Requests**: 1000 per minute
- **Unauthenticated Requests**: 100 per hour
- **Headers**: `X-RateLimit-*` for current limits and reset times

## Core Resources

### Organizations (Companies)

#### List Companies
```http
GET /companies
```

**Parameters:**
- `page` (integer, optional): Page number for pagination
- `per_page` (integer, optional): Items per page (max 100)
- `status` (string, optional): Filter by status (active, paused, suspended)
- `workspace_name` (string, optional): Filter by workspace name

**Response:**
```json
{
  "data": [
    {
      "id": 123,
      "tenant_id": "uuid-tenant",
      "name": "Acme Corporation",
      "workspace_name": "acme-corp",
      "logo_url": "https://example.com/logo.png",
      "status": "active",
      "created_at": "2025-01-15T10:30:00Z",
      "updated_at": "2025-01-20T14:45:00Z"
    }
  ],
  "meta": {
    "page": 1,
    "per_page": 20,
    "total": 5,
    "total_pages": 1
  }
}
```

#### Create Company
```http
POST /companies
```

**Request Body:**
```json
{
  "name": "New Company Inc",
  "workspace_name": "new-company",
  "industry": "technology",
  "team_size": "51-200"
}
```

#### Get Company Details
```http
GET /companies/{company_id}
```

#### Update Company
```http
PATCH /companies/{company_id}
```

**Request Body:**
```json
{
  "name": "Updated Company Name",
  "status": "active",
  "logo_url": "https://example.com/new-logo.png"
}
```

#### Switch Company Context
```http
POST /companies/{company_id}/switch
```

**Description:** Updates user's active company context for multi-company tenants.

### Team Management

#### List Team Members
```http
GET /companies/{company_id}/members
```

**Parameters:**
- `role` (string, optional): Filter by role (owner, admin, member)
- `status` (string, optional): Filter by status (active, pending, suspended)

**Response:**
```json
{
  "data": [
    {
      "user_id": "uuid-user",
      "email": "john.doe@company.com",
      "role": "admin",
      "status": "active",
      "joined_at": "2025-01-15T10:30:00Z",
      "last_active": "2025-01-20T14:45:00Z"
    }
  ],
  "meta": {
    "total_members": 5,
    "active_members": 4,
    "pending_invites": 1
  }
}
```

#### Invite Team Member
```http
POST /companies/{company_id}/members
```

**Request Body:**
```json
{
  "email": "john.doe@company.com",
  "role": "admin",
  "message": "Welcome to our team!",
  "send_invite": true
}
```

#### Update Member Role
```http
PATCH /companies/{company_id}/members/{user_id}
```

**Request Body:**
```json
{
  "role": "member",
  "reason": "Role change for project reassignment"
}
```

#### Remove Team Member
```http
DELETE /companies/{company_id}/members/{user_id}
```

**Request Body:**
```json
{
  "transfer_assets": true,
  "new_owner_id": "uuid-new-owner",
  "reason": "Employee departure"
}
```

#### Resend Invitation
```http
POST /companies/{company_id}/members/{user_id}/resend-invite
```

### Email Campaigns

#### List Campaigns
```http
GET /companies/{company_id}/campaigns
```

**Parameters:**
- `status` (string, optional): Filter by status (draft, scheduled, sending, completed, paused)
- `created_after` (datetime, optional): Filter campaigns created after date
- `created_before` (datetime, optional): Filter campaigns created before date

#### Create Campaign
```http
POST /companies/{company_id}/campaigns
```

**Request Body:**
```json
{
  "name": "Q4 Product Launch",
  "subject": "Introducing Our Latest Innovation",
  "from_email": "noreply@company.com",
  "from_name": "Company Team",
  "content": {
    "html": "<html><body><h1>Hello!</h1></body></html>",
    "text": "Hello!"
  },
  "recipients": {
    "list_id": "list_123456",
    "segment_id": "segment_789012"
  },
  "schedule": {
    "send_at": "2025-01-25T09:00:00Z"
  },
  "settings": {
    "track_opens": true,
    "track_clicks": true,
    "ip_id": "ip_abcdef"
  }
}
```

#### Send Test Email
```http
POST /companies/{company_id}/campaigns/{campaign_id}/test
```

**Request Body:**
```json
{
  "email_addresses": ["test@example.com", "qa@example.com"]
}
```

#### Launch Campaign
```http
POST /companies/{company_id}/campaigns/{campaign_id}/launch
```

### IP Management

#### List IPs
```http
GET /companies/{company_id}/ips
```

#### Provision New IP
```http
POST /companies/{company_id}/ips
```

**Request Body:**
```json
{
  "type": "dedicated",
  "domain": "company.com",
  "warmup_schedule": {
    "start_volume": 50,
    "max_volume": 100000,
    "ramp_up_days": 30
  }
}
```

#### Get IP Status
```http
GET /companies/{company_id}/ips/{ip_id}
```

**Response:**
```json
{
  "id": "ip_abcdef",
  "type": "dedicated",
  "domain": "company.com",
  "status": "active",
  "reputation_score": 85,
  "sending_volume": 75000,
  "created_at": "2025-01-01T00:00:00Z",
  "warmup_progress": {
    "current_day": 15,
    "total_days": 30,
    "current_volume": 25000,
    "target_volume": 100000
  }
}
```

### Analytics & Reporting

#### Get Campaign Analytics
```http
GET /companies/{company_id}/campaigns/{campaign_id}/analytics
```

**Parameters:**
- `metrics` (array, optional): Specific metrics to retrieve
- `start_date` (datetime, optional): Analysis start date
- `end_date` (datetime, optional): Analysis end date

**Response:**
```json
{
  "campaign_id": "camp_123456",
  "summary": {
    "sent": 50000,
    "delivered": 48500,
    "opens": 12250,
    "clicks": 2450,
    "unsubscribes": 125,
    "complaints": 15
  },
  "rates": {
    "deliverability": 97.0,
    "open_rate": 25.3,
    "click_rate": 5.0,
    "unsubscribe_rate": 0.25,
    "complaint_rate": 0.03
  },
  "timeline": [
    {
      "timestamp": "2025-01-25T09:00:00Z",
      "sent": 50000,
      "delivered": 48500,
      "opens": 12250
    }
  ]
}
```

#### Get Organization Analytics
```http
GET /companies/{company_id}/analytics
```

**Parameters:**
- `period` (string, optional): Analysis period (day, week, month)
- `metrics` (array, optional): Metrics to include

### Webhooks

#### Register Webhook
```http
POST /companies/{company_id}/webhooks
```

**Request Body:**
```json
{
  "url": "https://app.company.com/webhooks/penguinmails",
  "events": ["campaign.sent", "campaign.delivered", "campaign.opened"],
  "secret": "your-webhook-secret",
  "active": true
}
```

#### List Webhooks
```http
GET /companies/{company_id}/webhooks
```

#### Delete Webhook
```http
DELETE /companies/{company_id}/webhooks/{webhook_id}
```

## Webhook Events

### Campaign Events
- `campaign.created` - Campaign created
- `campaign.scheduled` - Campaign scheduled for sending
- `campaign.sending` - Campaign started sending
- `campaign.sent` - Campaign completed sending
- `campaign.cancelled` - Campaign cancelled

### Email Events
- `email.delivered` - Email delivered successfully
- `email.opened` - Email opened by recipient
- `email.clicked` - Link clicked in email
- `email.bounced` - Email bounced (hard/soft)
- `email.complained` - Spam complaint received
- `email.unsubscribed` - Unsubscribe request

### IP Management Events
- `ip.provisioned` - New IP provisioned
- `ip.activated` - IP activated for sending
- `ip.reputation_changed` - IP reputation score changed

### System Events
- `organization.created` - New organization created
- `user.invited` - User invited to organization
- `user.joined` - User accepted invitation

## Error Handling

### HTTP Status Codes
- `200 OK` - Success
- `201 Created` - Resource created
- `400 Bad Request` - Invalid request parameters
- `401 Unauthorized` - Authentication required
- `403 Forbidden` - Insufficient permissions
- `404 Not Found` - Resource not found
- `422 Unprocessable Entity` - Validation errors
- `429 Too Many Requests` - Rate limit exceeded
- `500 Internal Server Error` - Server error

### Error Response Format
```json
{
  "type": "https://api.penguinmails.com/errors/validation-error",
  "title": "Validation Error",
  "detail": "The request contains invalid parameters",
  "instance": "/companies/company_123/campaigns",
  "errors": [
    {
      "field": "subject",
      "message": "Subject is required and cannot be empty"
    },
    {
      "field": "from_email",
      "message": "From email must be a valid email address"
    }
  ]
}
```

## SDKs & Libraries

### Official SDKs
- **JavaScript/TypeScript**: `npm install @penguinmails/sdk`
- **Python**: `pip install penguinmails-sdk`
- **PHP**: `composer require penguinmails/sdk`
- **Ruby**: `gem install penguinmails-sdk`

### Community Libraries
- Go, Java, .NET, and other languages available on GitHub

## Rate Limiting

### Headers
```
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 999
X-RateLimit-Reset: 1640995200
X-RateLimit-Retry-After: 60
```

### Burst Handling
- Implement exponential backoff for retries
- Monitor rate limit headers
- Consider upgrading plan for higher limits

## Pagination

### Standard Pagination
```json
{
  "data": [...],
  "meta": {
    "page": 1,
    "per_page": 20,
    "total": 150,
    "total_pages": 8,
    "has_next": true,
    "has_prev": false
  },
  "links": {
    "self": "https://api.penguinmails.com/v1/companies?page=1",
    "next": "https://api.penguinmails.com/v1/companies?page=2",
    "prev": null,
    "first": "https://api.penguinmails.com/v1/companies?page=1",
    "last": "https://api.penguinmails.com/v1/companies?page=8"
  }
}
```

## Versioning

### API Versioning
- URL-based versioning (`/v1/`)
- Backward compatibility maintained within major versions
- Deprecation notices provided 6 months in advance

### Changelog
- Version history and breaking changes documented
- Migration guides provided for major updates
- Beta endpoints clearly marked

---

## Related Documents
- [Architecture Overview](architecture_overview.md) - System design and integration points
- [Security Documentation](security_documentation.md) - Authentication and security protocols
- [Integration Guide](integration_guide.md) - Third-party integration examples
- [Development Guidelines](development_guidelines.md) - Best practices for API usage