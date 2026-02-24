---
title: "Level 1: Quick Start Guide"
description: "Quick start guide for template editor"
last_modified_date: "2025-12-04"
level: "1"
keywords: "quick start, basics, getting started"
---

## Level 1: Quick Start Guide

### Your First Template

#### Step 1: Create New Template

```text

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

```text

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

```text

┌─────────────────────────────────────────────────────────┐
│ Template Editor: Welcome Email               [Save â–¼]  │
├─────────────────────────────────────────────────────────┤
│ Components │ Preview                    │ Settings     │
├───────────┼────────────────────────────┼──────────────┤
│ Structure │                            │ Selected:    │
│  â–¡ Row    │    [LOGO]                  │ Text Block   │
│  â–¡ Column │                            │              │
│           │    Welcome to PenguinMails │ Font: Inter  │
│ Content   │                            │ Size: 24px   │
│  📝 Text  │    We're excited to have   │ Color: #333  │
│  🖼️ Image │    you on board!           │ Align: Left  │
│  🔘 Button│                            │              │
│  âž– Divider│    [Get Started →]        │ [Link...]   │
│           │                            │ [Style...]   │
│ Layout    │    Follow us:              │              │
│  🗺️ Header│    [f] [t] [in]           │              │
│  🦶 Footer│                            │              │
│  📱 Social│                            │              │
└───────────┴────────────────────────────┴──────────────┘

Mode: [Visual] [HTML] [Preview]
Device: [📱 Mobile] [📱 Tablet] [🖥️ Desktop]

```

#### Step 4: Drag Components

```text

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

```text

Click on Text Block:

"Welcome to PenguinMails"

Replace with:

"Welcome, {{first_name}}!"

Variables Available:
  {{first_name}}
  {{last_name}}
  {{email}}
  {{company}}

[Insert Variable â–¼]

```

#### Step 6: Mobile Preview

```text

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

âœ“ Looks good on mobile

```

#### Step 7: Save Template

```text

[Save â–¼]
  ● Save
  ○ Save As...
  ○ Save as Draft

âœ“ Template saved: "Welcome Email"
Last saved: 2 seconds ago

Actions:
  [Preview] [Test Send] [Use in Campaign]

```

### Common Editing Tasks

#### Add a Header

```text

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

```text

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

```text

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
