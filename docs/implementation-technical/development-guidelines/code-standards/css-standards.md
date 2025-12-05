---
title: "CSS Standards"
description: "CSS and styling conventions for enterprise applications"
last_modified_date: "2025-12-04"
level: "3"
persona: "Senior Developers"
keywords: "CSS, styling, Tailwind, design system"
---

# CSS Standards

## CSS Standards

### Design System Integration

```scss
// styles/components/campaign-editor.scss
@import '../design-system/tokens/colors';
@import '../design-system/tokens/typography';
@import '../design-system/tokens/spacing';
@import '../design-system/tokens/elevation';

.campaign-editor {
  max-width: 1200px;
  margin: 0 auto;
  padding: spacing(xl);

  .editor-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: spacing(xl);
    padding-bottom: spacing(md);
    border-bottom: 1px solid $color-border-subtle;

    h2 {
      @include text-heading-lg;
      color: $color-text-primary;
      margin: 0;
    }

    .editor-actions {
      display: flex;
      gap: spacing(sm);
    }
  }

  .editor-content {
    display: grid;
    gap: spacing(xl);

    section {
      background: $color-surface;
      border-radius: $border-radius-lg;
      padding: spacing(lg);
      box-shadow: $elevation-1;
      border: 1px solid $color-border-light;

      h3 {
        @include text-heading-md;
        color: $color-text-primary;
        margin: 0 0 spacing(md) 0;
        padding-bottom: spacing(sm);
        border-bottom: 2px solid $color-primary-100;
      }
    }
  }

  .form-group {
    margin-bottom: spacing(md);

    label {
      @include text-body-sm;
      font-weight: $font-weight-medium;
      color: $color-text-secondary;
      display: block;
      margin-bottom: spacing(xs);
    }

    input, textarea {
      @include input-base;
      width: 100%;

      &:focus {
        @include input-focus;
      }

      &.error {
        @include input-error;
      }
    }

    .error-message {
      @include text-caption;
      color: $color-error;
      margin-top: spacing(xs);
    }
  }

  .ai-optimization-section {
    display: flex;
    align-items: center;
    gap: spacing(sm);
    margin-top: spacing(md);

    button {
      @include button-secondary;

      &:disabled {
        @include button-disabled;
      }
    }
  }
}

// Responsive design
@include mobile {
  .campaign-editor {
    padding: spacing(md);

    .editor-header {
      flex-direction: column;
      gap: spacing(md);
      align-items: stretch;

      .editor-actions {
        justify-content: stretch;

        button {
          flex: 1;
        }
      }
    }
  }
}

```
