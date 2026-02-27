# Troubleshooting Guide

Common issues and solutions for the agent-team-playground development workflow.

---

## Node.js & pnpm Issues

### Problem: "pnpm: command not found"

**Symptoms**:
```
$ pnpm install
pnpm: command not found
```

**Root Cause**:
- Node.js not switched to version 22 LTS
- corepack not enabled
- pnpm not installed via corepack

**Solution**:

```bash
# Step 1: Switch to Node.js 22 LTS
nvm use
node --version  # Should show v22.10.0+

# Step 2: Enable corepack
corepack enable

# Step 3: Install pnpm via corepack
corepack install -g pnpm

# Step 4: Verify
pnpm --version  # Should show 9.0.0+
```

### Problem: "Node version mismatch - expected 22.x, got 20.x"

**Symptoms**:
```
$ node --version
v20.10.0
$ nvm use
Now using node v22.10.0 (default)
```

**Root Cause**:
- `.nvmrc` or `.node-version` not recognized
- nvm not installed
- Wrong terminal shell

**Solution**:

```bash
# Verify .nvmrc and .node-version exist and match
cat .nvmrc      # Should show 22.10.0
cat .node-version  # Should show 22.10.0

# If files don't exist, create them
echo "22.10.0" > .nvmrc
echo "22.10.0" > .node-version

# Install Node.js 22 if not already installed
nvm install 22.10.0

# Switch to it
nvm use

# Verify
node --version  # v22.10.0
```

### Problem: "pnpm version mismatch - expected 9.x, got 8.x"

**Symptoms**:
```
$ pnpm --version
8.15.0
$ pnpm install
warn: Using pnpm v8 with Node.js 22 may cause compatibility issues
```

**Root Cause**:
- Old pnpm installed globally
- corepack not managing pnpm correctly
- package.json `packageManager` field not honored

**Solution**:

```bash
# Step 1: Uninstall old pnpm
npm uninstall -g pnpm

# Step 2: Enable corepack and use it to install pnpm
corepack enable
corepack install -g pnpm

# Step 3: Verify
pnpm --version  # Should show 9.0.0+

# Step 4: If still wrong version, check package.json
cat frontend/package.json | jq '.packageManager'
# Should output: "pnpm@9.0.0"

# If wrong, update it
jq '.packageManager = "pnpm@9.0.0"' frontend/package.json > /tmp/pkg.json
mv /tmp/pkg.json frontend/package.json
```

---

## Pre-commit & Linting Issues

### Problem: "Pre-commit hooks too slow (10+ seconds)"

**Symptoms**:
```
$ time pre-commit run --all-files
pre-commit run --all-files  15.24s user 3.42s system 87% cpu 21.356 total
```

**Root Cause**:
- lint-staged configured incorrectly (checking all files instead of changed)
- Too many hooks running unnecessarily
- Ruff checking files it shouldn't

**Solution**:

```bash
# Step 1: Check lint-staged configuration
cat frontend/package.json | jq '.["lint-staged"]'

# Should show:
# {
#   "src/**/*.{js,jsx,ts,tsx}": [...]  # Only changed files
# }
# NOT:
# "*.{js,jsx,ts,tsx}"  # This checks ALL files

# Step 2: Verify it's using local hook
cat .pre-commit-config.yaml | grep -A 3 "id: lint-staged"
# Should show: language: system

# Step 3: Run with timing
time pre-commit run --all-files

# Performance targets:
# - With lint-staged: 0.5-1 second
# - Without lint-staged: 5-10 seconds (checking all files)
```

### Problem: "Ruff formatting differs from team"

**Symptoms**:
```
$ uv run ruff check backend/
Would reformat: backend/main.py
$ uv run ruff format .
# Formatting changes everything
$ git diff shows massive changes
```

**Root Cause**:
- Ruff configuration differs between developers
- Different Ruff versions
- Different Python versions

**Solution**:

```bash
# Step 1: Check Ruff configuration in pyproject.toml
cat backend/pyproject.toml | grep -A 10 "\[tool.ruff\]"

# Should show consistent settings:
# [tool.ruff]
# line-length = 100
# target-version = "py310"
# select = ["E", "W", "F", "I", "C", "B", "UP", "ARG", "C90", "ICN", "PIE", "T201", "PT"]

# Step 2: Verify Ruff version
uv run ruff --version

# Step 3: Apply formatting consistently
uv run ruff check --fix backend/
uv run ruff format backend/

# Step 4: Run pre-commit to ensure consistency
pre-commit run --all-files

# Step 5: Verify no differences
git status  # Should show minimal changes

# Step 6: If still issues, check Python version
python --version  # Should be 3.10+
```

### Problem: "Biome formatting differs from ESLint"

**Symptoms**:
```
$ pnpm run lint
 Biome found 3 issues in src/components/Button.tsx
$ uv run ruff check backend/
Would reformat: backend/main.py
```

**Root Cause**:
- ESLint and Prettier still configured (conflicting with Biome)
- Biome rules not matching team standards
- Different Biome versions

**Solution**:

```bash
# Step 1: Verify Biome is installed, not ESLint
cd frontend
cat package.json | jq '.devDependencies | keys[]' | grep -E "biome|eslint|prettier"
# Should show: "biome"
# Should NOT show: "eslint", "prettier"

# Step 2: Check Biome is configured in package.json
cat package.json | jq '.["lint"]'
# Should run: biome check --apply

# Step 3: Apply Biome formatting
pnpm run lint  # Auto-fixes most issues

# Step 4: Verify with pre-commit
pre-commit run --all-files

# Step 5: If still issues, check biome.json
ls -la biome.json  # Should NOT exist (use package.json only)
```

### Problem: "detect-secrets found API key (false positive)"

**Symptoms**:
```
$ pre-commit run --all-files
...
detect-secrets...................................................Failed
- hook id: detect-secrets
  exit code: 1

Detected: type: API Token, language: Generic
```

**Root Cause**:
- Legitimate test API key detected as real secret
- Documentation contains example keys
- Configuration value looks like a secret

**Solution**:

```bash
# Step 1: Review the detected secret
cat <file-with-secret> | grep -n "<detected-text>"

# Step 2: If it's a false positive, add to baseline
detect-secrets scan --baseline .secrets.baseline

# Step 3: Verify baseline created
ls -la .secrets.baseline

# Step 4: Commit baseline
git add .secrets.baseline
git commit -m "chore: update secrets baseline with false positives"

# Step 5: Re-run pre-commit
pre-commit run --all-files
```

---

## Python & Backend Issues

### Problem: "uv sync fails with dependency conflict"

**Symptoms**:
```
$ uv sync
error: Dependency conflict: fastapi 0.100.0 requires starlette >=0.27.0, but you have starlette 0.26.0
```

**Root Cause**:
- pyproject.toml has conflicting versions
- Dependencies have incompatible constraints
- Python version incompatibility

**Solution**:

```bash
# Step 1: Review the conflict in pyproject.toml
cat backend/pyproject.toml | grep -A 10 "^\[project.dependencies\]"

# Step 2: Check dependency compatibility
# For example: fastapi 0.100+ requires starlette >=0.27

# Step 3: Update conflicting dependency
# Option 1: Update the main dependency
# In pyproject.toml: fastapi = "^0.109.0" (which requires starlette >=0.27)

# Option 2: Remove conflicting transitive dependency (not recommended)

# Step 4: Sync again
uv sync

# Step 5: Verify installation
python -c "import fastapi; import starlette; print('OK')"
```

### Problem: "pytest discovery finds no tests"

**Symptoms**:
```
$ uv run pytest
collected 0 items in 0.00s
```

**Root Cause**:
- Test files not in testpaths
- Test files don't match test_*.py pattern
- pytest configuration in pyproject.toml incorrect

**Solution**:

```bash
# Step 1: Check pytest configuration
cat backend/pyproject.toml | grep -A 5 "\[tool.pytest"

# Should show:
# [tool.pytest.ini_options]
# testpaths = ["tests"]

# Step 2: Verify test directory exists
ls -la tests/  # Should show test files

# Step 3: Check test file naming
ls tests/  # Files should be: test_*.py

# Step 4: Run pytest with discovery logging
uv run pytest --collect-only

# Step 5: If still issues, run with verbose
uv run pytest -vv --tb=short
```

### Problem: "Ruff ignores in pyproject.toml not working"

**Symptoms**:
```
$ uv run ruff check backend/
backend/main.py:10:1: F841 Local variable `unused` is assigned to but never used
```

**Root Cause**:
- Ignore rules in wrong section
- Ruff configuration incomplete
- Version mismatch

**Solution**:

```bash
# Step 1: Check Ruff configuration location
cat backend/pyproject.toml | grep -A 15 "\[tool.ruff\]"

# Should show complete config:
# [tool.ruff]
# line-length = 100
# select = ["E", "W", "F", "I", "C", "B", "UP", "ARG", "C90", "ICN", "PIE", "T201", "PT"]
# ignore = ["E501"]  # Ignore line-too-long (handled by formatter)

# Step 2: Add ignore rules as needed
# E501 - line-too-long (use formatter instead)
# F401 - unused imports (handled by isort)

# Step 3: Test ignore
uv run ruff check --ignore F841 backend/main.py

# Step 4: If working, add to [tool.ruff] section
# ignore = ["E501", "F841"]

# Step 5: Verify
uv run ruff check backend/
```

---

## Node.js & Frontend Issues

### Problem: "pnpm install --frozen-lockfile fails"

**Symptoms**:
```
$ pnpm install --frozen-lockfile
ERR! pnpm-lock.yaml is out of sync with package.json
```

**Root Cause**:
- package.json changed but lock file not updated
- Someone manually edited package.json
- Merge conflict in lock file

**Solution**:

```bash
# Step 1: Check what changed
git diff package.json

# Step 2: If you made changes, update lock file
pnpm install  # Updates pnpm-lock.yaml

# Step 3: Commit both files
git add package.json pnpm-lock.yaml
git commit -m "deps: update dependencies"

# Step 4: If merge conflict in pnpm-lock.yaml
git checkout --ours pnpm-lock.yaml  # Keep your version
pnpm install  # Regenerate lock file
git add pnpm-lock.yaml

# Step 5: Verify
pnpm install --frozen-lockfile
```

### Problem: "Vitest tests fail randomly (flaky)"

**Symptoms**:
```
$ pnpm test:vitest
 ✓ src/components/Button.test.tsx (1)
 ✗ src/hooks/useUser.test.ts (1)
   └─ Test timeout after 10000ms

$ pnpm test:vitest  # Run again
 ✓ src/components/Button.test.tsx (1)
 ✓ src/hooks/useUser.test.ts (1)  # Passes now
```

**Root Cause**:
- Async operations not awaited
- Timing issues in tests
- Unclean test state between tests

**Solution**:

```bash
# Step 1: Run tests with verbose output
pnpm test:vitest --reporter=verbose

# Step 2: Check for async issues
grep -r "async.*await" src/**/*.test.ts

# Step 3: Common fixes:

# Fix 1: Add await to async functions
// Before
test('loads user', () => {
  const user = fetchUser();  // Not awaited
})

// After
test('loads user', async () => {
  const user = await fetchUser();
})

# Fix 2: Increase timeout for slow operations
test('loads data', async () => {
  const data = await slowFetch();
  expect(data).toBeDefined();
}, 20000);  // 20 second timeout

# Fix 3: Clean up after tests
afterEach(() => {
  jest.clearAllMocks();
  cleanup();  // React Testing Library cleanup
});

# Step 4: Rerun tests
pnpm test:vitest
```

### Problem: "Playwright test timeout"

**Symptoms**:
```
$ pnpm exec playwright test
Error: Timeout 30000ms exceeded while waiting for event "load"
```

**Root Cause**:
- Page load taking too long
- Navigation not happening
- Network issues in CI
- Page selector not found

**Solution**:

```bash
# Step 1: Run test in headed mode (see what's happening)
pnpm exec playwright test --headed

# Step 2: Debug specific test
pnpm exec playwright test --debug tests/e2e/login.spec.ts

# Step 3: Check for common issues in test:

# Issue 1: Page not loading
await page.goto('/login');  // Missing await

// Fix
await page.goto('/login', { waitUntil: 'networkidle' });

# Issue 2: Element not found
await page.click('#button');  // Selector wrong

// Fix
await page.click('button:has-text("Submit")');

# Issue 3: Navigation not happening
await page.click('a[href="/next"]');  // Missing waitForNavigation

// Fix
await Promise.all([
  page.waitForNavigation(),
  page.click('a[href="/next"]')
]);

# Step 4: Increase timeout if needed
test.describe('Login', () => {
  test.setTimeout(60000);  // 60 second timeout
  test('user login flow', async ({ page }) => {
    // ...
  });
});

# Step 5: Run tests again
pnpm exec playwright test
```

---

## Git & GitHub Issues

### Problem: "Merge conflict in pnpm-lock.yaml"

**Symptoms**:
```
$ git merge feature-branch
Auto-merging pnpm-lock.yaml
CONFLICT (content): Merge conflict in pnpm-lock.yaml
```

**Root Cause**:
- Both branches modified dependencies
- Lock file not regenerated after merge

**Solution**:

```bash
# Step 1: Resolve by regenerating lock file
pnpm install

# Step 2: Stage the updated lock file
git add pnpm-lock.yaml

# Step 3: Complete merge
git commit -m "merge: resolve pnpm-lock.yaml conflict

Both branches modified dependencies. Regenerated lock file
with pnpm install to ensure consistency.

[agent-action]
Co-Authored-By: Full Stack Engineer <agent@playground.local>"

# Step 4: Push
git push
```

### Problem: "Pre-commit hook fails during git push"

**Symptoms**:
```
$ git push
Running: Ruff check...
ERR! Backend has linting errors

husky - commit hook failed (code 1)
```

**Root Cause**:
- Pre-commit hooks not installed locally
- Configuration mismatch between developers
- Changes don't pass linting

**Solution**:

```bash
# Step 1: Install pre-commit hooks (first time)
pre-commit install

# Step 2: Run locally before pushing
pre-commit run --all-files

# Step 3: Fix any issues
uv run ruff check --fix backend/
pnpm run lint

# Step 4: Re-run pre-commit
pre-commit run --all-files

# Step 5: Commit fixes
git add .
git commit -m "fix: resolve pre-commit hook issues"

# Step 6: Now push
git push
```

---

## Getting Help

If you encounter an issue not listed here:

1. **Check the documentation**:
   - `CLAUDE.md` - Project overview
   - `README.md` - Setup instructions
   - `.claude/agents/team.md` - Agent responsibilities

2. **Search similar issues**:
   - GitHub Issues: `gh issue list --label bug`
   - Previous troubleshooting: This file

3. **Debug systematically**:
   - Run command with `-v` or `--verbose` flag
   - Check `node --version`, `pnpm --version`, `python --version`
   - Verify configuration files are correct
   - Check error messages for root cause

4. **Ask for help**:
   - Post in GitHub Issue with error output
   - Tag relevant agent: `@Full Stack Engineer`, `@QA Engineer`, `@DevOps`
   - Include: what command failed, expected behavior, actual behavior

5. **Document the solution**:
   - If you solve a new issue, update this file
   - Create commit with fix: `chore: document troubleshooting for X`

