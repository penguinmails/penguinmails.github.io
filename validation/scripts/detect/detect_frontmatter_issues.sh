#!/bin/bash

# Frontmatter Issues Detection Script
# Usage: ./detect_frontmatter_issues.sh [target_directory]
# Detects missing required frontmatter fields and keywords in body

set -e

TARGET_ROOT="${1:-docs}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
REPORT_DIR="validation/reports"
REPORT_FILE="$REPORT_DIR/frontmatter_issues_${TIMESTAMP}.json"

# Create reports directory
mkdir -p "$REPORT_DIR"

# Initialize counters
total_issues=0

# Color codes for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "FRONTMATTER VALIDATION"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Target: $TARGET_ROOT"
echo "Report: $REPORT_FILE"
echo ""

# Initialize JSON report
echo "{" > "$REPORT_FILE"
echo "  \"timestamp\": \"$(date -Iseconds)\"," >> "$REPORT_FILE"
echo "  \"target_root\": \"$TARGET_ROOT\"," >> "$REPORT_FILE"
echo "  \"issues\": {" >> "$REPORT_FILE"

# Function to detect and report issues
detect_issue() {
    local field_name="$1"
    local pattern="$2"
    local description="$3"
    
    echo "Checking: $description..."
    
    # Find files missing the pattern
    local files=$(find "$TARGET_ROOT" -name "*.md" -type f -exec grep -L "$pattern" {} \; 2>/dev/null)
    local count=$(echo "$files" | grep -c . || echo "0")
    
    # Add to JSON report
    echo "    \"$field_name\": {" >> "$REPORT_FILE"
    echo "      \"description\": \"$description\"," >> "$REPORT_FILE"
    echo "      \"count\": $count," >> "$REPORT_FILE"
    echo "      \"files\": [" >> "$REPORT_FILE"
    
    if [ $count -gt 0 ]; then
        first=true
        while IFS= read -r file; do
            [ -z "$file" ] && continue
            if [ "$first" = true ]; then
                first=false
            else
                echo "," >> "$REPORT_FILE"
            fi
            echo -n "        \"$file\"" >> "$REPORT_FILE"
            echo -e "  ${RED}✗${NC} $file"
        done <<< "$files"
        echo "" >> "$REPORT_FILE"
        total_issues=$((total_issues + count))
    fi
    
    echo "      ]" >> "$REPORT_FILE"
    echo "    }," >> "$REPORT_FILE"
    
    if [ $count -eq 0 ]; then
        echo -e "  ${GREEN}✓${NC} No issues found"
    else
        echo -e "  ${YELLOW}⚠${NC} Found $count files"
    fi
    echo ""
}

# Check for missing frontmatter fields
detect_issue "missing_title" "^title:" "Missing 'title' field"
detect_issue "missing_description" "^description:" "Missing 'description' field"
detect_issue "missing_level" "^level:" "Missing 'level' field"
detect_issue "missing_persona" "^persona:" "Missing 'persona' field"
detect_issue "missing_date" "^last_modified_date:" "Missing 'last_modified_date' field"

# Check for keywords in body (should be in frontmatter)
echo "Checking: Keywords in body (should be in frontmatter)..."
keywords_files=$(grep -r "^\*\*Keywords\*\*:" "$TARGET_ROOT" --include="*.md" 2>/dev/null || echo "")
keywords_count=$(echo "$keywords_files" | grep -c ":" || echo "0")

echo "    \"keywords_in_body\": {" >> "$REPORT_FILE"
echo "      \"description\": \"Keywords in body (should be in frontmatter)\"," >> "$REPORT_FILE"
echo "      \"count\": $keywords_count," >> "$REPORT_FILE"
echo "      \"files\": [" >> "$REPORT_FILE"

if [ $keywords_count -gt 0 ]; then
    first=true
    while IFS=: read -r file line; do
        [ -z "$file" ] && continue
        if [ "$first" = true ]; then
            first=false
        else
            echo "," >> "$REPORT_FILE"
        fi
        echo -n "        {\"file\": \"$file\", \"line\": \"$line\"}" >> "$REPORT_FILE"
        echo -e "  ${RED}✗${NC} $file:$line"
    done <<< "$keywords_files"
    echo "" >> "$REPORT_FILE"
    total_issues=$((total_issues + keywords_count))
fi

echo "      ]" >> "$REPORT_FILE"
echo "    }" >> "$REPORT_FILE"

if [ $keywords_count -eq 0 ]; then
    echo -e "  ${GREEN}✓${NC} No keywords in body"
else
    echo -e "  ${YELLOW}⚠${NC} Found $keywords_count instances"
fi
echo ""

# Close JSON report
echo "  }," >> "$REPORT_FILE"
echo "  \"total_issues\": $total_issues" >> "$REPORT_FILE"
echo "}" >> "$REPORT_FILE"

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "SUMMARY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ $total_issues -eq 0 ]; then
    echo -e "${GREEN}✓${NC} All frontmatter checks passed!"
    exit 0
else
    echo -e "${RED}✗${NC} Found $total_issues frontmatter issues"
    echo "Report saved to: $REPORT_FILE"
    exit 1
fi
