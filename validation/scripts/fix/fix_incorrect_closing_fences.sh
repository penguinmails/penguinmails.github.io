#!/bin/bash

# Fix Incorrect Closing Fences
# Removes language tags from closing code fences that were incorrectly added

set -e

TARGET_ROOT="${1:-docs}"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "FIX: INCORRECT CLOSING FENCES"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Target: $TARGET_ROOT"
echo "Strategy: Remove language tags from closing fences"
echo ""

fix_count=0
file_count=0

# Find all markdown files with ```text (likely incorrect closing fences)
while IFS= read -r file; do
    echo -e "${YELLOW}Fixing:${NC} $file"
    
    # Backup
    cp "$file" "$file.bak"
    
    # Use awk to track fence state and remove language from closing fences
    awk '
    BEGIN { in_fence = 0 }
    /^```[a-zA-Z0-9_+-]+/ {
        if (in_fence == 0) {
            # Opening fence with language - keep it
            print $0
            in_fence = 1
        } else {
            # This looks like a closing fence with incorrect language tag
            print "```"
            in_fence = 0
        }
        next
    }
    /^```[[:space:]]*$/ {
        # Bare fence - toggle state
        print $0
        in_fence = (in_fence == 0) ? 1 : 0
        next
    }
    { print $0 }
    ' "$file" > "$file.tmp"
    
    mv "$file.tmp" "$file"
    
    # Verify change
    if ! diff -q "$file" "$file.bak" > /dev/null 2>&1; then
        changes=$(diff "$file.bak" "$file" | grep -c "^<" || echo "0")
        echo -e "${GREEN}  ✓${NC} Fixed $changes closing fences"
        fix_count=$((fix_count + changes))
        file_count=$((file_count + 1))
        rm "$file.bak"
    else
        echo -e "${YELLOW}  ⚠${NC} No changes made"
        rm "$file.bak"
    fi
done < <(find "$TARGET_ROOT" -name "*.md" -type f -exec grep -l "^\`\`\`text$" {} \;)

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "SUMMARY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ $fix_count -eq 0 ]; then
    echo -e "${YELLOW}⚠${NC} No files fixed"
else
    echo -e "${GREEN}✓${NC} Fixed $fix_count incorrect closing fences in $file_count files"
fi
