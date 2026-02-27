# Agent Roles & Responsibilities

Specific responsibilities and workflows for each agent role in the agent team.

---

## Full Stack Engineer

**Tooling**: Claude Code + Ruff + Biome + Node.js 22 LTS + corepack

### Core Responsibilities

1. **Implement FastAPI Backend**
   - Create endpoints with MCP documentation
   - Use SQLAlchemy for database models
   - Follow patterns in existing code
   - Ensure type safety with Pydantic models

2. **Implement Next.js Frontend**
   - Create React components with proper patterns
   - Use Prisma for database queries
   - Ensure UI/UX consistency
   - Add form validation

3. **Maintain Code Quality**
   - Run `uv run ruff check --fix` before committing (backend)
   - Run `pnpm run lint` before committing (frontend)
   - Ensure all tests pass locally
   - Follow established code patterns

4. **Ensure Node.js 22 LTS + corepack Compliance**
   - Run `nvm use` before frontend development
   - Verify `pnpm --version` (should be 9.0.0+)
   - Document any Node.js version issues

### Key Workflow

1. **Before Starting**
   ```bash
   # Switch to Node.js 22 LTS
   nvm use
   node --version  # Should show v22.10.0+

   # Verify corepack and pnpm
   corepack enable
   pnpm --version  # Should show 9.0.0+
   ```

2. **Backend Development**
   ```bash
   cd backend

   # View current Ruff configuration
   cat pyproject.toml | grep -A 10 "\[tool.ruff\]"

   # Run linting and fix issues
   uv run ruff check --fix
   uv run ruff format .

   # Run tests
   uv run pytest
   ```

3. **Frontend Development**
   ```bash
   cd frontend
   nvm use  # Ensure Node.js 22

   # Install dependencies (pnpm managed by corepack)
   pnpm install

   # Run linting and fix issues
   pnpm run lint

   # Run tests
   pnpm test:vitest
   ```

4. **Pre-commit Checks**
   ```bash
   # Ensure all pre-commit hooks pass
   pre-commit run --all-files

   # If failures, fix and re-run
   # Ruff and Biome will auto-fix most issues
   ```

5. **Submit Changes**
   ```bash
   git checkout -b feat/description
   git add .
   git commit -m "feat(scope): description

   [agent-action]
   Co-Authored-By: Full Stack Engineer <agent@playground.local>"

   git push -u origin feat/description
   gh pr create --title "feat: description" --body "..."
   ```

### Tools & Commands

| Tool | Purpose | Command |
|------|---------|---------|
| nvm | Switch Node.js version | `nvm use` |
| corepack | Manage pnpm | `corepack enable` |
| pnpm | Install frontend deps | `pnpm install` |
| Ruff | Lint/format Python | `uv run ruff check --fix` |
| Biome | Lint/format frontend | `pnpm run lint` |
| pytest | Test backend | `uv run pytest` |
| Vitest | Test frontend | `pnpm test:vitest` |

### Common Issues

**Issue**: "pnpm: command not found"
```bash
nvm use
corepack enable
corepack install -g pnpm
pnpm --version  # Should work now
```

**Issue**: "Ruff formatting differs from team"
```bash
# Check Ruff config in pyproject.toml
cat backend/pyproject.toml | grep -A 10 "\[tool.ruff\]"

# Ensure everyone uses same config
uv run ruff format .
pre-commit run --all-files
```

**Issue**: "Different linting results locally vs CI"
- Ensure Node.js version matches: `nvm use`
- Ensure pnpm version matches: `pnpm --version`
- Run: `pre-commit run --all-files`

---

## QA Engineer

**Tooling**: Vitest + Playwright + lint-staged + pnpm

### Core Responsibilities

1. **Generate and Execute Tests**
   - Create Vitest unit and component tests
   - Create Playwright E2E test scenarios
   - Maintain >80% test coverage
   - Document test scenarios

2. **Manage lint-staged Configuration**
   - Configure checks in `frontend/package.json`
   - Ensure checks run only on changed files
   - Monitor pre-commit hook execution time
   - Optimize for sub-second performance

3. **Quality Assurance**
   - Validate new features meet acceptance criteria
   - Check for regressions in existing tests
   - Ensure E2E tests cover critical user paths
   - Document edge cases

4. **Performance Optimization**
   - Monitor `pre-commit run` execution time
   - Optimize Vitest configurations
   - Monitor Playwright test speed
   - Document performance metrics

### lint-staged Configuration

**File**: `frontend/package.json`

```json
{
  "lint-staged": {
    "src/**/*.{js,jsx,ts,tsx}": [
      "biome check --apply",
      "vitest run --related"
    ],
    "prisma/schema.prisma": [
      "prisma format"
    ],
    "*.{json,jsonc}": [
      "biome check --apply"
    ],
    "*.{md,mdx}": [
      "biome check --apply"
    ]
  }
}
```

**How it works**:
- Only checks files in git staging area (NOT all files)
- Runs Biome on changed frontend files
- Runs Vitest on related test files
- Typical time: 0.5-1 second

### Key Workflow

1. **Run Full Test Suite**
   ```bash
   cd frontend
   pnpm test:vitest          # Unit tests
   pnpm exec playwright test # E2E tests
   pnpm test:coverage        # Coverage report
   ```

2. **Monitor lint-staged**
   ```bash
   # Check configuration
   cat frontend/package.json | jq '.["lint-staged"]'

   # Test lint-staged manually
   pnpm exec lint-staged

   # Or via pre-commit
   pre-commit run  # Only checks staged files
   ```

3. **Generate Tests for New Features**
   ```bash
   # For new component
   touch src/components/__tests__/NewComponent.test.tsx

   # For new API endpoint
   touch tests/api.test.ts

   # Verify coverage
   pnpm test:coverage
   ```

4. **Create E2E Test Scenarios**
   ```bash
   # Create new E2E test
   touch tests/e2e/user-flow.spec.ts

   # Run E2E tests in headed mode (see browser)
   pnpm exec playwright test --headed

   # Debug specific test
   pnpm exec playwright test --debug
   ```

5. **Validate PR Changes**
   ```bash
   # Run all tests before approving
   pnpm test:vitest
   pnpm exec playwright test
   pnpm test:coverage

   # Ensure coverage >80%
   # Ensure no regressions
   # Comment on PR with test results
   ```

### Tools & Commands

| Tool | Purpose | Command |
|------|---------|---------|
| Vitest | Unit/component tests | `pnpm test:vitest` |
| Playwright | E2E tests | `pnpm exec playwright test` |
| lint-staged | Fast pre-commit checks | `pnpm exec lint-staged` |
| Coverage | Test coverage report | `pnpm test:coverage` |

### Performance Targets

| Metric | Target | Current |
|--------|--------|---------|
| Vitest run time | <5 seconds | varies |
| Playwright run time | <30 seconds | varies |
| Pre-commit (lint-staged) | <1 second | 0.5-1s |
| Pre-commit (without lint-staged) | <5 seconds | 5-10s |

### Common Issues

**Issue**: "Test coverage below 80%"
```bash
# Generate coverage report
pnpm test:coverage

# Review coverage report
open coverage/index.html

# Add tests for uncovered lines
```

**Issue**: "Pre-commit hooks too slow"
```bash
# Check lint-staged configuration
cat frontend/package.json | jq '.["lint-staged"]'

# Ensure it's configured for changed files only (NOT --all-files)
# Typical time: 0.5-1 second

# If slow, remove unnecessary checks
# Only include: biome, vitest --related, prisma format
```

**Issue**: "Playwright tests flaky"
```bash
# Run tests in headed mode to debug
pnpm exec playwright test --headed

# Add wait conditions
# Use `page.waitForNavigation()` for navigation
# Use `page.waitForSelector()` for elements

# Check for timing issues
```

---

## DevOps (SRE)

**Tooling**: GitHub Actions + Prisma + uv + pre-commit + Node.js 22 LTS

### Core Responsibilities

1. **Manage Infrastructure**
   - Maintain GitHub Actions CI/CD pipeline
   - Configure environment variables
   - Monitor deployment processes
   - Manage database migrations

2. **Maintain Node.js Configuration**
   - Keep `.nvmrc` and `.node-version` in sync
   - Update `frontend/package.json` `engines` field
   - Manage `packageManager` field in package.json
   - Monitor Node.js LTS releases

3. **Maintain Python Configuration**
   - Manage `backend/pyproject.toml` as source of truth
   - Update dependencies carefully
   - Monitor Ruff configuration
   - Manage pytest configuration

4. **Code Quality Enforcement**
   - Maintain `.pre-commit-config.yaml`
   - Ensure Ruff and lint-staged hooks pass
   - Monitor hook execution time
   - Update tools as needed

5. **Database Management**
   - Validate migrations before production
   - Ensure SQLite dev and PostgreSQL prod compatibility
   - Monitor schema consistency
   - Document migration procedures

### Node.js Version Management

**Files to Update**:
```bash
.nvmrc           # For nvm users
.node-version    # For nodenv users
frontend/package.json  # engines field
.github/workflows/*.yml  # GitHub Actions
```

**Example: Update to Node.js 22.11.0**
```bash
# Update version files
echo "22.11.0" > .nvmrc
echo "22.11.0" > .node-version

# Update package.json
cat frontend/package.json | jq '.engines.node = ">=22.11.0"'

# Update GitHub Actions
grep -r "node-version:" .github/workflows/

# Verify
nvm use
node --version  # Should show v22.11.0
```

### Python Configuration Management

**Key Sections in `backend/pyproject.toml`**:

```toml
[project]
requires-python = ">=3.10,<3.13"

[project.dependencies]
# All production dependencies listed here

[project.optional-dependencies]
dev = [
  # All dev dependencies listed here
]

[tool.ruff]
line-length = 100
target-version = "py310"
select = ["E", "W", "F", "I", "C", "B", "UP", "ARG", "C90", "ICN", "PIE", "T201", "PT"]

[tool.pytest.ini_options]
minversion = "7.0"
testpaths = ["tests"]
asyncio_mode = "auto"
addopts = "--cov=... --cov-report=term-missing"
```

### Pre-commit Hook Management

**Workflow**:
```bash
# Install pre-commit framework
pip install pre-commit pre-commit-uv

# Install git hooks
pre-commit install

# Test hooks locally
pre-commit run --all-files

# Update hooks (monthly)
pre-commit autoupdate

# Commit changes
git add .pre-commit-config.yaml
git commit -m "chore: update pre-commit hooks"
```

### Database Migration Validation

**Workflow**:
```bash
# Create migration
pnpm exec prisma migrate dev --name feature_name

# Validate SQLite migration
cd frontend
pnpm exec prisma migrate dev

# Validate PostgreSQL compatibility
# Test against temporary PostgreSQL container in CI/CD

# Document migration in PR description
```

### GitHub Actions Workflow

**Key Steps**:
```yaml
- uses: actions/setup-node@v4
  with:
    node-version: 22

- run: corepack enable
- run: corepack install -g pnpm

- uses: actions/setup-python@v4
  with:
    python-version: '3.12'

- run: pip install uv
- run: uv sync

- run: pre-commit run --all-files
- run: uv run ruff check backend/
- run: pnpm run lint
- run: uv run pytest
- run: pnpm test:vitest
```

### Tools & Commands

| Tool | Purpose | Command |
|------|---------|---------|
| pre-commit | Git hooks | `pre-commit install` |
| uv | Python packages | `uv sync` |
| Ruff | Python linting | `uv run ruff check` |
| Prisma | Database migrations | `pnpm exec prisma migrate` |
| GitHub Actions | CI/CD | `gh run view` |

### Monitoring & Maintenance

**Weekly**:
- Check GitHub Actions runs
- Monitor pipeline execution time
- Review any failed hooks

**Monthly**:
- Update pre-commit hooks: `pre-commit autoupdate`
- Review Node.js LTS releases
- Review Python package updates

**Quarterly**:
- Audit dependencies for security
- Review and update documentation
- Plan major version upgrades

### Common Issues

**Issue**: "GitHub Actions fails on Node.js version"
```bash
# Ensure .nvmrc, .node-version, and GitHub Actions all use same version
cat .nvmrc
cat .node-version
grep node-version .github/workflows/*.yml

# All should match
```

**Issue**: "Pre-commit hooks too slow in CI/CD"
```bash
# Check if lint-staged is configured correctly
cat frontend/package.json | jq '.["lint-staged"]'

# Should only check changed files (NOT --all-files)
# Typical time: 0.5-1s

# If slow, profile with: time pre-commit run --all-files
```

**Issue**: "Python dependency incompatibility"
```bash
# Check requires-python range
cat backend/pyproject.toml | grep requires-python

# Test with multiple Python versions
python3.10 --version
python3.11 --version
python3.12 --version

# Update range if needed
```

---

## Project Manager

**Tooling**: Claude Code + GitHub CLI

### Core Responsibilities

1. **Planning & Coordination**
   - Maintain `PLAN.md` as source of truth
   - Create and prioritize GitHub Issues
   - Define feature requirements
   - Coordinate task handoffs between agents

2. **Status Tracking**
   - Update issue statuses
   - Track progress against milestones
   - Document blockers and dependencies
   - Report status to stakeholders

3. **Documentation**
   - Keep PLAN.md current
   - Document design decisions
   - Ensure all agents understand requirements
   - Create feature specs

4. **Agent Coordination**
   - Assign issues to appropriate agents
   - Monitor for merge conflicts
   - Facilitate cross-team handoffs
   - Escalate blockers

### Key Workflow

1. **Create Feature Issue**
   ```bash
   gh issue create \
     --title "feat: description" \
     --body "## Requirements
   - [ ] Requirement 1
   - [ ] Requirement 2

   ## Acceptance Criteria
   - [ ] Criteria 1
   - [ ] Criteria 2"
   ```

2. **Assign to Agent**
   ```bash
   gh issue edit <issue-number> --add-assignee @username

   # Add label
   gh issue edit <issue-number> --add-label "feat"
   ```

3. **Track Progress**
   ```bash
   # Update PLAN.md with assignment
   # Monitor PR for completion
   gh pr list --state open
   gh pr view <pr-number>
   ```

4. **Manage Milestones**
   ```bash
   # Create milestone for sprint
   gh api repos/{owner}/{repo}/milestones \
     -f title="Sprint 1" \
     -f description="Feb 27 - Mar 6"

   # Add issues to milestone
   gh issue edit <issue> --milestone "Sprint 1"
   ```

### Tools & Commands

| Tool | Purpose | Command |
|------|---------|---------|
| GitHub Issues | Feature tracking | `gh issue list` |
| GitHub PRs | Code review | `gh pr list` |
| PLAN.md | Project roadmap | Text editor |
| GitHub Labels | Issue categorization | `gh issue edit` |

### Success Criteria

- ✅ All open issues assigned
- ✅ PLAN.md updated weekly
- ✅ PRs reviewed within 24 hours
- ✅ No merge conflicts blocking progress
- ✅ Team moving at consistent velocity

---

## Team Coordination Matrix

| Scenario | Owner | Process |
|----------|-------|---------|
| Add Python dependency | Full Stack Engineer + DevOps | Engineer requests, DevOps approves |
| Add Node.js dependency | Full Stack Engineer + DevOps | Engineer requests, DevOps approves |
| Update Node.js version | DevOps | Update .nvmrc, .node-version, GitHub Actions |
| Create database migration | Full Stack Engineer + DevOps | Engineer creates, DevOps validates |
| Update Ruff config | DevOps + Full Stack Engineer | DevOps updates, engineer verifies |
| Update lint-staged config | QA Engineer + DevOps | QA Engineer updates, DevOps verifies |
| New feature implementation | Full Stack Engineer + QA Engineer | Engineer codes, QA tests |
| Infrastructure change | DevOps + Project Manager | DevOps implements, PM coordinates |

---

## Escalation Path

1. **Blocker discovered**: Create GitHub Issue with `blocker` label
2. **Technical uncertainty**: Comment on PR or issue with `@agent` mention
3. **Cross-team conflict**: Update PLAN.md with context and tag all agents
4. **External dependency**: Create tracking issue with external timeline

