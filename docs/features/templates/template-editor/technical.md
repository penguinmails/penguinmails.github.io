---
title: "Level 3: Technical Implementation"
description: "Technical implementation details"
last_modified_date: "2025-12-04"
level: "3"
keywords: "technical implementation, architecture, API"
---

## Level 3: Technical Implementation

### Database Schema

```sql
-- Templates
CREATE TABLE templates (
  id UUID PRIMARY KEY,
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  workspace_id UUID REFERENCES workspaces(id),

  -- Template metadata
  name VARCHAR(255) NOT NULL,
  description TEXT,
  category VARCHAR(100),  -- welcome, newsletter, promotional, etc.

  -- Template content
  html_content TEXT,
  json_structure JSONB,  -- Visual editor structure

  -- Design settings
  global_styles JSONB,

  -- Status
  status VARCHAR(50),  -- draft, active, archived
  is_public BOOLEAN DEFAULT FALSE,  -- Library template

  -- Version control
  version INTEGER DEFAULT 1,
  parent_template_id UUID REFERENCES templates(id),  -- For versions

  -- Metadata
  thumbnail_url TEXT,
  last_used_at TIMESTAMP,

  created_by UUID REFERENCES users(id),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_templates_tenant ON templates(tenant_id);
CREATE INDEX idx_templates_workspace ON templates(workspace_id);
CREATE INDEX idx_templates_status ON templates(status);
CREATE INDEX idx_templates_category ON templates(category);

-- Template versions (auto-save history)
CREATE TABLE template_versions (
  id UUID PRIMARY KEY,
  template_id UUID NOT NULL REFERENCES templates(id),

  -- Version data
  version_number INTEGER NOT NULL,
  html_content TEXT,
  json_structure JSONB,
  global_styles JSONB,

  -- Change metadata
  change_summary TEXT,

  created_by UUID REFERENCES users(id),
  created_at TIMESTAMP DEFAULT NOW(),

  UNIQUE(template_id, version_number)
);

CREATE INDEX idx_template_versions_template ON template_versions(template_id, version_number);

-- Template comments
CREATE TABLE template_comments (
  id UUID PRIMARY KEY,
  template_id UUID NOT NULL REFERENCES templates(id),

  -- Comment details
  component_id VARCHAR(255),  -- ID of component being commented on
  comment TEXT NOT NULL,

  -- Status
  is_resolved BOOLEAN DEFAULT FALSE,
  resolved_by UUID REFERENCES users(id),
  resolved_at TIMESTAMP,

  -- Thread
  parent_comment_id UUID REFERENCES template_comments(id),

  created_by UUID REFERENCES users(id),
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_template_comments_template ON template_comments(template_id);

-- Component library
CREATE TABLE template_components (
  id UUID PRIMARY KEY,

  -- Component metadata
  name VARCHAR(255) NOT NULL,
  category VARCHAR(100),  -- structure, content, layout
  description TEXT,

  -- Component definition
  html_template TEXT,
  json_schema JSONB,  -- Editable properties
  default_properties JSONB,

  -- Preview
  thumbnail_url TEXT,

  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_components_category ON template_components(category);

```

### Template Editor Service

```typescript
interface TemplateComponent {
  id: string;
  type: 'row' | 'column' | 'text' | 'image' | 'button' | 'divider' | 'header' | 'footer';
  properties: Record<string, any>;
  children?: TemplateComponent[];
}

interface TemplateStructure {
  version: string;
  globalStyles: {
    fonts?: Record<string, string>;
    colors?: Record<string, string>;
    spacing?: Record<string, number>;
  };
  components: TemplateComponent[];
}

class TemplateEditorService {
  async createTemplate(
    tenantId: string,
    workspaceId: string,
    name: string
  ): Promise<Template> {
    const template = await db.templates.create({
      tenantId,
      workspaceId,
      name,
      status: 'draft',
      version: 1,
      jsonStructure: this.getBlankTemplate(),
      htmlContent: '',
    });

    return template;
  }

  private getBlankTemplate(): TemplateStructure {
    return {
      version: '1.0.0',
      globalStyles: {
        fonts: {
          body: 'Inter, Arial, sans-serif',
          heading: 'Inter, Arial, sans-serif',
        },
        colors: {
          primary: '#0066cc',
          text: '#333333',
          background: '#ffffff',
        },
        spacing: {
          padding: 30,
          margin: 20,
        },
      },
      components: [
        {
          id: 'header-1',
          type: 'header',
          properties: {
            backgroundColor: '#ffffff',
            padding: 20,
            alignment: 'center',
          },
          children: [],
        },
        {
          id: 'content-1',
          type: 'row',
          properties: {
            backgroundColor: '#ffffff',
            padding: 40,
          },
          children: [
            {
              id: 'col-1',
              type: 'column',
              properties: {
                width: '100%',
              },
              children: [],
            },
          ],
        },
        {
          id: 'footer-1',
          type: 'footer',
          properties: {
            backgroundColor: '#f5f5f5',
            padding: 20,
          },
          children: [],
        },
      ],
    };
  }

  async updateTemplate(
    templateId: string,
    updates: {
      jsonStructure?: TemplateStructure;
      name?: string;
      description?: string;
      changeSummary?: string;
    }
  ): Promise<Template> {
    const template = await db.templates.findById(templateId);

    // Create version snapshot
    await this.createVersionSnapshot(template, updates.changeSummary);

    // Update template
    const updatedTemplate = await db.templates.update(templateId, {
      ...updates,
      version: template.version + 1,
      updatedAt: new Date(),
    });

    // Regenerate HTML if JSON structure changed
    if (updates.jsonStructure) {
      const html = await this.generateHTML(updates.jsonStructure);
      await db.templates.update(templateId, { htmlContent: html });
    }

    return updatedTemplate;
  }

  private async createVersionSnapshot(
    template: Template,
    changeSummary?: string
  ): Promise<void> {
    await db.templateVersions.create({
      templateId: template.id,
      versionNumber: template.version,
      htmlContent: template.htmlContent,
      jsonStructure: template.jsonStructure,
      globalStyles: template.globalStyles,
      changeSummary,
      createdBy: template.updatedBy,
    });
  }

  async generateHTML(structure: TemplateStructure): Promise<string> {
    const components = structure.components.map(c =>
      this.renderComponent(c, structure.globalStyles)
    ).join('\n');

    return `
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    ${this.generateGlobalCSS(structure.globalStyles)}
  </style>
</head>
<body style="margin: 0; padding: 0; font-family: ${structure.globalStyles.fonts?.body || 'Arial, sans-serif'};">
  <table role="presentation" width="100%" cellspacing="0" cellpadding="0">
    <tr>
      <td align="center">
        <table role="presentation" width="600" cellspacing="0" cellpadding="0">
          ${components}
        </table>
      </td>
    </tr>
  </table>
</body>
</html>
    `.trim();
  }

  private renderComponent(
    component: TemplateComponent,
    globalStyles: any
  ): string {
    switch (component.type) {
      case 'text':
        return this.renderTextComponent(component);
      case 'image':
        return this.renderImageComponent(component);
      case 'button':
        return this.renderButtonComponent(component);
      case 'row':
        return this.renderRowComponent(component, globalStyles);
      case 'header':
        return this.renderHeaderComponent(component);
      case 'footer':
        return this.renderFooterComponent(component);
      default:
        return '';
    }
  }

  private renderTextComponent(component: TemplateComponent): string {
    const { text, fontSize, color, alignment } = component.properties;

    return `
      <tr>
        <td style="padding: 10px 0; font-size: ${fontSize || 16}px; color: ${color || '#333'}; text-align: ${alignment || 'left'};">
          ${text}
        </td>
      </tr>
    `;
  }

  private renderButtonComponent(component: TemplateComponent): string {
    const { text, url, backgroundColor, textColor, alignment } = component.properties;

    return `
      <tr>
        <td align="${alignment || 'center'}" style="padding: 20px 0;">
          <a href="${url}" style="display: inline-block; padding: 15px 30px; background: ${backgroundColor || '#0066cc'}; color: ${textColor || '#ffffff'}; text-decoration: none; border-radius: 4px;">
            ${text}
          </a>
        </td>
      </tr>
    `;
  }

  async restoreVersion(
    templateId: string,
    versionNumber: number
  ): Promise<Template> {
    const version = await db.templateVersions.findOne({
      where: { templateId, versionNumber },
    });

    if (!version) {
      throw new Error('Version not found');
    }

    return await this.updateTemplate(templateId, {
      jsonStructure: version.jsonStructure,
      changeSummary: `Restored version ${versionNumber}`,
    });
  }
}

```

### Auto-Save System

```typescript
// Client-side auto-save
class AutoSaveManager {
  private saveTimer: NodeJS.Timeout | null = null;
  private unsavedChanges = false;

  scheduleAutoSave(templateId: string, structure: TemplateStructure): void {
    this.unsavedChanges = true;

    // Clear existing timer
    if (this.saveTimer) {
      clearTimeout(this.saveTimer);
    }

    // Schedule save after 30 seconds of inactivity
    this.saveTimer = setTimeout(() => {
      this.performAutoSave(templateId, structure);
    }, 30000);
  }

  private async performAutoSave(
    templateId: string,
    structure: TemplateStructure
  ): Promise<void> {
    try {
      await api.updateTemplate(templateId, {
        jsonStructure: structure,
        changeSummary: 'Auto-save',
      });

      this.unsavedChanges = false;
      console.log('Template auto-saved');

    } catch (error) {
      console.error('Auto-save failed:', error);
    }
  }

  hasUnsavedChanges(): boolean {
    return this.unsavedChanges;
  }
}

```

### API Endpoints

```typescript
// Create template
app.post('/api/templates', authenticate, async (req, res) => {
  const { name, description, workspaceId } = req.body;

  const service = new TemplateEditorService();
  const template = await service.createTemplate(
    req.user.tenantId,
    workspaceId,
    name
  );

  return res.json(template);
});

// Update template
app.put('/api/templates/:id', authenticate, async (req, res) => {
  const service = new TemplateEditorService();
  const template = await service.updateTemplate(req.params.id, req.body);

  return res.json(template);
});

// Get template versions
app.get('/api/templates/:id/versions', authenticate, async (req, res) => {
  const versions = await db.templateVersions.findAll({
    where: { templateId: req.params.id },
    order: [['versionNumber', 'DESC']],
  });

  return res.json(versions);
});

// Restore version
app.post('/api/templates/:id/restore/:version', authenticate, async (req, res) => {
  const service = new TemplateEditorService();
  const template = await service.restoreVersion(
    req.params.id,
    parseInt(req.params.version)
  );

  return res.json(template);
});

// Generate preview
app.post('/api/templates/:id/preview', authenticate, async (req, res) => {
  const template = await db.templates.findById(req.params.id);
  const service = new TemplateEditorService();

  const html = await service.generateHTML(template.jsonStructure);

  return res.json({ html });
});

```

---
