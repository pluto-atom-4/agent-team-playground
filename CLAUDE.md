# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **full-stack agent team playground**—a reference implementation for managing a full-stack development project using a multi-agent system. The repository demonstrates how specialized AI agents (Project Manager, Full Stack Engineer, QA Engineer, DevOps) collaborate via GitHub Issues, Pull Requests, and CLI workflows to build and maintain a complete application.

### Technical Stack

- **Backend**: Python 3.10-3.12 with FastAPI and Model Context Protocol (MCP)
  - Configuration: `backend/pyproject.toml` (centralized project metadata, dependencies, tool settings)
  - Package Manager: uv (fast Python installer)
  - Linting: Ruff (configured in pyproject.toml)
  - Testing: pytest (configured in pyproject.toml)
- **Frontend**: Next.js with Prisma ORM
  - Package Manager: pnpm (fast Node.js manager)
  - Linting: Biome (JavaScript/TypeScript)
- **Testing**: Vitest (unit/component) and Playwright (E2E)
- **Database**: SQLite for development, PostgreSQL for production
- **Code Quality**: Ruff (Python), Biome (frontend), pre-commit (hooks)
- **Infrastructure**: GitHub Actions for CI/CD

## Agent Team Roles

Each agent has a specific responsibility and toolset:

1. **Project Manager (Orchestrator)**
   - Tools: Claude Code + GitHub CLI
   - Responsibility: Maintains `PLAN.md`, triages GitHub Issues, defines requirements
   - Key Commands: `gh issue list`, `gh pr checkout -b`, `ck /plan`

2. **Full Stack Engineer (Developer)**
   - Tools: Claude Code CLI + Copilot CLI + Ruff + Biome
   - Responsibility: Implements features across FastAPI backend and Next.js frontend
   - Key Workflow: Read FastAPI schema → Generate matching Next.js components → Use Prisma for DB interactions
   - **Backend**: Code is linted via Ruff (configured in `backend/pyproject.toml`)
     - Run: `uv run ruff check --fix` (Ruff settings read from pyproject.toml)
     - Run: `uv run pytest` (tests defined in pyproject.toml)
   - **Frontend**: Code is linted via Biome
     - Run: `pnpm run lint`

3. **QA Engineer (Tester)**
   - Tools: Vitest + Playwright + Claude CLI + pre-commit
   - Responsibility: Generates and executes unit and E2E tests, validates code quality
   - Key Command: `ck qa-test` (runs all tests)

4. **DevOps (SRE)**
   - Tools: GitHub Actions + GitHub CLI + uv + pre-commit
   - Responsibility: Manages SQLite → PostgreSQL promotion, validates migrations, maintains CI/CD pipeline, enforces code quality
   - **Python Configuration**: Manages `backend/pyproject.toml` as source of truth
     - Dependencies in `[project.dependencies]` and `[project.optional-dependencies]`
     - Ruff configuration in `[tool.ruff]` section
     - Pytest configuration in `[tool.pytest.ini_options]`
   - Key Commands: `ck db-migrate`, `pre-commit run --all-files`, `uv sync`

## Development Workflow

### Phase A: Issue & Planning
1. Create issue: `gh issue create --title "Feature: ..." --body "..."`
2. Project Manager updates `PLAN.md` with requirements
3. Assign to appropriate agent

### Phase B: Development
1. Create feature branch: `gh pr checkout -b feature/[name]`
2. Full Stack Engineer implements feature:
   - Backend: FastAPI endpoint with MCP documentation
     - Dependencies defined in `backend/pyproject.toml` (auto-installed via `uv sync`)
     - Run: `uv run ruff check --fix` (Ruff settings from pyproject.toml)
     - Run: `uv run pytest` (pytest config from pyproject.toml)
   - Frontend: Next.js component with Prisma queries, run `pnpm run lint` to check code quality
3. Commit with message tagged `[agent-action]` for audit trail

### Phase C: Validation
1. QA Engineer runs tests:
   - Backend: `cd backend && uv run pytest` (pytest configured in pyproject.toml)
   - Frontend: `ck qa-test` (runs: `pnpm test:vitest && pnpm exec playwright test`)
2. DevOps validates migrations if schema changed: `ck db-migrate`
3. Verify code quality passes pre-commit: `pre-commit run --all-files`
4. Create PR: `gh pr create --title "feat: ..." --body "..."`
5. Check status: `gh pr checks`

## Repository Structure

```
agent-team-playground/
├── .claude/
│   ├── settings.json          # Claude Code configuration & custom commands
│   └── agents/team.md         # Agent team definition and roles
├── .github/workflows/
│   └── agentic-dev.md         # GitHub agentic workflow for PR validation
├── backend/                   # FastAPI application (to be created)
├── frontend/                  # Next.js application (to be created)
└── PLAN.md                    # Project roadmap & task tracking
```

## Key Configuration Files

### `.claude/settings.json`
Defines custom commands for agent team workflows:
- `pm-sync`: Sync GitHub issues and plan
- `qa-test`: Run all tests (Vitest + Playwright with pnpm)
- `db-migrate`: Execute database migrations with uv
- `backend-lint`: Run Ruff linting on Python code
- `frontend-lint`: Run Biome linting on frontend code
- `pre-commit-check`: Verify all pre-commit hooks pass

### `.claude/agents/team.md`
Defines the multi-agent system with clear role separation and responsibilities, including modern tooling (Ruff, Biome, pre-commit).

### `.github/workflows/agentic-dev.md`
Agentic workflow for automated PR validation:
- Checks for Prisma schema changes
- Validates database migrations with pnpm
- Runs test suite with pnpm
- Verifies FastAPI MCP documentation with uv
- Validates pre-commit hooks pass

### `.pre-commit-config.yaml`
Multi-language pre-commit hooks configuration (Python + JavaScript):
- **General**: Merge conflicts, file size limits, trailing whitespace, end-of-file fixes
- **Backend (Python)**: Ruff linting and formatting for `backend/` and `scripts/`
- **Frontend (JavaScript/TypeScript)**: Biome via local hook running `pnpm exec biome`
- **Security**: Secrets detection (API keys, tokens, credentials)
- **Dependency Safety**: Forbids CRLF line endings and new Git submodules

**Installation**:
```bash
uv tool install pre-commit --with pre-commit-uv  # pre-commit-uv makes hooks faster
pre-commit install  # Install git hooks
pre-commit run --all-files  # Run on all files
```

**Optional Enhancement**: Use `lint-staged` in frontend for checking only changed files

## Agent-Handshake Protocol

To prevent conflicts between agents:
1. Check if GitHub Issue is assigned before modifying code
2. End each agent-led session with commit tagged `[agent-action]`
3. Use GitHub Issue status to coordinate handoffs between agents

## Getting Started

When initializing the project with actual code:

1. **Create backend directory with pyproject.toml**: `mkdir -p backend && cd backend`
   - Initialize Python environment with uv: `uv venv`
   - Create `backend/pyproject.toml` with centralized project configuration:
     - Project metadata (name, version, description)
     - Dependencies and optional dev dependencies
     - Tool configurations: Ruff, pytest, mypy, coverage, isort
     - Python version: `>=3.10,<3.13` (supports 3.10, 3.11, 3.12)
   - Install all dependencies: `uv sync` (reads from pyproject.toml)
   - Implement MCP endpoints to expose API capabilities to agents
   - Run linting: `uv run ruff check --fix` (uses Ruff config from pyproject.toml)
   - Run tests: `uv run pytest` (uses pytest config from pyproject.toml)

2. **Create frontend directory**: `mkdir -p frontend && cd frontend`
   - Initialize Next.js with pnpm: `pnpm create next-app@latest frontend --use-pnpm`
   - Install Prisma: `pnpm add @prisma/client prisma`
   - Install test tools: `pnpm add -D vitest @testing-library/react @playwright/test biome`
   - Run linting: `pnpm run lint`

3. **Set Up Code Quality**:
   - Install pre-commit with uv: `uv tool install pre-commit --with pre-commit-uv`
   - Initialize hooks: `pre-commit install`
   - Run all hooks: `pre-commit run --all-files`
   - Optional: Add lint-staged to frontend for faster checks on changed files only

4. **Database Setup**:
   - Configure `prisma/schema.prisma` with SQLite for dev
   - Environment variables will switch to PostgreSQL in production

5. **Create PLAN.md**: Document project roadmap and feature backlog

**Key: pyproject.toml is the source of truth for Python configuration**
- All dependencies managed in one file
- Tool settings (Ruff, pytest, mypy, etc.) centralized
- Supports modern Python packaging standards
- Easily reproducible builds with `uv sync`

Refer to README.md for the complete step-by-step implementation guide with modern tooling.
