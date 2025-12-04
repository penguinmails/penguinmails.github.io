---
title: "Bug Verification & Best Practices"
description: "Testing checklists and bug reporting best practices"
last_modified_date: "2025-12-04"
level: "3"
persona: "Quality Assurance"
keywords: "bug verification, testing checklist, QA best practices"
---

# Bug Verification & Best Practices

## Bug Verification Checklist

**Before marking as fixed:**

- [ ] Bug reproduced in original environment

- [ ] Fix applied successfully

- [ ] Fix doesn't break existing functionality

- [ ] Edge cases handled

- [ ] Tests added to prevent regression

- [ ] Documentation updated if needed

- [ ] Security implications considered

- [ ] Performance impact assessed

- [ ] User communication prepared if needed

**Regression Testing:**

- [ ] All related functionality still works

- [ ] No new bugs introduced

- [ ] Performance maintained

- [ ] Security measures intact

- [ ] User experience preserved

## Bug Reporting Best Practices

### Good Bug Reports

1. **Clear Title**: Summarize the issue in one line

2. **Steps to Reproduce**: Provide exact steps

3. **Expected vs Actual**: Clear distinction

4. **Environment Details**: Complete system information

5. **Screenshots**: Visual evidence when helpful

6. **Error Logs**: Include relevant log entries

7. **Minimal Case**: Reduce to simplest reproduction

### Information to Include

- **Application State**: What was happening when bug occurred

- **User Actions**: Exact sequence of actions taken

- **Data**: Any specific data that triggered the bug

- **Network**: Any network-related issues

- **Browser/Client**: Client-specific details

- **Frequency**: How often does this occur

### Information to Avoid

- **Vague descriptions**: "It doesn't work"

- **Multiple issues**: One bug report per issue

- **Duplicate reports**: Check existing issues first

- **Personal information**: Never include passwords, tokens, etc.

- **Irrelevant details**: Focus on the bug, not your day

For testing requirements, see [`testing-requirements.md`](/docs/implementation-technical/development-guidelines/testing-requirements).
For the contribution process, see [`code-contribution.md`](/docs/implementation-technical/development-guidelines/code-contribution).
