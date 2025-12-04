---
title: "Template Management"
description: "Email template creation, HTML editing, and variable management"
last_modified_date: "2025-11-24"
level: "2"
persona: "Marketers, Designers"
status: "ACTIVE"
category: "Templates"
---

# Template Management

## Create, manage, and reuse beautiful email templates for your campaigns

---

## Overview

The Template Management system allows you to design responsive email layouts, save them for reuse, and dynamically inject content using variables. It supports both a visual Drag-and-Drop builder and a raw HTML code editor.

### Key Features

- **Visual Builder** - No-code drag-and-drop interface

- **HTML Editor** - Full control for developers

- **Variable Injection** - Personalization (`{{first_name}}`)

- **Responsive Design** - Mobile-friendly out of the box

- **Template Library** - Pre-built professional designs

---

## Level 1: Creating Templates

### Visual Builder

**Best for:** Marketers and non-technical users.

- **Blocks**: Drag text, images, buttons, dividers, and social icons.

- **Styles**: Global settings for fonts, colors, and padding.

- **Preview**: Real-time mobile and desktop preview.

### HTML Editor

**Best for:** Developers and custom designs.

- **Monaco Editor**: Syntax highlighting, auto-complete.

- **Live Preview**: See changes as you type.

- **Asset Hosting**: Upload images directly to PenguinMails CDN.

---

## Level 2: Personalization & Logic

### Variables (Merge Tags)

Inject dynamic data into your templates using Handlebars syntax.

## Standard Variables

{% raw %}

- `{{contact.first_name}}`

- `{{contact.email}}`

- `{{company.name}}`

- `{{company.address}}`

- `{{unsubscribe_url}}`

## Custom Fields

- `{{contact.custom.job_title}}`

- `{{contact.custom.industry}}`
{% endraw %}

### Conditional Logic

Show or hide content based on data.

{% raw %}

```handlebars

{{#if contact.first_name}}
  Hi {{contact.first_name}},
{{else}}
  Hi there,
{{/if}}

{{#if is_premium_user}}
  <p>Thanks for being a VIP!</p>
{{/if}}

```

{% endraw %}

### Loops

Iterate over lists (e.g., for e-commerce receipts).

{% raw %}

```text

<ul>
  {{#each order_items}}
    <li>{{product_name}}: {{price}}</li>
  {{/each}}
</ul>

```

{% endraw %}

---

## Level 3: Technical Implementation

### Template Storage

Templates are stored in the database with versioning.

```text

CREATE TABLE templates (
  id UUID PRIMARY KEY,
  tenant_id UUID,
  name VARCHAR(255),
  html_content TEXT, -- The rendered HTML
  json_design JSONB, -- The visual builder state
  thumbnail_url VARCHAR(255),
  updated_at TIMESTAMP
);

```

### API Usage

## Render a template

```text

POST /api/v1/templates/{id}/render
{
  "context": {
    "contact": { "first_name": "Alice" }
  }
}

```

## Create via API

```text

POST /api/v1/templates
{
  "name": "Welcome Email v2",
  "html_content": "<html>...</html>"
}

```

---

## Related Documentation

### Campaigns

- **[Campaign Management](/docs/features/campaigns/campaign-management/hub)** - Using templates in campaigns

### Compliance

- **[CAN-SPAM Compliance](/docs/features/compliance/can-spam-compliance)** - Required footer elements

---

**Last Updated:** November 24, 2025
**Engine:** Handlebars.js

*Great templates drive engagement. PenguinMails gives you the tools to look professional on every device.*
