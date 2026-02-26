# Start a new project managed at github.com (1) utilize agent team to organize members including project manager, full stack engineer, QA engineer, and DevOps. (2) integrate the project with github branch, issues,  and pull requests. (3) utilize Claude code CLI, GitHub CLI, and Copilot CLI. (4) back-end is python and fast API, MCP (5) NextJS, Prisma, Playwright and  vitest for front-end  (6) sqlite for development and postgresql for production.

- Agent Team Organization

  Utilize specialized AI agents to handle project roles. Tools like ClaudeKit or GitHub Copilot custom agents can be configured to act as specific team members. 

  - Project Manager Agent: Use the Planner agent to manage the backlog, triage issues, and define requirements in PLAN.md.
  - Full Stack Engineer Agent: Use the Developer or Coder agent to implement features across the FastAPI backend and Next.js frontend.
  - QA Engineer Agent: Use the Tester agent to generate Playwright E2E tests and Vitest unit tests.
  - DevOps Agent: Use the Infrastructure agent to manage GitHub Actions and deployment workflows. 

- Integrated Workflow (CLI & GitHub)

  Combine GitHub CLI (gh), Copilot CLI, and Claude Code for a seamless terminal-to-GitHub workflow. 

  - Issue & Branch Management:
    - Create an issue: gh issue create --title "Feature: User Auth" --body "Implement FastAPI auth".
    - Create a branch: gh pr checkout -b feature/auth.
  - AI-Powered Development:
    - Use Claude Code for project-wide editing and complex planning (/plan, /code).
    - Use Copilot CLI for quick command suggestions and real-time code snippets.
  - Pull Request Automation:
    - Open PRs directly from CLI: gh pr create --fill.
    - Automate PR descriptions and reviews using PR-Agent via GitHub Actions. 

- Technical Stack Implementation

  Configure your hybrid Python/TypeScript environment with dual-database support. 

  - Backend (Python/FastAPI/MCP):
    - Implement Model Context Protocol (MCP) to make your API discoverable by AI agents.
    - Use SQLAlchemy or Tortoise-ORM for Python-side database interactions.
  - Frontend (Next.js/Prisma):
    - Use Prisma as the primary ORM for the frontend-to-DB layer.
    - Configure Vitest for component testing and Playwright for browser-based E2E testing.
  - Database Strategy:
    - Development: Use SQLite for local speed and simplicity.
    - Production: Deploy with PostgreSQL. Manage migrations via Prisma (npx prisma migrate deploy) to ensure schema consistency across environments. 


## 1. Project Initialization & Repository Setup

Create your repository on GitHub and initialize the local environment. 

- Create Repo: Initialize a new repository on GitHub.com.
- Local Setup:
  ```bash
  # 1. Initialize the repo
gh repo create agent-team-playground --public --clone && cd agent-team-playground

# 2. Setup Claude project-level config
mkdir -p .claude/agents .github/workflows
touch .claude/settings.json .claude/agents/team.md .github/workflows/agentic-dev.md

# 3. Initialize Claude Code
claude /init

  ```


## 2. Agent Team Organization

Instead of generic roles, configure Claude Code and GitHub Actions to function as a **multi-agent system** that interacts via `PLAN.md` and GitHub Issues.


- The Orchestrator (Project Manager):
  - Tooling: Claude Code + GitHub CLI.
  - Workflow: The PM agent uses `gh issue list` to identify priorities, updates the PLAN.md file (the project's "Source of Truth"), and creates task-specific branches using `gh pr checkout -b`.
- The Feature Lead (Full Stack Engineer):
  - Tooling: Claude Code CLI + Copilot CLI.
  - Workflow: Use Claude’s /code command to read the FastAPI schema and generate matching Next.js components. It uses Prisma to bridge the database gap, ensuring the SQLite dev schema aligns with the Python models.
- The Gatekeeper (QA Engineer):
  - Tooling: Vitest + Playwright + Claude CLI.
  - Workflow: Before any PR is marked "Ready," the QA agent runs `ck run "Generate Vitest for [new component] and Playwright for [user flow]"`. It executes tests locally using `npm test` before pushing.
- The SRE (DevOps):
  - Tooling: GitHub Actions + GitHub CLI.
  - Workflow: Manages the transition from SQLite to PostgreSQL. It scripts the CI pipeline to run `prisma migrate` deploy against a temporary Postgres container to validate migrations before they hit production.


## 3. Integrated Workflow (CLI-First)

This workflow minimizes context switching by keeping the agent and developer in the terminal.

### Phase A: Initialization & Tasking

1. Copilot CLI helps you find the right command: `gh ?? create an issue for fastapi mcp integration`.
2. Claude Code analyzes the codebase: `ck "Review current FastAPI routes and list missing MCP endpoints in a new GitHub issue"`.

### Phase B: Autonomous Development Loop

1. Sync: ck sync to pull latest context.
2. Execute: Use Claude to build the feature:
   - ` ck "Create a FastAPI endpoint for [Feature] and a corresponding Next.js page using Prisma for data fetching."`
3. Refine: Use Copilot CLI for quick fixes: gh cs "Fix the python type hint error in main.py".


### Phase C: Validation & Pull Request

1. Test: ck "Run playwright tests. If they fail, fix the Next.js code until they pass."
2. Submit:
   - `gh pr create --title "feat: mcp integration" --body "$(ck 'summarize my changes for a PR description')"`
3. Review: Use GitHub CLI to check status: gh pr checks.



## The "Agent-Handshake" Protocol

To ensure these agents don't conflict, implement a Locking Mechanism:

- Agents must check if a GitHub Issue is assigned to agent-claude before modifying code.
- Every agent-led session must end with a commit message tagged [agent-action] to maintain a clear audit log in the GitHub history.

## 4. Technical Stack Implementation

Configure your hybrid Python/TypeScript environment with dual-database support. 

- Backend (Python/FastAPI/MCP):
   - Implement Model Context Protocol (MCP) to make your API discoverable by AI agents.
   - Use SQLAlchemy or Tortoise-ORM for Python-side database interactions.
- Frontend (Next.js/Prisma):
  - Use Prisma as the primary ORM for the frontend-to-DB layer.
  - Configure Vitest for component testing and Playwright for browser-based E2E testing.
- Database Strategy:
  - Development: Use SQLite for local speed and simplicity.
  - Production: Deploy with PostgreSQL. Manage migrations via Prisma (npx prisma migrate deploy) to ensure schema consistency across environments.
  
---

## To initialize the agent-team-playground repository with your specialized AI agent team and integrated CLI workflow, follow this configuration guide for your `.claude/` and `.github/` directories.


### 1. Claude Code Configuration (`.claude/`)

The .claude/ directory is the brain of your local agentic workflow. Use it to define project-specific roles and automation. 

- File: `.claude/settings.json`
  Enable the experimental agent team feature and define custom slash commands to bridge GitHub and your tech stack.

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

- File: `.claude/agents/team.md`
  Define sub-agents as Markdown files with YAML frontmatter. This allows Claude to spawn specialized instances for specific tasks.


```markdown
---
name: playground-team
description: "Multi-agent team for agent-team-playground development."
---
## Roles
- **Project Manager**: Maintains `PLAN.md` and uses `gh` to track progress.
- **Full Stack Engineer**: Focuses on **FastAPI (MCP)** and **NextJS (Prisma)**.
- **QA Engineer**: Writes and executes **Playwright** and **Vitest** suites.
- **DevOps**: Manages the **SQLite** to **PostgreSQL** promotion logic.

```

### 2. GitHub Integrated Workflow (.github/)

Use GitHub Agentic Workflows (gh-aw) to turn natural language instructions into automated Actions. 

- File: `.github/workflows/agentic-dev.md`
  This file describes an agent that automatically reviews Pull Requests and validates the dual-database setup.

```markdown
---
name: Agentic PR Validator
on: [pull_request]
tools: [edit, shell, github-pr-review]
permissions: [write-all]
---
1. Check if the PR changes the Prisma schema.
2. If changed, run the `db-migrate` command defined in `.claude/settings.json`.
3. Run Playwright tests and comment on the PR with a summary of the test coverage.
4. If the stack uses FastAPI, verify the MCP entry points are properly documented.

```

### 3. Core Tech Stack Integration

Ensure your agents understand the specific boundary between your dev and production environments.

- Database Management: Use your DevOps agent to manage `prisma/schema.prisma`.
  - Dev: `provider = "sqlite"` and `url = "file:./dev.db"`
  - Prod: Use environment variables to swap to postgresql during CI/CD.
- FastAPI & MCP: Expose your backend capabilities via the Model Context Protocol so Claude Code can directly query your local API for contex