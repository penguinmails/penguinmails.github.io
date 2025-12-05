---
title: "Level 2: Advanced Editing Features"
description: "Advanced template editing capabilities"
last_modified_date: "2025-12-04"
level: "2"
keywords: "advanced features, dynamic content, personalization"
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

```text

Settings â†’ Global Styles

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
  stack_columns: true  # 2-col â†’ 1-col

```

### Template Versioning

**Version History:**

```text

Template: Welcome Email (v8)

Version History:
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚ v8 (Current) â”‚ Nov 25, 2025 2:30 PM â”‚ Sarah J.    â”‚
â”‚ - Updated button style                             â”‚
â”‚ [Viewing] [Restore] [Compare]                      â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚ v7           â”‚ Nov 24, 2025 4:15 PM â”‚ Sarah J.    â”‚
â”‚ - Added social media links                         â”‚
â”‚ [View] [Restore] [Compare to v8]                   â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚ v6           â”‚ Nov 23, 2025 11:20 AM â”‚ Michael C. â”‚
â”‚ - Changed header background color                  â”‚
â”‚ [View] [Restore] [Compare]                         â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚ v5           â”‚ Nov 22, 2025 3:45 PM â”‚ Sarah J.    â”‚
â”‚ - Initial draft                                    â”‚
â”‚ [View] [Restore]                                   â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜

Auto-save: âœ“ Enabled (every 30 seconds)

```

**Compare Versions:**

```text

Version Comparison: v7 â†’ v8

Changes:

  - Button style: Secondary â†’ Primary

  - Button color: #6c757d â†’ #0066cc

  - Button text: "Learn More" â†’ "Get Started"

Side-by-Side View:
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚ v7           â”‚ v8 (Current) â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚ [Learn More â–«]â”‚ [Get Started]â”‚
â”‚  (Gray)      â”‚  (Blue)      â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜

[Restore v7] [Keep v8] [Merge Changes]

```

### Template Testing

**Preview & Test:**

```text

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
  â˜‘ Gmail (Desktop)
  â˜‘ Gmail (Mobile)
  â˜‘ Outlook (Desktop)
  â˜‘ Outlook (Mobile)
  â˜‘ Apple Mail
  â˜‘ Yahoo Mail

  [Generate Previews] (uses Litmus/Email on Acid API)

```

**Validation Checks:**

```text

Template Validation

âœ“ Passed:

  - Valid HTML structure

  - Mobile responsive

  - Unsubscribe link present

  - Alt text on images

  - No broken links

  - File size < 100kb

âš  Warnings:

  - Some email clients may not support web fonts

  - Image "hero.jpg" is 150kb (recommended < 100kb)

âœ— Errors:

  - None

Spam Score: 2.1 / 10 (âœ“ Good)

  - Subject line length OK

  - No spammy words detected

  - Image-to-text ratio OK

```

### Collaboration Features

**Comments & Feedback:**

```text

Template Editor â†’ Comments

ðŸ’¬ Sarah Johnson (2 hours ago)
   "Can we make the button bigger?"
   On: Button Component

   â†³ Michael Chen (1 hour ago)
     "Increased padding to 20px 40px"
     [Mark Resolved]

ðŸ’¬ Emily Davis (3 days ago)
   "Logo should be 250px wide for better visibility"
   On: Header Component
   Status: âœ“ Resolved

[Add Comment]

```

**Approval Workflow:**

```text

Template Status: Pending Approval

Workflow:
  âœ“ Created by: Sarah Johnson
  âœ“ Reviewed by: Michael Chen
  â³ Awaiting approval: Emily Davis (Marketing Director)

Comments:
  Michael: "Looks good, approved for marketing review"

[Request Changes] [Approve Template]

```

---
