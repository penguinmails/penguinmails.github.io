#!/usr/bin/env python3
"""
Script to fix common markdown linting errors across multiple files.
Fixes MD022 (blank lines around headings), MD032 (blank lines around lists), 
and MD031 (blank lines around fenced code blocks).
"""

import os
import re
import sys
from pathlib import Path

def fix_heading_blank_lines(content):
    """Fix MD022: Add blank lines around headings"""
    # Add blank line before headings (except at start of file)
    content = re.sub(r'(?<!\n\n)(\n#{1,6}\s+)', r'\n\1', content)
    # Add blank line after headings
    content = re.sub(r'(\n#{1,6}\s+.*?)(?=\n[^\n#])', r'\1\n', content)
    return content

def fix_list_blank_lines(content):
    """Fix MD032: Add blank lines around lists"""
    # Add blank line before unordered lists
    content = re.sub(r'(?<!\n\n)(\n[ \t]*[-*+]\s+)', r'\n\1', content)
    # Add blank line before ordered lists
    content = re.sub(r'(?<!\n\n)(\n[ \t]*\d+\.\s+)', r'\n\1', content)
    return content

def fix_code_fence_blank_lines(content):
    """Fix MD031: Add blank lines around fenced code blocks"""
    # Add blank line before code fences
    content = re.sub(r'(?<!\n\n)(\n```[a-z]*\n)', r'\n\1', content)
    # Add blank line after code fences
    content = re.sub(r'(\n```[ \t]*\n)(?!\n)', r'\1\n', content)
    return content

def fix_file(file_path):
    """Apply all fixes to a single file"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        original_content = content
        
        # Apply fixes
        content = fix_heading_blank_lines(content)
        content = fix_list_blank_lines(content)
        content = fix_code_fence_blank_lines(content)
        
        # Only write if changes were made
        if content != original_content:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
            print(f"Fixed: {file_path}")
            return True
        else:
            print(f"No changes needed: {file_path}")
            return False
            
    except Exception as e:
        print(f"Error processing {file_path}: {e}")
        return False

def main():
    """Process markdown files in docs directory"""
    docs_dir = Path("docs")
    if not docs_dir.exists():
        print("docs directory not found")
        return
    
    # Find all markdown files
    md_files = list(docs_dir.rglob("*.md"))
    
    print(f"Found {len(md_files)} markdown files")
    
    fixed_count = 0
    for file_path in md_files:
        if fix_file(file_path):
            fixed_count += 1
    
    print(f"\nFixed {fixed_count} files")

if __name__ == "__main__":
    main()
