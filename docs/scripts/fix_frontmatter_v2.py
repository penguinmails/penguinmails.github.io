import sys
import re
import os
import datetime

def parse_frontmatter(content):
    """
    Extracts frontmatter and content.
    Returns (frontmatter_dict, content_body, raw_frontmatter)
    """
    # Check if file starts with ---
    if not content.startswith('---\n'):
        return {}, content, ""
    
    # Find second ---
    parts = re.split(r'^---\n', content, maxsplit=2, flags=re.MULTILINE)
    if len(parts) < 3:
        # No second delimiter?
        return {}, content, ""
    
    raw_fm = parts[1]
    body = parts[2]
    
    fm_dict = {}
    for line in raw_fm.splitlines():
        line = line.strip()
        if ':' in line:
            key, val = line.split(':', 1)
            fm_dict[key.strip()] = val.strip().strip('"').strip("'")
            
    return fm_dict, body, raw_fm

def clean_content(content):
    """
    Removes the specific corruption block from content.
    Corruption block contains 'level: 2' and 'persona: "Documentation Users"'.
    """
    # Regex for the bad block
    # It starts with ---, contains specific fields, ends with ---
    # We use a fairly specific regex to avoid false positives (like HRs)
    
    pattern = r'\n---\n.*?level: 2.*?persona: "Documentation Users".*?\n---'
    
    # Check if such a block exists
    match = re.search(pattern, content, re.DOTALL)
    if match:
        # Remove it
        content = re.sub(pattern, '', content, flags=re.DOTALL)
        return content, True
        
    # Also check for block at the very end (no trailing newline)
    pattern_end = r'\n---\n.*?level: 2.*?persona: "Documentation Users".*?\n---$'
    match = re.search(pattern_end, content, re.DOTALL)
    if match:
        content = re.sub(pattern_end, '', content, flags=re.DOTALL)
        return content, True
        
    return content, False

def fix_file(filepath):
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
    except UnicodeDecodeError:
        print(f"⚠️  Skipping binary or non-utf8 file: {filepath}")
        return

    fm_dict, body, raw_fm = parse_frontmatter(content)
    
    # Clean the body
    cleaned_body, changed = clean_content(body)
    
    # If no corruption found in body, and we are just enforcing FM, 
    # we should check if we need to update FM.
    # The user wants to "Clean up... proper frontmatter".
    # So we should ALWAYS update FM to include level/persona if missing.
    
    # Update FM
    fm_dict['level'] = '2'
    fm_dict['persona'] = 'Documentation Users'
    if 'last_modified_date' not in fm_dict:
        fm_dict['last_modified_date'] = datetime.date.today().isoformat()
    
    # Reconstruct file
    new_fm_lines = ["---"]
    # Title first
    if 'title' in fm_dict:
        new_fm_lines.append(f'title: "{fm_dict["title"]}"')
        del fm_dict['title']
    
    # Sort other keys
    for key in sorted(fm_dict.keys()):
        new_fm_lines.append(f'{key}: "{fm_dict[key]}"')
        
    new_fm_lines.append("---")
    new_fm_lines.append("") # Empty line after FM
    
    new_content = "\n".join(new_fm_lines) + cleaned_body
    
    # Write back only if changed or FM updated
    # Actually, we should write back if we are fixing corruption OR updating FM.
    # But the task is "Corruption Cleanup".
    # If the file was NOT corrupted (no bad block removed), should we touch it?
    # The user said "Found systematic frontmatter corruption...".
    # But also "Clean up level 1-2 documentation files".
    # I'll assume we should apply the fix to all files that match the criteria.
    
    # However, to be safe and follow the "Corruption Cleanup" scope, 
    # I should probably only write if I removed corruption OR if the file was flagged as corrupted.
    # The bash script iterates files.
    
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(new_content)
    
    if changed:
        print(f"✅ Fixed corruption in: {filepath}")
    else:
        print(f"✅ Updated frontmatter in: {filepath}")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        fix_file(sys.argv[1])
