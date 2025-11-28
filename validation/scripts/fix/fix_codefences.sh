#!/bin/bash

# Fix Codefence Issues
# Usage: ./fix_codefences.sh [target_directory]
# Uses intermediary file from detect_codefence_issues.sh
# Currently only fixes "closing_fence_with_language"

set -e

TARGET_ROOT="${1:-docs}"
INSTANCES_FILE="$2"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "FIX: CODEFENCE ISSUES"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Target: $TARGET_ROOT"
echo ""

# If no intermediary file provided, search for latest
if [ -z "$INSTANCES_FILE" ]; then
    INSTANCES_FILE=$(ls -t validation/reports/instances/codefence_closing_issues_*.txt 2>/dev/null | head -1)
fi

if [ -z "$INSTANCES_FILE" ] || [ ! -f "$INSTANCES_FILE" ]; then
    echo -e "${YELLOW}⚠${NC} No intermediary file found."
    echo "Run detect_codefence_issues.sh first to generate the instances file."
    exit 0
fi

echo "Using intermediary file: $INSTANCES_FILE"
echo ""

# Filter for closing_with_lang issues
# Format: filename:line:type
issues=$(grep ":closing_with_lang" "$INSTANCES_FILE" || echo "")
count=$(echo "$issues" | grep -c ":" || echo "0")

if [ $count -eq 0 ]; then
    echo -e "${YELLOW}⚠${NC} No fixable issues found in intermediary file."
    exit 0
fi

fix_count=0

# Process issues
# Format in intermediary: /full/path/to/file.md:line:type
while IFS=: read -r file_path line type; do
    [ -z "$file_path" ] && continue
    
    # Get just the filename
    filename=$(basename "$file_path")
    
    # Find the file in TARGET_ROOT
    file=$(find "$TARGET_ROOT" -name "$filename" -type f | head -1)
    
    if [ -z "$file" ] || [ ! -f "$file" ]; then
        echo -e "${RED}✗${NC} File not found: $filename in $TARGET_ROOT"
        continue
    fi
    
    echo -e "${YELLOW}Fixing:${NC} $file:$line (Removing language from closing fence)"
    
    # Backup
    cp "$file" "$file.bak"
    
    # Replace ```lang with ``` on specific line
    # We use sed to match the line number and substitution
    # Pattern: ^(\s*```)[a-zA-Z0-9]+(\s*)$ -> \1
    sed -i "${line}s/^\([[:space:]]*\`\`\`\)[a-zA-Z0-9][a-zA-Z0-9]*[[:space:]]*$/\1/" "$file"
    
    # Verify change
    if ! diff -q "$file" "$file.bak" > /dev/null 2>&1; then
        echo -e "${GREEN}  ✓${NC} Fixed"
        fix_count=$((fix_count + 1))
        rm "$file.bak"
    else
        echo -e "${YELLOW}  ⚠${NC} No changes made (pattern might not match)"
        rm "$file.bak"
    fi
    
done <<< "$issues"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "SUMMARY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ $fix_count -eq 0 ]; then
    echo -e "${YELLOW}⚠${NC} No files fixed"
else
    echo -e "${GREEN}✓${NC} Fixed $fix_count issues"
    echo ""
    echo "Next step: Run detection script again to verify:"
    echo "  bash validation/scripts/detect/detect_codefence_issues.sh $TARGET_ROOT"
fi
