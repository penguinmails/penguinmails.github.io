#!/bin/bash

# Link Policy Violations Detection Script
# Usage: ./detect_link_policy_violations.sh [target_directory]
# Detects relative links, .md extensions, and links to non-Jekyll files

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
