# Markdown Linting Guide

## Overview

This guide provides instructions for maintaining high-quality markdown documentation standards using the project's markdown linting configuration.

## Markdown Linting with Docker

### Prerequisites

- Docker installed and running
- Project repository cloned locally
- Working directory set to repository root

### Basic Linting Command

```bash
docker run --rm -v $PWD:/md -w /md peterdavehello/markdownlint:latest markdownlint docs/ --config .markdownlint.json
```

### Lint Specific Directory

To lint only the international compliance documents:

```bash
docker run --rm -v $PWD:/md -w /md peterdavehello/markdownlint:latest markdownlint docs/compliance-security/international/*.md --config .markdownlint.json
```

### Auto-Fix Linting Issues

Many markdown linting issues can be automatically corrected using the `--fix` flag:

```bash
docker run --rm -v $PWD:/md -w /md peterdavehello/markdownlint:latest markdownlint docs/ --config .markdownlint.json --fix
```

## Linting Configuration

The project uses a `.markdownlint.json` configuration file with the following settings:

- **MD025**: Front matter title handling
- **MD041**: Front matter title requirements
- **MD013**: Line length (disabled)
- **MD036**: Emphasis as headings (configured for punctuation-based emphasis)
- **MD060**: Trailing spaces (disabled)
- **MD003**: Heading style (disabled)
- **MD024**: Multiple headings with same content (disabled)
- **MD033**: HTML in markdown (disabled)

## Common Linting Issues and Solutions

### MD022: Headings should be surrounded by blank lines

**Issue:** Missing blank lines around headings  
**Solution:** Add blank lines before and after headings

### MD032: Lists should be surrounded by blank lines

**Issue:** Lists not properly spaced from surrounding content  
**Solution:** Add blank lines before and after lists

### MD036: Emphasis used instead of heading

**Issue:** Bold text used where proper heading is required  
**Solution:** Convert `**Heading Text**` to proper markdown heading `# Heading Text`

### MD047: Files should end with a single newline

**Issue:** Files missing or having multiple trailing newlines  
**Solution:** Ensure exactly one newline at end of file

## Integration with Development Workflow

### Pre-commit Hook Integration

Add to your `.git/hooks/pre-commit` file:

```bash
#!/bin/bash
# Check for markdown linting issues before commit
if docker run --rm -v $PWD:/md -w /md peterdavehello/markdownlint:latest markdownlint docs/ --config .markdownlint.json --quiet; then
    echo "Markdown linting passed ✓"
else
    echo "Markdown linting failed. Run with --fix to auto-correct issues."
    exit 1
fi
```

### CI/CD Integration

For automated linting in CI/CD pipelines:

```yaml
# Example GitHub Actions workflow
- name: Lint Documentation
  run: |
    docker run --rm -v $PWD:/md -w /md peterdavehello/markdownlint:latest \
      markdownlint docs/ --config .markdownlint.json --fail-on-warnings
```

## Best Practices

1. **Run Linting Early**: Include linting in your development workflow
2. **Use Auto-Fix**: Start with `--fix` flag to resolve common issues automatically
3. **Review Changes**: Manually verify changes made by auto-fix
4. **Consistent Formatting**: Follow established heading hierarchy and spacing patterns
5. **Test Links**: Ensure all internal links follow Jekyll conventions (no `.md` extensions)

## Troubleshooting

### Docker Permission Issues

```bash
# Add user to docker group (Linux/macOS)
sudo usermod -aG docker $USER

# Restart terminal or logout/login for changes to take effect
```

### Container Volume Mount Issues

```bash
# Ensure working directory is repository root
pwd
# Should show the penguinmails repository root

# If issues persist, try absolute paths
docker run --rm -v $(pwd):/md -w /md peterdavehello/markdownlint:latest \
  markdownlint docs/ --config .markdownlint.json
```

### Performance Optimization

- Lint only changed files when possible
- Use `--quiet` flag to reduce output verbosity
- Run auto-fix before manual review to handle common issues

## Quick Reference

| Command | Purpose |
|---------|---------|
| `docker run --rm -v $PWD:/md -w /md peterdavehello/markdownlint:latest markdownlint docs/ --config .markdownlint.json` | Full directory linting |
| `docker run --rm -v $PWD:/md -w /md peterdavehello/markdownlint:latest markdownlint docs/ --config .markdownlint.json --fix` | Auto-fix common issues |
| `docker run --rm -v $PWD:/md -w /md peterdavehello/markdownlint:latest markdownlint docs/ --config .markdownlint.json --quiet` | Quiet mode (errors only) |
| `docker run --rm -v $PWD:/md -w /md peterdavehello/markdownlint:latest markdownlint docs/compliance-security/international/*.md --config .markdownlint.json` | Specific directory linting |

---

**Reference:** [MarkdownLint Documentation](https://github.com/DavidAnson/markdownlint)  
**Docker Image:** [peterdavehello/markdownlint](https://hub.docker.com/r/peterdavehello/markdownlint)
