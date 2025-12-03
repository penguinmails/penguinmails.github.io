#!/bin/bash

# Tech Stack Compliance Detection Script
# Usage: ./detect_tech_stack_violations.sh [target_directory]
# Detects forbidden code blocks and tech mentions

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
echo "TECH STACK COMPLIANCE VALIDATION"
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

# Function to detect forbidden code blocks
detect_code_block() {
    local lang="$1"
    local description="$2"
    
    echo "Checking: $description..."
    
    local files=$(grep -r "^\`\`\`$lang" "$TARGET_ROOT" --include="*.md" 2>/dev/null || echo "")
    local count=$(echo "$files" | grep -c ":" || echo "0")
    
    echo "    \"${lang}_blocks\": {" >> "$REPORT_FILE"
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
        echo -e "  ${GREEN}✓${NC} No $lang blocks found"
    else
        echo -e "  ${YELLOW}⚠${NC} Found $count $lang blocks"
    fi
    echo ""
}

# Check for forbidden code blocks
detect_code_block "python" "Python code blocks (forbidden)"
detect_code_block "ruby" "Ruby code blocks (forbidden)"
detect_code_block "php" "PHP code blocks (forbidden)"
detect_code_block "csharp" "C# code blocks (forbidden)"

# Check for forbidden tech mentions
echo "Checking: Forbidden tech mentions (prisma, bullmq, mysql)..."

# Prisma mentions (exclude lines with drizzle)
prisma_files=$(grep -ri "prisma" "$TARGET_ROOT" --include="*.md" 2>/dev/null | grep -vi "drizzle" || echo "")
prisma_count=$(echo "$prisma_files" | grep -c ":" || echo "0")

# BullMQ mentions
bullmq_files=$(grep -ri "bullmq" "$TARGET_ROOT" --include="*.md" 2>/dev/null || echo "")
bullmq_count=$(echo "$bullmq_files" | grep -c ":" || echo "0")

# MySQL mentions (exclude lines with postgresql)
mysql_files=$(grep -ri "mysql" "$TARGET_ROOT" --include="*.md" 2>/dev/null | grep -vi "postgresql" || echo "")
mysql_count=$(echo "$mysql_files" | grep -c ":" || echo "0")

# Add Prisma to report
echo "    \"prisma_mentions\": {" >> "$REPORT_FILE"
echo "      \"description\": \"Prisma mentions (without Drizzle context)\"," >> "$REPORT_FILE"
echo "      \"count\": $prisma_count," >> "$REPORT_FILE"
echo "      \"files\": [" >> "$REPORT_FILE"

if [ $prisma_count -gt 0 ]; then
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
    done <<< "$prisma_files"
    echo "" >> "$REPORT_FILE"
    total_issues=$((total_issues + prisma_count))
fi

echo "      ]" >> "$REPORT_FILE"
echo "    }," >> "$REPORT_FILE"

if [ $prisma_count -eq 0 ]; then
    echo -e "  ${GREEN}✓${NC} No Prisma mentions"
else
    echo -e "  ${YELLOW}⚠${NC} Found $prisma_count Prisma mentions"
fi

# Add BullMQ to report
echo "    \"bullmq_mentions\": {" >> "$REPORT_FILE"
echo "      \"description\": \"BullMQ mentions (forbidden)\"," >> "$REPORT_FILE"
echo "      \"count\": $bullmq_count," >> "$REPORT_FILE"
echo "      \"files\": [" >> "$REPORT_FILE"

if [ $bullmq_count -gt 0 ]; then
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
    done <<< "$bullmq_files"
    echo "" >> "$REPORT_FILE"
    total_issues=$((total_issues + bullmq_count))
fi

echo "      ]" >> "$REPORT_FILE"
echo "    }," >> "$REPORT_FILE"

if [ $bullmq_count -eq 0 ]; then
    echo -e "  ${GREEN}✓${NC} No BullMQ mentions"
else
    echo -e "  ${YELLOW}⚠${NC} Found $bullmq_count BullMQ mentions"
fi

# Add MySQL to report
echo "    \"mysql_mentions\": {" >> "$REPORT_FILE"
echo "      \"description\": \"MySQL mentions (without PostgreSQL context)\"," >> "$REPORT_FILE"
echo "      \"count\": $mysql_count," >> "$REPORT_FILE"
echo "      \"files\": [" >> "$REPORT_FILE"

if [ $mysql_count -gt 0 ]; then
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
    done <<< "$mysql_files"
    echo "" >> "$REPORT_FILE"
    total_issues=$((total_issues + mysql_count))
fi

echo "      ]" >> "$REPORT_FILE"
echo "    }" >> "$REPORT_FILE"

if [ $mysql_count -eq 0 ]; then
    echo -e "  ${GREEN}✓${NC} No MySQL mentions"
else
    echo -e "  ${YELLOW}⚠${NC} Found $mysql_count MySQL mentions"
fi

echo ""

# Close JSON report
echo "  }," >> "$REPORT_FILE"
echo "  \"total_issues\": $total_issues" >> "$REPORT_FILE"
echo "}" >> "$REPORT_FILE"

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "SUMMARY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ $total_issues -eq 0 ]; then
    echo -e "${GREEN}✓${NC} All tech stack compliance checks passed!"
    exit 0
else
    echo -e "${RED}✗${NC} Found $total_issues tech stack violations"
    if [ "$GENERATE_REPORT" = true ]; then
        echo "Report saved to: $REPORT_FILE"
    fi
    exit 1
fi
