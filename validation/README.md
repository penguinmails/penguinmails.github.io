# Documentation Validation

Clean, focused validation system for CI/CD and local development.

## Quick Start

### Run Main Validation (CI Script)

The CI pipeline runs these scripts individually:

1. **Critical Checks** (Fails Build):

   ```bash
   bash validation/detect/detect_link_policy_violations.sh
   ```

2. **Warning Checks** (Non-Blocking):

   ```bash
   bash validation/detect/detect_link_warnings.sh
   bash validation/detect/detect_frontmatter_issues.sh
   bash validation/detect/detect_tech_stack_violations.sh
   bash validation/detect/detect_formatting_issues.sh
   bash validation/detect/detect_navigation_violations.sh
   bash validation/detect/detect_content_quality_issues.sh
   ```

### Run with JSON Reports

By default, scripts output to stdout only. To generate JSON report files, use the `--report` flag:

```bash
# Generate JSON report in validation/reports/
bash validation/detect/detect_frontmatter_issues.sh --report
bash validation/detect/detect_frontmatter_issues.sh docs --report
```

### Run Detection Scripts

```bash
# Detect specific issues
bash validation/detect/detect_frontmatter_issues.sh
bash validation/detect/detect_link_policy_violations.sh # Critical only
bash validation/detect/detect_link_warnings.sh          # Warnings only
bash validation/detect/detect_tech_stack_violations.sh
bash validation/detect/detect_formatting_issues.sh
```

### Run Fix Scripts

```bash
# Fix common issues automatically
bash validation/fix/fix_link_extensions.sh        # Remove .md from /docs/ links
bash validation/fix/fix_codefences.sh              # Fix code fence formatting
bash validation/fix/fix_whitespace.sh              # Fix whitespace issues
```

## Structure

```bash
validation/
├── README.md           # This file
├── detect/             # Detection scripts (identify issues)
│   ├── detect_frontmatter_issues.sh
│   ├── detect_link_policy_violations.sh
│   ├── detect_link_warnings.sh
│   ├── detect_tech_stack_violations.sh
│   ├── detect_formatting_issues.sh
│   ├── detect_navigation_violations.sh
│   └── detect_content_quality_issues.sh
└── fix/                # Fix scripts (resolve issues)
    ├── fix_link_extensions.sh
    ├── fix_codefences.sh
    └── fix_whitespace.sh
```

## Link Policy

Internal documentation links must follow Jekyll conventions:

✅ **Correct**:

- Site-absolute: `/docs/features/analytics`
- With anchor: `/docs/implementation-technical/architecture#database`

❌ **Incorrect**:

- Relative: `./overview.md`, `../README.md`
- With extension: `/docs/features/README.md`
- To non-Jekyll files: `../tasks/task-01.md`

## Tech Stack Policy

Approved technologies:

- **Languages**: TypeScript, JavaScript, SQL, Bash
- **Database ORM**: Drizzle (NileDB SDK)
- **Database**: PostgreSQL (NileDB)
- **Queue**: Hybrid PostgreSQL + Redis

Forbidden code blocks: `python`, `ruby`, `php`, `csharp`

## File LOC Limits

Documentation files must stay within defined line limits to ensure maintainability and readability:

✅ **Thresholds**:

- **README.md & overview.md**: 250 lines (navigation hubs should be concise)
- **Guides & Feature docs**: 400 lines (`/guide/`, `/features/`)
- **API & Reference docs**: 600 lines (`/api/`, `/reference/`, `/implementation-technical/`)
- **Other documentation**: 500 lines (default)

💡 **Rationale**:

- Navigation hub files (README, overview) should guide users to detailed content, not contain it
- Shorter files are easier to maintain, review, and keep up-to-date
- Encourages proper content organization and information architecture
- Technical/API documentation may require more detail, hence higher limits

❌ **If file exceeds limit**:

1. Split into multiple focused files
2. Move detailed content to dedicated pages
3. Keep overview/hub file as a navigation guide with links

## CI/CD Integration

The `.github/workflows/validate-docs.yml` workflow has two jobs:

1. **Critical Link Validation**:
   - Runs `detect_link_policy_violations.sh`
   - Fails the build if critical issues are found

2. **Documentation Warnings**:
   - Runs all other detection scripts
   - Reports issues as warnings but does not fail the build

## Archived Files

Legacy artifacts, test fixtures, and reports have been moved to `.roo/legacy-archive/validation/` for reference.

## Related Files

- CI workflow: `.github/workflows/validate-docs.yml`
- Main validation script: `test-validation.sh`

## Session Log

### 2025-12-04 18:09 UTC - Content Quality Maintenance Cycle

**Objective**: Execute operational loop to reduce overlong files per content-quality-maintenance-agent.md

**Files Processed**:
- ✅ `bug-reporting.md` (2122 lines) → Split into hub + 6 subpages
  - Created `bug-reporting/overview.md` (175 lines) - Hub with navigation
  - Created `bug-reporting/bug-fix-guidelines.md` (433 lines)
  - Created `bug-reporting/email-delivery-bugs.md` (360 lines)
  - Created `bug-reporting/api-bugs.md` (233 lines)
  - Created `bug-reporting/database-bugs.md` (223 lines)
  - Created `bug-reporting/performance-bugs.md` (328 lines)
  - Created `bug-reporting/security-bugs.md` (375 lines)
  - Created `bug-reporting/bug-verification.md` (91 lines)
  - Updated links in `contribution-guide.md`

**Reports Generated**:
- Initial: `content_quality_issues_20251204_180923.json` (186 issues)
- Post-split: `content_quality_issues_20251204_181420.json` (185 issues)

**Remaining Backlog**: 184 overlong files
- Next target: `compliance/roadmap.md` (1516 lines)

**Third Iteration**:
- ✅ `executive-reporting-framework.md` (1884 lines) → Split into hub + 9 subpages
  - Created `executive-reporting/overview.md` (93 lines) - Hub with navigation
  - Created `executive-reporting/daily-briefing.md` (77 lines)
  - Created `executive-reporting/weekly-report.md` (441 lines)
  - Created `executive-reporting/monthly-review.md` (846 lines) - Still over 500, needs further split
  - Created `executive-reporting/automation.md` (133 lines)
  - Created `executive-reporting/integration.md` (59 lines)
  - Created `executive-reporting/security.md` (75 lines)
  - Created `executive-reporting/success-metrics.md` (95 lines)
  - Created `executive-reporting/implementation.md` (103 lines)
  - Created `executive-reporting/budget.md` (81 lines)
  - Updated links in documentation

**Reports Generated**:
- Post-exec-split: `content_quality_issues_20251204_182030.json` (184 issues)

**Note**: Monthly-review.md (846 lines) still exceeds 500-line limit and will need additional splitting in future iteration.

**Fourth Iteration**:
- ✅ `compliance/roadmap.md` (1516 lines) → Split into hub + 7 quarterly roadmaps
  - Created `roadmap/overview.md` (88 lines) - Hub with quarterly navigation
  - Created `roadmap/q4-2025.md` (95 lines) - MVP Foundation
  - Created `roadmap/q1-2026.md` (75 lines) - Enhanced Security
  - Created `roadmap/q2-2026.md` (94 lines) - Compliance Certifications
  - Created `roadmap/q3-2026.md` (78 lines) - Enterprise Security
  - Created `roadmap/q4-2026.md` (95 lines) - Advanced Authentication
  - Created `roadmap/q1-2027.md` (85 lines) - Compliance Expansion
  - Created `roadmap/q2-2027.md` (997 lines) - Government & Enterprise (still over 500)
  - Updated links in README

**Reports Generated**:
- Post-compliance-split: `content_quality_issues_20251204_182300.json` (184 issues)

**Note**: q2-2027.md (997 lines) still exceeds 500-line limit but is under 1000. Contains future vision and detailed roadmap items.

---

### Session Summary

**Session Duration**: 2025-12-04 18:09 - 18:23 UTC (14 minutes)

**Files Successfully Split**: 4
1. bug-reporting.md (2122 → 0 lines) - Split into 8 files
2. product-roadmap.md (2100 → 0 lines) - Split into 9 files
3. executive-reporting-framework.md (1884 → 846 lines) - Split into 10 files
4. compliance/roadmap.md (1516 → 997 lines) - Split into 8 files

**Total New Files Created**: 35 modular documentation files

**Impact Achieved**:
- Largest file reduced from 2122 to 1492 lines (30% improvement)
- Total issues: 186 → 184 (net reduction of 2, accounting for new files over 500)
- All new hub files under 250 lines
- Most subpages under 450 lines
- 2 subpages still need further splitting (monthly-review: 846, q2-2027: 997)

**Remaining Backlog**: 184 files
- Top targets: code-standards.md (1492), compliance-framework.md (1491), import-export.md (1454)

**Next Session**: Continue with code-standards.md and other high-variance files.

**Second Iteration**:
- ✅ `product-roadmap.md` (2100 lines) → Split into hub + 8 feature roadmaps
  - Created `product-roadmap/overview.md` (219 lines) - Hub with feature navigation
  - Created `product-roadmap/infrastructure.md` (214 lines)
  - Created `product-roadmap/domain-management.md` (174 lines)
  - Created `product-roadmap/automation-workflows.md` (118 lines)
  - Created `product-roadmap/billing-subscriptions.md` (286 lines)
  - Created `product-roadmap/analytics-reporting.md` (282 lines)
  - Created `product-roadmap/integrations.md` (368 lines)
  - Created `product-roadmap/inbox-management.md` (322 lines)
  - Created `product-roadmap/development-milestones.md` (224 lines)
  - Updated 20+ links across documentation

**Reports Generated**:
- Post-roadmap-split: `content_quality_issues_20251204_181736.json` (184 issues)
