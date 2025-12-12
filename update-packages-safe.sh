#!/bin/bash
# Safe Package Update Script
# Updates packages with security fixes and backward-compatible changes

set -e

echo "=========================================="
echo "Metrics - Safe Package Updates"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}This script will update packages with security fixes${NC}"
echo -e "${YELLOW}All updates are backward-compatible minor/patch versions${NC}"
echo ""
echo "Press Ctrl+C to cancel, or Enter to continue..."
read

# Backup package-lock.json
echo -e "${GREEN}Creating backup of package-lock.json...${NC}"
cp package-lock.json package-lock.json.backup
echo "✓ Backup created: package-lock.json.backup"
echo ""

# Phase 1: Critical Security Updates
echo "=========================================="
echo "Phase 1: Critical Security Updates"
echo "=========================================="
echo ""

echo -e "${RED}Updating axios (CRITICAL - Multiple CVEs)...${NC}"
npm update axios

echo -e "${YELLOW}Updating sanitize-html (Security)...${NC}"
npm update sanitize-html

echo -e "${YELLOW}Updating ejs (Security)...${NC}"
npm update ejs

echo -e "${YELLOW}Updating prismjs (Security)...${NC}"
npm update prismjs

echo ""
echo "✓ Critical security updates complete"
echo ""

# Phase 2: Safe Minor Updates
echo "=========================================="
echo "Phase 2: Safe Minor/Patch Updates"
echo "=========================================="
echo ""

npm update simple-git
npm update open-graph-scraper
npm update linguist-js
npm update xml-formatter
npm update js-yaml
npm update d3
npm update compression
npm update minimatch
npm update @primer/octicons

echo ""
echo "✓ Minor updates complete"
echo ""

# Phase 3: Express Update
echo "=========================================="
echo "Phase 3: Express Security Update"
echo "=========================================="
echo ""

echo -e "${RED}Updating Express (Security fixes)...${NC}"
npm update express
npm update express-rate-limit

echo ""
echo "✓ Express updated"
echo ""

# Phase 4: Fix transitive dependencies
echo "=========================================="
echo "Phase 4: Auto-fix Vulnerabilities"
echo "=========================================="
echo ""

echo "Running npm audit fix (non-breaking)..."
npm audit fix

echo ""
echo "✓ Audit fix complete"
echo ""

# Summary
echo "=========================================="
echo "Update Summary"
echo "=========================================="
echo ""

echo "Checking for remaining vulnerabilities..."
npm audit --json > /tmp/audit-result.json 2>/dev/null || true

CRITICAL=$(jq -r '.metadata.vulnerabilities.critical // 0' /tmp/audit-result.json)
HIGH=$(jq -r '.metadata.vulnerabilities.high // 0' /tmp/audit-result.json)
MODERATE=$(jq -r '.metadata.vulnerabilities.moderate // 0' /tmp/audit-result.json)
LOW=$(jq -r '.metadata.vulnerabilities.low // 0' /tmp/audit-result.json)

echo ""
echo "Remaining vulnerabilities:"
echo "  Critical: $CRITICAL"
echo "  High: $HIGH"
echo "  Moderate: $MODERATE"
echo "  Low: $LOW"
echo ""

if [ "$CRITICAL" -eq 0 ] && [ "$HIGH" -eq 0 ]; then
    echo -e "${GREEN}✓ No critical or high vulnerabilities remaining!${NC}"
else
    echo -e "${YELLOW}⚠ Some high/critical vulnerabilities remain${NC}"
    echo "  These may require major version updates or are false positives"
    echo "  Review PACKAGE-UPDATE-ANALYSIS.md for details"
fi

echo ""
echo "=========================================="
echo "Next Steps"
echo "=========================================="
echo ""
echo "1. Run tests: npm test"
echo "2. Run linter: npm run linter"
echo "3. Build: npm run build"
echo "4. Test locally: ./run-action-local.sh"
echo "5. Test Docker: docker build -t metrics-test ."
echo ""
echo "If tests pass, commit the changes:"
echo "  git add package.json package-lock.json"
echo "  git commit -m 'chore: update dependencies for security fixes'"
echo ""
echo "If tests fail, restore backup:"
echo "  mv package-lock.json.backup package-lock.json"
echo "  npm install"
echo ""
echo -e "${GREEN}Update complete!${NC}"
