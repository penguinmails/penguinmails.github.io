#!/bin/bash
# docs/scripts/validate-frontmatter.sh
# Complete frontmatter validation and auto-fix script for Jekyll/Just the Docs

set -e

REQUIRED_FIELDS="title description last_modified_date level persona"
CURRENT_DATE=$(date +%Y-%m-%d)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Go up to the repository root (script is in docs/scripts/, need to go up 2 levels)
REPO_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"
DOCS_DIR="$REPO_ROOT/docs"

# Verify we're in the correct repo root
if [ ! -f "$REPO_ROOT/_config.yaml" ]; then
  echo "❌ Error: _config.yaml not found in $REPO_ROOT. Not a Jekyll repo root."
  exit 1
fi
echo "✅ Confirmed Jekyll repo root: $REPO_ROOT"
echo "📁 Targeting docs directory: $DOCS_DIR"

mkdir -p "$SCRIPT_DIR"

echo "🔍 Scanning docs/ directory for frontmatter issues..."

# Function to extract title from H1
extract_title() {
  local file="$1"
  head -100 "$file" | grep -m1 '^# ' | sed 's/^# *//' | sed 's/"/\\"/g'
}

# Function to generate description
generate_description() {
  local file="$1"
  local title="$2"
  local path="$3"
  # Try first paragraph after frontmatter, then filename-based
  local first_para=$(sed -n '/^---/,/^---/d; /^$/d; /^#/d; 1{/^[[:space:]]*$/d; p; q}' "$file" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
  if [ -n "$first_para" ] && [ ${#first_para} -gt 20 ]; then
    echo "$first_para" | cut -c1-150 | sed 's/"/\\"/g'
  else
    echo "Documentation for $title - $(basename "$path" .md | sed 's/-/ /g;s/_/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)}1')" | cut -c1-150 | sed 's/"/\\"/g'
  fi
}

# Function to validate date format
validate_date() {
  local date="$1"
  if [[ "$date" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    return 0
  else
    return 1
  fi
}

# Find all MD files only in docs/ subdirectory
find "$DOCS_DIR" -name "*.md" -not -path "*/legacy-archive/*" -not -path "*/scripts/*" | sort | while read -r file; do
  echo "Checking [$file]..."
  
  # Skip if no content
  if [ ! -s "$file" ]; then
    echo "⚠️  Skipping empty file: $file"
    continue
  fi
  
  # Check if frontmatter exists (proper YAML frontmatter with title field)
  if ! awk '/^---/{f=1;next} f&&/^---/{has_title=1;exit} f&&/^title:/{has_title=1}' "$file" | grep -q "^title:" || ! head -30 "$file" | grep -A20 "^---$" | grep -qm1 "^---$"; then
    echo "❌ MISSING frontmatter: $file"
    
    title=$(extract_title "$file")
    [ -z "$title" ] && title=$(basename "$file" .md | sed 's/-/ /g;s/_/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)}1')
    description=$(generate_description "$file" "$title" "$file")
    
    cat > "$file.tmp" << EOF
---
title: "$title"
description: "$description"
last_modified_date: "$CURRENT_DATE"
level: 2
persona: "Documentation Users"
---

EOF
    cat "$file" >> "$file.tmp"
    mv "$file.tmp" "$file"
    echo "✅ Added frontmatter to $file"
    continue
  fi
  
  # Extract existing frontmatter (only if proper YAML structure exists)
  frontmatter=$(awk '
  /^---/{f=1;next}
  /^title:/{has_title=1}
  /^[a-zA-Z_]+:/ && f{has_yaml=1}
  f&&/^---/{f=0;exit}
  f' "$file")
  
  if ! echo "$frontmatter" | grep -q "^title:"; then
    echo "❌ INVALID frontmatter (missing title YAML): $file"
  else
    # Check required fields
    missing=()
    for field in $REQUIRED_FIELDS; do
      if ! echo "$frontmatter" | grep -q "^$field:"; then
        missing+=("$field")
      fi
    done
    
    # Validate existing fields
    errors=()
    if echo "$frontmatter" | grep -q "^last_modified_date:"; then
      date=$(echo "$frontmatter" | grep "^last_modified_date:" | sed 's/.*: *"\([^"]*\)".*/\1/')
      if ! validate_date "$date"; then
        errors+=("invalid last_modified_date format")
      fi
    fi
    
    if [ ${#missing[@]} -ne 0 ] || [ ${#errors[@]} -ne 0 ]; then
      echo "⚠️  Issues in $file: ${missing[*]} ${errors[*]}"
      
      # Create backup
      cp "$file" "$file.backup.$(date +%Y%m%d_%H%M%S)"
      
      # Auto-fix missing fields (insert before second ---)
      temp_file=$(mktemp)
      awk -v date="$CURRENT_DATE" '
      /^---/ {print; lines=0; next}
      lines==0 && /^---/ { 
        if (!/title:/) print "title: \"Document Title\"";
        if (!/description:/) print "description: \"Documentation content\"";
        if (!/last_modified_date:/) print "last_modified_date: \"" date "\"";
        if (!/level:/) print "level: 2";
        if (!/persona:/) print "persona: \"Documentation Users\"";
        print; next
      }
      {print; lines++}
      END {if (lines>0) print "---"}
      ' "$file" > "$temp_file"
      
      mv "$temp_file" "$file"
      echo "✅ Auto-fixed $file (backup: $file.backup.*)"
    else
      echo "✅ VALID: $file"
    fi
  fi
done

# Summary
total_files=$(find "$DOCS_DIR" -name "*.md" -not -path "*/legacy-archive/*" -not -path "*/scripts/*" | wc -l)
echo ""
echo "🎉 Frontmatter validation complete!"
echo "📊 Total files checked: $total_files"
echo "ℹ️  Run 'bundle exec jekyll build' to test the site."
echo "ℹ️  Run 'bundle exec jekyll serve' to preview changes."