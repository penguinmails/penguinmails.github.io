#!/bin/bash

# Fix MD040 Codefence Issues - Version 2
# Usage: ./fix_codefences_md040_v2.sh [target_directory]
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
echo "Strategy: Add 'text' to bare opening code fences"
echo ""

# Get MD040 violations from markdownlint
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

# Save violations to temp file
TEMP_FILE=$(mktemp)
echo "$VIOLATIONS" > "$TEMP_FILE"

fix_count=0
file_count=0

# Get unique files
for file in $(awk -F: '{print $1}' "$TEMP_FILE" | sort -u); do
    echo -e "${YELLOW}Fixing:${NC} $file"
    
    # Get all line numbers for this file (in reverse order to avoid line number shifts)
    line_numbers=$(grep "^$file:" "$TEMP_FILE" | awk -F: '{print $2}' | sort -rn)
    
    # Process each line number
    file_fixes=0
    for linenum in $line_numbers; do
        # Use awk to fix this specific line
        awk -v line="$linenum" '{
            if (NR == line && $0 ~ /^```[[:space:]]*$/) {
                print "```text"
            } else {
                print $0
            }
        }' "$file" > "$file.tmp"
        
        mv "$file.tmp" "$file"
        file_fixes=$((file_fixes + 1))
        fix_count=$((fix_count + 1))
    done
    
    echo -e "${GREEN}  ✓${NC} Fixed $file_fixes code fences"
    file_count=$((file_count + 1))
done

rm "$TEMP_FILE"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "SUMMARY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ $fix_count -eq 0 ]; then
    echo -e "${YELLOW}⚠${NC} No files fixed"
else
    echo -e "${GREEN}✓${NC} Fixed $fix_count code fences in $file_count files"
    echo ""
    echo "Verification:"
    remaining=$(docker run --rm -v $PWD:/md -w /md peterdavehello/markdownlint:latest \
      markdownlint "$TARGET_ROOT/" --config .markdownlint.json 2>&1 | grep -c "MD040" || echo "0")
    if [ "$remaining" -eq 0 ]; then
        echo -e "${GREEN}✓${NC} All MD040 violations resolved!"
    else
        echo -e "${YELLOW}⚠${NC} $remaining MD040 violations remaining"
    fi
fi
