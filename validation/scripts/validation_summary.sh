#!/bin/bash

# Validation Summary
# Shows current validation status across all categories
# Usage: ./validation_summary.sh [docs|docs-test-backup]

set -e

TARGET_ROOT="${1:-docs}"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "VALIDATION SUMMARY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Target: $TARGET_ROOT"
echo "Date: $(date)"
echo ""

# Markdownlint checks
echo -e "${CYAN}═══ Markdownlint Checks ═══${NC}"
echo ""

# MD040 - Code fence language
md040_count=$(docker run --rm -v $PWD:/md -w /md peterdavehello/markdownlint:latest \
  markdownlint "$TARGET_ROOT/" --config .markdownlint.json 2>&1 | grep -c "MD040" || echo "0")

if [ "$md040_count" -eq 0 ]; then
  echo -e "${GREEN}✓${NC} MD040 (Code fence language): 0 violations"
else
  echo -e "${RED}✗${NC} MD040 (Code fence language): $md040_count violations"
  echo "  Fix: bash validation/scripts/fix/fix_codefences_md040_v2.sh $TARGET_ROOT"
fi

# MD001 - Heading hierarchy
md001_count=$(docker run --rm -v $PWD:/md -w /md peterdavehello/markdownlint:latest \
  markdownlint "$TARGET_ROOT/" --config .markdownlint.json 2>&1 | grep -c "MD001" || echo "0")

if [ "$md001_count" -eq 0 ]; then
  echo -e "${GREEN}✓${NC} MD001 (Heading hierarchy): 0 violations"
else
  echo -e "${YELLOW}⚠${NC} MD001 (Heading hierarchy): $md001_count violations (manual fix)"
fi

# MD036 - Emphasis as heading
md036_count=$(docker run --rm -v $PWD:/md -w /md peterdavehello/markdownlint:latest \
  markdownlint "$TARGET_ROOT/" --config .markdownlint.json 2>&1 | grep -c "MD036" || echo "0")

if [ "$md036_count" -eq 0 ]; then
  echo -e "${GREEN}✓${NC} MD036 (Emphasis as heading): 0 violations"
else
  echo -e "${YELLOW}⚠${NC} MD036 (Emphasis as heading): $md036_count violations (manual fix)"
fi

echo ""

# Custom validation checks
echo -e "${CYAN}═══ Custom Validation Checks ═══${NC}"
echo ""

# Link policy violations
latest_link_report=$(ls -t validation/reports/link_violations_*.json 2>/dev/null | head -1)
if [ -f "$latest_link_report" ]; then
  link_count=$(jq -r '.total_violations' "$latest_link_report" 2>/dev/null || echo "unknown")
  md_ext_count=$(jq -r '.violations.md_extensions.count' "$latest_link_report" 2>/dev/null || echo "0")
  
  if [ "$link_count" = "0" ]; then
    echo -e "${GREEN}✓${NC} Link policy: 0 violations"
  else
    echo -e "${YELLOW}⚠${NC} Link policy: $link_count violations"
    if [ "$md_ext_count" != "0" ]; then
      echo "  - $md_ext_count .md extensions (auto-fixable)"
      echo "    Fix: bash validation/scripts/fix/fix_link_extensions.sh $TARGET_ROOT"
    fi
  fi
else
  echo -e "${YELLOW}⚠${NC} Link policy: No report found (run detection)"
fi

# Frontmatter issues
latest_frontmatter=$(ls -t validation/reports/frontmatter_issues_*.json 2>/dev/null | head -1)
if [ -f "$latest_frontmatter" ]; then
  frontmatter_count=$(jq -r '.total_issues' "$latest_frontmatter" 2>/dev/null || echo "unknown")
  
  if [ "$frontmatter_count" = "0" ]; then
    echo -e "${GREEN}✓${NC} Frontmatter: 0 issues"
  else
    echo -e "${YELLOW}⚠${NC} Frontmatter: $frontmatter_count issues (manual fix)"
  fi
else
  echo -e "${YELLOW}⚠${NC} Frontmatter: No report found (run detection)"
fi

# Tech stack violations
latest_tech=$(ls -t validation/reports/tech_violations_*.json 2>/dev/null | head -1)
if [ -f "$latest_tech" ]; then
  tech_count=$(jq -r '.total_violations' "$latest_tech" 2>/dev/null || echo "unknown")
  
  if [ "$tech_count" = "0" ]; then
    echo -e "${GREEN}✓${NC} Tech stack: 0 violations"
  else
    echo -e "${YELLOW}⚠${NC} Tech stack: $tech_count violations (manual fix)"
  fi
else
  echo -e "${YELLOW}⚠${NC} Tech stack: No report found (run detection)"
fi

# Content quality
latest_content=$(ls -t validation/reports/content_quality_issues_*.json 2>/dev/null | head -1)
if [ -f "$latest_content" ]; then
  content_count=$(jq -r '.total_issues' "$latest_content" 2>/dev/null || echo "unknown")
  
  if [ "$content_count" = "0" ]; then
    echo -e "${GREEN}✓${NC} Content quality: 0 issues"
  else
    echo -e "${YELLOW}⚠${NC} Content quality: $content_count issues (manual review)"
  fi
else
  echo -e "${YELLOW}⚠${NC} Content quality: No report found (run detection)"
fi

# Navigation violations
latest_nav=$(ls -t validation/reports/navigation_violations_*.json 2>/dev/null | head -1)
if [ -f "$latest_nav" ]; then
  nav_count=$(jq -r '.total_violations' "$latest_nav" 2>/dev/null || echo "unknown")
  
  if [ "$nav_count" = "0" ]; then
    echo -e "${GREEN}✓${NC} Navigation: 0 violations"
  else
    echo -e "${YELLOW}⚠${NC} Navigation: $nav_count violations (manual fix)"
  fi
else
  echo -e "${YELLOW}⚠${NC} Navigation: No report found (run detection)"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "ACTIONS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Run full detection:"
echo "  bash validation/scripts/run_validation_workflow.sh $TARGET_ROOT"
echo ""
echo "View detailed reports:"
echo "  ls -lt validation/reports/*.json | head -10"
echo ""
echo "Test Jekyll build:"
echo "  docker build -t penguinmails-docs ."
