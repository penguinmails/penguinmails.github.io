---
title: Accessibility Guidelines
nav_order: 18
has_children: false
description: "WCAG 2.1 AA compliance and inclusive design standards for PenguinMails"
---

# Accessibility Guidelines

## Purpose

These guidelines ensure PenguinMails meets WCAG 2.1 AA standards and provides an inclusive user experience for all users, regardless of ability. Accessibility is not just a compliance requirement—it's essential for reaching the widest possible audience and providing an excellent user experience.

## Legal and Standards Compliance

### WCAG 2.1 Guidelines
- **Level A**: Basic accessibility requirements (minimum compliance)
- **Level AA**: Enhanced accessibility requirements (target standard)
- **Level AAA**: Highest accessibility requirements (aspirational)

### Legal Requirements
- **ADA (Americans with Disabilities Act)**: US federal accessibility requirements
- **Section 508**: US government website accessibility standards
- **EN 301 549**: European accessibility requirements for ICT products
- **AODA (Accessibility for Ontarians with Disabilities Act)**: Canadian provincial requirements

### Industry Standards
- **WAI-ARIA 1.2**: Accessible Rich Internet Applications specification
- **ISO 9241-171**: Ergonomics of human-system interaction - guidance on software accessibility
- **BITV 2.0**: German federal government's accessibility standard

## Perceivable Guidelines

### Text Alternatives
- **All images must have alt text** describing the image's purpose or content
- **Decorative images** use empty alt text (alt="")
- **Complex images** (charts, graphs) include detailed descriptions
- **Icons** use descriptive alt text or aria-label attributes

```html
<!-- Good examples -->
<img src="logo.png" alt="PenguinMails - Email Infrastructure Platform">
<img src="chart.png" alt="Monthly user growth: January 100 users, February 250 users, March 500 users">
<button aria-label="Close dialog">
  <svg aria-hidden="true"><!-- icon --></svg>
</button>

<!-- Avoid -->
<img src="logo.png" alt="Logo">
<img src="chart.png"> <!-- Missing alt text -->
```

### Color and Contrast
- **Normal text**: 4.5:1 contrast ratio minimum
- **Large text** (18pt+ or 14pt+ bold): 3:1 contrast ratio minimum
- **UI components**: 3:1 contrast ratio minimum
- **Focus indicators**: 3:1 contrast ratio against adjacent colors

```css
/* Color contrast compliance */
--text-primary: hsl(222, 84%, 5%);    /* On white background: 20.6:1 */
--text-secondary: hsl(215, 16%, 47%); /* On white background: 6.8:1 */
--text-muted: hsl(215, 16%, 47%);     /* On gray background: 4.6:1 */

/* Focus indicators */
.focus-visible {
  outline: 2px solid hsl(199, 89%, 48%);
  outline-offset: 2px;
}
```

### Audio and Video
- **Captions** for all video content
- **Transcripts** for audio-only content
- **Audio descriptions** for video content with important visual information
- **Pause/stop controls** for auto-playing media

### Structure and Semantics
- **Heading hierarchy**: H1 → H2 → H3 (no skipping levels)
- **Semantic HTML**: Use proper elements (`<main>`, `<nav>`, `<article>`, etc.)
- **Landmarks**: ARIA landmarks for screen reader navigation
- **Lists**: Use proper `<ul>`, `<ol>`, `<dl>` elements

## Operable Guidelines

### Keyboard Navigation
- **All interactive elements** must be keyboard accessible
- **Logical tab order** following reading order
- **Keyboard shortcuts** don't interfere with screen readers
- **No keyboard traps** (can't tab out of a component)

```html
<!-- Keyboard navigation examples -->
<button tabindex="0">Primary Action</button>
<a href="#main-content">Skip to main content</a>

<!-- Custom components need keyboard support -->
<div role="tablist" aria-label="Campaign tabs">
  <button role="tab" aria-selected="true" tabindex="0">
    Active Campaigns
  </button>
  <button role="tab" aria-selected="false" tabindex="-1">
    Draft Campaigns
  </button>
</div>
```

### Touch Targets
- **Minimum size**: 44px × 44px for touch targets
- **Adequate spacing**: 8px minimum between interactive elements
- **Touch gestures**: Support common gestures with alternatives

### Timing and Movement
- **No auto-advancing** carousels or timed content without pause controls
- **Adjustable timeouts**: At least 20 seconds, preferably 10 minutes
- **Reduced motion**: Respect `prefers-reduced-motion` setting
- **Pause animations** that last more than 5 seconds

```css
/* Respect user motion preferences */
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}
```

### Error Prevention
- **Clear error messages** explaining what went wrong
- **Suggestions for correction** when possible
- **Confirmation** for destructive actions
- **Undo functionality** where appropriate

## Understandable Guidelines

### Clear Language
- **Plain language** avoiding jargon and technical terms
- **Consistent terminology** throughout the interface
- **Progressive disclosure** of complex information
- **Helpful error messages** with actionable guidance

### Predictable Behavior
- **Consistent navigation** across all pages
- **Expected interactions** following platform conventions
- **Clear focus indicators** for keyboard navigation
- **No unexpected context changes**

### Input Assistance
- **Field labels** clearly associated with inputs
- **Input formats** clearly specified (e.g., "MM/DD/YYYY")
- **Help text** available for complex fields
- **Autocomplete** for repetitive inputs

```html
<!-- Proper form labeling -->
<label for="email">Email Address</label>
<input id="email" type="email" aria-describedby="email-help">
<span id="email-help">We'll use this to send you campaign updates</span>

<!-- Error states -->
<div class="error-message" role="alert" aria-live="polite">
  Please enter a valid email address
</div>
```

## Robust Guidelines

### Compatible Technologies
- **Standards compliance**: Valid HTML5, CSS3, and JavaScript
- **Progressive enhancement**: Core functionality works without JavaScript
- **Cross-browser support**: Modern browsers with fallbacks
- **API accessibility**: REST APIs designed for assistive technology

### Assistive Technology Support
- **Screen readers**: JAWS, NVDA, VoiceOver, TalkBack
- **Screen magnifiers**: ZoomText, built-in browser zoom
- **Voice control**: Dragon NaturallySpeaking
- **Alternative input**: Switch devices, head pointers

## Implementation Guidelines

### Development Process
1. **Accessibility-first design**: Consider accessibility in initial designs
2. **Automated testing**: Run accessibility audits during development
3. **Manual testing**: Include assistive technology testing
4. **User testing**: Include users with disabilities in testing
5. **Continuous monitoring**: Regular accessibility audits post-launch

### Code Quality Standards
```typescript
// Accessible component example
interface ButtonProps {
  children: React.ReactNode;
  onClick: () => void;
  variant?: 'primary' | 'secondary';
  disabled?: boolean;
  loading?: boolean;
}

export function Button({
  children,
  onClick,
  variant = 'primary',
  disabled = false,
  loading = false
}: ButtonProps) {
  return (
    <button
      className={`btn btn-${variant}`}
      onClick={onClick}
      disabled={disabled || loading}
      aria-disabled={disabled || loading}
    >
      {loading && <Spinner aria-hidden="true" />}
      <span aria-hidden={loading}>{children}</span>
    </button>
  );
}
```

### Accessibility Testing Checklist

#### Automated Testing
- [ ] Color contrast ratios meet WCAG standards
- [ ] Alt text provided for all images
- [ ] Form fields properly labeled
- [ ] Heading hierarchy is correct
- [ ] ARIA attributes used appropriately
- [ ] Keyboard navigation works
- [ ] Focus indicators are visible

#### Manual Testing
- [ ] Screen reader navigation works
- [ ] Keyboard-only operation possible
- [ ] Touch targets are adequate size
- [ ] Error messages are helpful
- [ ] Content makes sense when zoomed
- [ ] Color is not the only way information is conveyed

#### Assistive Technology Testing
- [ ] Works with screen readers (NVDA, JAWS, VoiceOver)
- [ ] Works with voice control software
- [ ] Works with screen magnification
- [ ] Works with high contrast modes
- [ ] Works with reduced motion preferences

## Component-Specific Guidelines

### Data Tables
```html
<table role="table" aria-label="Campaign performance data">
  <thead>
    <tr>
      <th scope="col">Campaign Name</th>
      <th scope="col">Sent</th>
      <th scope="col">Open Rate</th>
      <th scope="col">Click Rate</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th scope="row">Welcome Series</th>
      <td>1,250</td>
      <td>42%</td>
      <td>8%</td>
    </tr>
  </tbody>
</table>
```

### Modal Dialogs
```html
<div role="dialog" aria-modal="true" aria-labelledby="modal-title">
  <div class="modal-header">
    <h2 id="modal-title">Confirm Campaign Deletion</h2>
    <button aria-label="Close dialog">
      <CloseIcon />
    </button>
  </div>
  <div class="modal-body">
    <p>Are you sure you want to delete this campaign?</p>
  </div>
  <div class="modal-footer">
    <button>Cancel</button>
    <button class="destructive">Delete Campaign</button>
  </div>
</div>
```

### Progress Indicators
```html
<div role="progressbar" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100">
  <span class="sr-only">Sending emails: 75% complete</span>
  <div class="progress-bar" style="width: 75%"></div>
</div>
```

### Custom Components
- **ARIA attributes**: Use appropriate ARIA roles and properties
- **Keyboard support**: Custom components need keyboard event handlers
- **Focus management**: Proper focus behavior for complex components
- **Screen reader support**: Descriptive announcements and instructions

## Content Guidelines

### Writing for Accessibility
- **Clear headings** that describe section content
- **Short paragraphs** (3-5 sentences maximum)
- **Simple words** avoiding complex vocabulary
- **Active voice** instead of passive voice
- **Front-loaded content** (most important information first)

### Visual Design Guidelines
- **Sufficient contrast** for all text and UI elements
- **Meaningful icons** with text labels
- **Consistent spacing** for visual hierarchy
- **Clear focus indicators** that don't rely on color alone
- **Readable fonts** at appropriate sizes

### Multimedia Content
- **Audio content** requires transcripts
- **Video content** requires captions and audio descriptions
- **Animations** should be optional and respect user preferences
- **Interactive content** should be operable by multiple input methods

## Tools and Resources

### Development Tools
- **axe DevTools**: Browser extension for accessibility testing
- **WAVE**: Web accessibility evaluation tool
- **Lighthouse**: Automated accessibility auditing
- **Color Contrast Analyzer**: Contrast ratio checking
- **NVDA**: Free screen reader for testing

### Design Tools
- **Stark**: Contrast checking and simulation tools
- **Color Oracle**: Color blindness simulation
- **Accessibility Plugin for Figma**: Design-time accessibility checks
- **Contrast Grid**: Contrast ratio visualization

### Testing Environments
- **Screen Reader Testing**: NVDA (Windows), VoiceOver (macOS), TalkBack (Android)
- **Keyboard Testing**: Full keyboard navigation testing
- **Mobile Testing**: Touch target and gesture testing
- **Cross-browser Testing**: Accessibility across different browsers

## Monitoring and Maintenance

### Accessibility Audits
- **Quarterly automated scans** of all pages
- **Annual comprehensive audit** by external experts
- **Continuous monitoring** of accessibility metrics
- **User feedback integration** from accessibility issues

### Performance Metrics
- **Accessibility score**: Lighthouse accessibility score > 90
- **Issue resolution time**: Average time to fix accessibility issues < 48 hours
- **User satisfaction**: Accessibility-related support ticket volume
- **Compliance rate**: Percentage of components meeting accessibility standards

### Training and Awareness
- **Developer training**: Accessibility fundamentals for all developers
- **Designer training**: Inclusive design principles and techniques
- **QA training**: Accessibility testing methodologies
- **Stakeholder education**: Business case for accessibility

## Common Issues and Solutions

### Missing Alt Text
**Issue**: Images without alternative text
**Solution**: Implement alt text requirements in component library

### Poor Color Contrast
**Issue**: Text doesn't meet contrast requirements
**Solution**: Design system enforces contrast ratios

### Keyboard Navigation Problems
**Issue**: Interactive elements not keyboard accessible
**Solution**: Component library includes keyboard support by default

### Missing Form Labels
**Issue**: Form fields without proper labels
**Solution**: Form components require labels and enforce proper association

### Inaccessible Custom Components
**Issue**: Custom widgets not accessible to assistive technology
**Solution**: ARIA implementation guidelines and testing requirements

---

## Related Documents
- [Design System](design-system.md) - Complete design system overview
- [Design Tokens](design-tokens.md) - Design token specifications
- [Component Library](component-library.md) - Reusable component catalog
- [UI Library](ui-library.md) - Component usage guidelines and patterns

**Keywords**: accessibility, WCAG, inclusive design, screen readers, keyboard navigation, color contrast, assistive technology, ARIA, a11y