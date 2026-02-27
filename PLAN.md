# Project Plan: Agent Team Playground

**Last Updated**: [Timestamp]
**Project Manager**: [Agent Name]
**Repository**: https://github.com/pluto-atom-4/agent-team-playground

---

## Project Vision

Build a production-ready full-stack application managed by a coordinated team of specialized AI agents. The project demonstrates how agents can collaborate effectively through GitHub Issues, Pull Requests, and CLI workflows while maintaining code quality and database integrity.

### Key Objectives

1. Establish a multi-agent development workflow with clear role separation
2. Implement a FastAPI backend with Model Context Protocol (MCP) integration
3. Build a Next.js frontend with Prisma ORM for seamless data access
4. Automate database management across SQLite (dev) and PostgreSQL (prod)
5. Create an automated CI/CD pipeline with agent-aware validation

---

## Technology Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| **Node.js Runtime** | Node.js 22 LTS or later | Modern JavaScript runtime with built-in corepack |
| **Node.js Version Mgmt** | .nvmrc + .node-version | Specify Node.js 22.10.0 (for nvm and nodenv) |
| **Node Package Manager** | pnpm 9+ (via corepack) | Fast, efficient Node.js package manager (auto-managed by corepack) |
| **Backend Framework** | FastAPI + SQLAlchemy | RESTful API with type safety |
| **Backend Config** | pyproject.toml | Centralized Python configuration (dependencies, tools, metadata) |
| **Protocol** | Model Context Protocol (MCP) | Agent-discoverable API endpoints |
| **Frontend Framework** | Next.js + React | Modern web UI (requires Node.js 22 LTS) |
| **Database ORM** | Prisma | Type-safe database access |
| **Database (Dev)** | SQLite | Local development speed |
| **Database (Prod)** | PostgreSQL | Production reliability |
| **Testing (Backend)** | pytest | Python unit and integration tests |
| **Testing (Frontend)** | Vitest + Playwright | Unit and E2E testing |
| **Python Package Manager** | uv | Fast, modern Python installer (uses pyproject.toml) |
| **Python Linter** | Ruff | Fast Python linter/formatter (config in pyproject.toml) |
| **Frontend Linter** | Biome | Fast formatter and linter for JS/TS |
| **Fast Pre-commit** | lint-staged | Only checks changed files on commit (0.5-1s vs 5-10s) |
| **Code Quality** | pre-commit | Automated hooks for code quality gates |
| **CI/CD** | GitHub Actions | Automated validation and deployment |

---

## Feature Backlog

### Phase 1: Foundation (MVP)

- [ ] **Setup**: Project initialization and repository structure
  - [ ] Node.js 22 LTS configured (.nvmrc, .node-version, corepack enabled)
  - [ ] pnpm managed by corepack (packageManager field in package.json)
  - [ ] FastAPI project structure created with pyproject.toml
  - [ ] Next.js project initialized with Prisma and package.json
  - [ ] lint-staged configured for fast pre-commit frontend checks
  - [ ] Pre-commit hooks configured (Ruff for Python, lint-staged for frontend)
  - [ ] CI/CD pipeline configured with pre-commit validation
  - **Assigned to**: DevOps (Node.js/corepack) + Full Stack Engineer (frontend) + QA Engineer (lint-staged)
  - **Status**: Not Started

- [ ] **Core API**: User management endpoints with MCP documentation
  - [ ] POST `/auth/register` - User registration
  - [ ] POST `/auth/login` - User authentication
  - [ ] GET `/users/me` - Current user profile
  - [ ] PUT `/users/{id}` - Update user profile
  - [ ] DELETE `/users/{id}` - Delete user account
  - **Assigned to**: Full Stack Engineer
  - **Status**: Not Started

- [ ] **Frontend Pages**: Authentication and user dashboard
  - [ ] Login page with form validation
  - [ ] Registration page with password strength indicator
  - [ ] User dashboard with profile management
  - [ ] Navigation layout and theme
  - **Assigned to**: Full Stack Engineer
  - **Status**: Not Started

- [ ] **Testing**: Core functionality test coverage
  - [ ] Unit tests for authentication logic (>80% coverage)
  - [ ] E2E tests for user registration and login flows
  - [ ] Database migration validation tests
  - **Assigned to**: QA Engineer
  - **Status**: Not Started

### Phase 2: Enhancement (Post-MVP)

- [ ] Advanced features (to be defined after Phase 1 completion)
- [ ] Performance optimization
- [ ] Security hardening
- [ ] User documentation

### Phase 3: Production Ready

- [ ] Load testing and performance benchmarks
- [ ] Security audit and compliance review
- [ ] Deployment and production monitoring
- [ ] Disaster recovery and backup strategy

---

## Agent Assignments

### Current Sprints

| Task | Assigned To | Priority | Due Date | Status |
|------|------------|----------|----------|--------|
| (None yet) | - | - | - | - |

---

## Dependency Chain

```
Setup (DevOps)
    ↓
Core API (Full Stack Engineer) → Testing (QA Engineer)
    ↓
Frontend Pages (Full Stack Engineer) → Testing (QA Engineer)
    ↓
CI/CD Validation (DevOps)
```

---

## Definition of Done

A feature is considered "Done" when:

1. ✓ Code is implemented and follows established patterns
2. ✓ All unit tests pass (>80% coverage)
3. ✓ All E2E tests pass for user workflows
4. ✓ Database migrations (if any) validated on SQLite and PostgreSQL
5. ✓ MCP documentation is complete (for backend)
6. ✓ PR passes agentic workflow validation
7. ✓ Code review approved by appropriate agent
8. ✓ Merged to main branch

---

## Agent Team Coordination Notes

### How to Escalate Issues

1. **Merge conflicts**: Comment on PR with `@PM` to get Project Manager attention
2. **Technical blockers**: Create a GitHub Issue with label `blocker` and assign to relevant agent
3. **Cross-team concerns**: Update this PLAN.md and tag all relevant agents

### Communication Protocol

- **GitHub Issues**: Feature requests and bug reports
- **GitHub PR Comments**: Code review and technical discussion
- **Commit messages**: Tagged with `[agent-action]` for audit trail
- **PLAN.md**: Source of truth for project status and assignments

---

## Success Metrics

- [ ] All core API endpoints implemented and tested
- [ ] Frontend pages fully functional with E2E test coverage
- [ ] CI/CD pipeline validates all PRs without manual intervention
- [ ] Zero database consistency issues across dev/prod
- [ ] Agent team completes sprints without merge conflicts
- [ ] Test coverage maintained above 80%

---

## Resources & References

- **Agent Team Roles**: See `.claude/agents/team.md`
- **Development Workflow**: See `start-from-here.md`
- **Agentic Validation**: See `.github/workflows/agentic-dev.md`
- **Claude Code Configuration**: See `.claude/settings.json`

---

## Frequently Asked Questions

**Q: How do I claim a task?**
A: Find an unassigned feature in the backlog, create a GitHub Issue, assign it to yourself, and comment with `[agent-action] Starting work on [Feature Name]`.

**Q: What if my PR fails the agentic workflow?**
A: The workflow will comment on your PR with specific errors. Fix the issues (migrations, tests, MCP docs) and push again.

**Q: How do I coordinate with another agent?**
A: Use GitHub Issue assignment and status labels. Update this PLAN.md if the handoff affects the critical path.

**Q: What's the difference between Vitest and Playwright tests?**
A: Vitest runs unit and component tests in Node.js. Playwright runs E2E tests in a real browser to validate user workflows.

---

*This PLAN.md is a living document. Update it as the project progresses and new information becomes available.*
