# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **full-stack agent team playground**—a reference implementation for managing a full-stack development project using a multi-agent system. The repository demonstrates how specialized AI agents (Project Manager, Full Stack Engineer, QA Engineer, DevOps) collaborate via GitHub Issues, Pull Requests, and CLI workflows to build and maintain a complete application.

### Technical Stack

- **Backend**: Python with FastAPI and Model Context Protocol (MCP)
- **Frontend**: Next.js with Prisma ORM
- **Testing**: Vitest (unit/component) and Playwright (E2E)
- **Database**: SQLite for development, PostgreSQL for production
- **Package Managers**: uv (Python) and pnpm (Node.js) for fast, modern dependency management
- **Code Quality**: Ruff (Python linting), Biome (frontend linting/formatting), pre-commit (hooks)
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
   - Code Quality: Use `uv run ruff check --fix` for backend, `pnpm run lint` for frontend

3. **QA Engineer (Tester)**
   - Tools: Vitest + Playwright + Claude CLI + pre-commit
   - Responsibility: Generates and executes unit and E2E tests, validates code quality
   - Key Command: `ck qa-test` (runs all tests)

4. **DevOps (SRE)**
   - Tools: GitHub Actions + GitHub CLI + uv + pre-commit
   - Responsibility: Manages SQLite → PostgreSQL promotion, validates migrations, maintains CI/CD pipeline, enforces code quality
   - Key Commands: `ck db-migrate`, `pre-commit run --all-files`

## Development Workflow

### Phase A: Issue & Planning
1. Create issue: `gh issue create --title "Feature: ..." --body "..."`
2. Project Manager updates `PLAN.md` with requirements
3. Assign to appropriate agent

### Phase B: Development
1. Create feature branch: `gh pr checkout -b feature/[name]`
2. Full Stack Engineer implements feature:
   - Backend: FastAPI endpoint with MCP documentation, run `uv run ruff check --fix` to lint
   - Frontend: Next.js component with Prisma queries, run `pnpm run lint` to check code quality
3. Commit with message tagged `[agent-action]` for audit trail

### Phase C: Validation
1. QA Engineer runs tests: `ck qa-test` (custom command runs: `pnpm test:vitest && pnpm exec playwright test`)
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
Configuration for pre-commit hooks framework:
- Ruff: Python linting and formatting
- Biome: Frontend linting and formatting
- General hooks: Trailing whitespace, end-of-file fixes, JSON/YAML validation
- Secrets detection: Prevents accidental commits of API keys/tokens

## Agent-Handshake Protocol

To prevent conflicts between agents:
1. Check if GitHub Issue is assigned before modifying code
2. End each agent-led session with commit tagged `[agent-action]`
3. Use GitHub Issue status to coordinate handoffs between agents

## Getting Started

When initializing the project with actual code:

1. **Create backend directory**: `mkdir -p backend && cd backend`
   - Initialize Python environment with uv: `uv venv`
   - Install FastAPI: `uv pip install fastapi uvicorn sqlalchemy ruff`
   - Implement MCP endpoints to expose API capabilities to agents
   - Run linting: `uv run ruff check --fix`

2. **Create frontend directory**: `mkdir -p frontend && cd frontend`
   - Initialize Next.js with pnpm: `pnpm create next-app@latest frontend --use-pnpm`
   - Install Prisma: `pnpm add @prisma/client prisma`
   - Install test tools: `pnpm add -D vitest @testing-library/react @playwright/test biome`
   - Run linting: `pnpm run lint`

3. **Set Up Code Quality**:
   - Install pre-commit: `pip install pre-commit`
   - Initialize hooks: `pre-commit install`
   - Run all hooks: `pre-commit run --all-files`

4. **Database Setup**:
   - Configure `prisma/schema.prisma` with SQLite for dev
   - Environment variables will switch to PostgreSQL in production

5. **Create PLAN.md**: Document project roadmap and feature backlog

Refer to README.md for the complete step-by-step implementation guide with modern tooling.
