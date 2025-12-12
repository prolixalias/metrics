# GitHub Action Debugging Summary

## Problem Statement
The metrics GitHub Action was failing in GitHub's container environment with a Puppeteer Chrome launch error.

## Root Cause Analysis

### Issue Identified
The action failed with the following error:
```
Failed to launch the browser process!
/home/ptalbot/.cache/puppeteer/chrome/linux-116.0.5845.96/chrome-linux64/chrome: 3: Syntax error: ")" unexpected
```

### Root Cause
The Puppeteer package downloads its own Chrome binary during `npm install`. This binary (Chrome 116) was:
1. Being corrupted or incompatible with certain Linux environments
2. Being interpreted as a shell script instead of an executable binary
3. Failing to launch in both local and Docker environments

### Why It Happened
In the original `Dockerfile`, the environment variables to prevent Puppeteer from downloading Chrome were set **AFTER** `npm ci` ran:

```dockerfile
# Original (BROKEN)
RUN npm ci  # Puppeteer downloads Chrome here
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true  # Too late!
ENV PUPPETEER_BROWSER_PATH "google-chrome-stable"  # Too late!
```

This meant Puppeteer still downloaded its own Chrome, which was then used instead of the system-installed `google-chrome-stable`.

## Solution Implemented

### Fix 1: Reorder Environment Variables (Primary Fix)
Move the Puppeteer environment variables **BEFORE** npm install:

```dockerfile
# Fixed
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_BROWSER_PATH=/usr/bin/google-chrome-stable
RUN npm ci  # Now Puppeteer skips Chrome download
```

### Fix 2: Modernize Chrome Repository Setup (Secondary Fix)
The deprecated `apt-key` method was causing Chrome installation failures. Updated to use modern keyring method:

```dockerfile
# Old (deprecated)
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list

# New (modern)
wget -q -O /tmp/linux_signing_key.pub https://dl-ssl.google.com/linux/linux_signing_key.pub
gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg /tmp/linux_signing_key.pub
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list
```

## Testing Methodology

### Local Testing Setup
Created testing scripts to simulate GitHub Actions environment:

1. **run-action-local.sh** - Runs the action locally with environment variables from Doppler
2. **diagnose-environment.sh** - Checks system requirements
3. **test-action-docker.sh** - Tests in Docker container

### Test Results

#### Before Fix (Local):
```
✗ Failed to launch the browser process!
/home/ptalbot/.cache/puppeteer/chrome/linux-116.0.5845.96/chrome-linux64/chrome: 3: Syntax error: ")" unexpected
```

#### After Fix (Local):
```
✓ metrics/svg/resize > started Chrome/143.0.7499.40
✓ metrics/svg/resize > rendering complete
✓ Status: complete
✓ Success, thanks for using metrics!
```

## Files Changed

### Modified Files:
- `Dockerfile` - Fixed Puppeteer environment variables order and Chrome repository setup

### Created Files:
- `run-action-local.sh` - Local testing script with Doppler integration
- `diagnose-environment.sh` - Environment diagnostic tool
- `test-action-docker.sh` - Docker testing script
- `DEBUGGING-SUMMARY.md` - This document

## How to Test

### Local Testing:
```bash
# Test locally (fastest)
doppler run -- bash -c 'export INPUT_TOKEN=$GITHUB_PAT_TOKEN_LOCALDEV && export INPUT_USER=prolixalias && ./run-action-local.sh'
```

### Docker Testing:
```bash
# Build and test in Docker (matches GitHub Actions environment)
docker build -t metrics-test:fixed .
docker run --rm \
  -e INPUT_TOKEN=$GITHUB_PAT_TOKEN_LOCALDEV \
  -e INPUT_USER=prolixalias \
  -e INPUT_DRYRUN=true \
  metrics-test:fixed
```

## Key Learnings

1. **Environment Variable Order Matters**: In Dockerfiles, set environment variables BEFORE they're needed
2. **Puppeteer Chrome Issues**: Common problem in containers; always prefer system-installed Chrome
3. **Local Testing is Essential**: Reproducing GitHub Actions environment locally saves debugging time
4. **Deprecated apt-key**: Modern Debian/Ubuntu require keyring method for third-party repos

## Next Steps

1. ✅ Verify Docker build completes successfully
2. ⏳ Test Docker container with real action execution
3. ⏳ Commit changes to repository
4. ⏳ Test in actual GitHub Actions workflow

## References

- [Puppeteer Troubleshooting in Docker](https://github.com/puppeteer/puppeteer/blob/master/docs/troubleshooting.md#running-puppeteer-in-docker)
- [Debian apt-key Deprecation](https://wiki.debian.org/DebianRepository/UseThirdParty)
- [GitHub Actions Runner Images](https://github.com/actions/runner-images)
