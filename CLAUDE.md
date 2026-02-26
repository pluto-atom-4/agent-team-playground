# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **full-stack agent team playground**—a reference implementation for managing a full-stack development project using a multi-agent system. The repository demonstrates how specialized AI agents (Project Manager, Full Stack Engineer, QA Engineer, DevOps) collaborate via GitHub Issues, Pull Requests, and CLI workflows to build and maintain a complete application.

### Technical Stack

- **Backend**: Python with FastAPI and Model Context Protocol (MCP)
- **Frontend**: Next.js with Prisma ORM
- **Testing**: Vitest (unit/component) and Playwright (E2E)
- **Database**: SQLite for development, PostgreSQL for production
- **Infrastructure**: GitHub Actions for CI/CD

## Agent Team Roles

Each agent has a specific responsibility and toolset:

1. **Project Manager (Orchestrator)**
   - Tools: Claude Code + GitHub CLI
   - Responsibility: Maintains `PLAN.md`, triages GitHub Issues, defines requirements
   - Key Commands: `gh issue list`, `gh pr checkout -b`, `ck /plan`

2. **Full Stack Engineer (Developer)**
   - Tools: Claude Code CLI + Copilot CLI
   - Responsibility: Implements features across FastAPI backend and Next.js frontend
   - Key Workflow: Read FastAPI schema → Generate matching Next.js components → Use Prisma for DB interactions

3. **QA Engineer (Tester)**
   - Tools: Vitest + Playwright + Claude CLI
   - Responsibility: Generates and executes unit and E2E tests
   - Key Command: `npm run test:vitest && npx playwright test`

4. **DevOps (SRE)**
   - Tools: GitHub Actions + GitHub CLI
   - Responsibility: Manages SQLite → PostgreSQL promotion, validates migrations, maintains CI/CD pipeline
   - Key Command: `npx prisma migrate deploy`

## Development Workflow

### Phase A: Issue & Planning
1. Create issue: `gh issue create --title "Feature: ..." --body "..."`
2. Project Manager updates `PLAN.md` with requirements
3. Assign to appropriate agent

### Phase B: Development
1. Create feature branch: `gh pr checkout -b feature/[name]`
2. Full Stack Engineer implements feature:
   - Backend: FastAPI endpoint with MCP documentation
   - Frontend: Next.js component with Prisma queries
3. Commit with message tagged `[agent-action]` for audit trail

### Phase C: Validation
1. QA Engineer runs tests: `npm run test:vitest && npx playwright test`
2. DevOps validates migrations if schema changed
3. Create PR: `gh pr create --title "feat: ..." --body "..."`
4. Check status: `gh pr checks`

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
- `qa-test`: Run all tests (Vitest + Playwright)
- `db-migrate`: Execute database migrations

### `.claude/agents/team.md`
Defines the multi-agent system with clear role separation and responsibilities.

### `.github/workflows/agentic-dev.md`
Agentic workflow for automated PR validation:
- Checks for Prisma schema changes
- Validates database migrations
- Runs Playwright test suite
- Verifies FastAPI MCP documentation

## Agent-Handshake Protocol

To prevent conflicts between agents:
1. Check if GitHub Issue is assigned before modifying code
2. End each agent-led session with commit tagged `[agent-action]`
3. Use GitHub Issue status to coordinate handoffs between agents

## Getting Started

When initializing the project with actual code:

1. **Create backend directory**: `mkdir -p backend && cd backend`
   - Initialize FastAPI project with `pip install fastapi uvicorn sqlalchemy`
   - Implement MCP endpoints to expose API capabilities to agents

2. **Create frontend directory**: `mkdir -p frontend && cd frontend`
   - Initialize Next.js: `npx create-next-app@latest`
   - Install Prisma: `npm install @prisma/client prisma`
   - Install test tools: `npm install -D vitest @testing-library/react playwright`

3. **Database Setup**:
   - Configure `prisma/schema.prisma` with SQLite for dev
   - Environment variables will switch to PostgreSQL in production

4. **Create PLAN.md**: Document project roadmap and feature backlog

Refer to `start-from-here.md` for the complete detailed implementation guide.
