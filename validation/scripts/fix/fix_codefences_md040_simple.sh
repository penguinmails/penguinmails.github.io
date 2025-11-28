#!/bin/bash

# Fix MD040 Codefence Issues - Simple Version
# Usage: ./fix_codefences_md040_simple.sh [target_directory]
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

fix_count=0
file_count=0
current_file=""

# Process each violation
while IFS= read -r line; do
    # Parse: filename:linenum:rule message
    file=$(echo "$line" | cut -d: -f1)
    linenum=$(echo "$line" | cut -d: -f2)
    
    if [ "$file" != "$current_file" ]; then
        if [ -n "$current_file" ]; then
            echo -e "${GREEN}  ✓${NC} Fixed $file_fixes code fences"
            file_count=$((file_count + 1))
        fi
        current_file="$file"
        file_fixes=0
        echo -e "${YELLOW}Fixing:${NC} $file"
    fi
    
    # Use awk to replace bare ``` with ```text on specific line
    awk -v line="$linenum" '{
        if (NR == line && $0 ~ /^```[[:space:]]*$/) {
            print "```text"
        } else {
            print $0
        }
    }' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
    
    fix_count=$((fix_count + 1))
    file_fixes=$((file_fixes + 1))
done <<< "$VIOLATIONS"

# Print last file's summary
if [ -n "$current_file" ]; then
    echo -e "${GREEN}  ✓${NC} Fixed $file_fixes code fences"
    file_count=$((file_count + 1))
fi

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
