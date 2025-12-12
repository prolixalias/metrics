#!/bin/bash
# Direct GitHub Action Test Runner
# Pass environment variables directly (e.g., from Doppler)

set -e

echo "=========================================="
echo "Local GitHub Action Test Runner"
echo "=========================================="
echo ""

# Validate required variables
if [ -z "$INPUT_TOKEN" ]; then
    echo "ERROR: INPUT_TOKEN environment variable is required"
    echo ""
    echo "Usage examples:"
    echo "  1. Direct: INPUT_TOKEN=ghp_xxx ./run-action-local.sh"
    echo "  2. Doppler: doppler run -- ./run-action-local.sh"
    echo "  3. Export: export INPUT_TOKEN=ghp_xxx && ./run-action-local.sh"
    exit 1
fi

# Set Puppeteer environment to use system Chromium
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export PUPPETEER_EXECUTABLE_PATH="${PUPPETEER_EXECUTABLE_PATH:-$(which chromium-browser || which chromium || which google-chrome-stable || echo /usr/bin/chromium)}"

# Set GitHub Actions context environment variables
export GITHUB_WORKSPACE="${GITHUB_WORKSPACE:-$(pwd)}"
export GITHUB_REPOSITORY="${GITHUB_REPOSITORY:-test/test-repo}"
export GITHUB_ACTOR="${GITHUB_ACTOR:-testuser}"
export GITHUB_EVENT_NAME="${GITHUB_EVENT_NAME:-workflow_dispatch}"
export GITHUB_SHA="${GITHUB_SHA:-0000000000000000000000000000000000000000}"
export GITHUB_REF="${GITHUB_REF:-refs/heads/main}"
export GITHUB_RUN_ID="${GITHUB_RUN_ID:-123456789}"
export GITHUB_RUN_NUMBER="${GITHUB_RUN_NUMBER:-1}"
export GITHUB_ACTION="${GITHUB_ACTION:-test-action}"

# Set defaults for optional inputs
export INPUT_USER="${INPUT_USER:-$GITHUB_ACTOR}"
export INPUT_FILENAME="${INPUT_FILENAME:-github-metrics.svg}"
export INPUT_OUTPUT_ACTION="${INPUT_OUTPUT_ACTION:-none}"
export INPUT_TEMPLATE="${INPUT_TEMPLATE:-classic}"
export INPUT_BASE="${INPUT_BASE:-header, activity, community, repositories, metadata}"
export INPUT_DRYRUN="${INPUT_DRYRUN:-true}"
export INPUT_DEBUG="${INPUT_DEBUG:-true}"

echo "Environment configured:"
echo "  GITHUB_WORKSPACE: $GITHUB_WORKSPACE"
echo "  GITHUB_REPOSITORY: $GITHUB_REPOSITORY"
echo "  GITHUB_ACTOR: $GITHUB_ACTOR"
echo "  INPUT_USER: $INPUT_USER"
echo "  INPUT_FILENAME: $INPUT_FILENAME"
echo "  INPUT_TEMPLATE: $INPUT_TEMPLATE"
echo "  INPUT_TOKEN: ***PROVIDED***"
echo ""

echo "Running action..."
echo "=========================================="
echo ""

# Run the action
node source/app/action/index.mjs

EXIT_CODE=$?

echo ""
echo "=========================================="
if [ $EXIT_CODE -eq 0 ]; then
    echo "✓ Action completed successfully!"
else
    echo "✗ Action failed with exit code: $EXIT_CODE"
fi
echo ""

# Check if output file was created
if [ -f "$INPUT_FILENAME" ]; then
    echo "✓ Output file created: $INPUT_FILENAME"
    ls -lh "$INPUT_FILENAME"
else
    echo "✗ Output file not found: $INPUT_FILENAME"
fi

exit $EXIT_CODE
