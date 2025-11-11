# CORE-1.3: Configure Prettier for Code Formatting

**Ticket ID:** CORE-1.3  
**Milestone:** 1 - Project Initialization & Code Quality  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

Install and configure Prettier to enforce a consistent code style across the entire codebase. This eliminates debates about formatting and improves readability, making code reviews more focused on logic rather than style.

## Context

Consistent code formatting is crucial for team collaboration. Prettier automates formatting decisions, ensuring all code follows the same style regardless of who writes it.

## Acceptance Criteria

1. ✅ A `.prettierrc` configuration file is created with our team's chosen style rules (e.g., `semi: true`, `singleQuote: true`)
2. ✅ A `.prettierignore` file is created to exclude non-code files (e.g., `node_modules`, `.next`, `dist`)
3. ✅ An `npm run format` script is added to `package.json` that runs Prettier
4. ✅ An `npm run format:check` script is added to verify formatting without making changes
5. ✅ Prettier configuration is compatible with ESLint (consider using `eslint-config-prettier`)

## Technical Details

### Required Packages

- `prettier`
- `eslint-config-prettier` (to avoid conflicts with ESLint)
- `eslint-plugin-prettier` (optional, to run Prettier as ESLint rule)

### Recommended Configuration

```json
{
  "semi": true,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5",
  "printWidth": 80,
  "arrowParens": "avoid"
}
```

## Implementation Notes

- Configure Prettier to work alongside ESLint without conflicts
- Set up appropriate ignore patterns for generated files and dependencies
- Consider adding format-on-save in IDE configuration (separate from this ticket)
- Ensure Prettier handles TypeScript, JavaScript, JSON, and Markdown files

## Related Documentation

- [Development Standards](../../docs/implementation-technical/development-guidelines/development-standards.md) - **Primary reference** for Prettier configuration and code formatting standards
- [Team Workflow](../../docs/quick-access/team-workflow.md) - Code formatting standards

## Dependencies

- **CORE-1.1** - Next.js project must be initialized
- **CORE-1.2** - ESLint should be configured to avoid conflicts

## Testing

- [ ] Run `npm run format` and verify it formats files correctly
- [ ] Run `npm run format:check` and verify it detects formatting issues
- [ ] Verify Prettier formats TypeScript, JavaScript, and JSON files
- [ ] Confirm Prettier ignores files listed in `.prettierignore`


