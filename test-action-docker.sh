#!/bin/bash
# Docker-based GitHub Action Test Script
# This builds and runs the action in Docker just like GitHub Actions does

set -e

echo "=========================================="
echo "Docker GitHub Action Test Runner"
echo "=========================================="
echo ""

# Check if .env file exists for secrets
if [ ! -f ".env.test" ]; then
    echo "ERROR: .env.test not found. Run ./test-action-locally.sh first to create it."
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

# Build the Docker image
echo "Building Docker image..."
echo "This may take several minutes on first run..."
docker build -t metrics-test:local .

echo ""
echo "Docker image built successfully!"
echo ""

# Set GitHub Actions context environment variables
export GITHUB_WORKSPACE="/github/workspace"
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

# Prepare environment variables for Docker
ENV_VARS=""
while IFS='=' read -r name value; do
    if [[ $name == INPUT_* ]] || [[ $name == GITHUB_* ]]; then
        ENV_VARS="$ENV_VARS -e $name"
    fi
done < <(env)

echo "Running action in Docker..."
echo "Environment configured:"
echo "  GITHUB_WORKSPACE: $GITHUB_WORKSPACE"
echo "  GITHUB_REPOSITORY: $GITHUB_REPOSITORY"
echo "  GITHUB_ACTOR: $GITHUB_ACTOR"
echo "  INPUT_USER: $INPUT_USER"
echo "  INPUT_FILENAME: $INPUT_FILENAME"
echo "  INPUT_TOKEN: ***PROVIDED***"
echo ""
echo "=========================================="
echo ""

# Run the Docker container
docker run --rm \
    $ENV_VARS \
    -v "$(pwd)/output:/output" \
    metrics-test:local

echo ""
echo "=========================================="
echo "Docker action completed!"
echo ""

# Check if output file was created
if [ -f "output/$INPUT_FILENAME" ]; then
    echo "✓ Output file created: output/$INPUT_FILENAME"
    ls -lh "output/$INPUT_FILENAME"
else
    echo "✗ Output file not found: output/$INPUT_FILENAME"
fi
