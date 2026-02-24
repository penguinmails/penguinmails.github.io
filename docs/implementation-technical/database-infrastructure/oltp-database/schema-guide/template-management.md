---
title: "OLTP Schema - Template Management"
description: "Email templates, tagging, organization, and rendering storage schema."
last_modified_date: "2026-02-24"
level: "2"
persona: "Documentation Users"
---

# OLTP Schema - Template Management

### **Template Management**

#### **templates** - Email Templates

```sql
CREATE TABLE templates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    name VARCHAR(100) NOT NULL,
    subject VARCHAR(255),
    content TEXT,
    is_started BOOLEAN DEFAULT FALSE,
    updated TIMESTAMP WITH TIME ZONE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

#### **Template Organization**

```sql
-- Template folders for organization (UUID → BIGINT optimization)
CREATE TABLE folders (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name TEXT NOT NULL,
    updated TIMESTAMP WITH TIME ZONE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Template-to-folder mapping (UUID → BIGINT optimization)
CREATE TABLE template_folders (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    template_id UUID REFERENCES templates(id) ON DELETE CASCADE,
    folder_id BIGINT REFERENCES folders(id) ON DELETE CASCADE,
    updated TIMESTAMP WITH TIME ZONE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(template_id, folder_id)
);

-- Template tagging system (UUID → BIGINT optimization)
CREATE TABLE tags (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    value TEXT NOT NULL,
    description TEXT,
    name TEXT,
    tenant_id UUID,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE,
    is_default BOOLEAN DEFAULT FALSE
);

CREATE TABLE template_tags (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    template_id UUID REFERENCES templates(id) ON DELETE CASCADE,
    tag_id BIGINT REFERENCES tags(id) ON DELETE CASCADE,
    tenant_id UUID NOT NULL,
    updated TIMESTAMP WITH TIME ZONE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(template_id, tag_id)
);
```

#### Eta Template Rendering Storage

```sql
CREATE TABLE email_templates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    name TEXT NOT NULL,
    subject TEXT NOT NULL,
    body TEXT NOT NULL,          -- raw .eta template body
    async BOOLEAN DEFAULT FALSE, -- if template uses async includes
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE (tenant_id, name)
);
```

```sql
CREATE TABLE template_dictionaries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    key TEXT NOT NULL,
    value JSONB NOT NULL,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_template_dictionaries_tenant ON template_dictionaries(tenant_id);
```
