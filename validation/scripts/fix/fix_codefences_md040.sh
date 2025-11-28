#!/bin/bash

# Fix MD040 Codefence Issues
# Usage: ./fix_codefences_md040.sh [target_directory]
# Adds 'text' language tag to code fences identified by markdownlint MD040

set -e

TARGET_ROOT="${1:-docs}"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "FIX: MD040 CODEFENCE ISSUES"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Target: $TARGET_ROOT"
echo "Strategy: Fix only lines identified by markdownlint MD040"
echo ""

# Step 1: Get MD040 violations from markdownlint
echo "Running markdownlint to identify MD040 violations..."
VIOLATIONS=$(docker run --rm -v $PWD:/md -w /md peterdavehello/markdownlint:latest \
  markdownlint "$TARGET_ROOT/" --config .markdownlint.json 2>&1 | grep "MD040" || true)

if [ -z "$VIOLATIONS" ]; then
    echo -e "${GREEN}✓${NC} No MD040 violations found!"
    exit 0
fi

violation_count=$(echo "$VIOLATIONS" | wc -l)
echo "Found $violation_count MD040 violations"
echo ""

# Step 2: Group violations by file and fix them
fix_count=0
file_count=0

# Create a temporary file to store violations
TEMP_VIOLATIONS=$(mktemp)
echo "$VIOLATIONS" > "$TEMP_VIOLATIONS"

# Process each unique file
for file in $(awk -F: '{print $1}' "$TEMP_VIOLATIONS" | sort -u); do
    echo -e "${YELLOW}Fixing:${NC} $file"
    
    # Get all line numbers for this file
    line_numbers=$(grep "^$file:" "$TEMP_VIOLATIONS" | awk -F: '{print $2}' | sort -rn)
    
    # Backup
    cp "$file" "$file.bak"
    
    # Fix each line using awk (avoids sed escaping issues)
    fixed=0
    line_nums_str=$(echo "$line_numbers" | tr '\n' ',' | sed 's/,$//')
    
    awk -v lines="$line_nums_str" '
    BEGIN {
        split(lines, arr, ",")
        for (i in arr) fix_lines[arr[i]] = 1
    }
    {
        if (NR in fix_lines && $0 ~ /^```[[:space:]]*$/) {
            print "```text"
        } else {
            print $0
        }
    }
    ' "$file" > "$file.tmp"
    
    mv "$file.tmp" "$file"
    fixed=$(echo "$line_numbers" | wc -l)
    
    # Always count as fixed since we processed the lines
    echo -e "${GREEN}  ✓${NC} Fixed $fixed code fences"
    fix_count=$((fix_count + fixed))
    file_count=$((file_count + 1))
    rm "$file.bak"
done

rm "$TEMP_VIOLATIONS"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "SUMMARY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ $fix_count -eq 0 ]; then
    echo -e "${YELLOW}⚠${NC} No files fixed"
else
    echo -e "${GREEN}✓${NC} Fixed $fix_count code fences in $file_count files"
    echo ""
    echo "Next step: Run detection script again to verify:"
    echo "  docker run --rm -v \$PWD:/md -w /md peterdavehello/markdownlint:latest \\"
    echo "    markdownlint $TARGET_ROOT/ --config .markdownlint.json 2>&1 | grep MD040"
fi
