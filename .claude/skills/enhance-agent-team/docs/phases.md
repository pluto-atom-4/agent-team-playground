# Enhancement Phases

A structured 4-phase approach to enhancing the agent-team-playground project with modern tooling.

---

## Phase 1: Audit Current State

**Duration**: 1 hour
**Owner**: DevOps / Project Manager
**Goal**: Understand what currently exists and what needs updating

### Step 1.1: Review Python Configuration

```bash
# Check if backend/pyproject.toml exists
cat backend/pyproject.toml

# Look for key sections
grep -E "^\[|requires-python|ruff|pytest" backend/pyproject.toml
```

**What to check**:
- ✅ Does `[project]` section exist with metadata?
- ✅ Are dependencies listed in `[project.dependencies]`?
- ✅ Is `requires-python` set to `>=3.10,<3.13`?
- ✅ Does `[tool.ruff]` section exist?
- ✅ Does `[tool.pytest.ini_options]` exist?

### Step 1.2: Review Node.js Configuration

```bash
# Check frontend/package.json
cat frontend/package.json | jq '.packageManager, .engines'

# Example output should be:
# "packageManager": "pnpm@9.0.0"
# "engines": { "node": ">=22.0.0", "pnpm": ">=9.0.0" }
```

**What to check**:
- ✅ Does `packageManager` field exist and specify pnpm 9+?
- ✅ Does `engines` field exist with Node.js 22+ and pnpm 9+?
- ✅ Are all dependencies listed?
- ✅ Does `lint-staged` configuration exist?

### Step 1.3: Review Version Files

```bash
# Check Node.js version pinning
ls -la .nvmrc .node-version

# Should show version like "22.10.0"
cat .nvmrc
cat .node-version
```

**What to check**:
- ✅ Do both `.nvmrc` and `.node-version` exist?
- ✅ Do they specify Node.js 22.10.0 or later?
- ✅ Are they identical?

### Step 1.4: Review Pre-commit Configuration

```bash
# Check if .pre-commit-config.yaml exists
cat .pre-commit-config.yaml | grep -A5 "repo:"
```

**What to check**:
- ✅ Does Ruff hook exist for Python files?
- ✅ Does lint-staged hook exist for frontend?
- ✅ Does general validation hook exist (merge conflicts, trailing whitespace)?
- ✅ Does secrets detection exist?

### Phase 1 Checklist

- [ ] `backend/pyproject.toml` reviewed
- [ ] `frontend/package.json` reviewed
- [ ] `.nvmrc` and `.node-version` exist
- [ ] `.pre-commit-config.yaml` exists
- [ ] Document current state in a temporary file
- [ ] Create GitHub Issue for Phase 2 work

---

## Phase 2: Update Configuration Files

**Duration**: 2-3 hours
**Owner**: DevOps + Full Stack Engineer
**Goal**: Centralize all configuration and enforce version pinning

### Step 2.1: Update `backend/pyproject.toml`

**Task**: Create comprehensive Python configuration file

```toml
[build-system]
requires = ["setuptools>=65", "wheel"]
build-backend = "setuptools.build_meta"

[project]
name = "agent-team-playground-backend"
version = "0.1.0"
description = "FastAPI backend for agent team playground"
requires-python = ">=3.10,<3.13"
dependencies = [
    "fastapi>=0.109.0",
    "uvicorn[standard]>=0.27.0",
    "sqlalchemy>=2.0",
    "pydantic>=2.0",
    "pydantic-settings>=2.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.0",
    "pytest-asyncio>=0.21.0",
    "pytest-cov>=4.0",
    "ruff>=0.1.0",
    "mypy>=1.0",
    "black>=23.0",
    "isort>=5.0",
]

[tool.ruff]
line-length = 100
target-version = "py310"
select = ["E", "W", "F", "I", "C", "B", "UP", "ARG", "C90", "ICN", "PIE", "T201", "PT"]
ignore = ["E501"]

[tool.pytest.ini_options]
minversion = "7.0"
testpaths = ["tests"]
asyncio_mode = "auto"
addopts = "--cov=agent_team_playground_backend --cov-report=term-missing --cov-report=html --strict-markers"
markers = ["unit", "integration", "e2e"]

[tool.mypy]
python_version = "3.10"
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = false
```

**Verification**:
```bash
cd backend
uv sync            # Install dependencies
uv run ruff check  # Verify Ruff works
uv run pytest      # Verify pytest works
```

### Step 2.2: Update `frontend/package.json`

**Task**: Add Node.js version pinning and package manager field

```json
{
  "name": "agent-team-playground-frontend",
  "version": "0.1.0",
  "type": "module",
  "packageManager": "pnpm@9.0.0",
  "engines": {
    "node": ">=22.0.0",
    "pnpm": ">=9.0.0"
  },
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "biome check --apply src/",
    "test:vitest": "vitest",
    "test:playwright": "playwright test",
    "test:coverage": "vitest --coverage"
  },
  "dependencies": {
    "next": "^15.0.0",
    "react": "^19.0.0",
    "@prisma/client": "^5.0.0",
    "typescript": "^5.0.0"
  },
  "devDependencies": {
    "biome": "^1.0.0",
    "vitest": "^1.0.0",
    "@testing-library/react": "^14.0.0",
    "@playwright/test": "^1.0.0",
    "lint-staged": "^15.0.0",
    "prisma": "^5.0.0"
  },
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

**Verification**:
```bash
cd frontend
nvm use                    # Switch to Node.js 22
corepack enable           # Enable corepack
pnpm install --frozen-lockfile  # Install dependencies
pnpm run lint             # Verify Biome works
pnpm test:vitest          # Verify Vitest works
```

### Step 2.3: Create Node.js Version Files

**File**: `.nvmrc`
```
22.10.0
```

**File**: `.node-version`
```
22.10.0
```

**Verification**:
```bash
nvm use
node --version  # Should output v22.10.0
```

### Step 2.4: Configure `.pre-commit-config.yaml`

**Task**: Set up multi-language pre-commit hooks

```yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: check-merge-conflict
      - id: check-yaml
      - id: end-of-file-fixer
      - id: trailing-whitespace
      - id: check-json
      - id: check-case-conflict
      - id: check-added-large-files

  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.1.7
    hooks:
      - id: ruff
        files: ^(backend|scripts)/
        args: [--fix, --show-fixes]
      - id: ruff-format
        files: ^(backend|scripts)/

  - repo: local
    hooks:
      - id: lint-staged
        name: lint-staged
        entry: bash -c 'cd frontend && pnpm exec lint-staged'
        language: system
        stages: [commit]
        pass_filenames: false

  - repo: https://github.com/Yelp/detect-secrets
    rev: v1.4.0
    hooks:
      - id: detect-secrets
        args: [--baseline, .secrets.baseline]

  - repo: https://github.com/pre-commit/mirrors-prettier
    rev: v3.1.0
    hooks:
      - id: prettier
        files: '\.(md|mdx)$'
```

**Verification**:
```bash
pre-commit install           # Install git hooks
pre-commit run --all-files   # Run all hooks
# Should see: Ruff checks, lint-staged runs, secrets detected
```

### Phase 2 Checklist

- [ ] `backend/pyproject.toml` created/updated with all sections
- [ ] `frontend/package.json` updated with packageManager and engines
- [ ] `.nvmrc` and `.node-version` created with 22.10.0
- [ ] `.pre-commit-config.yaml` created with Ruff + lint-staged
- [ ] `uv sync` runs successfully in backend
- [ ] `pnpm install` runs successfully in frontend
- [ ] `pnpm run lint` and `uv run ruff check` pass locally
- [ ] Create GitHub Issue for Phase 3 work

---

## Phase 3: Update Documentation

**Duration**: 2 hours
**Owner**: Full Stack Engineer + Project Manager
**Goal**: Ensure all documentation reflects new tooling

### Step 3.1: Update README.md

**Add Step 0 - Node.js Setup**:
```markdown
## Step 0: Install Node.js 22 LTS (One-time Setup)

1. Install Node.js 22 LTS from https://nodejs.org/
   - Choose the LTS version (currently 22.10.0 or later)

2. If using nvm:
   ```bash
   nvm install 22.10.0
   nvm use  # Uses .nvmrc automatically
   ```

3. Enable corepack:
   ```bash
   corepack enable
   corepack install -g pnpm  # Install pnpm 9+
   pnpm --version  # Should show 9.x.x
   ```

4. Verify installation:
   ```bash
   node --version    # Should show v22.10.0+
   pnpm --version    # Should show 9.0.0+
   ```
```

**Update Frontend Setup Section**:
- Change "npm install" to "pnpm install"
- Add note about pnpm being managed by corepack
- Document that package.json has packageManager field

**Update Code Quality Checks Section**:
- Backend: `uv run ruff check --fix` (Ruff config from pyproject.toml)
- Frontend: `pnpm run lint` (Biome rules)
- Pre-commit: `pre-commit run --all-files`

### Step 3.2: Update CLAUDE.md

**Add Node.js 22 LTS section**:
- Document version requirement (22.10.0+)
- Explain corepack management of pnpm
- Show verification commands

**Update Agent Responsibilities**:
- Full Stack Engineer: Add Node.js verification
- DevOps: Add Node.js version management tasks

### Step 3.3: Update `.claude/agents/team.md`

**Full Stack Engineer Role**:
```
- Ensure Node.js 22 LTS: `nvm use`
- Verify pnpm: `pnpm --version` (>=9.0.0)
- Run linting: `uv run ruff check --fix` (backend)
- Run linting: `pnpm run lint` (frontend)
```

**DevOps Role**:
```
- Maintain `.nvmrc` and `.node-version` files
- Ensure `packageManager` field in frontend/package.json
- Update GitHub Actions to use Node.js 22 LTS
- Manage `backend/pyproject.toml` as source of truth
```

### Step 3.4: Update PLAN.md

**Technology Stack Table**:
- Add: "Node.js Runtime: Node.js 22 LTS or later"
- Add: "Node Version Mgmt: .nvmrc + .node-version"
- Add: "Package Manager: pnpm 9+ (via corepack)"
- Update Python tools to reference pyproject.toml

**Setup Phase Checklist**:
- Add Node.js 22 LTS setup as required step
- Add corepack configuration step
- Cross-reference README.md Step 0

### Phase 3 Checklist

- [ ] README.md Step 0 added for Node.js setup
- [ ] Frontend setup documentation updated (pnpm)
- [ ] Code quality checks section updated (Ruff, Biome, pre-commit)
- [ ] CLAUDE.md updated with Node.js guidance
- [ ] `.claude/agents/team.md` updated with Node.js/corepack tasks
- [ ] PLAN.md technology stack updated
- [ ] All documentation links are correct
- [ ] Create GitHub Issue for Phase 4 work

---

## Phase 4: Update CI/CD

**Duration**: 2-3 hours
**Owner**: DevOps
**Goal**: Ensure GitHub Actions uses correct tooling

### Step 4.1: Update GitHub Actions Workflow

**File**: `.github/workflows/agentic-dev.yml` (if it exists)

```yaml
name: Agentic PR Validator
on: [pull_request]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      # Setup Node.js 22 LTS
      - uses: actions/setup-node@v4
        with:
          node-version: 22
          cache: 'pnpm'

      # Enable corepack and install pnpm
      - run: corepack enable
      - run: corepack install -g pnpm
      - run: pnpm --version

      # Install frontend dependencies
      - run: pnpm install --frozen-lockfile

      # Setup Python
      - uses: actions/setup-python@v4
        with:
          python-version: '3.12'

      # Install backend dependencies with uv
      - run: pip install uv
      - run: uv sync

      # Run tests
      - run: uv run pytest
      - run: pnpm test:vitest
      - run: pnpm exec playwright test

      # Run linting
      - run: uv run ruff check backend/
      - run: pnpm run lint

      # Run pre-commit
      - run: pip install pre-commit pre-commit-uv
      - run: pre-commit run --all-files
```

### Step 4.2: Document CI/CD in `.github/workflows/agentic-dev.md`

**Add Node.js 22 section**:
```markdown
## Node.js 22 LTS Setup in CI/CD

All GitHub Actions workflows use Node.js 22 LTS:

1. Actions setup-node@v4 with node-version: 22
2. Enable corepack: `corepack enable`
3. Install pnpm via corepack (reads from package.json)
4. Use pnpm for all frontend operations
```

### Step 4.3: Verify Performance Improvements

**Measure pipeline time**:
```bash
# Before: Should take ~2-3 minutes
# After: Should take ~1-2 minutes (30-50% improvement)

# Monitor GitHub Actions run times
gh run list --repo org/repo
gh run view <run-id>
```

### Phase 4 Checklist

- [ ] GitHub Actions workflow uses Node.js 22 LTS
- [ ] GitHub Actions enables corepack
- [ ] GitHub Actions uses `uv sync` for Python
- [ ] GitHub Actions uses `pnpm install` for Node.js
- [ ] Pre-commit validation runs in CI/CD
- [ ] Test suite runs in CI/CD
- [ ] Linting passes in CI/CD
- [ ] Pipeline time is 30-50% faster than before
- [ ] Document performance metrics

---

## Completion Checklist

After all 4 phases:

- [ ] Phase 1: Audit complete
- [ ] Phase 2: Configuration files updated
- [ ] Phase 3: Documentation updated
- [ ] Phase 4: CI/CD pipeline updated
- [ ] All team members can run: `nvm use && pnpm install && uv sync`
- [ ] All tests pass locally
- [ ] All pre-commit hooks pass
- [ ] GitHub Actions pipeline passes
- [ ] Performance improved by 30-50%

---

## Estimated Timeline

| Phase | Duration | Team Size | Total |
|-------|----------|-----------|-------|
| Phase 1 (Audit) | 1 hour | 1 person | 1 hour |
| Phase 2 (Config) | 3 hours | 2 people | 6 hours |
| Phase 3 (Docs) | 2 hours | 2 people | 4 hours |
| Phase 4 (CI/CD) | 3 hours | 1 person | 3 hours |
| **Total** | | | **14 hours** |

For a 4-person team: ~3-4 days of focused work.
