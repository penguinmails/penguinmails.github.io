#!/bin/bash

# Validation Workflow Runner
# Orchestrates detection, fixing, and verification in a safe, repeatable way
# Usage: ./run_validation_workflow.sh [docs|docs-test-backup]

set -e

TARGET_ROOT="${1:-docs}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
WORKFLOW_LOG="validation/reports/workflow_${TIMESTAMP}.log"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

mkdir -p validation/reports

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a "$WORKFLOW_LOG"
echo "VALIDATION WORKFLOW" | tee -a "$WORKFLOW_LOG"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a "$WORKFLOW_LOG"
echo "Target: $TARGET_ROOT" | tee -a "$WORKFLOW_LOG"
echo "Timestamp: $TIMESTAMP" | tee -a "$WORKFLOW_LOG"
echo "Log: $WORKFLOW_LOG" | tee -a "$WORKFLOW_LOG"
echo "" | tee -a "$WORKFLOW_LOG"

# Step 1: Run markdownlint auto-fixes first
echo -e "${BLUE}Step 1: Running markdownlint auto-fixes...${NC}" | tee -a "$WORKFLOW_LOG"
docker run --rm -v $PWD:/md -w /md peterdavehello/markdownlint:latest \
  markdownlint "$TARGET_ROOT/" --config .markdownlint.json --fix 2>&1 | tee -a "$WORKFLOW_LOG" || true
echo -e "${GREEN}✓${NC} Markdownlint auto-fixes complete" | tee -a "$WORKFLOW_LOG"
echo "" | tee -a "$WORKFLOW_LOG"

# Step 2: Run all detection scripts
echo -e "${BLUE}Step 2: Running detection scripts...${NC}" | tee -a "$WORKFLOW_LOG"

detection_scripts=(
  "detect_frontmatter_issues.sh"
  "detect_link_policy_violations.sh"
  "detect_tech_stack_violations.sh"
  "detect_formatting_issues.sh"
  "detect_content_quality_issues.sh"
  "detect_navigation_violations.sh"
)

for script in "${detection_scripts[@]}"; do
  echo "  Running: $script" | tee -a "$WORKFLOW_LOG"
  bash "validation/scripts/detect/$script" "$TARGET_ROOT" >> "$WORKFLOW_LOG" 2>&1 || true
done

echo -e "${GREEN}✓${NC} Detection complete" | tee -a "$WORKFLOW_LOG"
echo "" | tee -a "$WORKFLOW_LOG"

# Step 3: Check for fixable issues
echo -e "${BLUE}Step 3: Checking for auto-fixable issues...${NC}" | tee -a "$WORKFLOW_LOG"

# Check MD040 violations
md040_count=$(docker run --rm -v $PWD:/md -w /md peterdavehello/markdownlint:latest \
  markdownlint "$TARGET_ROOT/" --config .markdownlint.json 2>&1 | grep -c "MD040" || echo "0")

# Check link violations
link_violations=$(ls -t validation/reports/instances/md_extension_links_*.txt 2>/dev/null | head -1)
if [ -f "$link_violations" ]; then
  link_count=$(wc -l < "$link_violations")
else
  link_count=0
fi

echo "  MD040 (code fence language): $md040_count violations" | tee -a "$WORKFLOW_LOG"
echo "  Link extensions: $link_count violations" | tee -a "$WORKFLOW_LOG"
echo "" | tee -a "$WORKFLOW_LOG"

# Step 4: Offer to apply fixes
if [ "$md040_count" -gt 0 ] || [ "$link_count" -gt 0 ]; then
  echo -e "${YELLOW}Fixable issues found!${NC}" | tee -a "$WORKFLOW_LOG"
  
  if [ "$TARGET_ROOT" = "docs" ]; then
    echo -e "${YELLOW}⚠${NC} Running on production docs/" | tee -a "$WORKFLOW_LOG"
    echo "Recommendation: Test on docs-test-backup first" | tee -a "$WORKFLOW_LOG"
    echo "" | tee -a "$WORKFLOW_LOG"
    echo "To test safely:" | tee -a "$WORKFLOW_LOG"
    echo "  1. cp -r docs docs-test-backup" | tee -a "$WORKFLOW_LOG"
    echo "  2. bash validation/scripts/run_validation_workflow.sh docs-test-backup" | tee -a "$WORKFLOW_LOG"
    echo "  3. Review changes, then apply to docs/" | tee -a "$WORKFLOW_LOG"
  else
    echo "Apply fixes? (y/n)" | tee -a "$WORKFLOW_LOG"
    read -r apply_fixes
    
    if [ "$apply_fixes" = "y" ]; then
      echo -e "${BLUE}Applying fixes...${NC}" | tee -a "$WORKFLOW_LOG"
      
      # Fix MD040
      if [ "$md040_count" -gt 0 ]; then
        echo "  Fixing MD040 violations..." | tee -a "$WORKFLOW_LOG"
        bash validation/scripts/fix/fix_codefences_md040_v2.sh "$TARGET_ROOT" >> "$WORKFLOW_LOG" 2>&1
      fi
      
      # Fix links
      if [ "$link_count" -gt 0 ]; then
        echo "  Fixing link extensions..." | tee -a "$WORKFLOW_LOG"
        bash validation/scripts/fix/fix_link_extensions.sh "$TARGET_ROOT" "$link_violations" >> "$WORKFLOW_LOG" 2>&1
      fi
      
      echo -e "${GREEN}✓${NC} Fixes applied" | tee -a "$WORKFLOW_LOG"
      
      # Re-run detection
      echo -e "${BLUE}Re-running detection to verify...${NC}" | tee -a "$WORKFLOW_LOG"
      for script in "${detection_scripts[@]}"; do
        bash "validation/scripts/detect/$script" "$TARGET_ROOT" >> "$WORKFLOW_LOG" 2>&1 || true
      done
    fi
  fi
else
  echo -e "${GREEN}✓${NC} No auto-fixable issues found" | tee -a "$WORKFLOW_LOG"
fi

echo "" | tee -a "$WORKFLOW_LOG"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a "$WORKFLOW_LOG"
echo "WORKFLOW COMPLETE" | tee -a "$WORKFLOW_LOG"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a "$WORKFLOW_LOG"
echo "Full log: $WORKFLOW_LOG" | tee -a "$WORKFLOW_LOG"
echo "" | tee -a "$WORKFLOW_LOG"
echo "Next steps:" | tee -a "$WORKFLOW_LOG"
echo "  1. Review reports in validation/reports/" | tee -a "$WORKFLOW_LOG"
echo "  2. Check manual fix categories (frontmatter, tech stack, etc.)" | tee -a "$WORKFLOW_LOG"
echo "  3. Run Docker Jekyll build: docker build -t penguinmails-docs ." | tee -a "$WORKFLOW_LOG"
