#!/bin/bash
# docs/scripts/validate-frontmatter-fixed.sh
# Validates and fixes frontmatter using the safe Python implementation.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"
DOCS_DIR="$REPO_ROOT/docs"

echo "🔍 Validating and Fixing Frontmatter..."
echo "📁 Docs Directory: $DOCS_DIR"

# Find all markdown files
find "$DOCS_DIR" -name "*.md" -not -path "*/legacy-archive/*" -not -path "*/scripts/*" | while read -r file; do
    # Run the python script
    python3 "$DOCS_DIR/scripts/fix_frontmatter_v2.py" "$file"
done

echo "✅ Validation and Fix Complete!"
