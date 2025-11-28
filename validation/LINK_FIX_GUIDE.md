# Link Fix Quick Reference Guide

**Purpose**: Quick reference for fixing link policy violations discovered in Task 5.2

---

## 🎯 Quick Fix Patterns

### Pattern 1: Remove `.md` Extensions (AUTOMATED ✅)

**Before**: `[Link](/docs/features/README.md)`  
**After**: `[Link](/docs/features/README)`

**Command**:
```bash
bash validation/scripts/fix/fix_link_extensions.sh docs
```

---

### Pattern 2: Same-Directory Relative Links

**Before**: `[Code Standards](./code-standards)`  
**After**: `[Code Standards](/docs/implementation-technical/development-guidelines/code-standards)`

**Rule**: Replace `./` with full site-absolute path `/docs/current-section/`

---

### Pattern 3: Parent-Directory Relative Links

**Before**: `[Roadmap](../roadmap/README.md)`  
**After**: `[Roadmap](/docs/roadmap)`

**Rule**: Replace `../folder/` with `/docs/folder/` and remove `.md`

---

### Pattern 4: Complex Relative Paths

**Before**: `[Campaign Journey](../../docs/operations-analytics/analytics-performance/user-journey-analytics-campaigns.md)`  
**After**: `[Campaign Journey](/docs/operations-analytics/analytics-performance/user-journey-analytics-campaigns)`

**Rule**: Replace `../../docs/` with `/docs/` and remove `.md`

---

### Pattern 5: Relative Links with Anchors

**Before**: `[SOP Workflow](./task-clarity-essentials#sop-workflow)`  
**After**: `[SOP Workflow](/docs/freelancer-onboarding/task-clarity-essentials#sop-workflow)`

**Rule**: Convert path to site-absolute, **preserve the `#anchor`**

---

### Pattern 6: Links to Non-Jekyll Files

**Before**: `[Tasks](../tasks/epic-1/README.md)`  
**After**: Remove or replace with valid docs link

**Rule**: `tasks/`, `user-journeys/`, `CONTRIBUTING.md`, root `README.md` are NOT published

---

## 🔍 Detection Commands

### Check All Violations
```bash
bash validation/scripts/detect/detect_link_policy_violations.sh docs
```

### Check Specific Directory
```bash
bash validation/scripts/detect/detect_link_policy_violations.sh docs/features
```

### View Latest Report
```bash
cat validation/reports/link_violations_*.json | jq .
```

---

## 📝 Manual Fix Workflow

### Step 1: Identify Files with Issues
```bash
bash validation/scripts/detect/detect_link_policy_violations.sh docs 2>&1 | grep "✗"
```

### Step 2: Fix High-Priority Files First
Priority order:
1. `docs/getting-started.md`
2. `docs/quick-setup.md`
3. `docs/*/README.md` (hub pages)
4. Frequently accessed documentation
5. Remaining files

### Step 3: Use Find & Replace in Editor

**VS Code / Kiro IDE**:
- Open file
- Use Regex find & replace
- Test patterns on one file first
- Verify links work after changes

**Example Regex Patterns**:
```regex
# Find relative same-dir links
\]\(\./([^)]+)\)

# Find relative parent-dir links
\]\(\.\./([^)]+)\)

# Find .md extensions in site-absolute links
\]\(/docs/([^)]+)\.md\)
```

### Step 4: Verify Each Batch
```bash
# After fixing a batch of files
bash validation/scripts/detect/detect_link_policy_violations.sh docs

# Check specific files
bash validation/scripts/detect/detect_link_policy_violations.sh docs/features
```

### Step 5: Commit Incrementally
```bash
git add docs/features/
git commit -m "fix: convert relative links to site-absolute in features/"
```

---

## 🎨 Path Resolution Examples

### Example 1: File in `docs/implementation-technical/development-guidelines/`

**Current file**: `docs/implementation-technical/development-guidelines/development-standards.md`

**Relative link**: `[Code Standards](./code-standards)`  
**Site-absolute**: `[Code Standards](/docs/implementation-technical/development-guidelines/code-standards)`

**Relative link**: `[API Reference](./api-reference)`  
**Site-absolute**: `[API Reference](/docs/implementation-technical/development-guidelines/api-reference)`

---

### Example 2: File in `docs/user-journeys/`

**Current file**: `docs/user-journeys/README.md`

**Relative link**: `[User Journey Testing](./user-journey-testing.md)`  
**Site-absolute**: `[User Journey Testing](/docs/user-journeys/user-journey-testing)`

**Relative link**: `[Roadmap](../roadmap/README.md)`  
**Site-absolute**: `[Roadmap](/docs/roadmap)`

---

### Example 3: File in `docs/quick-setup.md`

**Current file**: `docs/quick-setup.md`

**Relative link**: `[Task Clarity](./freelancer-onboarding/task-clarity-essentials#sop-workflow)`  
**Site-absolute**: `[Task Clarity](/docs/freelancer-onboarding/task-clarity-essentials#sop-workflow)`

---

## ⚠️ Common Mistakes to Avoid

### ❌ Don't Do This:
```markdown
# Keeping .md extension
[Link](/docs/features/README.md)

# Using relative paths
[Link](../features/analytics)

# Forgetting to update anchor links
[Link](./file#section) → [Link](/docs/section/file)  # Lost the #section!
```

### ✅ Do This Instead:
```markdown
# Remove .md extension
[Link](/docs/features/README)

# Use site-absolute paths
[Link](/docs/features/analytics)

# Preserve anchors
[Link](./file#section) → [Link](/docs/section/file#section)  # Anchor preserved!
```

---

## 📊 Progress Tracking

### Initial State (2025-11-28)
- Total violations: **765**
- Automated fixes available: **195** (`.md` extensions)
- Manual fixes required: **570** (relative links)

### Track Your Progress
```bash
# Run detection and count violations
bash validation/scripts/detect/detect_link_policy_violations.sh docs 2>&1 | grep "Found.*link policy violations"

# Goal: 0 violations
```

---

## 🆘 Troubleshooting

### Issue: Can't find the correct site-absolute path

**Solution**: Look at the file's location in the `docs/` directory
```bash
# If file is at: docs/features/analytics/overview.md
# And you want to link to: docs/features/analytics/core-analytics.md
# Use: /docs/features/analytics/core-analytics
```

### Issue: Link works in repo but breaks on site

**Cause**: Linking to non-Jekyll files (`tasks/`, `user-journeys/`, etc.)  
**Solution**: Remove the link or find equivalent in `docs/`

### Issue: Anchor link not working after conversion

**Cause**: Forgot to preserve the `#anchor` fragment  
**Solution**: Always copy the `#anchor` part when converting paths

---

## 📚 Related Documentation

- **Edge Cases**: `validation/LINK_EDGE_CASES.md`
- **Summary**: `validation/LINK_EDGE_CASES_SUMMARY.md`
- **Broken Links Report**: `validation/broken_links_report_generated.md`
- **Link Policy**: `.kiro/steering/tech.md`

---

## 🎯 Success Criteria

✅ All link policy violations resolved  
✅ Detection script returns 0 violations  
✅ All internal links use site-absolute `/docs/` paths  
✅ No `.md` extensions in links  
✅ No links to non-Jekyll files  
✅ All anchor fragments preserved  

---

**Last Updated**: 2025-11-28  
**Task**: 5.2 Handle link edge cases if discovered  
**Status**: Guide complete, ready for Task 5.3 (Apply fixes)
