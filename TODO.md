# Package Update TODO List

**Created**: 2025-12-12
**Status**: Ready to begin
**Estimated Total Time**: 1-2 hours for Phase 1-2

---

## Phase 1: Immediate Security Fixes (TODAY - ~30 minutes)

### Critical Security Updates
- [ ] Run `./update-packages-safe.sh` script
- [ ] Verify script completed without errors
- [ ] Review update summary output

### Testing
- [ ] Run `npm test` - Verify all tests pass
- [ ] Run `npm run linter` - Verify no new lint errors
- [ ] Run `npm run build` - Verify build succeeds
- [ ] Check for new vulnerabilities: `npm audit | grep -E "critical|high"`

### Local Validation
- [ ] Test action locally: `./run-action-local.sh`
- [ ] Verify SVG generation works
- [ ] Check Puppeteer/Chromium rendering
- [ ] Verify GitHub API calls succeed

### Docker Validation
- [ ] Build Docker image: `docker build -t metrics-test .`
- [ ] Verify build completes without errors
- [ ] Test Docker container with real execution
- [ ] Verify output quality

### Commit Changes
- [ ] Review changes: `git diff package.json`
- [ ] Add files: `git add package.json package-lock.json`
- [ ] Commit: `git commit -m "chore: security updates for dependencies"`
- [ ] Optionally push to test branch first

---

## Phase 2: This Week Testing (1-2 hours)

### Thorough Testing
- [ ] Run full test suite multiple times
- [ ] Test all major plugins (languages, activity, stars, etc.)
- [ ] Test different templates (classic, repository, terminal)
- [ ] Test web server functionality: `npm start`
- [ ] Verify web UI loads correctly
- [ ] Test embed functionality

### GitHub Actions Testing
- [ ] Create test workflow in fork
- [ ] Run action in actual GitHub Actions environment
- [ ] Verify Docker image builds in GH Actions
- [ ] Check action output quality
- [ ] Monitor for any runtime errors

### Documentation
- [ ] Document any issues found
- [ ] Note any behavioral changes
- [ ] Update TODO.md with results

### Review Remaining Vulnerabilities
- [ ] Run `npm audit` and review report
- [ ] Document remaining critical/high vulnerabilities
- [ ] Determine if they're false positives or real issues
- [ ] Plan remediation for remaining issues

---

## Phase 3: Next Month - Major Updates (4-8 hours)

### Research & Planning
- [ ] Review Puppeteer 21 → 24 changelog
- [ ] Review Marked 7 → 17 migration guide
- [ ] Review @octokit/graphql breaking changes
- [ ] Review @octokit/rest breaking changes
- [ ] Create test plan for each major update

### Puppeteer Update (21 → 24)
- [ ] Read breaking changes documentation
- [ ] Create feature branch: `git checkout -b update/puppeteer-24`
- [ ] Update: `npm install puppeteer@^24.33.0`
- [ ] Test SVG rendering
- [ ] Test PNG export
- [ ] Verify browser launch options still work
- [ ] Run full test suite
- [ ] Update documentation if needed
- [ ] Create PR if tests pass

### Marked Update (7 → 17)
- [ ] Review 10 major versions of changelogs
- [ ] Identify breaking changes
- [ ] Create feature branch: `git checkout -b update/marked-17`
- [ ] Update: `npm install marked@^17.0.1`
- [ ] Test markdown rendering
- [ ] Test markdown template
- [ ] Verify sanitization still works
- [ ] Run full test suite
- [ ] Create PR if tests pass

### Octokit Updates
- [ ] Test @octokit/graphql API compatibility
- [ ] Update: `npm install @octokit/graphql@^9.0.3`
- [ ] Test all GraphQL queries
- [ ] Update @octokit/rest: `npm install @octokit/rest@^22.0.1`
- [ ] Test all REST API calls
- [ ] Verify rate limiting still works
- [ ] Run full test suite
- [ ] Create PR if tests pass

### GitHub Actions SDK Updates
- [ ] Review @actions/core v2 changes
- [ ] Update: `npm install @actions/core@^2.0.1`
- [ ] Update: `npm install @actions/github@^6.0.1`
- [ ] Test action execution
- [ ] Verify inputs/outputs work
- [ ] Test annotations and logging
- [ ] Create PR if tests pass

---

## Phase 4: Future Considerations (Plan & Schedule)

### Express 5 Migration (Optional)
- [ ] Research Express 4 → 5 breaking changes
- [ ] Evaluate benefits vs. effort
- [ ] Decide: Stay on v4 or migrate to v5
- [ ] If migrating: Create migration plan
- [ ] Schedule migration work

### ESLint 9 Migration (Dev-Only)
- [ ] Research flat config migration
- [ ] Review @eslint/migrate tool
- [ ] Test flat config locally
- [ ] Migrate when convenient
- [ ] Update CI/CD workflows

### Jest 30 Migration
- [ ] Review Jest 29 → 30 breaking changes
- [ ] Test Jest 30 compatibility
- [ ] Update if no issues found
- [ ] Update test configurations if needed

### Vue 3 Migration (Low Priority)
- [ ] Evaluate Vue 3 benefits for web UI
- [ ] Estimate migration effort (likely significant)
- [ ] Decide if worth the effort (web UI is secondary)
- [ ] If yes: Create detailed migration plan
- [ ] Schedule migration work

---

## Automation & Process Improvements

### Dependency Management Automation
- [ ] Research Dependabot setup
- [ ] Configure Dependabot for security updates
- [ ] Set up auto-merge for patch updates
- [ ] Configure Renovate Bot (optional, more flexible)
- [ ] Set up weekly dependency review schedule

### CI/CD Improvements
- [ ] Add `npm audit` to CI pipeline
- [ ] Configure to fail on critical/high vulnerabilities
- [ ] Add automated dependency update tests
- [ ] Set up nightly builds with latest deps
- [ ] Configure security scanning (CodeQL)

### Documentation
- [ ] Document dependency update policy
- [ ] Create SLA for security updates
- [ ] Document testing procedures
- [ ] Create runbook for major migrations
- [ ] Update CLAUDE.md with update procedures

---

## Completed Tasks

### ✅ Initial Analysis
- [x] Audit current dependencies
- [x] Identify security vulnerabilities
- [x] Categorize updates by risk
- [x] Create update analysis document
- [x] Create safe update script

### ✅ Environment Setup
- [x] Verify Node.js version
- [x] Check Docker base image
- [x] Review code quality
- [x] Create testing scripts

---

## Notes & Issues

### Blockers
- None currently

### Decisions Needed
- None currently - ready to proceed with Phase 1

### Risks
- Low risk for Phase 1 (all backward-compatible updates)
- Medium risk for Phase 3 (major version updates)
- Test coverage should catch any issues

---

## Quick Reference Commands

```bash
# Run safe updates
./update-packages-safe.sh

# Test everything
npm test && npm run linter && npm run build

# Test action locally
./run-action-local.sh

# Test Docker
docker build -t metrics-test .

# Check vulnerabilities
npm audit

# Restore backup if needed
mv package-lock.json.backup package-lock.json && npm install
```

---

**Legend:**
- [ ] Not started
- [x] Completed
- ~~[x] Completed and verified~~

**Priority Levels:**
- 🔴 Critical - Do immediately
- 🟠 High - Do this week
- 🟡 Medium - Do this month
- 🔵 Low - Do when convenient
