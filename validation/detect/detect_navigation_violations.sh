#!/bin/bash

# Navigation Violations Detection Script
# Usage: ./detect_navigation_violations.sh [target_directory]
# Detects non-numeric nav_order

set -e

# Parse arguments
GENERATE_REPORT=false
TARGET_ROOT=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --report|-r)
            GENERATE_REPORT=true
            shift
            ;;
        *)
            TARGET_ROOT="$1"
            shift
            ;;
    esac
done

# Set default target if not provided
TARGET_ROOT="${TARGET_ROOT:-docs}"

# Setup report file or redirect to /dev/null
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
REPORT_DIR="validation/reports"

if [ "$GENERATE_REPORT" = true ]; then
    REPORT_FILE="$REPORT_DIR/$(basename $0 .sh | sed 's/detect_//')_${TIMESTAMP}.json"
    mkdir -p "$REPORT_DIR"
else
    REPORT_FILE="/dev/null"  # Redirect all report writes to /dev/null
fi

total_issues=0

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "NAVIGATION VALIDATION"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Target: $TARGET_ROOT"
if [ "$GENERATE_REPORT" = true ]; then
    echo "Report: $REPORT_FILE"
fi
echo ""

# Initialize JSON report
echo "{" > "$REPORT_FILE"
echo "  \"timestamp\": \"$(date -Iseconds)\"," >> "$REPORT_FILE"
echo "  \"target_root\": \"$TARGET_ROOT\"," >> "$REPORT_FILE"
echo "  \"issues\": {" >> "$REPORT_FILE"

# Detect non-numeric nav_order
# We use grep to find nav_order lines, then check if value is numeric
# Regex: nav_order:\s*"?\d+"? is valid.
# Anything else is invalid?
# nav_order: 10 -> valid
# nav_order: "10" -> valid
# nav_order: ten -> invalid
# nav_order: 10.5 -> invalid (usually integer)

echo "Checking: Non-numeric nav_order..."

# Find files with nav_order, extract value, check if numeric
# grep -n outputs filename:line:content
bad_nav_order=$(grep -r -n "nav_order:" "$TARGET_ROOT" --include="*.md" | while IFS=: read -r file line content; do
    # Extract value after nav_order:
    # Remove leading spaces and quotes
    val=$(echo "$content" | sed 's/.*nav_order:[[:space:]]*"\?//' | sed 's/".*$//')
    
    # Check if value is a positive integer
    if ! echo "$val" | grep -q "^[0-9]\+$"; then
        echo "$file:$line:$val"
    fi
done)

count=$(echo "$bad_nav_order" | grep -c ":" || true)

echo "    \"non_numeric_nav_order\": {" >> "$REPORT_FILE"
echo "      \"description\": \"nav_order must be a positive integer\"," >> "$REPORT_FILE"
echo "      \"count\": $count," >> "$REPORT_FILE"
echo "      \"files\": [" >> "$REPORT_FILE"

if [ "$count" -gt 0 ]; then
    first=true
    while IFS=: read -r file line val; do
        [ -z "$file" ] && continue
        if [ "$first" = true ]; then
            first=false
        else
            echo "," >> "$REPORT_FILE"
        fi
        echo -n "        {\"file\": \"$file\", \"line\": \"$line\", \"value\": \"$val\"}" >> "$REPORT_FILE"
        echo -e "  ${RED}✗${NC} $file:$line (Value: $val)"
    done <<< "$bad_nav_order"
    echo "" >> "$REPORT_FILE"
    total_issues=$((total_issues + count))
else
    echo -e "Checking: Non-numeric nav_order... ${GREEN}✓${NC} None found"
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
    echo -e "${GREEN}✓${NC} All navigation checks passed!"
    exit 0
else
    echo -e "${RED}✗${NC} Found $total_issues navigation violations"
    if [ "$GENERATE_REPORT" = true ]; then
        echo "Report saved to: $REPORT_FILE"
    fi
    exit 1
fi
