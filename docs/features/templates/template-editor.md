---
title: "Template Editor"
description: "Visual WYSIWYG email template editor with drag-and-drop, HTML/visual toggle, component library, and version control"
level: "2"
status: "PLANNED"
roadmap_timeline: "Q2 2026"
priority: "High"
related_features:


  - templates/template-management


  - templates/template-variables


  - templates/template-library


  - campaigns/campaign-management/overview
related_tasks:


  - epic-6-templates-content
---


# Template Editor

**Quick Access**: Create beautiful, responsive email templates with a powerful visual editor featuring drag-and-drop components, live preview, and HTML editing capabilities.


## Overview

The Template Editor is a comprehensive WYSIWYG (What You See Is What You Get) email design tool that allows marketers and designers to create professional email templates without requiring extensive coding knowledge, while still providing full HTML access for advanced users.


### Key Capabilities


- **Drag-and-Drop Interface**: Build emails visually with pre-built components


- **WYSIWYG Editing**: See exactly how your email will look


- **HTML/Visual Mode Toggle**: Switch between visual and code editing


- **Component Library**: Pre-designed buttons, headers, footers, images, text blocks


- **Mobile Preview**: Real-time preview for desktop, tablet, and mobile


- **Template Versioning**: Auto-save and version history


- **Responsive Design**: Mobile-first, responsive by default


- **Undo/Redo**: Full edit history

---


## Level 1: Quick Start Guide


### Your First Template


#### Step 1: Create New Template


```

Templates → Create Template

Template Name: Welcome Email
Description: New subscriber welcome message

Starting Point:
  ○ Blank Template
  ● From Library (Recommended)
  ○ Import HTML

[Continue →]


```


#### Step 2: Choose Base Template


```

Select a Template:

[Basic Email]     [Newsletter]     [Promotional]
[Transactional]   [Event]          [Product Launch]

Selected: Basic Email


  - Simple header with logo


  - Single column content area


  - Footer with social links

[Use This Template]


```


#### Step 3: Visual Editor


```

┌─────────────────────────────────────────────────────────┐
│ Template Editor: Welcome Email               [Save ▼]  │
├─────────────────────────────────────────────────────────┤
│ Components │ Preview                    │ Settings     │
├───────────┼────────────────────────────┼──────────────┤
│ Structure │                            │ Selected:    │
│  □ Row    │    [LOGO]                  │ Text Block   │
│  □ Column │                            │              │
│           │    Welcome to PenguinMails │ Font: Inter  │
│ Content   │                            │ Size: 24px   │
│  📝 Text  │    We're excited to have   │ Color: #333  │
│  🖼️ Image │    you on board!           │ Align: Left  │
│  🔘 Button│                            │              │
│  ➖ Divider│    [Get Started →]        │ [Link...]   │
│           │                            │ [Style...]   │
│ Layout    │    Follow us:              │              │
│  📋 Header│    [f] [t] [in]           │              │
│  🦶 Footer│                            │              │
│  📱 Social│                            │              │
└───────────┴────────────────────────────┴──────────────┘

Mode: [Visual] [HTML] [Preview]
Device: [📱 Mobile] [📱 Tablet] [🖥️ Desktop]


```


#### Step 4: Drag Components


```

Drag "Button" from Components → Drop in Content Area

Button Properties:
  Text: Get Started
  Link: https://app.penguinmails.com/onboarding
  Style: Primary (Blue)
  Alignment: Center
  Full Width: ☐

[Apply]


```


#### Step 5: Edit Content


```

Click on Text Block:

"Welcome to PenguinMails"
  
Replace with:
  
"Welcome, {{first_name}}!"

Variables Available:
  {{first_name}}
  {{last_name}}
  {{email}}
  {{company}}
  
[Insert Variable ▼]


```


#### Step 6: Mobile Preview


```

Switch to Mobile View: 📱

Preview:
┌──────────┐
│ [LOGO]   │
│          │
│ Welcome, │
│ John!    │
│          │
│ We're    │
│ excited..│
│          │
│[Get Start]│
│          │
│Follow us:│
│ f t in  │
└──────────┘

✓ Looks good on mobile


```


#### Step 7: Save Template


```

[Save ▼]
  ● Save
  ○ Save As...
  ○ Save as Draft

✓ Template saved: "Welcome Email"
Last saved: 2 seconds ago

Actions:
  [Preview] [Test Send] [Use in Campaign]


```


### Common Editing Tasks


#### Add a Header


```

Drag "Header" component to top:

Header Settings:
  Logo: [Upload] (max 200kb)


    - Recommended: 600x200px
  Background Color: #ffffff
  Padding: 20px
  Alignment: Center

[Apply]


```


#### Add Social Media Links


```

Drag "Social" component:

Social Media Links:
  ☑ Facebook: https://facebook.com/yourpage
  ☑ Twitter: https://twitter.com/yourhandle
  ☑ LinkedIn: https://linkedin.com/company/yourcompany
  ☐ Instagram
  ☐ YouTube

Icon Style:
  ● Round Color
  ○ Square Color
  ○ Round B&W
  ○ Square B&W

[Apply]


```


#### Insert Image


```

Drag "Image" component:

Image Source:
  ○ Upload Image
  ● Image URL
  ○ From Asset Library

URL: https://example.com/hero.jpg
Alt Text: Product Hero Image

Size:
  Width: 600px (max email width)
  Height: Auto
  
Link to:
  URL: https://example.com/product

[Insert]


```

---


## Level 2: Advanced Editing Features


### HTML/Visual Mode Toggle

**Switch to HTML Mode:**


```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Welcome Email</title>
</head>
<body style="margin: 0; padding: 0; font-family: Arial, sans-serif;">
  <table role="presentation" width="100%" cellspacing="0" cellpadding="0">
    <tr>
      <td align="center" style="padding: 20px 0;">
        <table role="presentation" width="600" cellspacing="0" cellpadding="0">
          <!-- Header -->
          <tr>
            <td align="center" style="padding: 20px; background: #ffffff;">
              <img src="{{logo_url}}" alt="PenguinMails" width="200">
            </td>
          </tr>
          
          <!-- Content -->
          <tr>
            <td style="padding: 40px 30px; background: #ffffff;">
              <h1 style="margin: 0 0 20px; font-size: 24px; color: #333;">
                Welcome, {{first_name}}!
              </h1>
              <p style="margin: 0 0 20px; line-height: 1.6; color: #666;">
                We're excited to have you on board!
              </p>
              
              <!-- Button -->
              <table role="presentation" width="100%">
                <tr>
                  <td align="center" style="padding: 20px 0;">
                    <a href="https://app.penguinmails.com/onboarding"
                       style="display: inline-block; padding: 15px 30px;
                              background: #0066cc; color: #ffffff;
                              text-decoration: none; border-radius: 4px;">
                      Get Started
                    </a>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          
          <!-- Footer -->
          <tr>
            <td align="center" style="padding: 20px; background: #f5f5f5;">
              <p style="margin: 0 0 10px; font-size: 14px; color: #999;">
                Follow us:
              </p>
              <a href="{{social_facebook}}" style="margin: 0 5px;">
                <img src="{{cdn}}/icons/facebook.png" width="32" alt="Facebook">
              </a>
              <a href="{{social_twitter}}" style="margin: 0 5px;">
                <img src="{{cdn}}/icons/twitter.png" width="32" alt="Twitter">
              </a>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>


```


### Component Library

**Structure Components:**


```yaml
row:
  description: "Container for columns"
  settings:


    - background_color


    - padding


    - full_width
    
column:
  description: "Content column (supports 1-4 columns)"
  layouts:


    - single: "100%"


    - two_equal: "50% | 50%"


    - two_third: "66% | 33%"


    - three_equal: "33% | 33% | 33%"


    - four_equal: "25% | 25% | 25% | 25%"


```

**Content Components:**


```yaml
text_block:
  description: "Rich text editor"
  supports:


    - Bold, Italic, Underline


    - Headings (H1-H6)


    - Lists (ordered, unordered)


    - Links


    - Font family, size, color


    - Alignment


    - Line height, letter spacing
    
image:
  description: "Image with link"
  settings:


    - source: upload | url | asset_library


    - alt_text


    - width, height


    - alignment


    - link_url


    - border, padding
    
button:
  description: "Call-to-action button"
  styles:


    - primary: "#0066cc"


    - secondary: "#6c757d"


    - success: "#28a745"


    - danger: "#dc3545"


    - custom: "any color"
  settings:


    - text


    - link_url


    - style


    - alignment


    - full_width


    - border_radius


    - padding
    
divider:
  description: "Horizontal line separator"
  settings:


    - line_style: solid | dashed | dotted


    - color


    - thickness


    - width


    - padding
    
spacer:
  description: "Vertical spacing"
  settings:


    - height: 10px - 100px
    
html:
  description: "Custom HTML block"
  usage: "For advanced users"


```

**Layout Components:**


```yaml
header:
  description: "Email header with logo and navigation"
  presets:


    - logo_centered


    - logo_left_menu_right


    - full_width_image
    
footer:
  description: "Email footer with legal and social"
  includes:


    - unsubscribe_link (required)


    - company_address


    - social_media_links


    - copyright_text
    
social:
  description: "Social media icons"
  platforms:


    - facebook


    - twitter


    - linkedin


    - instagram


    - youtube


    - tiktok
  styles:


    - round_color


    - square_color


    - round_bw


    - square_bw


    - icons_only


```


### Advanced Styling

**Global Styles:**


```

Settings → Global Styles

Typography:
  Default Font: Inter, Arial, Helvetica, sans-serif
  Heading Font: Inter, Arial, Helvetica, sans-serif
  Body Font Size: 16px
  Line Height: 1.6
  
Colors:
  Primary: #0066cc
  Secondary: #6c757d
  Text: #333333
  Muted: #666666
  Background: #ffffff
  
Spacing:
  Container Padding: 30px
  Section Padding: 40px 0
  Element Margin: 20px 0
  
Buttons:
  Border Radius: 4px
  Padding: 15px 30px
  Font Weight: 600


```

**Responsive Settings:**


```yaml
breakpoints:
  mobile: "< 480px"
  tablet: "481px - 768px"
  desktop: "> 768px"

mobile_overrides:
  font_size: 14px  # Scale down
  padding: 20px  # Reduce padding
  button_full_width: true
  hide_images: optional
  stack_columns: true  # 2-col → 1-col


```


### Template Versioning

**Version History:**


```

Template: Welcome Email (v8)

Version History:
┌────────────────────────────────────────────────────┐
│ v8 (Current) │ Nov 25, 2025 2:30 PM │ Sarah J.    │
│ - Updated button style                             │
│ [Viewing] [Restore] [Compare]                      │
├────────────────────────────────────────────────────┤
│ v7           │ Nov 24, 2025 4:15 PM │ Sarah J.    │
│ - Added social media links                         │
│ [View] [Restore] [Compare to v8]                   │
├────────────────────────────────────────────────────┤
│ v6           │ Nov 23, 2025 11:20 AM │ Michael C. │
│ - Changed header background color                  │
│ [View] [Restore] [Compare]                         │
├────────────────────────────────────────────────────┤
│ v5           │ Nov 22, 2025 3:45 PM │ Sarah J.    │
│ - Initial draft                                    │
│ [View] [Restore]                                   │
└────────────────────────────────────────────────────┘

Auto-save: ✓ Enabled (every 30 seconds)


```

**Compare Versions:**


```

Version Comparison: v7 → v8

Changes:


  - Button style: Secondary → Primary


  - Button color: #6c757d → #0066cc


  - Button text: "Learn More" → "Get Started"

Side-by-Side View:
┌──────────────┬──────────────┐
│ v7           │ v8 (Current) │
├──────────────┼──────────────┤
│ [Learn More ▫]│ [Get Started]│
│  (Gray)      │  (Blue)      │
└──────────────┴──────────────┘

[Restore v7] [Keep v8] [Merge Changes]


```


### Template Testing

**Preview & Test:**


```

Template: Welcome Email

Preview Mode:
  [Desktop] [Tablet] [Mobile]
  
Test Email:
  Send To: your.email@example.com
  Use Test Data:
    first_name: John
    last_name: Doe
    company: Acme Inc
    email: john@example.com
  
  [Send Test Email]
  
Email Client Preview:
  ☑ Gmail (Desktop)
  ☑ Gmail (Mobile)
  ☑ Outlook (Desktop)
  ☑ Outlook (Mobile)
  ☑ Apple Mail
  ☑ Yahoo Mail
  
  [Generate Previews] (uses Litmus/Email on Acid API)


```

**Validation Checks:**


```

Template Validation

✓ Passed:


  - Valid HTML structure


  - Mobile responsive


  - Unsubscribe link present


  - Alt text on images


  - No broken links


  - File size < 100kb

⚠ Warnings:


  - Some email clients may not support web fonts


  - Image "hero.jpg" is 150kb (recommended < 100kb)
  
✗ Errors:


  - None

Spam Score: 2.1 / 10 (✓ Good)


  - Subject line length OK


  - No spammy words detected


  - Image-to-text ratio OK


```


### Collaboration Features

**Comments & Feedback:**


```

Template Editor → Comments

💬 Sarah Johnson (2 hours ago)
   "Can we make the button bigger?"
   On: Button Component
   
   ↳ Michael Chen (1 hour ago)
     "Increased padding to 20px 40px"
     [Mark Resolved]

💬 Emily Davis (3 days ago)
   "Logo should be 250px wide for better visibility"
   On: Header Component
   Status: ✓ Resolved

[Add Comment]


```

**Approval Workflow:**


```

Template Status: Pending Approval

Workflow:
  ✓ Created by: Sarah Johnson
  ✓ Reviewed by: Michael Chen
  ⏳ Awaiting approval: Emily Davis (Marketing Director)
  
Comments:
  Michael: "Looks good, approved for marketing review"
  
[Request Changes] [Approve Template]


```

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


## Related Documentation


- **[Template Management](./template-management.md)** - Template organization and management


- **[Template Variables](./template-variables.md)** - Dynamic content and merge tags


- **[Template Library](./template-library.md)** - Pre-built template collection


- **[Campaign Management](../campaigns/campaign-management/overview.md)** - Use templates in campaigns

---

**Last Updated:** November 25, 2025  
**Status:** Planned - High Priority (Level 2)  
**Target Release:** Q2 2026  
**Owner:** Templates Team
