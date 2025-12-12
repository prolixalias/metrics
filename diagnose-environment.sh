#!/bin/bash
# Environment Diagnostic Script
# Checks if everything needed for the action is available

echo "=========================================="
echo "Metrics Action Environment Diagnostic"
echo "=========================================="
echo ""

# Check Node.js
echo "✓ Checking Node.js..."
if command -v node &> /dev/null; then
    echo "  Node.js version: $(node --version)"
else
    echo "  ✗ Node.js not found!"
fi

# Check npm
echo "✓ Checking npm..."
if command -v npm &> /dev/null; then
    echo "  npm version: $(npm --version)"
else
    echo "  ✗ npm not found!"
fi

# Check Chrome/Chromium (for Puppeteer)
echo "✓ Checking Chrome/Chromium..."
if command -v google-chrome &> /dev/null; then
    echo "  Chrome: $(google-chrome --version)"
elif command -v chromium &> /dev/null; then
    echo "  Chromium: $(chromium --version)"
elif command -v chromium-browser &> /dev/null; then
    echo "  Chromium: $(chromium-browser --version)"
else
    echo "  ⚠ Chrome/Chromium not found (Puppeteer will download its own)"
fi

# Check Docker
echo "✓ Checking Docker..."
if command -v docker &> /dev/null; then
    echo "  Docker version: $(docker --version)"
    if docker ps &> /dev/null; then
        echo "  Docker daemon: running"
    else
        echo "  ⚠ Docker daemon not running or no permission"
    fi
else
    echo "  ⚠ Docker not found (needed for container testing)"
fi

# Check Git
echo "✓ Checking Git..."
if command -v git &> /dev/null; then
    echo "  Git version: $(git --version)"
else
    echo "  ✗ Git not found!"
fi

# Check dependencies installed
echo "✓ Checking Node modules..."
if [ -d "node_modules" ]; then
    echo "  Node modules: installed"
    if [ -d "node_modules/puppeteer" ]; then
        echo "  Puppeteer: installed"
    else
        echo "  ✗ Puppeteer not found"
    fi
else
    echo "  ✗ Node modules not installed (run npm install)"
fi

# Check Puppeteer cache
echo "✓ Checking Puppeteer cache..."
if [ -d "$HOME/.cache/puppeteer" ]; then
    echo "  Puppeteer cache: $(du -sh $HOME/.cache/puppeteer | cut -f1)"
else
    echo "  ⚠ Puppeteer cache not found"
fi

# Check configuration
echo "✓ Checking configuration..."
if [ -f ".env.test" ]; then
    echo "  .env.test: exists"
    if grep -q "your_github_token_here" .env.test; then
        echo "  ⚠ GitHub token not set in .env.test"
    else
        echo "  GitHub token: configured"
    fi
else
    echo "  ⚠ .env.test not found"
fi

if [ -f "settings.json" ]; then
    echo "  settings.json: exists"
else
    echo "  ⚠ settings.json not found (only needed for web instance)"
fi

# Check required files
echo "✓ Checking required files..."
if [ -f "source/app/action/index.mjs" ]; then
    echo "  Action entry point: exists"
else
    echo "  ✗ Action entry point missing!"
fi

if [ -f "source/app/metrics/index.mjs" ]; then
    echo "  Metrics engine: exists"
else
    echo "  ✗ Metrics engine missing!"
fi

if [ -f "action.yml" ]; then
    echo "  action.yml: exists"
else
    echo "  ⚠ action.yml missing"
fi

if [ -f "Dockerfile" ]; then
    echo "  Dockerfile: exists"
else
    echo "  ⚠ Dockerfile missing"
fi

echo ""
echo "=========================================="
echo "Diagnostic complete!"
echo "=========================================="
