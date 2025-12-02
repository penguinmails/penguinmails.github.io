#!/bin/bash

# Content Quality Detection Script
# Usage: ./detect_content_quality_issues.sh [target_directory]
# Detects emoji in title and overlong files

set -e

TARGET_ROOT="${1:-docs}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
REPORT_DIR="validation/reports"
REPORT_FILE="$REPORT_DIR/content_quality_issues_${TIMESTAMP}.json"

mkdir -p "$REPORT_DIR"

total_issues=0

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "CONTENT QUALITY VALIDATION"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Target: $TARGET_ROOT"
echo "Report: $REPORT_FILE"
echo ""

# Initialize JSON report
echo "{" > "$REPORT_FILE"
echo "  \"timestamp\": \"$(date -Iseconds)\"," >> "$REPORT_FILE"
echo "  \"target_root\": \"$TARGET_ROOT\"," >> "$REPORT_FILE"
echo "  \"issues\": {" >> "$REPORT_FILE"

# 1. Emoji in Title
echo "Checking: Emoji in title..."

# We look for non-ASCII characters in title line
# grep -n "title:" outputs line number
# We pipe to awk to check for non-ascii
emoji_titles=$(grep -r -n "title:" "$TARGET_ROOT" --include="*.md" | awk '
{
  # Check if line contains non-ascii
  # In standard awk, this is hard.
  # Let use a heuristic: if length(line) != length_bytes(line)?
  # GNU awk handles utf8.
  
  # Alternative: use grep -P if available, or perl.
  # Let assume perl is available.
}')

# Using perl for reliable non-ascii detection
emoji_titles=$(find "$TARGET_ROOT" -name "*.md" -print0 | xargs -0 grep -n "title:" | perl -ne 'print if /[^\x00-\x7F]/')
count_emoji=$(echo "$emoji_titles" | grep -c ":" || true)

echo "    \"emoji_in_title\": {" >> "$REPORT_FILE"
echo "      \"description\": \"Title contains non-ASCII characters (likely emoji)\"," >> "$REPORT_FILE"
echo "      \"count\": $count_emoji," >> "$REPORT_FILE"
echo "      \"files\": [" >> "$REPORT_FILE"

if [ "$count_emoji" -gt 0 ]; then
    first=true
    while IFS=: read -r file line content; do
        [ -z "$file" ] && continue
        if [ "$first" = true ]; then
            first=false
        else
            echo "," >> "$REPORT_FILE"
        fi
        # Clean content for JSON
        clean_content=$(echo "$content" | sed 's/"/\\"/g')
        echo -n "        {\"file\": \"$file\", \"line\": \"$line\", \"content\": \"$clean_content\"}" >> "$REPORT_FILE"
        echo -e "  ${RED}✗${NC} $file:$line"
    done <<< "$emoji_titles"
    echo "" >> "$REPORT_FILE"
    total_issues=$((total_issues + count_emoji))
else
    echo -e "Checking: Emoji in title... ${GREEN}✓${NC} None found"
fi

echo "      ]" >> "$REPORT_FILE"
echo "    }," >> "$REPORT_FILE"

# 2. Overlong Files (> 500 lines)
echo "Checking: Overlong files (> 500 lines)..."

# find files, count lines, filter
overlong_files=$(find "$TARGET_ROOT" -name "*.md" -exec wc -l {} + | awk '$1 > 500 && $2 != "total" {print $2 ":" $1}')
count_overlong=$(echo "$overlong_files" | grep -c ":" || true)

echo "    \"overlong_files\": {" >> "$REPORT_FILE"
echo "      \"description\": \"File exceeds 500 lines\"," >> "$REPORT_FILE"
echo "      \"count\": $count_overlong," >> "$REPORT_FILE"
echo "      \"files\": [" >> "$REPORT_FILE"

if [ "$count_overlong" -gt 0 ]; then
    first=true
    while IFS=: read -r file lines; do
        [ -z "$file" ] && continue
        if [ "$first" = true ]; then
            first=false
        else
            echo "," >> "$REPORT_FILE"
        fi
        echo -n "        {\"file\": \"$file\", \"lines\": $lines}" >> "$REPORT_FILE"
        echo -e "  ${RED}✗${NC} $file ($lines lines)"
    done <<< "$overlong_files"
    echo "" >> "$REPORT_FILE"
    total_issues=$((total_issues + count_overlong))
else
    echo -e "Checking: Overlong files... ${GREEN}✓${NC} None found"
fi

echo "      ]" >> "$REPORT_FILE"
echo "    }" >> "$REPORT_FILE"

# Close JSON report
echo "  }," >> "$REPORT_FILE"
echo "  \"total_issues\": $total_issues" >> "$REPORT_FILE"
echo "}" >> "$REPORT_FILE"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "SUMMARY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ $total_issues -eq 0 ]; then
    echo -e "${GREEN}✓${NC} All content quality checks passed!"
    exit 0
else
    echo -e "${RED}✗${NC} Found $total_issues content quality violations"
    echo "Report saved to: $REPORT_FILE"
    exit 1
fi
