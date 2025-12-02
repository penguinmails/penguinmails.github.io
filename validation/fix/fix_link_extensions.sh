#!/bin/bash

# Fix .md Extensions in Site-Absolute Links
# Usage: ./fix_link_extensions.sh [target_directory]
# Uses intermediary file from detect_link_policy_violations.sh

set -e

TARGET_ROOT="${1:-docs}"
INSTANCES_FILE="$2"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "FIX: REMOVE .md EXTENSIONS FROM SITE-ABSOLUTE LINKS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Target: $TARGET_ROOT"
echo ""

# If no intermediary file provided, search for latest
if [ -z "$INSTANCES_FILE" ]; then
    INSTANCES_FILE=$(ls -t validation/reports/instances/md_extension_links_*.txt 2>/dev/null | head -1)
fi

if [ -z "$INSTANCES_FILE" ] || [ ! -f "$INSTANCES_FILE" ]; then
    echo -e "${YELLOW}⚠${NC} No intermediary file found."
    echo "Run detect_link_policy_violations.sh first to generate the instances file."
    exit 0
fi

echo "Using intermediary file: $INSTANCES_FILE"
echo ""

# Get unique files from intermediary file
files_to_fix=$(cat "$INSTANCES_FILE" | cut -d: -f1 | sort -u)
fix_count=0

# Fix each file
for file in $files_to_fix; do
    if [ ! -f "$file" ]; then
        echo -e "${RED}✗${NC} File not found: $file"
        continue
    fi
    
    echo -e "${YELLOW}Fixing:${NC} $file"
    
    # Backup original file
    cp "$file" "$file.bak"
    
    # Remove .md from site-absolute /docs/ links
    # Pattern: ](/docs/path/to/file.md) or ](/docs/path/to/file.md#anchor)
    sed -i 's|](/docs/\([^)]*\)\.md)|](/docs/\1)|g' "$file"
    sed -i 's|](/docs/\([^)]*\)\.md#|](/docs/\1#|g' "$file"
    
    # Check if file was actually modified
    if ! diff -q "$file" "$file.bak" > /dev/null 2>&1; then
        echo -e "${GREEN}  ✓${NC} Fixed"
        fix_count=$((fix_count + 1))
        rm "$file.bak"
    else
        echo -e "${YELLOW}  ⚠${NC} No changes needed"
        rm "$file.bak"
    fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "SUMMARY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ $fix_count -eq 0 ]; then
    echo -e "${YELLOW}⚠${NC} No files needed fixes"
else
    echo -e "${GREEN}✓${NC} Fixed $fix_count files"
    echo ""
    echo "Next step: Run detection script again to verify:"
    echo "  bash validation/scripts/detect/detect_link_policy_violations.sh $TARGET_ROOT"
fi
