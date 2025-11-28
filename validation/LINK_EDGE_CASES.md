# Link Policy Edge Cases

This document tracks edge cases discovered during production validation of link policies.

## Edge Case 1: Relative Links with `./` Prefix

**Date Discovered**: 2025-11-28
**Category**: links
**Affected Files**: 
- docs/implementation-technical/development-guidelines/development-standards.md
- docs/user-journeys/README.md

**Pattern**:
```markdown
[Link Text](./relative-path)
[Link Text](./relative-path.md)
```

**Examples from Production**:
```markdown
- **[Code Standards](./code-standards)** - Comprehensive coding standards
- **[User Journey Testing](./user-journey-testing.md)** - New user onboarding
```

**Root Cause**:
The original fixture tests only covered:
- Site-absolute links with `.md` extension: `[Link](/docs/path/file.md)`
- Relative links to non-Jekyll folders: `[Link](../tasks/)`

They did NOT cover relative links within the `docs/` directory using `./` or `../` prefixes.

**Impact**:
- Jekyll processes these links correctly when files are in the same directory
- However, they violate the link policy which requires site-absolute `/docs/` links
- These links are fragile and break when files are moved

**Resolution**:
- [x] Documented edge case pattern
- [x] Created fixture files for relative `./` links
- [x] Created fixture files for relative `../` links
- [x] Updated detection script to catch these patterns
- [x] Re-ran test suite to verify (Link Policy tests: 2/2 passing)
- [ ] Updated fix script to convert relative links to site-absolute (requires path resolution logic)

**Prevention**:
Add fixtures covering:
1. Relative links with `./` prefix (same directory)
2. Relative links with `../` prefix (parent directory)
3. Complex relative paths like `../../docs/`
4. Relative links with and without `.md` extensions

---

## Edge Case 2: Relative Links with `../` Prefix

**Date Discovered**: 2025-11-28
**Category**: links
**Affected Files**: 
- docs/user-journeys/README.md

**Pattern**:
```markdown
[Link Text](../sibling-folder/file)
[Link Text](../sibling-folder/file.md)
```

**Examples from Production**:
```markdown
- **[Roadmap](../roadmap/README.md)** - When journeys will be improved
```

**Root Cause**:
Same as Edge Case 1 - fixtures only covered specific patterns, not all relative link variations.

**Impact**:
- Works in Jekyll but violates link policy
- Fragile when directory structure changes
- Inconsistent with site-absolute link standard

**Resolution**:
- [x] Documented edge case pattern
- [x] Created fixture files
- [x] Updated detection script
- [x] Re-ran test suite to verify (Link Policy tests: 2/2 passing)
- [ ] Updated fix script (requires path resolution logic)

---

## Edge Case 3: Complex Relative Paths

**Date Discovered**: 2025-11-28
**Category**: links
**Affected Files**: 
- docs/user-journeys/README.md

**Pattern**:
```markdown
[Link Text](../../docs/path/to/file.md)
```

**Examples from Production**:
```markdown
- **[Campaign Creation Journey](../../docs/operations-analytics/analytics-performance/user-journey-analytics-campaigns.md)**
```

**Root Cause**:
This is an unusual pattern where a file in `docs/` links to another file in `docs/` using `../../docs/` instead of `/docs/` or a simple relative path.

**Impact**:
- Extremely fragile - breaks if either file moves
- Confusing path that goes up two levels then back into docs
- Should use site-absolute `/docs/` path instead

**Resolution**:
- [x] Documented edge case pattern
- [x] Created fixture file
- [x] Updated detection script to catch `../../` patterns
- [x] Re-ran test suite to verify (Link Policy tests: 2/2 passing)
- [ ] Updated fix script to convert to site-absolute (requires path resolution logic)

---

## Edge Case 4: Anchor Links with Relative Paths

**Date Discovered**: 2025-11-28
**Category**: links
**Affected Files**: 
- Multiple files across docs/

**Pattern**:
```markdown
[Link Text](./file#anchor)
[Link Text](../folder/file#anchor)
```

**Examples from Production**:
Not found yet, but theoretically possible based on other patterns.

**Root Cause**:
Combination of relative path and anchor link.

**Impact**:
- Same fragility as other relative links
- Anchor portion should be preserved when converting to site-absolute

**Resolution**:
- [x] Documented potential edge case
- [x] Created fixture file with anchor examples
- [x] Detection script catches relative links with anchors
- [x] Re-ran test suite to verify (Link Policy tests: 2/2 passing)
- [ ] Fix script needs to preserve anchors when converting (requires path resolution logic)

---

## Summary of Required Fixture Files

### Already Covered (validation/fixtures/links/bad/):
- ✅ `md_extension_site_absolute.md` - Site-absolute with `.md`
- ✅ `relative_tasks_link.md` - Links to non-Jekyll `tasks/` folder
- ✅ `relative_journeys_link.md` - Links to non-Jekyll `user-journeys/` folder
- ✅ `contributing_link.md` - Links to non-Jekyll `CONTRIBUTING.md`
- ✅ `relative_md_links.md` - Basic relative links with `.md`

### New Fixtures Created:
- [x] `relative_same_dir.md` - Links with `./` prefix (no `.md`)
- [x] `relative_same_dir_with_md.md` - Links with `./` prefix (with `.md`)
- [x] `relative_parent_dir.md` - Links with `../` prefix (no `.md`)
- [x] `relative_parent_dir_with_md.md` - Links with `../` prefix (with `.md`)
- [x] `relative_complex_path.md` - Links with `../../docs/` pattern
- [x] `relative_with_anchors.md` - Relative links with `#anchor` fragments

### Good Fixtures Needed:
- [ ] Update `site_absolute_links.md` to show correct conversion examples

---

## Detection Script Updates

✅ **COMPLETED** - The detection script has been enhanced with:

1. **Edge Case Detection Section** - Separate section for better categorization
2. **Same-directory links** - Pattern: `]\(\\./[^/)]*)`
3. **Parent-directory links** - Pattern: `]\(\\.\\./[^)]*)`
4. **Complex paths** - Pattern: `](../../docs/`
5. **Links with anchors** - Pattern: `]\(\\./[^)]*#|]\(\\.\\./[^)]*#`

All patterns are now detected and categorized separately in the JSON report.

---

## Fix Script Updates Required

The current `fix_link_extensions.sh` only handles:
- Removing `.md` from site-absolute `/docs/` links

It needs to be enhanced or a new script created to:
1. Convert `./file` → `/docs/current-dir/file`
2. Convert `../folder/file` → `/docs/parent-dir/folder/file`
3. Convert `../../docs/path/file` → `/docs/path/file`
4. Preserve anchor fragments in all conversions
5. Handle `.md` extension removal during conversion

**Complexity**: HIGH
- Requires knowing the current file's path in the docs structure
- Must calculate correct site-absolute path based on relative path
- Must handle edge cases like `./` vs `../` vs `../../`

**Recommendation**: 
- Create a new script `fix_relative_links.sh` separate from `fix_link_extensions.sh`
- Or enhance existing script with path resolution logic
- Test thoroughly on fixtures before production use

---

## Test Suite Updates

✅ **VERIFIED** - Test suite status:
- Link Policy Detection (good fixtures): ✓ PASS
- Link Policy Detection (bad fixtures): ✓ PASS
- All 6 new edge case fixtures are detected correctly
- Detection script catches all patterns without errors

**Note**: The test suite validates detection only. Fix script tests will be added once the fix script is enhanced with path resolution logic.

Current test count: 17 tests (11 passing, 6 failing in unrelated categories)

---

## Production Impact Assessment

**Files Affected**: ~50+ files based on grep results

**Risk Level**: MEDIUM
- Relative links work in Jekyll but violate policy
- Converting them is safe but requires careful path calculation
- Incorrect conversion could break navigation

**Recommended Approach**:
1. ✅ Document all edge cases (this file)
2. ✅ Create comprehensive fixtures
3. ✅ Update detection script
4. ⚠️ Create/update fix script with path resolution
5. ⚠️ Test extensively on fixtures
6. ⚠️ Test on copy of docs before production
7. ⚠️ Manual review of conversions
8. ⚠️ Apply to production with commit

**Timeline**: 
- Edge case documentation: Complete
- Fixture creation: 1-2 hours
- Script updates: 2-4 hours
- Testing: 1-2 hours
- Production application: 1 hour

---

## Next Steps

### Completed ✅
1. ✅ Created new fixture files for all edge cases (6 new fixtures)
2. ✅ Updated detection script with clearer categorization
3. ✅ Verified detection with test suite (Link Policy: 2/2 passing)

### Remaining Tasks
4. **Decide on fix strategy** (RECOMMENDED: Option C for now):
   - Option A: Enhance `fix_link_extensions.sh` with path resolution (COMPLEX - requires file path context)
   - Option B: Create new `fix_relative_links.sh` script (COMPLEX - requires path resolution logic)
   - Option C: Manual fixes with script-assisted detection (SAFE - recommended for production)
5. If implementing automated fix:
   - Implement path resolution logic
   - Handle anchor preservation
   - Update test suite with fix verification
   - Test extensively on fixtures
6. Test on docs copy before production
7. Apply to production with careful review

### Recommendation

**For task 5.3 (Apply link fixes to production):**
- Use current `fix_link_extensions.sh` for `.md` extension removal (already working)
- Use detection script to identify relative links
- Apply manual fixes for relative links (safer than automated path resolution)
- Reason: Path resolution is complex and error-prone; manual review ensures correctness

---

**Last Updated**: 2025-11-28
**Status**: Edge cases documented and detected; automated fix pending decision
**Owner**: Validation Pipeline Team
