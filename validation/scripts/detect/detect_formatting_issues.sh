#!/bin/bash

# Markdown Formatting Detection Script (via markdownlint)
# Usage: ./detect_formatting_issues.sh [target_directory]
# Detects formatting issues that cannot be auto-fixed by markdownlint:
#   - MD001: Heading levels should only increment by one level at a time
#   - MD036: Emphasis used instead of a heading
#   - MD040: Fenced code blocks should have a language specified

set -e

TARGET_ROOT="${1:-docs}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
REPORT_DIR="validation/reports"
REPORT_FILE="$REPORT_DIR/formatting_issues_${TIMESTAMP}.json"

mkdir -p "$REPORT_DIR"

total_issues=0

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "MARKDOWN FORMATTING VALIDATION (via markdownlint)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Target: $TARGET_ROOT"
echo "Report: $REPORT_FILE"
echo ""

# Run markdownlint and capture output
MARKDOWNLINT_OUT=$(mktemp)
docker run --rm -v $PWD:/md -w /md peterdavehello/markdownlint:latest \
  markdownlint "$TARGET_ROOT/" --config .markdownlint.json 2>&1 > "$MARKDOWNLINT_OUT" || true

# Initialize JSON report
echo "{" > "$REPORT_FILE"
echo "  \"timestamp\": \"$(date -Iseconds)\"," >> "$REPORT_FILE"
echo "  \"target_root\": \"$TARGET_ROOT\"," >> "$REPORT_FILE"
echo "  \"detection_method\": \"markdownlint\"," >> "$REPORT_FILE"
echo "  \"issues\": {" >> "$REPORT_FILE"

# 1. MD001: Heading increment violations
echo "Checking: Heading levels (MD001)..."
MD001_OUT=$(grep "MD001" "$MARKDOWNLINT_OUT" || true)
count_md001=$(echo "$MD001_OUT" | grep -c "MD001" || echo "0")

echo "    \"heading_increment_md001\": {" >> "$REPORT_FILE"
echo "      \"description\": \"MD001: Heading levels should only increment by one level at a time\"," >> "$REPORT_FILE"
echo "      \"count\": $count_md001," >> "$REPORT_FILE"
echo "      \"fixable\": false," >> "$REPORT_FILE"
echo "      \"files\": [" >> "$REPORT_FILE"

if [ "$count_md001" -gt 0 ]; then
    first=true
    while IFS= read -r line; do
        [ -z "$line" ] && continue
        file=$(echo "$line" | cut -d: -f1)
        linenum=$(echo "$line" | cut -d: -f2 | cut -d' ' -f1)
        
        if [ "$first" = true ]; then
            first=false
        else
            echo "," >> "$REPORT_FILE"
        fi
        echo -n "        {\"file\": \"$file\", \"line\": \"$linenum\"}" >> "$REPORT_FILE"
        echo -e "  ${RED}✗${NC} $file:$linenum"
    done <<< "$MD001_OUT"
    echo "" >> "$REPORT_FILE"
    total_issues=$((total_issues + count_md001))
else
    echo -e "  ${GREEN}✓${NC} None found"
fi

echo "      ]" >> "$REPORT_FILE"
echo "    }," >> "$REPORT_FILE"

# 2. MD036: Emphasis used as heading
echo "Checking: Emphasis as heading (MD036)..."
MD036_OUT=$(grep "MD036" "$MARKDOWNLINT_OUT" || true)
count_md036=$(echo "$MD036_OUT" | grep -c "MD036" || echo "0")

echo "    \"emphasis_as_heading_md036\": {" >> "$REPORT_FILE"
echo "      \"description\": \"MD036: Emphasis should not be used instead of a heading\"," >> "$REPORT_FILE"
echo "      \"count\": $count_md036," >> "$REPORT_FILE"
echo "      \"fixable\": false," >> "$REPORT_FILE"
echo "      \"files\": [" >> "$REPORT_FILE"

if [ "$count_md036" -gt 0 ]; then
    first=true
    while IFS= read -r line; do
        [ -z "$line" ] && continue
        file=$(echo "$line" | cut -d: -f1)
        linenum=$(echo "$line" | cut -d: -f2 | cut -d' ' -f1)
        
        if [ "$first" = true ]; then
            first=false
        else
            echo "," >> "$REPORT_FILE"
        fi
        echo -n "        {\"file\": \"$file\", \"line\": \"$linenum\"}" >> "$REPORT_FILE"
        echo -e "  ${RED}✗${NC} $file:$linenum"
    done <<< "$MD036_OUT"
    echo "" >> "$REPORT_FILE"
    total_issues=$((total_issues + count_md036))
else
    echo -e "  ${GREEN}✓${NC} None found"
fi

echo "      ]" >> "$REPORT_FILE"
echo "    }," >> "$REPORT_FILE"

# 3. MD040: Missing language on code fences
echo "Checking: Code fence language tags (MD040)..."
MD040_OUT=$(grep "MD040" "$MARKDOWNLINT_OUT" || true)
count_md040=$(echo "$MD040_OUT" | grep -c "MD040" || echo "0")

echo "    \"missing_code_language_md040\": {" >> "$REPORT_FILE"
echo "      \"description\": \"MD040: Fenced code blocks should have a language specified\"," >> "$REPORT_FILE"
echo "      \"count\": $count_md040," >> "$REPORT_FILE"
echo "      \"fixable\": true," >> "$REPORT_FILE"
echo "      \"fix_script\": \"validation/scripts/fix/fix_codefences.sh\"," >> "$REPORT_FILE"
echo "      \"files\": [" >> "$REPORT_FILE"

if [ "$count_md040" -gt 0 ]; then
    first=true
    while IFS= read -r line; do
        [ -z "$line" ] && continue
        file=$(echo "$line" | cut -d: -f1)
        linenum=$(echo "$line" | cut -d: -f2 | cut -d' ' -f1)
        
        if [ "$first" = true ]; then
            first=false
        else
            echo "," >> "$REPORT_FILE"
        fi
        echo -n "        {\"file\": \"$file\", \"line\": \"$linenum\"}" >> "$REPORT_FILE"
        echo -e "  ${RED}✗${NC} $file:$linenum"
    done <<< "$MD040_OUT"
    echo "" >> "$REPORT_FILE"
    total_issues=$((total_issues + count_md040))
else
    echo -e "  ${GREEN}✓${NC} None found"
fi

echo "      ]" >> "$REPORT_FILE"
echo "    }" >> "$REPORT_FILE"

# Close JSON report
echo "  }," >> "$REPORT_FILE"
echo "  \"total_issues\": $total_issues" >> "$REPORT_FILE"
echo "}" >> "$REPORT_FILE"

rm "$MARKDOWNLINT_OUT"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "SUMMARY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ $total_issues -eq 0 ]; then
    echo -e "${GREEN}✓${NC} All formatting checks passed!"
    exit 0
else
    echo -e "${RED}✗${NC} Found $total_issues formatting violations"
    echo "  - MD001 (heading increment): $count_md001 (manual fix required)"
    echo "  - MD036 (emphasis as heading): $count_md036 (manual fix required)"
    echo "  - MD040 (code fence language): $count_md040 (automated fix available)"
    echo ""
    echo "Report saved to: $REPORT_FILE"
    exit 1
fi
