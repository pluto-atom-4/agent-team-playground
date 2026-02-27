# Core Principles

This document explains the 4 foundational principles behind the agent-team-playground enhancements.

---

## 1. Modern Tooling Philosophy

Use fast, Rust-based alternatives to legacy tools. Modern tooling is not optional—it's essential for productivity.

| Legacy Tool | Modern Alternative | Benefit | Improvement |
|-------------|-------------------|---------|-------------|
| pip | uv | Python package management | 10-100x faster |
| npm | pnpm | Node.js package management | 30-50x faster |
| flake8 | Ruff | Python linting | 10-100x faster |
| ESLint + Prettier | Biome | JavaScript/TypeScript formatting | 10-100x faster |

### Why Modern Tooling Matters

- **Speed**: Rust-based tools run orders of magnitude faster than Python/Node.js equivalents
- **Consistency**: Single tool for both linting and formatting (Biome, Ruff)
- **Simplicity**: Fewer configuration files, fewer tools to manage
- **Reliability**: Modern tools have fewer edge cases and better error messages

### Implementation Approach

1. **Replace one tool at a time**: Don't switch everything overnight
2. **Verify compatibility**: Ensure all team members can use the tool
3. **Document the change**: Update CLAUDE.md, README.md, team.md
4. **Measure improvement**: Track before/after metrics for buy-in

---

## 2. Centralized Configuration

All project configuration lives in a single file per language. No scattered config files.

### Python Configuration
**Location**: `backend/pyproject.toml`

```toml
[project]
name = "agent-team-playground-backend"
version = "0.1.0"
description = "FastAPI backend for agent team"
requires-python = ">=3.10,<3.13"

[project.dependencies]
fastapi = "^0.109.0"
uvicorn = "^0.27.0"
sqlalchemy = "^2.0"
pydantic = "^2.0"

[project.optional-dependencies]
dev = ["pytest", "ruff", "mypy"]

[tool.ruff]
line-length = 100
select = ["E", "W", "F", "I", "C", "B", "UP", "ARG", "C90", "ICN", "PIE", "T201", "PT"]

[tool.pytest.ini_options]
minversion = "7.0"
testpaths = ["tests"]
```

**Benefits**:
- ✅ Single source of truth for Python configuration
- ✅ No requirements.txt, setup.cfg, .pylintrc scattered around
- ✅ PEP 621/517/518 standard (supported by all modern tools)
- ✅ Easy to understand project metadata at a glance

### Node.js Configuration
**Location**: `frontend/package.json`

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
  "dependencies": {
    "next": "^15.0.0",
    "react": "^19.0.0",
    "@prisma/client": "^5.0.0"
  },
  "devDependencies": {
    "biome": "^1.0.0",
    "vitest": "^1.0.0",
    "@playwright/test": "^1.0.0",
    "lint-staged": "^15.0.0"
  },
  "lint-staged": {
    "src/**/*.{js,jsx,ts,tsx}": ["biome check --apply"],
    "prisma/schema.prisma": ["prisma format"]
  }
}
```

**Benefits**:
- ✅ All Node.js configuration in one place
- ✅ No .npmrc, .eslintrc, .prettierrc files
- ✅ `packageManager` field enforces pnpm version for all team members
- ✅ `engines` field specifies Node.js version requirements
- ✅ `lint-staged` configuration for fast pre-commit checks

### Anti-Pattern: Scattered Configuration

❌ Don't do this:
```
frontend/
├── package.json          # Dependencies only
├── .npmrc               # npm configuration
├── .eslintrc            # ESLint rules
├── .prettierrc           # Prettier rules
├── tsconfig.json        # TypeScript rules
├── vitest.config.js     # Test configuration
└── biome.json           # Biome rules (conflicts with ESLint)
```

✅ Do this instead:
```
frontend/
├── package.json         # All config + dependencies
├── tsconfig.json        # TypeScript only (separate standard)
└── biome.json           # Biome only (if needed)
```

---

## 3. Version Pinning

Specify exact versions across three layers to prevent "works on my machine" issues.

### Layer 1: Global Node.js Runtime
**Files**: `.nvmrc` and `.node-version`

```
22.10.0
```

**Tools that read this**:
- `nvm` (Node Version Manager) reads `.nvmrc`
- `nodenv` reads `.node-version`
- Modern IDEs automatically switch Node.js when opening project

**Verification**:
```bash
nvm use      # Switches to Node.js 22.10.0
node --version  # Should output v22.10.0
```

### Layer 2: pnpm Package Manager
**Location**: `frontend/package.json`

```json
{
  "packageManager": "pnpm@9.0.0"
}
```

**How it works**:
1. Corepack (built into Node.js 16.13+) reads `packageManager` field
2. Automatically installs the exact pnpm version specified
3. All team members get the same pnpm version
4. No manual `npm install -g pnpm` needed

**Verification**:
```bash
corepack enable
pnpm --version  # Should output 9.x.x
```

### Layer 3: Python Runtime
**Location**: `backend/pyproject.toml`

```toml
[project]
requires-python = ">=3.10,<3.13"
```

**Meaning**:
- Supports Python 3.10, 3.11, 3.12
- Rejects Python 3.9 and earlier (EOL)
- Rejects Python 3.13+ (may have breaking changes)

**Verification**:
```bash
python --version  # Should output 3.10.x, 3.11.x, or 3.12.x
uv sync           # Respects requires-python constraint
```

### Benefits of Version Pinning

✅ **Reproducibility**: All developers run same tools
✅ **CI/CD Reliability**: GitHub Actions uses same versions as local development
✅ **Dependency Lock**: package-lock.json / pnpm-lock.yaml ensures consistent installs
✅ **Zero Setup Confusion**: No manual version management needed
✅ **Audit Trail**: Git history shows exactly when versions changed

### Anti-Pattern: Loose Versioning

❌ Don't do this:
```json
{
  "engines": {
    "node": ">=18",
    "npm": ">=8"
  }
}
```

❌ Don't do this:
```toml
[project]
requires-python = ">=3.8"
```

✅ Do this instead:
```json
{
  "engines": {
    "node": ">=22.0.0",
    "pnpm": ">=9.0.0"
  }
}
```

```toml
[project]
requires-python = ">=3.10,<3.13"
```

---

## 4. Feature Branch Workflow

Use clear branch naming conventions and atomic commits for better code archaeology.

### Branch Naming Convention

**Format**: `<type>/<description>`

| Type | Purpose | Example |
|------|---------|---------|
| `feat/` | New feature | `feat/user-authentication` |
| `fix/` | Bug fix | `fix/login-token-expiry` |
| `refactor/` | Code restructuring | `refactor/api-error-handling` |
| `docs/` | Documentation only | `docs/setup-guide` |
| `chore/` | Maintenance (deps, config) | `chore/update-node-lts` |
| `test/` | Test improvements | `test/add-e2e-coverage` |

### Example Workflow

```bash
# 1. Create feature branch
git checkout main
git pull origin main
git checkout -b feat/enhance-agent-team

# 2. Make changes (commit frequently)
git add backend/pyproject.toml
git commit -m "feat(config): add Ruff linting configuration"

git add frontend/package.json
git commit -m "feat(config): add biome linting and lint-staged"

# 3. Update documentation alongside code
git add CLAUDE.md README.md
git commit -m "docs: update tooling instructions"

# 4. Push to remote
git push -u origin feat/enhance-agent-team

# 5. Create PR with test plan
gh pr create --title "feat: enhance agent team with modern tooling"
```

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

[agent-action]
Co-Authored-By: <Agent Role> <email>
```

**Example**:
```
feat(backend): add Ruff linting configuration

- Add Ruff to backend/pyproject.toml [tool.ruff]
- Configure line-length = 100
- Select rules: E, W, F, I, C, B, UP, ARG, C90, ICN, PIE, T201, PT
- Update CLAUDE.md with backend linting instructions

[agent-action]
Co-Authored-By: Full Stack Engineer <agent@playground.local>
```

### Branch Lifecycle

1. **Create**: `git checkout -b feat/description`
2. **Develop**: Make commits with atomic changes
3. **Test**: Run linting, tests, pre-commit locally
4. **Push**: `git push -u origin feat/description`
5. **PR**: Create PR with description and test plan
6. **Review**: Address feedback
7. **Merge**: Squash or rebase to main
8. **Delete**: Cleanup feature branch

### Benefits

✅ **Clear History**: Future developers understand what each commit does
✅ **Atomic Commits**: Easier to revert if needed
✅ **Traceability**: Git history shows when/why changes were made
✅ **Parallel Work**: Multiple agents can work on different branches
✅ **Code Review**: Smaller PRs are easier to review

---

## Summary

| Principle | Key Idea | Benefit |
|-----------|----------|---------|
| **Modern Tooling** | Use Rust-based tools | 10x+ faster development |
| **Centralized Config** | Single source of truth | No configuration drift |
| **Version Pinning** | Exact versions everywhere | Reproducible environments |
| **Feature Branches** | Clear naming + atomic commits | Easy code archaeology |

These 4 principles combine to create a high-velocity development environment for the agent team.
