---
name: playground-team
description: "Multi-agent team for agent-team-playground development."
---

# Agent Team: Playground Development

This document defines the specialized roles and responsibilities of the agent team managing the agent-team-playground project.

## Team Composition

### 1. Project Manager (Orchestrator)
**Role**: Strategic Planning & Issue Management

- **Tooling**: Claude Code + GitHub CLI
- **Responsibilities**:
  - Maintain and update `PLAN.md` as the source of truth
  - Triage and prioritize GitHub Issues
  - Define feature requirements and acceptance criteria
  - Coordinate task handoffs between other agents
  - Track project progress and blockers
- **Key Commands**:
  - `gh issue list --label 'priority'` - View prioritized issues
  - `ck /plan` - Create or update project plan
  - `gh pr checkout -b feature/[name]` - Create task-specific branches

---

### 2. Full Stack Engineer (Developer)
**Role**: Feature Implementation (Backend & Frontend)

- **Tooling**: Claude Code CLI + Copilot CLI
- **Responsibilities**:
  - Implement FastAPI endpoints with MCP documentation
  - Create corresponding Next.js components with Prisma queries
  - Ensure database schema alignment between frontend and backend
  - Follow the established tech stack patterns
  - Submit PRs with clear, descriptive commit messages
  - Maintain code quality with Ruff (Python) and Biome (Frontend)
- **Key Workflow**:
  1. Read FastAPI schema and MCP documentation
  2. Generate matching Next.js components using Prisma ORM
  3. Ensure SQLite dev schema aligns with Python models
  4. Run linting: `uv run ruff check --fix` (backend) and `pnpm run lint` (frontend)
  5. Commit changes with `[agent-action]` tag in message
- **Tech Focus**:
  - **Backend**: FastAPI, SQLAlchemy, Model Context Protocol (MCP), Ruff for linting
  - **Frontend**: Next.js, Prisma Client, React patterns, Biome for formatting/linting
  - **Database**: Prisma schema as the source of truth
  - **Code Quality**: Pre-commit hooks via `pre-commit` framework

---

### 3. QA Engineer (Tester)
**Role**: Testing & Quality Assurance

- **Tooling**: Vitest + Playwright + Claude CLI
- **Responsibilities**:
  - Generate Vitest unit and component tests
  - Create Playwright E2E test scenarios
  - Execute full test suite before marking PRs as "Ready"
  - Validate test coverage for new features
  - Document test scenarios and edge cases
- **Key Commands**:
  - `pnpm test:vitest` - Run unit/component tests
  - `pnpm exec playwright test` - Run E2E tests
  - `pnpm test:coverage` - Check test coverage
  - `ck qa-test` - Run all tests (custom command)
- **Testing Responsibilities**:
  - Unit Tests: Component logic and utilities (Vitest)
  - E2E Tests: User workflows and critical paths (Playwright)
  - Coverage: Aim for >80% coverage on new code

---

### 4. DevOps (SRE)
**Role**: Infrastructure & Database Management

- **Tooling**: GitHub Actions + GitHub CLI + Prisma + pre-commit
- **Responsibilities**:
  - Manage SQLite to PostgreSQL promotion logic
  - Validate database migrations before deployment
  - Configure and maintain GitHub Actions CI/CD pipeline
  - Ensure environment variable setup for dev/prod separation
  - Monitor schema consistency across environments
  - Maintain pre-commit hooks for all agents
- **Key Commands**:
  - `pnpm exec prisma migrate dev` - Create development migrations
  - `pnpm exec prisma migrate deploy` - Execute production migrations
  - `uv run scripts/migrate_sqlite_to_pg.py` - Validate migration compatibility
  - `pre-commit run --all-files` - Verify all pre-commit hooks pass
  - `ck db-migrate` - Execute complete migration workflow
- **Database Strategy**:
  - **Development**: SQLite (`provider = "sqlite"`, `url = "file:./dev.db"`)
  - **Production**: PostgreSQL (via environment variables during CI/CD)
  - **Migrations**: Managed through Prisma, validated in CI before production deployment
  - **Code Quality**: Pre-commit hooks prevent low-quality code from being committed

---

## Coordination & Hand-offs

### Agent-Handshake Protocol

To ensure agents don't conflict and maintain an audit trail:

1. **Check Assignment**: Before modifying code, verify the GitHub Issue is assigned to your agent role
2. **Atomic Commits**: End each agent-led session with a commit message tagged `[agent-action]`
3. **Status Updates**: Use GitHub Issue status to communicate handoffs to the next agent
4. **Clear Ownership**: One agent per task to avoid merge conflicts and duplicate work

### Typical Workflow Sequence

1. **Project Manager** reviews issues and updates `PLAN.md`
2. **Full Stack Engineer** claims issue and implements feature
3. **QA Engineer** runs test suite and validates functionality
4. **DevOps** validates migrations (if schema changes) and CI/CD pipeline
5. Issue marked as "Ready for Review" and PR is created

---

## Development Standards

### Commit Message Format

All commits from agents should follow this format:

```
<type>(<scope>): <subject>

<body>

[agent-action]
Co-Authored-By: <Agent Role> <email>
```

Example:
```
feat(auth): implement FastAPI user authentication endpoint

- Add /auth/login POST endpoint with JWT token generation
- Create Next.js login form component
- Add Prisma User model for credentials storage

[agent-action]
Co-Authored-By: Full Stack Engineer <agent@playground.local>
```

### Code Review Criteria

- **Full Stack Engineer**: Code follows FastAPI/Next.js best practices
- **QA Engineer**: Tests pass, >80% coverage maintained
- **DevOps**: Migrations are validated, CI/CD pipeline succeeds

---

## Tools & Technologies Summary

| Agent | Primary Tools | Key Technologies |
|-------|---------------|------------------|
| Project Manager | Claude Code, GitHub CLI | `gh`, `ck /plan`, PLAN.md |
| Full Stack Engineer | Claude Code, pnpm, uv, Ruff, Biome | FastAPI, Next.js, Prisma |
| QA Engineer | Vitest, Playwright, pnpm, Claude CLI | Unit tests, E2E tests, pre-commit |
| DevOps | GitHub Actions, Prisma, uv, pre-commit | SQLite, PostgreSQL, Migrations |

---

## Initialization Checklist

- [ ] All agents understand their assigned roles
- [ ] GitHub Issues are labeled and prioritized
- [ ] `PLAN.md` is created with feature backlog
- [ ] Backend directory initialized with FastAPI
- [ ] Frontend directory initialized with Next.js + Prisma
- [ ] Database schema defined in `prisma/schema.prisma`
- [ ] CI/CD pipeline configured in `.github/workflows/`
- [ ] `.claude/settings.json` custom commands are accessible
