# Reference: Benchmarks, Metrics & Resources

Performance data, success metrics, and links to external documentation.

---

## Performance Benchmarks

### Development Workflow Timeline

#### Before Modern Tooling (Legacy Stack)

**Setup Time** (first-time developer):
- npm install: 45-60 seconds
- eslint/prettier setup: 30 minutes (npm install + config)
- Python pip install: 60-90 seconds
- Total: ~90 minutes

**Development Cycle** (per commit):
- npm install: 15-20 seconds
- npm run lint: 3-5 seconds
- npm run prettier: 2-3 seconds
- pasting eslint/prettier: 10-15 seconds
- pytest run: 10-15 seconds
- **Total per commit**: 40-60 seconds

**CI/CD Pipeline**:
- GitHub Actions npm install: 20-30 seconds
- ESLint check: 5-10 seconds
- Prettier format: 3-5 seconds
- pytest run: 15-20 seconds
- Total: 45-70 seconds

#### After Modern Tooling (Optimized Stack)

**Setup Time** (first-time developer):
- pnpm install (via corepack): 5-8 seconds
- uv sync (Python): 10-15 seconds
- pre-commit setup: 5-10 seconds
- Total: ~30 seconds (3x faster!)

**Development Cycle** (per commit):
- pnpm install: 2-3 seconds (if needed)
- Biome check: 0.5-1 second
- Ruff check: 0.5-1 second
- lint-staged (changed files only): 0.5-1 second
- pytest run: 5-8 seconds
- **Total per commit**: 7-14 seconds (4-5x faster!)

**CI/CD Pipeline**:
- GitHub Actions pnpm install: 3-5 seconds
- Biome check: 0.5-1 second
- Ruff check: 0.5-1 second
- pytest run: 5-8 seconds
- Total: 9-15 seconds (5x faster!)

### Detailed Tool Comparison

| Tool Category | Old | New | Speedup | Notes |
|---------------|-----|-----|---------|-------|
| **Node.js Package Manager** | npm | pnpm (corepack) | 30-50x | pnpm uses hard links, corepack manages versions |
| **JavaScript Linter** | ESLint | Biome | 10-20x | Single tool for linting + formatting |
| **Python Package Manager** | pip | uv | 10-100x | Rust-based, parallel downloads |
| **Python Linter** | flake8 | Ruff | 10-100x | Rust-based, checks faster |
| **JavaScript Formatter** | Prettier | Biome | 10x | Integrated with Biome linter |
| **Pre-commit Hook Time** | husky/lint-staged (slow) | pre-commit + lint-staged | 10x | Only checks changed files |

### Real-World Metrics

**Team of 4 developers, 100 commits/week**:

| Metric | Before | After | Savings |
|--------|--------|-------|---------|
| Setup time per developer | 90 min | 30 min | 60 min × 4 = 4 hours |
| Commit hook time per commit | 40-60s | 7-14s | 30-50s × 100 = 50-80 min |
| CI/CD time per PR | 45-70s | 9-15s | 30-60s × 10 PRs/week = 5-10 min |
| **Total weekly savings** | - | - | **6-8 hours/week** |

**Annual impact** (52 weeks × 7 hours):
- **364 developer-hours saved per year**
- Equivalent to **1.7 FTE** (full-time engineer)

---

## Success Metrics

### Phase Completion Checklist

#### Phase 1: Audit (Completion = 100%)
- [ ] `backend/pyproject.toml` reviewed
- [ ] `frontend/package.json` reviewed
- [ ] `.nvmrc` and `.node-version` verified
- [ ] `.pre-commit-config.yaml` reviewed
- [ ] Current state documented
- **Completion Status**: Audit complete ✓

#### Phase 2: Configuration (Completion = 100%)
- [ ] `backend/pyproject.toml` updated with all sections
- [ ] `frontend/package.json` updated with packageManager + engines
- [ ] `.nvmrc` and `.node-version` created (22.10.0)
- [ ] `.pre-commit-config.yaml` configured with Ruff + lint-staged
- [ ] `uv sync` runs successfully
- [ ] `pnpm install` runs successfully
- [ ] All linting passes: `uv run ruff check` + `pnpm run lint`
- **Completion Status**: Configuration complete ✓

#### Phase 3: Documentation (Completion = 100%)
- [ ] README.md Step 0 added for Node.js setup
- [ ] Frontend setup docs updated (pnpm instead of npm)
- [ ] Code quality checks section updated
- [ ] CLAUDE.md updated with Node.js guidance
- [ ] `.claude/agents/team.md` updated with responsibilities
- [ ] PLAN.md technology stack updated
- [ ] All documentation links verified
- **Completion Status**: Documentation complete ✓

#### Phase 4: CI/CD (Completion = 100%)
- [ ] GitHub Actions uses Node.js 22 LTS
- [ ] GitHub Actions enables corepack
- [ ] GitHub Actions uses `uv sync` for Python
- [ ] GitHub Actions uses `pnpm install` for Node.js
- [ ] Pre-commit validation runs in CI/CD
- [ ] Test suite passes in CI/CD
- [ ] Linting passes in CI/CD
- [ ] Pipeline time is 30-50% faster than before
- **Completion Status**: CI/CD complete ✓

### Team Adoption Metrics

Track these metrics to measure team adoption of new tooling:

| Metric | Target | How to Measure |
|--------|--------|----------------|
| **Node.js 22 LTS Adoption** | 100% | `node --version` in each PR |
| **pnpm 9+ Adoption** | 100% | `pnpm --version` in CI/CD |
| **Pre-commit Hooks** | 100% | `pre-commit install` confirmation |
| **Ruff Linting** | 100% | `uv run ruff check` passes in CI/CD |
| **Biome Formatting** | 100% | `pnpm run lint` passes in CI/CD |
| **Test Coverage** | >80% | Coverage report in each PR |
| **Pre-commit Speed** | <5 seconds | `time pre-commit run --all-files` |

### Development Velocity Improvement

Measure velocity improvement over time:

```bash
# Week 1 (before optimization)
- Average PR time: 4-6 hours (including setup, testing, linting)
- Average commit time: 60+ seconds
- CI/CD pipeline: 45-70 seconds

# Week 4 (after optimization)
- Average PR time: 1-2 hours (3x faster)
- Average commit time: 10-15 seconds (4-5x faster)
- CI/CD pipeline: 10-15 seconds (4-5x faster)
```

---

## External Documentation

### Official Resources

#### Node.js & Package Management
- [Node.js Official Site](https://nodejs.org/) - Download LTS versions
- [Node.js 22 LTS Release Notes](https://nodejs.org/en/blog/) - Latest features
- [corepack Documentation](https://nodejs.org/api/corepack.html) - Package manager management
- [pnpm Official Site](https://pnpm.io/) - Package manager docs
- [pnpm Installation](https://pnpm.io/installation) - Setup guide

#### Python & Package Management
- [Python Official Site](https://python.org/) - Downloads
- [uv Package Manager](https://docs.astral.sh/uv/) - Fast Python installer
- [uv Installation](https://docs.astral.sh/uv/getting-started/installation/) - Setup guide
- [pyproject.toml Format](https://packaging.python.org/en/latest/specifications/pyproject-toml/) - Standard

#### Code Quality & Linting
- [Ruff Python Linter](https://docs.astral.sh/ruff/) - Fast Python linter
- [Ruff Configuration](https://docs.astral.sh/ruff/configuration/) - Config options
- [Biome Code Formatter](https://biomejs.dev/) - JavaScript/TypeScript formatter
- [Biome Configuration](https://biomejs.dev/reference/configuration/) - Config options

#### Testing Frameworks
- [pytest Documentation](https://docs.pytest.org/) - Python testing
- [Vitest Documentation](https://vitest.dev/) - JavaScript unit testing
- [Playwright Documentation](https://playwright.dev/) - E2E testing

#### Git & Pre-commit
- [pre-commit Framework](https://pre-commit.com/) - Git hooks
- [pre-commit Hooks Library](https://pre-commit.com/hooks.html) - Available hooks
- [lint-staged](https://github.com/okonet/lint-staged) - Fast pre-commit checks

#### CI/CD
- [GitHub Actions Documentation](https://docs.github.com/en/actions) - CI/CD workflows
- [GitHub Actions Node.js Setup](https://github.com/actions/setup-node) - Node.js in CI
- [GitHub Actions Python Setup](https://github.com/actions/setup-python) - Python in CI

### Project-Specific Files

**Core Configuration**:
- `backend/pyproject.toml` - Python project configuration (PEP 621)
- `frontend/package.json` - Node.js project configuration (npm standard)
- `.nvmrc` - Node.js version for nvm
- `.node-version` - Node.js version for nodenv
- `.pre-commit-config.yaml` - Git hook configuration

**Agent Documentation**:
- `.claude/agents/team.md` - Agent team roles and responsibilities
- `.claude/settings.json` - Claude Code configuration
- `CLAUDE.md` - Developer guidance

**Project Management**:
- `PLAN.md` - Project roadmap and feature backlog
- `README.md` - Setup and getting started guide
- `.github/workflows/agentic-dev.md` - CI/CD workflow documentation

**This Skill**:
- `SKILL.md` - Main skill entry point
- `docs/principles.md` - Core principles
- `docs/phases.md` - Implementation phases
- `docs/agent_roles.md` - Agent responsibilities
- `docs/common_tasks.md` - Common tasks and workflows
- `docs/troubleshooting.md` - Problem-solving guide
- `docs/reference.md` - This file

---

## Version Pinning Reference

### Node.js Versions

**Current LTS**: Node.js 22 LTS
- Release Date: October 2024
- LTS Until: April 2027
- Latest Version: 22.10.0+

**Version Files**:
```
.nvmrc          → 22.10.0
.node-version   → 22.10.0
package.json    → "engines": { "node": ">=22.0.0" }
```

**Installation**:
```bash
# Using nvm
nvm install 22.10.0
nvm use  # Reads from .nvmrc

# Using nodenv
nodenv install 22.10.0
eval "$(nodenv init -)"  # Auto-reads .node-version
```

### pnpm Versions

**Current Version**: 9.0.0+
- Requirement: Node.js 16.13+
- Managed by: corepack (built into Node.js)

**Version Specification**:
```json
{
  "packageManager": "pnpm@9.0.0"
}
```

**Installation**:
```bash
corepack enable
corepack install -g pnpm
```

### Python Versions

**Supported Range**: 3.10, 3.11, 3.12
- Python 3.9: End of life (June 2023)
- Python 3.10: Supported until October 2026
- Python 3.11: Supported until October 2027
- Python 3.12: Supported until October 2028

**Version Specification**:
```toml
[project]
requires-python = ">=3.10,<3.13"
```

**Installation**:
```bash
# Using pyenv
pyenv install 3.12.0
eval "$(pyenv init -)"

# Or system Python
python3 --version  # Ensure 3.10+
```

---

## CLI Quick Reference

### Node.js & pnpm
```bash
nvm use                           # Switch to Node.js 22 (from .nvmrc)
corepack enable                   # Enable corepack
corepack install -g pnpm          # Install pnpm
pnpm install                      # Install dependencies
pnpm run lint                      # Run Biome linting
pnpm test:vitest                  # Run unit tests
pnpm exec playwright test          # Run E2E tests
```

### Python & uv
```bash
uv venv                           # Create virtual environment
source .venv/bin/activate         # Activate venv
uv sync                           # Install dependencies from pyproject.toml
uv run ruff check --fix           # Run Ruff linting
uv run pytest                     # Run tests
uv pip install package-name       # Install package
```

### Git & Pre-commit
```bash
pre-commit install                # Install git hooks
pre-commit run --all-files        # Run all hooks
pre-commit run                    # Run on staged files only
pre-commit autoupdate             # Update hooks
git checkout -b feat/description  # Create feature branch
git commit -m "feat: description" # Commit changes
gh pr create --title "..." --body "..."  # Create PR
```

### GitHub
```bash
gh issue list                     # List open issues
gh issue create --title "..." --body "..."  # Create issue
gh pr list                        # List open PRs
gh pr checkout 42                 # Checkout PR branch
gh pr merge 42 --squash           # Merge PR
gh run list                       # List CI/CD runs
gh run view <run-id>              # View run details
```

---

## Monitoring & Metrics Collection

### Weekly Check-in

```bash
# Measure pre-commit hook time
time pre-commit run --all-files

# Check recent CI/CD times
gh run list --limit 10

# Count commits per developer
git log --since="1 week ago" --pretty=format:"%an" | sort | uniq -c

# Test coverage
pnpm test:coverage
uv run pytest --cov
```

### Monthly Review

```bash
# Check for dependency updates
uv pip list --outdated
pnpm outdated

# Check for security vulnerabilities
uv pip audit
pnpm audit

# Review pre-commit hook versions
pre-commit autoupdate --dry-run

# Count issues and PRs
gh issue list --state open
gh pr list --state open
```

### Quarterly Planning

1. **Assess team velocity**
   - Count PRs merged
   - Calculate average PR time
   - Measure test coverage

2. **Review tooling performance**
   - Compare setup time vs. 3 months ago
   - Compare commit time vs. 3 months ago
   - Analyze CI/CD pipeline time

3. **Plan improvements**
   - Update Node.js LTS if new release
   - Upgrade critical dependencies
   - Refactor slow tests
   - Optimize CI/CD workflow

---

## Troubleshooting Quick Links

| Problem | Solution |
|---------|----------|
| pnpm not found | See [troubleshooting.md](./troubleshooting.md#problem-pnpm-command-not-found) |
| Pre-commit too slow | See [troubleshooting.md](./troubleshooting.md#problem-pre-commit-hooks-too-slow-10-seconds) |
| Ruff formatting differs | See [troubleshooting.md](./troubleshooting.md#problem-ruff-formatting-differs-from-team) |
| Biome conflicts with ESLint | See [troubleshooting.md](./troubleshooting.md#problem-biome-formatting-differs-from-eslint) |
| uv sync fails | See [troubleshooting.md](./troubleshooting.md#problem-uv-sync-fails-with-dependency-conflict) |
| Vitest flaky | See [troubleshooting.md](./troubleshooting.md#problem-vitest-tests-fail-randomly-flaky) |
| Playwright timeout | See [troubleshooting.md](./troubleshooting.md#problem-playwright-test-timeout) |

---

## Glossary

**corepack**: Node.js built-in package manager manager (since v16.13)
- Automatically installs and manages pnpm, npm, yarn versions
- Reads version from `packageManager` field in package.json
- No manual install needed

**uv**: Fast Python package installer written in Rust
- 10-100x faster than pip
- Supports all pip features
- Integrated with pyproject.toml

**Ruff**: Fast Python linter and formatter written in Rust
- 10-100x faster than flake8/black
- Single tool for linting and formatting
- Configured in pyproject.toml

**Biome**: Fast JavaScript/TypeScript formatter and linter
- 10x faster than ESLint + Prettier combined
- Single tool for linting and formatting
- Replaces ESLint, Prettier, and others

**lint-staged**: Run linters on changed files only
- Configured in package.json
- Runs via git hooks (pre-commit)
- Typical time: 0.5-1 second (vs 5-10s without)

**pre-commit**: Git hooks framework
- Define hooks in .pre-commit-config.yaml
- Run automatically before commits
- Prevents bad code from being committed

**Playwright**: Browser automation for E2E testing
- Supports Chrome, Firefox, Safari
- Run E2E tests in real browser
- Generates test reports

**Vitest**: JavaScript unit test framework
- Similar API to Jest
- 10x faster startup time
- Works with React components

---

## Contact & Support

For questions about benchmarks or metrics:

1. **Review this document** - Check Glossary or CLI Quick Reference
2. **Check troubleshooting guide** - Likely issues covered in [troubleshooting.md](./troubleshooting.md)
3. **Ask your team** - Post in GitHub Issues with performance data
4. **Consult external docs** - Links in External Documentation section above

