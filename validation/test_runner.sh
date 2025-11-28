#!/bin/bash

# Test Runner for Validation Pipeline
# Tests detection and fix scripts on fixtures

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

TESTS_PASSED=0
TESTS_FAILED=0

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║       VALIDATION PIPELINE TEST SUITE                          ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Function to run test
run_test() {
    local test_name="$1"
    local command="$2"
    local expected_exit="$3"
    
    echo -ne "${BLUE}Testing:${NC} $test_name... "
    
    if eval "$command" > /dev/null 2>&1; then
        actual_exit=0
    else
        actual_exit=$?
    fi
    
    if [ $actual_exit -eq $expected_exit ]; then
        echo -e "${GREEN}✓ PASS${NC}"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}✗ FAIL${NC} (expected exit $expected_exit, got $actual_exit)"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "DETECTION SCRIPT TESTS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Frontmatter tests
echo "${YELLOW}Frontmatter Detection:${NC}"
run_test "Frontmatter good fixtures" \
    "bash validation/scripts/detect/detect_frontmatter_issues.sh validation/fixtures/frontmatter/good" \
    0
run_test "Frontmatter bad fixtures" \
    "bash validation/scripts/detect/detect_frontmatter_issues.sh validation/fixtures/frontmatter/bad" \
    1

echo ""

# Link policy tests
echo "${YELLOW}Link Policy Detection:${NC}"
run_test "Link policy good fixtures" \
    "bash validation/scripts/detect/detect_link_policy_violations.sh validation/fixtures/links/good" \
    0
run_test "Link policy bad fixtures" \
    "bash validation/scripts/detect/detect_link_policy_violations.sh validation/fixtures/links/bad" \
    1

echo ""

# Tech stack tests
echo "${YELLOW}Tech Stack Detection:${NC}"
run_test "Tech stack good fixtures" \
    "bash validation/scripts/detect/detect_tech_stack_violations.sh validation/fixtures/tech/good" \
    0
run_test "Tech stack bad fixtures" \
    "bash validation/scripts/detect/detect_tech_stack_violations.sh validation/fixtures/tech/bad" \
    1

echo ""

# Codefence tests
echo "${YELLOW}Codefence Detection:${NC}"
run_test "Codefence good fixtures" \
    "bash validation/scripts/detect/detect_codefence_issues.sh validation/fixtures/codefence/good" \
    0
run_test "Codefence bad fixtures" \
    "bash validation/scripts/detect/detect_codefence_issues.sh validation/fixtures/codefence/bad" \
    1

echo ""

# Whitespace tests
echo "${YELLOW}Whitespace Detection:${NC}"
run_test "Whitespace good fixtures" \
    "bash validation/scripts/detect/detect_whitespace_issues.sh validation/fixtures/whitespace/good" \
    0
run_test "Whitespace bad fixtures" \
    "bash validation/scripts/detect/detect_whitespace_issues.sh validation/fixtures/whitespace/bad" \
    1

echo ""

# Navigation tests
echo "${YELLOW}Navigation Detection:${NC}"
run_test "Navigation good fixtures" \
    "bash validation/scripts/detect/detect_navigation_violations.sh validation/fixtures/navigation/good" \
    0
run_test "Navigation bad fixtures" \
    "bash validation/scripts/detect/detect_navigation_violations.sh validation/fixtures/navigation/bad" \
    1

echo ""

# Content Quality tests
echo "${YELLOW}Content Quality Detection:${NC}"
run_test "Content quality good fixtures" \
    "bash validation/scripts/detect/detect_content_quality_issues.sh validation/fixtures/content/good" \
    0
run_test "Content quality bad fixtures" \
    "bash validation/scripts/detect/detect_content_quality_issues.sh validation/fixtures/content/bad" \
    1

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "FIX SCRIPT TESTS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Link extension fix test
echo "${YELLOW}Link Extension Fix:${NC}"

# Create temp test directory
TEST_DIR="/tmp/validation-test-$$"
mkdir -p "$TEST_DIR"
cp -r validation/fixtures/links/bad "$TEST_DIR/"

# Detect issues and generate intermediary file
bash validation/scripts/detect/detect_link_policy_violations.sh "$TEST_DIR/bad" > /dev/null 2>&1 || true

# Apply fix
bash validation/scripts/fix/fix_link_extensions.sh "$TEST_DIR/bad" > /dev/null 2>&1

# Re-run detection - md_extensions should now be 0
if bash validation/scripts/detect/detect_link_policy_violations.sh "$TEST_DIR/bad" > /dev/null 2>&1; then
    # Check if the specific .md extension issue is fixed
    if ! grep -q "](/docs/.*\.md)" "$TEST_DIR/bad/md_extension_site_absolute.md" 2>/dev/null; then
       echo -e "${GREEN}✓ PASS${NC} - .md extensions removed"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${YELLOW}⚠ PARTIAL${NC} - File still has .md extensions"
       TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
else
    # Still has issues (which is expected - only .md extensions should be fixed)
    if ! grep -q "](/docs/.*\.md)" "$TEST_DIR/bad/md_extension_site_absolute.md" 2>/dev/null; then
        echo -e "${GREEN}✓ PASS${NC} - .md extensions removed (other issues remain as expected)"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}✗ FAIL${NC} - .md extensions NOT removed"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
fi

# Cleanup
rm -rf "$TEST_DIR"

echo ""

# Whitespace fix test
echo "${YELLOW}Whitespace Fix:${NC}"

# Create temp test directory
TEST_DIR="/tmp/validation-test-ws-$$"
mkdir -p "$TEST_DIR"
cp -r validation/fixtures/whitespace/bad "$TEST_DIR/"

# Detect issues and generate intermediary file
bash validation/scripts/detect/detect_whitespace_issues.sh "$TEST_DIR/bad" > /dev/null 2>&1 || true

# Apply fix
bash validation/scripts/fix/fix_whitespace.sh "$TEST_DIR/bad" > /dev/null 2>&1

# Re-run detection - should be 0
if bash validation/scripts/detect/detect_whitespace_issues.sh "$TEST_DIR/bad" > /dev/null 2>&1; then
    echo -e "${GREEN}✓ PASS${NC} - Trailing whitespace removed"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}✗ FAIL${NC} - Trailing whitespace NOT removed"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

# Cleanup
rm -rf "$TEST_DIR"

echo ""

# Codefence fix test
echo "${YELLOW}Codefence Fix:${NC}"

# Create temp test directory
TEST_DIR="/tmp/validation-test-cf-$$"
mkdir -p "$TEST_DIR"
cp -r validation/fixtures/codefence/bad "$TEST_DIR/"

# Detect issues and generate intermediary file
bash validation/scripts/detect/detect_codefence_issues.sh "$TEST_DIR/bad" > /dev/null 2>&1 || true

# Get the intermediary file path (latest one)
INTERMEDIARY_FILE=$(ls -t validation/reports/instances/codefence_closing_issues_*.txt 2>/dev/null | head -1)

# Apply fix with explicit intermediary file
bash validation/scripts/fix/fix_codefences.sh "$TEST_DIR/bad" "$INTERMEDIARY_FILE" > /dev/null 2>&1

# Re-run detection - closing_with_lang should be 0
# We check that the number of ```typescript lines is now 1 (only the opening one), not 2.
count=$(grep -c "^\`\`\`typescript$" "$TEST_DIR/bad/closing_fence_with_lang.md" || echo "0")

if [ "$count" -eq 1 ]; then
    echo -e "${GREEN}✓ PASS${NC} - Closing fence language removed (only opening fence remains)"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}✗ FAIL${NC} - Expected 1 occurrence of '\`\`\`typescript', found $count"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

# Cleanup
rm -rf "$TEST_DIR"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "SUMMARY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

TOTAL_TESTS=$((TESTS_PASSED + TESTS_FAILED))

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ ALL TESTS PASSED${NC} ($TESTS_PASSED/$TOTAL_TESTS)"
    echo ""
    echo "Validation pipeline is working correctly!"
    exit 0
else
    echo -e "${RED}✗ SOME TESTS FAILED${NC}"
    echo "  Passed: $TESTS_PASSED/$TOTAL_TESTS"
    echo "  Failed: $TESTS_FAILED/$TOTAL_TESTS"
    exit 1
fi
