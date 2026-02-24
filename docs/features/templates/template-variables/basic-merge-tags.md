---
title: "Template Variables - Basic Merge Tags"
description: "Quick start guide for basic merge tags, standard contact fields, and default values."
last_modified_date: "2026-02-24"
level: "2"
persona: "Documentation Users"
---

# Template Variables - Basic Merge Tags

## Quick Start Guide

### Basic Merge Tags

#### Standard Contact Fields

```text
Hi {{first_name}},

Welcome to {{company}}! We're excited to have you on board.

Your account email is: {{email}}

Best regards,
The {{workspace_name}} Team
```

**Output Example:**

```text
Hi John,

Welcome to Acme Inc! We're excited to have you on board.

Your account email is: john@example.com

Best regards,
The Acme Marketing Team
```

### Default Values

#### Basic Syntax

```text
Hi {{first_name | default: "there"}},

Welcome to {{company | default: "our platform"}}!
```

**When Data Exists:**

```text
Hi John,
Welcome to Acme Inc!
```

**When Data Missing:**

```text
Hi there,
Welcome to our platform!
```

#### Multiple Fallbacks

```text
{{first_name | default: {{contact_name}} | default: "Valued Customer"}}
```

**Fallback Chain:**

1. Try `first_name`
2. If empty, try `contact_name`
3. If both empty, use "Valued Customer"
