#!/bin/bash

# Link Warnings Detection Script
# Usage: ./detect_link_warnings.sh [target_directory]
# Detects non-critical link issues (links to tasks/ and user-journeys/ folders)

set -e

TARGET_ROOT="${1:-docs}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
REPORT_DIR="validation/reports"
REPORT_FILE="$REPORT_DIR/link_warnings_${TIMESTAMP}.json"

# Create directories
mkdir -p "$REPORT_DIR"

# Initialize counters
total_issues=0

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "LINK WARNINGS VALIDATION"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Target: $TARGET_ROOT"
echo "Report: $REPORT_FILE"
echo ""

# Initialize JSON report
echo "{" > "$REPORT_FILE"
echo "  \"timestamp\": \"$(date -Iseconds)\"," >> "$REPORT_FILE"
echo "  \"target_root\": \"$TARGET_ROOT\"," >> "$REPORT_FILE"
echo "  \"issues\": {" >> "$REPORT_FILE"

# Function to detect link violations
detect_links() {
    local issue_name="$1"
    local pattern="$2"
    local description="$3"
    
    echo "Checking: $description..."
    
    local files=$(grep -r "$pattern" "$TARGET_ROOT" --include="*.md" 2>/dev/null || echo "")
    
    local count=0
    if [ -n "$files" ]; then
        count=$(echo "$files" | grep -c ":" 2>/dev/null || echo "0")
    fi
    
    # Add to JSON report
    echo "    \"$issue_name\": {" >> "$REPORT_FILE"
    echo "      \"description\": \"$description\"," >> "$REPORT_FILE"
    echo "      \"count\": $count," >> "$REPORT_FILE"
    echo "      \"files\": [" >> "$REPORT_FILE"
    
    if [ $count -gt 0 ]; then
        first=true
        while IFS=: read -r file line; do
            [ -z "$file" ] && continue
            if [ "$first" = true ]; then
                first=false
            else
                echo "," >> "$REPORT_FILE"
            fi
            echo -n "        {\"file\": \"$file\", \"line\": \"$line\"}" >> "$REPORT_FILE"
            echo -e "  ${YELLOW}⚠${NC} $file"
        done <<< "$files"
        echo "" >> "$REPORT_FILE"
        total_issues=$((total_issues + count))
    fi
    
    echo "      ]" >> "$REPORT_FILE"
    echo "    }," >> "$REPORT_FILE"
    
    if [ $count -eq 0 ]; then
        echo -e "  ${GREEN}✓${NC} No issues found"
    else
        echo -e "  ${YELLOW}⚠${NC} Found $count instances"
    fi
    echo ""
}

# Check for relative links to tasks/ folder
detect_links "tasks_links" "](.*tasks/" "Links to tasks/ folder (should be avoided)"

# Check for relative links to user-journeys/ folder
detect_links "journeys_links" "](.*user-journeys/" "Links to user-journeys/ folder (should be avoided)"

# Close JSON report
echo "    \"total\": {" >> "$REPORT_FILE"
echo "      \"count\": $total_issues" >> "$REPORT_FILE"
echo "    }" >> "$REPORT_FILE"
echo "  }," >> "$REPORT_FILE"
echo "  \"total_issues\": $total_issues" >> "$REPORT_FILE"
echo "}" >> "$REPORT_FILE"

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "SUMMARY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ $total_issues -eq 0 ]; then
    echo -e "${GREEN}✓${NC} All link warning checks passed!"
    exit 0
else
    echo -e "${YELLOW}⚠${NC} Found $total_issues link warnings"
    echo "Report saved to: $REPORT_FILE"
    exit 1
fi
