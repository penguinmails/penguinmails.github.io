#!/bin/bash

# Frontmatter Fix Script - Version 2
# Usage: ./fix_frontmatter.sh [target_directory]
# Adds missing frontmatter fields to files

set -e

TARGET_ROOT="${1:-docs}"
TODAY=$(date +%Y-%m-%d)

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "FRONTMATTER FIX - Version 2"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Target: $TARGET_ROOT"
echo "Date: $TODAY"
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

count_fixed=0

# Function to extract title from first H1
extract_title() {
    local file="$1"
    local h1=$(grep -m1 "^# " "$file" 2>/dev/null || echo "")
    if [ -n "$h1" ]; then
        echo "$h1" | sed 's/^# //' | tr -d '"'
    else
        basename "$file" .md
    fi
}

# Function to fix a single file
fix_file() {
    local file="$1"
    local has_frontmatter=$(head -1 "$file" 2>/dev/null)
    
    if [ "$has_frontmatter" != "---" ]; then
        return
    fi
    
    local modified=0
    
    # Check and add title if missing
    if ! grep -q "^title:" "$file"; then
        local title=$(extract_title "$file")
        sed -i "1a title: \"$title\"" "$file"
        modified=1
    fi
    
    # Check and add description if missing
    if ! grep -q "^description:" "$file"; then
        sed -i "/^title:/a description: \"\"" "$file"
        modified=1
    fi
    
    # Check and add level if missing
    if ! grep -q "^level:" "$file"; then
        sed -i "/^description:/a level: \"2\"" "$file"
        modified=1
    fi
    
    # Check and add last_modified_date if missing
    if ! grep -q "^last_modified_date:" "$file"; then
        sed -i "/^level:/a last_modified_date: \"$TODAY\"" "$file"
        modified=1
    fi
    
    if [ $modified -eq 1 ]; then
        count_fixed=$((count_fixed + 1))
        echo -e "  ${GREEN}✓${NC} Fixed: $file"
    fi
}

echo "Fixing files with partial frontmatter..."
echo ""

# Find all .md files in target directory
find "$TARGET_ROOT" -name "*.md" -type f | while read file; do
    fix_file "$file"
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "SUMMARY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "Files fixed: ${GREEN}$count_fixed${NC}"
echo ""
echo "Done!"
