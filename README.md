# Agent Team Playground 🤖

A full-stack project managed by a coordinated team of AI agents. Learn how to build, test, and deploy applications using automated agents working together.

---

## What is This Project?

This is a **reference implementation** showing how AI agents can work together as a team to develop a complete web application. Instead of one developer doing everything, we have:

- 📋 **Project Manager Agent** - Plans and organizes work
- 💻 **Full Stack Engineer Agent** - Builds the application
- ✅ **QA Engineer Agent** - Tests everything
- 🚀 **DevOps Agent** - Manages deployment

All agents coordinate through GitHub Issues, Pull Requests, and command-line tools to work seamlessly together.

---

## Prerequisites

Before you start, make sure you have these installed on your computer:

### Required Software

**Core Tools**:
- **Node.js 18+** - [Download here](https://nodejs.org/)
- **Python 3.10+** - [Download here](https://www.python.org/)
- **Git** - [Download here](https://git-scm.com/)
- **GitHub CLI** - [Installation guide](https://cli.github.com/)
- **Claude Code CLI** - Install with: `npm install -g @anthropic/claude-code`

**Package Managers** (modern, fast alternatives):
- **pnpm** - Fast Node.js package manager - [Installation guide](https://pnpm.io/installation)
  - Install: `npm install -g pnpm`
- **uv** - Fast Python package installer - [Installation guide](https://docs.astral.sh/uv/getting-started/installation/)
  - Install: `curl -LsSf https://astral.sh/uv/install.sh | sh`

**Linting & Formatting**:
- **Biome** - Fast formatter/linter for JS/TS (installed via pnpm in frontend)
- **Ruff** - Fast Python linter (installed via uv in backend)

**Code Quality**:
- **pre-commit** - Git hooks framework - [Installation guide](https://pre-commit.com/#installation)
  - Install: `pip install pre-commit`

**Optional but Recommended**:
- **Docker** - [Download here](https://www.docker.com/)

### Required Accounts
- **GitHub Account** - [Sign up free](https://github.com/signup)
- **GitHub CLI Authentication** - Run `gh auth login` after installing

### Verify Your Installation

Run these commands to confirm everything is installed correctly:

```bash
# Check Node.js and pnpm
node --version
pnpm --version

# Check Python and uv
python --version
uv --version

# Check Git and GitHub CLI
git --version
gh --version

# Check Claude Code
ck --version

# Check pre-commit
pre-commit --version
```

---

## Quick Start (5 Minutes)

### Step 1: Clone the Repository

```bash
git clone https://github.com/pluto-atom-4/agent-team-playground.git
cd agent-team-playground
```

### Step 2: Verify the Setup

```bash
# Check that all configuration files exist
ls -la .claude/
ls -la .github/workflows/
ls -la docs/

# You should see:
# .claude/settings.json
# .claude/agents/team.md
# .github/workflows/agentic-dev.md
# docs/CONFIGURATION_SUMMARY.md
```

### Step 3: Read the Documentation

Start with these files in this order:

1. **This README.md** (you're reading it now!) ✓
2. **CLAUDE.md** - Understand the development workflow
3. **PLAN.md** - See the project roadmap
4. **.claude/agents/team.md** - Learn about each agent role

```bash
# Open files (use your favorite editor)
cat CLAUDE.md
cat PLAN.md
cat .claude/agents/team.md
```

### Step 4: Authenticate with GitHub

```bash
# Login to GitHub CLI
gh auth login

# Choose: GitHub.com
# Choose: HTTPS
# Authenticate via web browser when prompted
```

That's it! You're ready to start. 🎉

---

## Understanding the Agent Team

### 👨‍💼 Project Manager Agent
**What they do**: Organizes work and keeps everyone on track
**Tools they use**: GitHub CLI, Claude Code
**Your role**: Create GitHub Issues for new features

### 👨‍💻 Full Stack Engineer Agent
**What they do**: Writes code for the backend and frontend with high code quality
**Tools they use**: Claude Code, FastAPI, Next.js, Ruff (linting), Biome (formatting)
**Your role**: Provide clear feature specifications in Issues

### ✅ QA Engineer Agent
**What they do**: Tests the code to make sure it works and maintains quality standards
**Tools they use**: Vitest, Playwright, Claude Code, pre-commit hooks
**Your role**: Ensure test requirements are clear in Issues

### 🚀 DevOps Agent
**What they do**: Manages databases, deployment, and code quality automation
**Tools they use**: Prisma, GitHub Actions, PostgreSQL, pre-commit, uv
**Your role**: Understand database schema changes and code quality standards

---

## Step-by-Step Workflow Guide

### Scenario: You want to add a new feature

#### Step 1: Create a GitHub Issue 📝

```bash
# Create an issue for a new feature
gh issue create \
  --title "Feature: User Authentication" \
  --body "Implement user login/logout functionality

- FastAPI endpoint for /auth/login
- FastAPI endpoint for /auth/logout
- Next.js login form component
- Store user session in database

Requirements:
- Use JWT tokens for authentication
- Hash passwords with bcrypt
- Add email validation
"
```

**What happens next**: The Project Manager agent will see this issue and plan the work.

---

#### Step 2: Assign the Issue 🎯

```bash
# List issues to find the one you just created
gh issue list

# Assign it to the Full Stack Engineer agent (use issue number)
gh issue assign ISSUE_NUMBER

# Add priority label
gh issue label ISSUE_NUMBER --add priority
```

---

#### Step 3: Monitor Progress 📊

```bash
# Check the issue status
gh issue view ISSUE_NUMBER

# See all pull requests related to this work
gh pr list --search "auth"

# View a specific PR
gh pr view PR_NUMBER
```

---

#### Step 4: Review the Code 👀

```bash
# See the PR details and automated validation results
gh pr view PR_NUMBER --comments

# Check if all validations passed
gh pr checks PR_NUMBER
```

You'll see:
- ✅ Tests passed
- ✅ Database migrations validated
- ✅ Code coverage >80%
- ✅ API documentation complete

---

#### Step 5: Approve and Merge 🎉

```bash
# Approve the pull request
gh pr review PR_NUMBER --approve

# Merge the code to main
gh pr merge PR_NUMBER

# See confirmation
gh pr view PR_NUMBER
```

---

## Common Commands Reference

### Starting Your Day

```bash
# Sync the latest changes from GitHub
git pull origin main

# Check what issues are waiting
gh issue list --label "priority"

# Check your custom agent commands
cat .claude/settings.json
```

### Working on a Feature

```bash
# Create and switch to a feature branch
gh pr checkout -b feature/my-feature

# Check the current status
git status

# View recent changes
git log --oneline -10

# Commit your changes
git commit -m "feat(auth): add login endpoint [agent-action]"
```

### Running Tests Locally

**Backend Tests (Python)**:
```bash
cd backend
source .venv/bin/activate  # On Windows: .venv\Scripts\activate

# Dependencies are defined in backend/pyproject.toml
# Install all dependencies (including pytest)
uv sync

# Run pytest
uv run pytest

# Run specific test
uv run pytest tests/test_auth.py

# Run with coverage report
uv run pytest --cov
```

**Frontend Tests (TypeScript)**:
```bash
cd frontend
pnpm install

# Run all Vitest (unit tests)
pnpm test:vitest

# Run Playwright E2E tests
pnpm exec playwright test

# Check test coverage
pnpm test:coverage

# Run the custom qa-test command (runs both)
ck qa-test
```

### Code Quality Checks

**Backend (Ruff configured in pyproject.toml)**:
```bash
cd backend
source .venv/bin/activate  # On Windows: .venv\Scripts\activate

# uv automatically reads Ruff configuration from backend/pyproject.toml
uv sync  # Install Ruff and other dev tools

# Lint with Ruff (configuration from pyproject.toml)
uv run ruff check --fix .

# Format with Ruff
uv run ruff format .

# Run Ruff checks without fixing
uv run ruff check .
```

**Frontend (Biome)**:
```bash
cd frontend
pnpm exec biome check --apply
```

**Pre-commit Framework (covers both backend and frontend)**:
```bash
# Install pre-commit framework with uv
uv tool install pre-commit --with pre-commit-uv
pre-commit install

# Run all code quality checks (Ruff + Biome + general hooks)
pre-commit run --all-files

# Update hook versions to latest
pre-commit autoupdate
```

**Optional: Add lint-staged for faster pre-commit on changed files**:

```bash
cd frontend
pnpm add -D lint-staged

# Add to frontend/package.json
cat >> package.json << 'EOF'
{
  "lint-staged": {
    "src/**/*.{js,jsx,ts,tsx}": ["biome check --apply"],
    "*.json": ["biome check --apply"]
  }
}
EOF
```

### Managing the Database

```bash
# Install Python dependencies
uv sync

# Create a migration
pnpm exec prisma migrate dev --name add_users_table

# View the database schema
pnpm exec prisma studio

# Reset the database (careful!)
pnpm exec prisma migrate reset

# Run migrations
pnpm exec prisma migrate deploy
```

### Creating Pull Requests

```bash
# Push your branch
git push origin feature/my-feature

# Create a pull request
gh pr create --title "feat: add user login" --body "Implements user authentication"

# View your PR
gh pr view --web

# Check if validation passed
gh pr checks
```

---

## Project Structure

```
agent-team-playground/
│
├── README.md                       ← You are here!
├── CLAUDE.md                       ← Development guide
├── PLAN.md                         ← Project roadmap
│
├── .claude/                        ← Agent team configuration
│   ├── settings.json              (Custom commands)
│   └── agents/team.md             (Agent role definitions)
│
├── .github/workflows/
│   └── agentic-dev.md             ← Automated PR validation
│
├── docs/                          ← Detailed documentation
│   └── CONFIGURATION_SUMMARY.md   (Full technical reference)
│
├── backend/                       ← To be created (Python/FastAPI)
│   ├── main.py
│   ├── routes/
│   └── models/
│
├── frontend/                      ← To be created (Next.js)
│   ├── src/pages/
│   ├── src/components/
│   └── package.json
│
└── prisma/                        ← To be created (Database)
    └── schema.prisma
```

---

## Your First Task: Set Up the Project Foundation

### Objective
Initialize the backend (FastAPI) and frontend (Next.js) directories so agents can start building features.

### Steps

**Step 1: Create Backend Directory**

```bash
# Create the backend folder
mkdir -p backend
cd backend

# Initialize Python environment with uv (faster than venv!)
uv venv

# Activate virtual environment
source .venv/bin/activate  # On Windows: .venv\Scripts\activate

# Install all dependencies from pyproject.toml
# uv automatically reads and uses pyproject.toml for dependencies
uv sync  # Install dependencies including dev tools (Ruff, pytest, etc.)

# Or install just core dependencies (no dev tools)
uv pip install -e .

# Create main.py
cat > main.py << 'EOF'
from fastapi import FastAPI

app = FastAPI(title="Agent Team Playground API")

@app.get("/")
async def root():
    return {"message": "Welcome to Agent Team Playground"}

@app.get("/health")
async def health():
    return {"status": "healthy"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
EOF

cd ..
```

**About `pyproject.toml`**:
- ✓ Centralized Python configuration (dependencies, build system, tool settings)
- ✓ Specifies Python 3.10, 3.11, 3.12 support
- ✓ Includes Ruff, pytest, mypy, and other dev tools
- ✓ Uses `uv sync` for fast dependency management
- ✓ All packages verified to support Python 3.10+

**Step 2: Create Frontend Directory**

```bash
# Create the frontend folder with Next.js (using pnpm!)
pnpm create next-app@latest frontend --typescript --eslint --tailwind --use-pnpm

cd frontend

# Install testing and database tools with pnpm
pnpm add -D vitest @testing-library/react @testing-library/jest-dom
pnpm add -D @playwright/test
pnpm add -D biome
pnpm add @prisma/client prisma

# Initialize Prisma
pnpm exec prisma init

cd ..
```

**Step 3: Create Database Schema**

```bash
# Open the Prisma schema
nano frontend/prisma/schema.prisma
```

Replace the content with:

```prisma
// This is your Prisma schema file,
// learn more about it in the docs: https://pris.ly/d/prisma-schema

generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "sqlite"
  url      = env("DATABASE_URL")
}

model User {
  id    Int     @id @default(autoincrement())
  email String  @unique
  name  String?
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
}
```

**Step 4: Create Environment Files**

```bash
# Frontend environment
echo 'DATABASE_URL="file:./dev.db"' > frontend/.env.local
echo 'NEXT_PUBLIC_API_URL="http://localhost:8000"' >> frontend/.env.local

# Backend environment
echo 'DATABASE_URL="sqlite:///./test.db"' > backend/.env
echo 'SECRET_KEY="your-secret-key-change-me"' >> backend/.env
```

**Step 5: Initialize Database**

```bash
cd frontend

# Create Prisma migration with pnpm
pnpm exec prisma migrate dev --name init

# Open Prisma Studio to view database
# pnpm exec prisma studio

cd ..
```

**Step 6: Set Up Pre-commit Hooks**

```bash
# Install pre-commit framework with uv (includes pre-commit-uv for faster hook execution)
uv tool install pre-commit --with pre-commit-uv

# Initialize pre-commit hooks in .git/hooks/
pre-commit install

# Run hooks on all files to verify setup (this may auto-fix some issues)
pre-commit run --all-files
```

**What pre-commit does**:
- ✅ Ruff: Lints and formats Python code in `backend/`
- ✅ Biome: Formats and lints JavaScript/TypeScript in `frontend/`
- ✅ General: Fixes trailing whitespace, ensures newlines, validates JSON/YAML
- ✅ Secrets: Prevents commits of API keys, tokens, or credentials
- 🔄 Auto-fixes: Many issues are automatically fixed before commit

**Step 7: Test Both Servers**

Terminal 1 - Backend (with uv):
```bash
cd backend

# Activate the virtual environment
source .venv/bin/activate  # On Windows: .venv\Scripts\activate

# Run the server
python main.py

# Visit: http://localhost:8000
# Visit: http://localhost:8000/health
```

Terminal 2 - Frontend (with pnpm):
```bash
cd frontend

# Run development server
pnpm dev

# Visit: http://localhost:3000
```

**Step 7: Create a GitHub Issue to Track This Work**

```bash
gh issue create \
  --title "Setup: Initialize project structure" \
  --body "Project foundation is now set up with:
- FastAPI backend running on port 8000
- Next.js frontend running on port 3000
- SQLite database with Prisma schema
- Agents can now start implementing features"
```

**Step 8: Commit Your Changes**

```bash
git add .
git commit -m "chore(setup): initialize project structure with FastAPI, Next.js, and modern tooling

- Created backend directory with FastAPI and uv environment
- Created frontend directory with Next.js and pnpm
- Configured Prisma schema with SQLite for development
- Set up environment files for local development
- Initialized pre-commit hooks for code quality
- Configured Ruff for Python linting and Biome for frontend

[agent-action]
Co-Authored-By: Setup Task <setup@playground.local>"
```

Great! Your project is now ready for the agents to start building features with modern, fast tooling! 🚀

---

## Troubleshooting

### Problem: Command not found errors

**Solution**: Make sure all software is installed correctly.

```bash
# Reinstall core tools if needed
npm install -g @anthropic/claude-code
curl -LsSf https://astral.sh/uv/install.sh | sh  # uv
npm install -g pnpm  # pnpm
pip install --upgrade pip pre-commit  # pre-commit
```

### Problem: pnpm not working

**Solution**: Install or update pnpm

```bash
npm install -g pnpm
pnpm --version
```

### Problem: uv not working

**Solution**: Install uv from [astral.sh](https://astral.sh/)

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
uv --version
```

### Problem: Pre-commit hooks failing

**Solution**: Run hooks locally to debug and auto-fix

```bash
# Install with pre-commit-uv plugin for faster execution
uv tool install pre-commit --with pre-commit-uv
pre-commit install

# Run on all files (auto-fixes most issues)
pre-commit run --all-files

# Run on staged files only
pre-commit run

# Debug a specific hook
pre-commit run ruff --all-files
pre-commit run biome-check --all-files
```

### Problem: GitHub CLI not authenticating

**Solution**: Login again

```bash
gh auth logout
gh auth login
# Follow the prompts
```

### Problem: Database errors

**Solution**: Reset and reinitialize with pnpm

```bash
cd frontend
pnpm exec prisma migrate reset
pnpm exec prisma migrate dev --name init
```

### Problem: Port already in use

**Solution**: Use different ports or kill the process

```bash
# For port 3000 (frontend)
lsof -ti:3000 | xargs kill -9

# For port 8000 (backend)
lsof -ti:8000 | xargs kill -9
```

### Problem: Can't find files or commands

**Solution**: Make sure you're in the correct directory

```bash
# You should be in the project root
pwd

# This directory should exist
ls -la .claude/
ls -la .github/
```

---

## Next Steps

1. **Read CLAUDE.md** - Learn the full development workflow
2. **Review PLAN.md** - Understand the feature roadmap
3. **Create an Issue** - Request a new feature for the agents to build
4. **Watch the Agents Work** - Monitor PRs and see the workflow in action
5. **Run Tests** - Verify everything works correctly
6. **Explore Docs** - Read `docs/CONFIGURATION_SUMMARY.md` for advanced topics

---

## Common Questions

**Q: Do I need to code anything myself?**
A: No! The agents handle most of the coding. You create Issues describing what you want, and agents implement it.

**Q: What if an agent makes a mistake?**
A: The automated PR validation will catch many issues. You can review PRs and request changes.

**Q: Can I use this with my own project?**
A: Yes! The configuration in `.claude/`, `CLAUDE.md`, and `PLAN.md` can be adapted to any project.

**Q: How do I add more agents?**
A: Edit `.claude/agents/team.md` to define new roles and update `.claude/settings.json` with their custom commands.

**Q: What if I want to manually implement a feature?**
A: Create a branch, implement the feature, and submit a PR. The automated validation will still apply.

---

## Getting Help

### Documentation
- **CLAUDE.md** - Development workflow and best practices
- **PLAN.md** - Project roadmap and feature backlog
- **.claude/agents/team.md** - Agent role definitions
- **docs/CONFIGURATION_SUMMARY.md** - Detailed technical reference

### Online Resources
- [GitHub CLI Documentation](https://cli.github.com/manual)
- [Claude Code Documentation](https://claude.ai/code)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Next.js Documentation](https://nextjs.org/docs)
- [Prisma ORM Guide](https://www.prisma.io/docs/)

### Reporting Issues
If something doesn't work:
1. Check the troubleshooting section above
2. Review the relevant documentation file
3. Create a GitHub Issue with:
   - What you were trying to do
   - What error you got
   - Steps to reproduce
   - Output of `node --version`, `python --version`, `gh --version`

---

## Glossary

- **Agent** - An AI model performing a specific role (PM, Engineer, QA, DevOps)
- **GitHub Issue** - A task or feature request
- **Pull Request (PR)** - A proposed code change
- **Commit** - A saved change to the code
- **Branch** - An isolated line of development
- **MCP** - Model Context Protocol (allows agents to discover API endpoints)
- **Prisma** - A database tool that manages schema and migrations
- **Vitest** - A testing framework for JavaScript
- **Playwright** - A tool for testing web applications
- **FastAPI** - A Python web framework
- **Next.js** - A React web framework

---

## License

This project is provided as a reference implementation for educational purposes.

---

## Summary

You now have:
- ✅ Installed all required software
- ✅ Cloned the repository
- ✅ Understood the agent team structure
- ✅ Learned basic commands
- ✅ Set up the project foundation
- ✅ Created your first GitHub Issue

**You're ready to work with the agent team!** 🎉

Start by creating Issues for features you want built, and watch the agents collaborate to implement them.

---

**Questions?** Check the documentation files in this repository or create a GitHub Issue describing your question.

**Happy building!** 🚀
