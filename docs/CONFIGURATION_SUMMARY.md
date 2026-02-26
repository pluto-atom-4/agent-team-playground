# Agent Team Playground - Configuration Summary

**Created**: 2026-02-26
**Repository**: https://github.com/pluto-atom-4/agent-team-playground
**Purpose**: Reference implementation for managing full-stack development with a coordinated team of AI agents

---

## Overview

The agent-team-playground is a fully configured project that demonstrates how specialized AI agents can collaborate effectively to build, test, and deploy a complete full-stack application. This document summarizes the configuration, structure, and operational workflows.

---

## Technology Stack

| Component | Technology | Purpose |
|-----------|-----------|---------|
| **Backend Framework** | FastAPI + SQLAlchemy | Type-safe RESTful API with async support |
| **API Discovery** | Model Context Protocol (MCP) | Enables agents to discover and understand API endpoints |
| **Frontend Framework** | Next.js + React | Modern web application with server/client components |
| **Database ORM** | Prisma | Type-safe, multi-database ORM for frontend and backend |
| **Development DB** | SQLite | Local development with zero setup |
| **Production DB** | PostgreSQL | Scalable production database |
| **Unit Testing** | Vitest | Fast unit and component tests |
| **E2E Testing** | Playwright | Browser-based end-to-end testing |
| **CI/CD** | GitHub Actions | Automated validation, testing, and deployment |
| **Project Management** | GitHub Issues + PLAN.md | Centralized task tracking and coordination |

---

## Agent Team Structure

### Four Specialized Roles

```
┌─────────────────────────────────────────────────────────┐
│         Agent Team: Playground Development              │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  1. PROJECT MANAGER (Orchestrator)                     │
│     Tools: Claude Code + GitHub CLI                    │
│     Responsibility: Planning, issue triage, PLAN.md    │
│                                                         │
│  2. FULL STACK ENGINEER (Developer)                    │
│     Tools: Claude Code + Copilot CLI                   │
│     Responsibility: FastAPI backend + Next.js frontend │
│                                                         │
│  3. QA ENGINEER (Tester)                               │
│     Tools: Vitest + Playwright + Claude CLI            │
│     Responsibility: Unit tests + E2E tests             │
│                                                         │
│  4. DEVOPS (SRE)                                        │
│     Tools: GitHub Actions + Prisma CLI                 │
│     Responsibility: Migrations, CI/CD, DB management   │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## Configuration Files

### 1. `.claude/settings.json`

**Purpose**: Defines Claude Code environment and custom commands for agent workflows

**Key Configuration**:
```json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  },
  "commands": {
    "pm-sync": "gh issue list --label 'priority' && ck /plan",
    "qa-test": "npm run test:vitest && npx playwright test",
    "db-migrate": "npx prisma migrate dev && python -m scripts.migrate_sqlite_to_pg"
  },
  "hooks": {
    "post-edit": "npx vitest run --changed"
  }
}
```

**Features**:
- ✓ Experimental agent team feature enabled
- ✓ Custom commands for each agent role
- ✓ Post-edit hook automatically runs changed tests

---

### 2. `.claude/agents/team.md`

**Purpose**: Defines the multi-agent team structure with clear responsibilities

**Content**:
- **Team Name**: `playground-team`
- **Agent Definitions**: Four roles with specific responsibilities
- **Coordination Protocol**: Agent-handshake mechanism to prevent conflicts
- **Commit Format**: Tagged `[agent-action]` for audit trail
- **Tools & Technologies**: Summary table of each agent's toolset
- **Initialization Checklist**: Pre-launch validation

**Key Principles**:
1. One agent per task to avoid merge conflicts
2. All commits tagged with `[agent-action]` for traceability
3. GitHub Issues used for task assignment and coordination
4. Clear hand-off protocol between agents

---

### 3. `.github/workflows/agentic-dev.md`

**Purpose**: Defines the automated PR validation workflow

**Five-Step Validation Pipeline**:

1. **Schema Detection**
   - Identifies if Prisma schema was modified
   - Triggers migration validation if schema changed

2. **Migration Validation**
   - Tests migrations against SQLite (dev)
   - Tests migrations against PostgreSQL (prod) via temporary container
   - Prevents incompatible schema changes from reaching production

3. **Test Suite Execution**
   - Runs Vitest unit/component tests
   - Runs Playwright E2E tests
   - Reports coverage metrics (target: >80%)
   - Comments PR with results

4. **MCP Documentation Verification**
   - Validates all FastAPI endpoints have MCP documentation
   - Ensures endpoint parameters are properly typed
   - Checks that documentation is discoverable by agents

5. **Workflow Summary Comment**
   - Posts comprehensive validation results
   - Labels PR appropriately
   - Indicates if ready for review or needs changes

---

### 4. `PLAN.md`

**Purpose**: Source of truth for project status, feature backlog, and agent assignments

**Sections**:
- **Project Vision**: Objectives and key goals
- **Technology Stack**: Component matrix with purposes
- **Feature Backlog**: Three-phase rollout (Foundation, Enhancement, Production)
- **Agent Assignments**: Current sprint tasks with priority and status
- **Dependency Chain**: Visual task dependencies
- **Definition of Done**: Criteria for feature completion
- **Success Metrics**: Measurable outcomes
- **FAQ**: Common questions and answers

**Features**:
- ✓ Centralized task tracking
- ✓ Clear assignment and ownership
- ✓ Phase-based roadmap
- ✓ Dependency visualization

---

### 5. `CLAUDE.md`

**Purpose**: Guidance for Claude Code instances working in this repository

**Content**:
- Project overview and vision
- Agent team roles and responsibilities
- Development workflow (3 phases)
- Repository structure and file organization
- Configuration file references
- Agent-handshake protocol
- Getting started instructions

---

## Development Workflow

### Phase A: Planning & Issue Creation

1. **Project Manager** reviews backlog and creates GitHub Issues
2. Issues are labeled by priority and assigned to agents
3. PLAN.md is updated with task details
4. Tasks wait for agent claim

```bash
# Example command
gh issue create --title "Feature: User Authentication" --body "Implement FastAPI auth endpoints and Next.js login form"
gh issue label 18 --add priority
gh issue assign 18 --assignee @full-stack-engineer
```

### Phase B: Development

1. **Agent** claims issue and creates feature branch
2. Implements code following established patterns
3. Commits with `[agent-action]` tag for audit trail
4. Opens PR when feature is ready

```bash
# Example workflow
gh pr checkout -b feature/user-auth
# ... implementation ...
git commit -m "feat(auth): implement user authentication

- Add /auth/login POST endpoint with JWT generation
- Create Next.js login form component

[agent-action]
Co-Authored-By: Full Stack Engineer <agent@playground.local>"
```

### Phase C: Validation & Merge

1. **GitHub Workflow** automatically validates PR:
   - Runs all tests
   - Validates migrations
   - Checks MCP documentation
   - Posts results comment

2. **QA Agent** reviews test results
3. **DevOps** validates migrations
4. PR is approved and merged to main

```bash
# Check validation status
gh pr checks 18
gh pr view 18 --comments
```

---

## Agent Coordination Mechanisms

### 1. GitHub Issues
- **Purpose**: Task assignment and ownership
- **Usage**: Each feature gets an issue assigned to responsible agent
- **Status**: Labels track progress (todo, in-progress, review, done)

### 2. Pull Requests
- **Purpose**: Code review and integration
- **Workflow**: Automated validation before review
- **Comments**: Agentic workflow posts validation results

### 3. Commit Messages
- **Format**: `<type>(<scope>): <subject>` with `[agent-action]` tag
- **Purpose**: Audit trail showing which agent made changes
- **Example**: `feat(db): add user migration [agent-action]`

### 4. PLAN.md
- **Purpose**: Single source of truth for project status
- **Updates**: Project Manager updates after each phase
- **Visibility**: All agents reference before starting work

### 5. Custom Commands
- **pm-sync**: Project Manager syncs issues and plan
- **qa-test**: QA runs full test suite
- **db-migrate**: DevOps executes migrations

---

## Key Features

### ✓ Automated Quality Gates
- All PRs automatically validated before review
- Migration compatibility tested for both databases
- Test coverage enforced (>80% target)
- MCP documentation verified

### ✓ Clear Role Separation
- Each agent has specific responsibilities
- No overlap in code ownership
- Handoff protocol prevents merge conflicts
- Audit trail tracks all changes

### ✓ Multi-Database Support
- Development with SQLite (zero setup)
- Production with PostgreSQL
- Migrations validated for both
- Environment-specific configuration

### ✓ Comprehensive Testing
- Unit/component tests with Vitest
- E2E tests with Playwright
- Coverage reporting
- Automated test execution on PR

### ✓ Agent-Discoverable API
- FastAPI endpoints documented with MCP
- Enables agents to understand API capabilities
- Type-safe parameter documentation
- Automatic discovery by Claude Code instances

### ✓ CLI-First Workflow
- All operations via GitHub CLI or Claude CLI
- Minimizes context switching
- Terminal-native development
- Integration with standard tools

---

## Repository Structure (After Implementation)

```
agent-team-playground/
├── .claude/
│   ├── settings.json              # Claude Code configuration
│   └── agents/team.md             # Agent team definition
├── .github/workflows/
│   └── agentic-dev.md             # PR validation workflow
├── backend/                       # FastAPI application
│   ├── main.py
│   ├── routes/
│   ├── models/
│   └── scripts/
├── frontend/                      # Next.js application
│   ├── src/
│   │   ├── pages/
│   │   ├── components/
│   │   └── lib/
│   ├── package.json
│   └── playwright.config.ts
├── prisma/
│   └── schema.prisma              # Database schema (source of truth)
├── CLAUDE.md                      # Guidance for Claude Code
├── PLAN.md                        # Project roadmap & tracking
├── README.md                      # Project documentation
└── docs/
    └── CONFIGURATION_SUMMARY.md   # This file
```

---

## Getting Started Checklist

### Prerequisites
- [ ] GitHub account with repository access
- [ ] Claude Code CLI installed (`npm install -g @anthropic/claude-code`)
- [ ] GitHub CLI installed (`brew install gh` or equivalent)
- [ ] Node.js and npm installed
- [ ] Python 3.10+ installed
- [ ] Docker installed (for PostgreSQL testing)

### Initialization Steps
1. [ ] Clone repository
2. [ ] Install backend dependencies: `pip install fastapi sqlalchemy uvicorn`
3. [ ] Initialize frontend: `npx create-next-app@latest frontend`
4. [ ] Install frontend dependencies: `npm install prisma vitest playwright @testing-library/react`
5. [ ] Configure Prisma schema: `npx prisma init`
6. [ ] Create PLAN.md with initial feature backlog
7. [ ] Assign first tasks to agents
8. [ ] Run initial CI/CD pipeline to validate setup

### Validation Commands
```bash
# Verify Claude Code is configured
ck --version

# Check GitHub CLI is connected
gh auth status

# Verify Node.js/npm
node --version && npm --version

# Verify Python
python --version && pip --version

# Verify Docker
docker --version
```

---

## Troubleshooting Guide

### Issue: Agent conflicts on same task
**Solution**: Ensure one agent per issue. Use GitHub Issue assignment to claim work.

### Issue: PR validation fails
**Solution**: Check workflow comments for specific errors. Common causes:
- Missing tests (QA agent should address)
- Migration incompatibility (DevOps agent should fix)
- Missing MPC documentation (Full Stack Engineer should complete)

### Issue: Database migration fails
**Solution**: Run locally first:
```bash
npx prisma migrate dev --name migration_name
npx prisma db push  # To test schema
```

### Issue: Tests failing
**Solution**: Run tests locally and debug:
```bash
npm run test:vitest -- --watch
npx playwright test --headed --debug
```

---

## Advanced Configuration

### Custom Slash Commands

Add more commands to `.claude/settings.json`:

```json
{
  "commands": {
    "backend-lint": "cd backend && flake8 . && black --check .",
    "frontend-lint": "npm run lint",
    "full-test": "npm run test:vitest && npx playwright test && npm run test:coverage",
    "deploy-dev": "vercel deploy --prod",
    "deploy-prod": "vercel deploy --prod --target production"
  }
}
```

### Environment Variables

Create `.env.local` for development:
```
DATABASE_URL=file:./dev.db
NEXT_PUBLIC_API_URL=http://localhost:8000
JWT_SECRET=your-secret-key-here
```

Create environment for CI/CD:
```
# GitHub Secrets
POSTGRES_URL=postgresql://...
VERCEL_TOKEN=...
DOCKER_REGISTRY_TOKEN=...
```

---

## Metrics & Monitoring

### Success Metrics
- ✓ All core features implemented (Phase 1 backlog complete)
- ✓ Test coverage >80%
- ✓ Zero database consistency issues
- ✓ Agent team completes sprints without conflicts
- ✓ PR validation <2 minutes
- ✓ Zero critical bugs in production

### Key Performance Indicators
- Average PR validation time
- Test suite execution time
- Migration validation success rate
- Code coverage percentage
- Agent task completion rate

---

## References

### Internal Documentation
- `CLAUDE.md` - Claude Code guidance and workflow
- `PLAN.md` - Project roadmap and task tracking
- `.claude/agents/team.md` - Agent role definitions
- `.github/workflows/agentic-dev.md` - PR validation details
- `start-from-here.md` - Original implementation guide

### External Resources
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Next.js Documentation](https://nextjs.org/docs)
- [Prisma ORM Guide](https://www.prisma.io/docs/)
- [Model Context Protocol](https://modelcontextprotocol.io)
- [Playwright Testing](https://playwright.dev/)
- [Vitest Documentation](https://vitest.dev/)
- [GitHub CLI Reference](https://cli.github.com/)

---

## Support & Contribution

For issues, questions, or improvements to this configuration:

1. Create a GitHub Issue describing the problem
2. Tag with `config` or `workflow` label
3. Assign to Project Manager agent
4. Provide context and reproduction steps

---

**Last Updated**: 2026-02-26
**Configuration Version**: 1.0
**Status**: Ready for Agent Team Deployment
