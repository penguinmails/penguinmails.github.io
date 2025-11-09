# CORE-1.4: Implement Pre-commit Hooks with Husky

**Ticket ID:** CORE-1.4  
**Milestone:** 1 - Project Initialization & Code Quality  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

Set up Husky and lint-staged to automatically run ESLint and Prettier on all staged files before a commit is made. This automates quality checks and prevents improperly formatted code from entering the codebase.

## Context

Automated pre-commit hooks ensure code quality standards are enforced before code enters the repository. This prevents common issues from being committed and reduces the burden on code reviewers.

## Acceptance Criteria

1. ✅ Husky is installed and a pre-commit hook is configured
2. ✅ The `lint-staged` configuration in `package.json` is set to run `eslint --fix` and `prettier --write` on staged files
3. ✅ Attempting to commit a file with linting errors fails the commit process with a clear error message
4. ✅ Attempting to commit a file with formatting issues automatically fixes them and allows the commit
5. ✅ The pre-commit hook only runs on staged files (not the entire codebase)

## Technical Details

### Required Packages

- `husky` - Git hooks manager
- `lint-staged` - Run linters on staged files

### Configuration Structure

```json
{
  "lint-staged": {
    "*.{ts,tsx}": [
      "eslint --fix",
      "prettier --write"
    ],
    "*.{js,jsx,json,md}": [
      "prettier --write"
    ]
  }
}
```

## Implementation Notes

- Initialize Husky with `npx husky init`
- Configure the pre-commit hook to run lint-staged
- Ensure the hook runs quickly (only on staged files)
- Provide clear error messages when hooks fail
- Consider adding a commit message linting hook (optional, future enhancement)

## Related Documentation

- [Team Workflow](../../docs/quick-access/team-workflow.md) - Development workflow standards

## Dependencies

- **CORE-1.1** - Next.js project must be initialized
- **CORE-1.2** - ESLint must be configured
- **CORE-1.3** - Prettier must be configured

## Testing

- [ ] Create a file with linting errors and attempt to commit - verify commit fails
- [ ] Create a file with formatting issues and attempt to commit - verify it auto-fixes and commits
- [ ] Verify the hook only processes staged files
- [ ] Test that the hook runs in a reasonable time (< 5 seconds for typical commits)
- [ ] Verify the hook works for both new and modified files

