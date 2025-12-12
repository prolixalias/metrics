# Package Update Analysis

**Generated**: 2025-12-12
**Current Version**: 3.35.0-beta
**Node Version**: 20.19.6 (in Docker: node:20-bookworm-slim)

## Executive Summary

**Total Vulnerabilities**: 46 unique packages with issues
- 🔴 **Critical**: 4
- 🟠 **High**: 17
- 🟡 **Moderate**: 18
- 🔵 **Low**: 7

**Outdated Packages**: 40+ packages have updates available

## Critical Security Issues

### 1. @babel/traverse (CRITICAL)
- **Current**: Transitive dependency
- **Issue**: Arbitrary code execution vulnerability
- **CVE**: GHSA-67hx-6x53-jw92
- **Fix**: `npm audit fix`
- **Impact**: Low (build-time only, not runtime)

### 2. crypto-js (CRITICAL)
- **Issue**: Multiple critical vulnerabilities
- **Fix**: Update to latest version
- **Impact**: Medium if used for cryptographic operations

### 3. axios (HIGH - Multiple CVEs)
- **Current**: 1.5.0
- **Latest**: 1.13.2
- **Issues**:
  - CSRF vulnerabilities (GHSA-wf5p-g6vw-rhxx)
  - SSRF vulnerabilities (GHSA-8hc4-vh64-cxmj, GHSA-jr5f-v2jv-69x6)
  - DoS vulnerabilities (GHSA-4hjh-wcwx-xvwj)
- **Fix**: `npm update axios` (safe minor update)
- **Impact**: **HIGH** - Used for external API calls

### 4. express (HIGH)
- **Current**: 4.18.2
- **Latest**: 5.2.1 (major), 4.22.1 (minor)
- **Issues**:
  - body-parser DoS (GHSA-qwcr-r2fm-qrc7)
  - cookie vulnerabilities
  - path-to-regexp issues
- **Fix**: Update to 4.22.1 (safe), or migrate to Express 5 (breaking)
- **Impact**: **HIGH** - Core web server

## Major Package Updates Available

### Breaking Changes Required

| Package | Current | Latest | Breaking? | Notes |
|---------|---------|--------|-----------|-------|
| **@actions/core** | 1.10.1 | 2.0.1 | ⚠️ Yes | Major version bump |
| **@actions/github** | 5.1.1 | 6.0.1 | ⚠️ Yes | Major version bump |
| **@octokit/graphql** | 7.0.1 | 9.0.3 | ⚠️ Yes | 2 major versions behind |
| **@octokit/rest** | 20.0.1 | 22.0.1 | ⚠️ Yes | 2 major versions behind |
| **eslint** | 8.49.0 | 9.39.1 | ⚠️ Yes | Major ESLint v9 (flat config) |
| **express** | 4.18.2 | 5.2.1 | ⚠️ Yes | Express 5 (can stay on 4.x) |
| **jest** | 29.7.0 | 30.2.0 | ⚠️ Yes | Jest 30 |
| **jsdom** | 22.1.0 | 27.3.0 | ⚠️ Yes | 5 major versions |
| **marked** | 7.0.5 | 17.0.1 | ⚠️ Yes | 10 major versions! |
| **puppeteer** | 21.2.1 | 24.33.0 | ⚠️ Maybe | 3 major versions |
| **purgecss** | 5.0.0 | 7.0.2 | ⚠️ Yes | 2 major versions |
| **svgo** | 3.0.2 | 4.0.0 | ⚠️ Yes | Major version |
| **vue** | 2.7.14 | 3.5.25 | ⚠️ Yes | Vue 3 (major rewrite) |

### Safe Minor/Patch Updates (Recommended)

| Package | Current | Latest | Security? | Priority |
|---------|---------|--------|-----------|----------|
| **axios** | 1.5.0 | 1.13.2 | 🔴 YES | **CRITICAL** |
| **sanitize-html** | 2.11.0 | 2.17.0 | 🟠 Likely | **HIGH** |
| **ejs** | 3.1.9 | 3.1.10 | 🟡 Yes | **MEDIUM** |
| **prismjs** | 1.29.0 | 1.30.0 | 🟡 Maybe | MEDIUM |
| **simple-git** | 3.19.1 | 3.30.0 | - | MEDIUM |
| **open-graph-scraper** | 6.2.2 | 6.11.0 | - | MEDIUM |
| **linguist-js** | 2.6.1 | 2.9.2 | - | MEDIUM |
| **xml-formatter** | 3.5.0 | 3.6.7 | - | LOW |
| **js-yaml** | 4.1.0 | 4.1.1 | - | LOW |
| **d3** | 7.8.5 | 7.9.0 | - | LOW |
| **compression** | 1.7.4 | 1.8.1 | 🔵 Low | LOW |

## Recommended Update Strategy

### Phase 1: Immediate Security Fixes (Do First)

```bash
# Fix critical security issues with safe updates
npm update axios@^1.13.2
npm update sanitize-html@^2.17.0
npm update ejs@^3.1.10
npm update prismjs@^1.30.0
npm update simple-git@^3.30.0
npm update open-graph-scraper@^6.11.0
npm update linguist-js@^2.9.2
npm update xml-formatter@^3.6.7
npm update js-yaml@^4.1.1
npm update d3@^7.9.0
npm update compression@^1.8.1
npm update minimatch@^9.0.5

# Fix babel vulnerabilities (transitive)
npm audit fix
```

**Risk**: LOW - These are all backward-compatible updates
**Testing**: Run `npm test` after updates

### Phase 2: Express Security Update (High Priority)

```bash
# Update Express to latest v4.x (stays on v4)
npm update express@^4.22.1
npm update express-rate-limit@^7.5.1
```

**Risk**: LOW - v4.22.1 is backward compatible with 4.18.2
**Testing**: Test web server functionality

### Phase 3: GitHub Actions SDK Updates (Medium Priority)

```bash
# Update to latest within major version first
npm update @actions/core@^1.11.1
npm update @primer/octicons@^19.21.1
```

Then consider major version updates:
```bash
# These require testing but likely safe
npm install @actions/core@^2.0.1
npm install @actions/github@^6.0.1
```

**Risk**: MEDIUM - May have API changes
**Testing**: Test GitHub Action execution locally first

### Phase 4: Octokit Updates (Medium Risk)

The Octokit packages have security fixes but require coordination:

```bash
# Update incrementally
npm update @octokit/graphql@^7.1.1  # Stay on v7 first
npm update @octokit/rest@^20.1.2    # Stay on v20 first
```

Then test and upgrade to latest:
```bash
npm install @octokit/graphql@^9.0.3
npm install @octokit/rest@^22.0.1
```

**Risk**: MEDIUM-HIGH - API changes possible
**Testing**: Test all GitHub API interactions

### Phase 5: Major Updates (Plan Carefully)

These require significant testing and possibly code changes:

#### Puppeteer (21 → 24)
```bash
npm install puppeteer@^24.33.0
```
**Changes**: Check Puppeteer changelog for breaking changes
**Testing**: Test all SVG rendering functionality

#### Marked (7 → 17)
```bash
npm install marked@^17.0.1
```
**Changes**: 10 major versions - review migration guide
**Testing**: Test all markdown rendering

#### ESLint (8 → 9)
```bash
npm install eslint@^9.39.1
```
**Changes**: Requires flat config migration
**Impact**: Development only, not runtime

#### Vue.js (2 → 3)
```bash
npm install vue@^3.5.25
```
**Changes**: Complete rewrite, major API changes
**Impact**: Only affects web UI, not core metrics

## Docker Base Image

**Current**: `node:20-bookworm-slim` (Node 20.19.6)
**Status**: ✅ Up to date
**Action**: No change needed - already on latest LTS

## Files That Need Updating

If you proceed with updates, these files will change:

1. **package.json** - Version constraints
2. **package-lock.json** - Locked versions (auto-generated)
3. **Possibly source files** - If APIs changed

## Testing Checklist After Updates

- [ ] `npm test` - All tests pass
- [ ] `npm run linter` - No new lint errors
- [ ] `npm run build` - Build succeeds
- [ ] Test GitHub Action locally with `./run-action-local.sh`
- [ ] Test Docker build: `docker build -t metrics-test .`
- [ ] Test web server: `npm start` and verify UI
- [ ] Test key plugins (languages, activity, etc.)
- [ ] Check rendered SVG output quality

## Recommendation Priority

### Do Immediately:
1. ✅ Update axios (CRITICAL security)
2. ✅ Update sanitize-html (security)
3. ✅ Update ejs (security)
4. ✅ Run `npm audit fix` for transitive deps

### Do Soon (This Week):
1. Update Express to 4.22.1
2. Update minor versions (simple-git, linguist-js, etc.)
3. Test thoroughly

### Plan For Later:
1. Research Puppeteer 24 migration
2. Research Marked 17 migration
3. Consider ESLint 9 migration (dev-only)
4. Evaluate Vue 3 migration (low priority, web UI only)

### Skip/Defer:
- Vue 2 → 3 migration (major effort, web UI only)
- jsdom major version (test compatibility first)
- @octokit major versions (test API compatibility)

## Automation Suggestions

Consider setting up:
1. **Dependabot** - Automated dependency PRs
2. **Weekly npm audit** - Scheduled security scans
3. **Renovate Bot** - More configurable than Dependabot

## Notes

- Many vulnerabilities are in **transitive dependencies** (dependencies of dependencies)
- Some vulnerabilities may not apply to this use case (e.g., SSRF if not using affected features)
- The metrics project is primarily used for generating static images, reducing exposure to many web vulnerabilities
- Docker container isolation provides additional security layer
