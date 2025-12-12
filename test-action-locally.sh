#!/bin/bash
# Local GitHub Action Test Script
# This simulates the GitHub Actions environment for debugging

set -e

echo "=========================================="
echo "Local GitHub Action Test Runner"
echo "=========================================="
echo ""

# Check if .env file exists for secrets
if [ ! -f ".env.test" ]; then
    echo "Creating .env.test template..."
    cat > .env.test << 'EOF'
# GitHub Action Environment Variables for Local Testing
# Copy this to .env.test and fill in your values

# Required: GitHub Personal Access Token
INPUT_TOKEN=your_github_token_here

# Optional: Username to test with (defaults to token owner)
INPUT_USER=

# Optional: Repository to test with
INPUT_REPO=

# Output settings
INPUT_FILENAME=github-metrics.svg
INPUT_OUTPUT_ACTION=none
INPUT_COMMITTER_TOKEN=
INPUT_COMMITTER_BRANCH=
INPUT_COMMITTER_MESSAGE=

# Template to use
INPUT_TEMPLATE=classic

# Base content
INPUT_BASE=header, activity, community, repositories, metadata

# Example: Enable a plugin
# INPUT_PLUGIN_LANGUAGES=yes
# INPUT_PLUGIN_LANGUAGES_LIMIT=8

# Debug settings
INPUT_DEBUG=true
INPUT_DEBUG_FLAGS=

# Verify output
INPUT_VERIFY=false

# Dry run (don't commit)
INPUT_DRYRUN=true
EOF
    echo "Created .env.test template. Please edit it with your GitHub token."
    echo "Then run this script again."
    exit 1
fi

echo "Loading environment from .env.test..."
set -a
source .env.test
set +a

# Validate required variables
if [ "$INPUT_TOKEN" = "your_github_token_here" ] || [ -z "$INPUT_TOKEN" ]; then
    echo "ERROR: Please set INPUT_TOKEN in .env.test"
    exit 1
fi

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

echo "Environment configured:"
echo "  GITHUB_WORKSPACE: $GITHUB_WORKSPACE"
echo "  GITHUB_REPOSITORY: $GITHUB_REPOSITORY"
echo "  GITHUB_ACTOR: $GITHUB_ACTOR"
echo "  INPUT_USER: $INPUT_USER"
echo "  INPUT_FILENAME: $INPUT_FILENAME"
echo "  INPUT_TOKEN: ***PROVIDED***"
echo ""

echo "Running action..."
echo "=========================================="
echo ""

# Run the action
node source/app/action/index.mjs

echo ""
echo "=========================================="
echo "Action completed!"
echo ""

# Check if output file was created
if [ -f "$INPUT_FILENAME" ]; then
    echo "✓ Output file created: $INPUT_FILENAME"
    ls -lh "$INPUT_FILENAME"
else
    echo "✗ Output file not found: $INPUT_FILENAME"
fi
