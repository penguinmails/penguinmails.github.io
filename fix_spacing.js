const fs = require('fs');
const path = require('path');

function processFile(filePath) {
    let content = fs.readFileSync(filePath, 'utf8');
    
    // Remove extra newlines between unordered list items
    // Matches a list item, followed by \n\n+, followed by a list item.
    let changed = true;
    while(changed) {
        let newContent = content.replace(/^([ \t]*[-*] .*)\n\n+(?=[ \t]*[-*] )/gm, '$1\n');
        // Also fix numbered lists
        newContent = newContent.replace(/^([ \t]*\d+\. .*)\n\n+(?=[ \t]*\d+\. )/gm, '$1\n');
        
        if (newContent === content) {
            changed = false;
        } else {
            content = newContent;
        }
    }
    
    fs.writeFileSync(filePath, content, 'utf8');
}

function walkDir(dir) {
    const files = fs.readdirSync(dir);
    for (const file of files) {
        const fullPath = path.join(dir, file);
        if (fs.statSync(fullPath).isDirectory()) {
            walkDir(fullPath);
        } else if (fullPath.endsWith('.md')) {
            processFile(fullPath);
        }
    }
}

walkDir('docs');
console.log('Done fixing spacing in all docs.');
