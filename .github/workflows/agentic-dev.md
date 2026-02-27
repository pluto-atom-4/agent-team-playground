---
name: Agentic PR Validator
description: Automated validation workflow for agent-driven pull requests
on: [pull_request]
tools: [edit, shell, github-pr-review]
permissions: [write-all]
---

# Agentic Development Workflow

This workflow automates the validation of pull requests created by the agent team, ensuring consistency across the full-stack application and preventing schema/migration conflicts.

## Workflow Steps

### 1. Detect Schema Changes

**Goal**: Identify if the PR modifies the Prisma schema or backend models.

```bash
# Check for Prisma schema changes
if git diff origin/main -- 'prisma/schema.prisma' | grep -q '.'; then
  echo "Prisma schema modified"
  export SCHEMA_CHANGED=true
else
  echo "No schema changes detected"
  export SCHEMA_CHANGED=false
fi
```

**Action**: Set flag `SCHEMA_CHANGED` for downstream steps.

---

### 2. Validate Database Migrations

**Goal**: Ensure migrations are valid and compatible with both SQLite (dev) and PostgreSQL (prod).

**Trigger**: Only runs if `SCHEMA_CHANGED=true`

```bash
# Set up Node.js 22 LTS environment (GitHub Actions)
# Uses node-version: 22 in workflow configuration
node --version  # Should show v22.x.x

# Enable corepack and install pnpm
corepack enable
corepack install -g pnpm

# Install frontend dependencies with pnpm
pnpm install --frozen-lockfile

# Install backend dependencies from pyproject.toml
uv sync

# Run migrations against dev database (SQLite)
pnpm exec prisma migrate dev --name verify_migration

# Validate PostgreSQL compatibility by testing against a temporary Postgres container
docker run -d \
  --name postgres-test \
  -e POSTGRES_PASSWORD=test \
  postgres:15

# Wait for postgres to be ready
sleep 5

# Test migration against postgres
DATABASE_URL=postgresql://postgres:test@localhost/test pnpm exec prisma migrate deploy

# Cleanup
docker stop postgres-test
docker rm postgres-test

echo "✓ Migrations validated for both SQLite and PostgreSQL"
```

**Failures**: If migrations fail, comment on PR with migration error details.

---

### 3. Run Full Test Suite

**Goal**: Execute backend pytest and frontend Vitest/Playwright tests to validate functionality.

```bash
# Install backend dependencies from pyproject.toml (includes pytest)
uv sync

# Run backend tests (pytest configuration from pyproject.toml)
uv run pytest --cov=agent_team_playground_backend --cov-report=term-missing

# Install frontend dependencies with pnpm (frozen lockfile ensures reproducibility)
pnpm install --frozen-lockfile

# Run frontend unit and component tests
pnpm test:vitest -- --reporter=verbose

# Run E2E tests
pnpm exec playwright test --reporter=html

# Generate coverage report
pnpm test:coverage
```

**Validation Criteria**:
- Backend pytest: All tests pass, coverage >80% (configured in pyproject.toml)
- Frontend Vitest: All tests pass, coverage >80%
- Frontend Playwright: All E2E tests pass
- No regressions in existing tests

**Action**: Comment on PR with test results and coverage summary.

---

### 4. Verify FastAPI MCP Documentation

**Goal**: If backend code changed, ensure MCP entry points are properly documented.

**Trigger**: Detects changes in `backend/` directory

```bash
# Install Python dependencies with uv (reads from backend/pyproject.toml)
uv sync

# Check for MCP documentation in FastAPI endpoints
uv run scripts/validate_mcp_docs.py \
  --check-endpoints \
  --report-missing

# Validate MCP schema matches frontend expectations
uv run scripts/validate_mcp_schema.py --frontend-integration

# Run backend linting (Ruff config from pyproject.toml)
uv run ruff check backend/
```

**Validation Criteria**:
- All new FastAPI endpoints have MCP documentation
- MCP schema is valid and discoverable by agents
- Documentation includes parameter descriptions and return types
- Ruff linting passes (configuration from pyproject.toml)

**Action**: If missing MCP docs or linting fails, comment on PR requesting updates.

---

### 5. Verify Pre-commit Hooks (with lint-staged for frontend)

**Goal**: Ensure all code quality checks pass via pre-commit framework with lint-staged optimization for frontend.

**Trigger**: Always runs before merging

```bash
# Install pre-commit framework with uv (includes pre-commit-uv for speed)
uv tool install pre-commit --with pre-commit-uv

# Run all pre-commit hooks
# Backend: Ruff checks all Python files
# Frontend: lint-staged checks only changed files (much faster!)
pre-commit run --all-files
```

**Pre-commit Architecture**:
- **Backend (Ruff)**: Synchronous, checks all Python files for consistency
- **Frontend (lint-staged)**: Checks only git staging area files (optimized)
  - Configuration in `frontend/package.json`
  - Runs Biome on changed files
  - Runs Vitest on related test files
  - Runs Prisma format on schema changes
  - Much faster than checking all frontend files

**Validation Criteria**:
- ✓ Ruff: Python linting and formatting for `backend/` passes
- ✓ lint-staged: Biome checks pass on changed frontend files
- ✓ lint-staged: Vitest runs on related test files
- ✓ General: No merge conflicts, trailing whitespace, or invalid JSON/YAML
- ✓ Secrets: No API keys or credentials detected
- ✓ All hooks pass

**Performance**:
- Without lint-staged: Checks all files (~5-10 seconds)
- With lint-staged: Checks only changed files (~0.5-1 second)

**Action**: If any hook fails, comment on PR with specific failures and request fixes.

**Note**: Most issues are auto-fixed by Ruff and lint-staged tools. Developers should run `pre-commit run --all-files` locally before pushing.

---

### 6. Comment with Workflow Summary

**Goal**: Post a summary comment on the PR with validation results.

**Comment Template**:

```markdown
## Agentic PR Validation Results

### Code Quality
- Pre-commit Hooks: [✓ Passed]
  - Ruff (Python): [✓ Passed]
  - Biome (Frontend): [✓ Passed]
  - Other Hooks: [✓ Passed]

### Database Validation
- Schema Changes: [Yes/No]
- Migrations Validated: [✓/✗]
  - SQLite: [✓/✗]
  - PostgreSQL: [✓/✗]

### Testing
- Vitest: [✓ Passed] (Coverage: X%)
- Playwright E2E: [✓ Passed]

### Backend Integration
- MCP Documentation: [✓ Complete]
- New Endpoints Documented: [X endpoints]

### Status
- **Ready for Review**: All checks passed ✓
- **Needs Changes**: See errors below 👇

---
[Validation run details]
```

---

## Agent Coordination

### On Successful Validation

1. Label PR with `validated-by-workflow`
2. Notify QA Agent (via comment) that tests passed
3. Mark GitHub Issue as "Ready for Code Review"

### On Validation Failure

1. Comment with specific error details
2. Request specific agent to fix issues:
   - **Migration errors** → DevOps Agent
   - **Test failures** → QA Agent
   - **MCP documentation** → Full Stack Engineer
3. Do NOT auto-merge until all checks pass

---

## Integration with Agent Team

This workflow ensures:

- **Full Stack Engineer**: Receives feedback on MCP documentation completeness
- **QA Engineer**: Gets automated test results and coverage reports
- **DevOps**: Validates migrations work on both SQLite and PostgreSQL before production deployment
- **Project Manager**: Can see overall PR health at a glance

---

## Configuration Requirements

The following GitHub Actions secrets and variables are required:

```
POSTGRES_TEST_URL=postgresql://postgres:test@localhost/test
```

The following directories must exist:

```
backend/
├── main.py
└── routes/
    └── *.py (FastAPI endpoints)

frontend/
├── package.json
└── src/
    └── components/ (React components)

prisma/
└── schema.prisma (Prisma ORM schema)

scripts/
├── validate_mcp_docs.py
├── validate_mcp_schema.py
└── migrate_sqlite_to_pg.py
```

---

## Troubleshooting

### Migration Validation Fails

**Common Causes**:
- PostgreSQL container not starting → Check Docker availability
- Prisma migration incompatible → Review schema changes for SQL compatibility

**Solution**:
```bash
# Debug locally
npx prisma migrate dev --name debug_migration
npx prisma migrate reset  # Reset dev database to start
```

### Test Suite Fails

**Common Causes**:
- New code missing test coverage
- Environment variables not configured in CI

**Solution**:
```bash
# Run tests locally with pnpm
pnpm test:vitest -- --watch
pnpm exec playwright test --headed  # See browser testing
```

### Pre-commit Hooks Fail

**Common Causes**:
- Python code has linting issues (Ruff)
- Frontend code has formatting issues (Biome)
- Trailing whitespace or other file issues

**Solution**:
```bash
# Install and run pre-commit hooks locally
pip install pre-commit
pre-commit run --all-files

# Or let pre-commit auto-fix issues
pre-commit run --all-files  # Ruff and Biome will auto-fix many issues
```

### MCP Documentation Missing

**Common Causes**:
- New FastAPI endpoint added without MCP docstring
- Endpoint parameters not properly typed

**Solution**:
```python
# Ensure all FastAPI routes have MCP documentation
@app.post("/users", tags=["users"], summary="Create new user")
async def create_user(user: UserSchema) -> UserResponse:
    """
    Create a new user in the database.

    Args:
        user: User data (email, password, name)

    Returns:
        UserResponse: Created user with ID and timestamp
    """
    ...
```

---

## Future Enhancements

- [x] Code quality checks via pre-commit (Ruff, Biome, etc.)
- [ ] Automated performance regression testing
- [ ] Advanced type checking (Pyright for backend, TypeScript strict mode)
- [ ] Security scanning for dependencies (Dependabot, safety)
- [ ] Automated changelog generation from commit messages
- [ ] Slack notifications for workflow status
- [ ] Workflow timing and performance monitoring
