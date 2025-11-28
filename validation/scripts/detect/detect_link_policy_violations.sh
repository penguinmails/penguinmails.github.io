#!/bin/bash

# Link Policy Violations Detection Script
# Usage: ./detect_link_policy_violations.sh [target_directory]
# Detects relative links, .md extensions, and links to non-Jekyll files

set -e

TARGET_ROOT="${1:-docs}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
REPORT_DIR="validation/reports"
REPORT_FILE="$REPORT_DIR/link_violations_${TIMESTAMP}.json"
INSTANCES_DIR="$REPORT_DIR/instances"
MD_EXTENSION_FILE="$INSTANCES_DIR/md_extension_links_${TIMESTAMP}.txt"

# Create directories
mkdir -p "$REPORT_DIR" "$INSTANCES_DIR"

# Initialize counters
total_issues=0

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "LINK POLICY VALIDATION"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Target: $TARGET_ROOT"
echo "Report: $REPORT_FILE"
echo ""

# Initialize JSON report
echo "{" > "$REPORT_FILE"
echo "  \"timestamp\": \"$(date -Iseconds)\"," >> "$REPORT_FILE"
echo "  \"target_root\": \"$TARGET_ROOT\"," >> "$REPORT_FILE"
echo "  \"issues\": {" >> "$REPORT_FILE"

# Function to detect link violations
detect_links() {
    local issue_name="$1"
    local pattern="$2"
    local description="$3"
    local use_regex="${4:-false}"
    
    echo "Checking: $description..."
    
    local files
    if [ "$use_regex" = "true" ]; then
        files=$(grep -rE "$pattern" "$TARGET_ROOT" --include="*.md" 2>/dev/null || echo "")
    else
        files=$(grep -r "$pattern" "$TARGET_ROOT" --include="*.md" 2>/dev/null || echo "")
    fi
    
    local count=0
    if [ -n "$files" ]; then
        count=$(echo "$files" | grep -c ":" 2>/dev/null || echo "0")
    fi
    
    # Add to JSON report
    echo "    \"$issue_name\": {" >> "$REPORT_FILE"
    echo "      \"description\": \"$description\"," >> "$REPORT_FILE"
    echo "      \"count\": $count," >> "$REPORT_FILE"
    echo "      \"files\": [" >> "$REPORT_FILE"
    
    if [ $count -gt 0 ]; then
        first=true
        while IFS=: read -r file line; do
            [ -z "$file" ] && continue
            if [ "$first" = true ]; then
                first=false
            else
                echo "," >> "$REPORT_FILE"
            fi
            echo -n "        {\"file\": \"$file\", \"line\": \"$line\"}" >> "$REPORT_FILE"
            echo -e "  ${RED}✗${NC} $file"
        done <<< "$files"
        echo "" >> "$REPORT_FILE"
        total_issues=$((total_issues + count))
    fi
    
    echo "      ]" >> "$REPORT_FILE"
    echo "    }," >> "$REPORT_FILE"
    
    if [ $count -eq 0 ]; then
        echo -e "  ${GREEN}✓${NC} No violations found"
    else
        echo -e "  ${YELLOW}⚠${NC} Found $count instances"
    fi
    echo ""
}

# Check for relative links to tasks/ folder
detect_links "tasks_links" "](.*tasks/" "Relative links to tasks/ folder" false

# Check for relative links to user-journeys/ folder
detect_links "journeys_links" "](.*user-journeys/" "Relative links to user-journeys/ folder" false

# Check for links to CONTRIBUTING.md
detect_links "contributing_links" "](.*CONTRIBUTING" "Links to CONTRIBUTING.md" false

# Check for links to root README.md
detect_links "readme_links" "](.*\\.\\./README\\|](/README" "Links to root README.md" false

# Check for site-absolute links with .md extension
echo "Checking: Site-absolute links with .md extension..."
md_ext_files=$(grep -rE "]\(/docs/.*\.md[)#]" "$TARGET_ROOT" --include="*.md" 2>/dev/null || echo "")
md_ext_count=$(echo "$md_ext_files" | grep -c ":" || echo "0")

# Save to intermediary file for fix script
if [ $md_ext_count -gt 0 ]; then
    echo "$md_ext_files" > "$MD_EXTENSION_FILE"
    echo "Intermediary file created: $MD_EXTENSION_FILE"
fi

echo "    \"md_extensions\": {" >> "$REPORT_FILE"
echo "      \"description\": \"Site-absolute links with .md extension\"," >> "$REPORT_FILE"
echo "      \"count\": $md_ext_count," >> "$REPORT_FILE"
echo "      \"intermediary_file\": \"$MD_EXTENSION_FILE\"," >> "$REPORT_FILE"
echo "      \"files\": [" >> "$REPORT_FILE"

if [ $md_ext_count -gt 0 ]; then
    first=true
    while IFS=: read -r file line; do
        [ -z "$file" ] && continue
        if [ "$first" = true ]; then
            first=false
        else
            echo "," >> "$REPORT_FILE"
        fi
        echo -n "        {\"file\": \"$file\", \"line\": \"$line\"}" >> "$REPORT_FILE"
        echo -e "  ${RED}✗${NC} $file"
    done <<< "$md_ext_files"
    echo "" >> "$REPORT_FILE"
    total_issues=$((total_issues + md_ext_count))
fi

echo "      ]" >> "$REPORT_FILE"
echo "    }," >> "$REPORT_FILE"

if [ $md_ext_count -eq 0 ]; then
    echo -e "  ${GREEN}✓${NC} No .md extensions found"
else
    echo -e "  ${YELLOW}⚠${NC} Found $md_ext_count instances"
fi
echo ""

# Check for relative .md links (general catch-all)
detect_links "relative_md_links" "]\(\\.\\./.*\\.md\\|]\(\\./" "Relative .md links (./  or ../)" true

# Additional edge case checks for better categorization
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "EDGE CASE DETECTION"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check for same-directory relative links (./file)
detect_links "relative_same_dir" "]\(\\./[^/)]*)" "Relative same-directory links (./file)" true

# Check for parent-directory relative links (../folder/file)
detect_links "relative_parent_dir" "]\(\\.\\./[^)]*)" "Relative parent-directory links (../)" true

# Check for complex relative paths (../../docs/)
detect_links "relative_complex" "](../../docs/" "Complex relative paths (../../docs/)" false

# Check for relative links with anchors
detect_links "relative_with_anchors" "]\(\\./[^)]*#|]\(\\.\\./[^)]*#" "Relative links with anchors" true

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Close JSON report
echo "    \"total\": {" >> "$REPORT_FILE"
echo "      \"count\": $total_issues" >> "$REPORT_FILE"
echo "    }" >> "$REPORT_FILE"
echo "  }," >> "$REPORT_FILE"
echo "  \"total_issues\": $total_issues" >> "$REPORT_FILE"
echo "}" >> "$REPORT_FILE"

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "SUMMARY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ $total_issues -eq 0 ]; then
    echo -e "${GREEN}✓${NC} All link policy checks passed!"
    exit 0
else
    echo -e "${RED}✗${NC} Found $total_issues link policy violations"
    echo "Report saved to: $REPORT_FILE"
    if [ -f "$MD_EXTENSION_FILE" ]; then
        echo "Intermediary file for fixes: $MD_EXTENSION_FILE"
    fi
    exit 1
fi
