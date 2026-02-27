# Common Tasks

Practical examples for everyday operations in the agent-team-playground project.

---

## Task 1: Add New Python Dependency

**Owner**: Full Stack Engineer (request) + DevOps (approval)
**Time**: 5-10 minutes

### Scenario
Need to add a new Python package (e.g., `requests` for HTTP calls) to the backend.

### Steps

1. **Request the Dependency**
   ```bash
   cd backend

   # View current dependencies
   cat pyproject.toml | grep -A 5 "^\[project.dependencies\]"
   ```

2. **Install and Test Locally**
   ```bash
   # Activate environment (if using venv)
   source .venv/bin/activate  # or uv venv if not created

   # Install with uv
   uv pip install requests

   # Test import
   python -c "import requests; print(requests.__version__)"
   ```

3. **Update pyproject.toml**
   ```toml
   [project.dependencies]
   fastapi = "^0.109.0"
   uvicorn = "^0.27.0"
   sqlalchemy = "^2.0"
   pydantic = "^2.0"
   requests = "^2.31.0"  # Add this line
   ```

4. **Sync Dependencies**
   ```bash
   uv sync  # Reads from updated pyproject.toml
   ```

5. **Verify**
   ```bash
   python -c "import requests; print('Success')"
   ```

6. **Commit Changes**
   ```bash
   git add backend/pyproject.toml
   git commit -m "deps(backend): add requests for HTTP client

   Added requests library for making HTTP calls in backend.

   [agent-action]
   Co-Authored-By: Full Stack Engineer <agent@playground.local>"
   ```

7. **Create PR** (if part of larger feature)
   ```bash
   git push -u origin feat/add-requests-dependency
   gh pr create --title "deps(backend): add requests" --body "..."
   ```

### Verification Checklist
- [ ] Dependency added to `[project.dependencies]`
- [ ] `uv sync` runs successfully
- [ ] Import test works: `python -c "import requests"`
- [ ] Existing tests still pass: `uv run pytest`
- [ ] Ruff linting passes: `uv run ruff check`
- [ ] Commit message includes `[agent-action]` tag

---

## Task 2: Add New Node.js Dependency

**Owner**: Full Stack Engineer (request) + DevOps (approval)
**Time**: 5-10 minutes

### Scenario
Need to add a new npm package (e.g., `axios` for HTTP calls) to the frontend.

### Steps

1. **Ensure Node.js 22 LTS**
   ```bash
   nvm use
   node --version  # Should show v22.10.0+
   ```

2. **Request the Dependency**
   ```bash
   cd frontend

   # View current dependencies
   cat package.json | jq '.dependencies'
   ```

3. **Install with pnpm**
   ```bash
   # Regular dependency
   pnpm add axios

   # Dev dependency
   pnpm add -D @types/axios
   ```

4. **Update package.json**
   ```json
   {
     "dependencies": {
       "axios": "^1.6.0"
     }
   }
   ```

5. **Verify**
   ```bash
   # Test import
   node -e "const axios = require('axios'); console.log('Success')"

   # Or in TypeScript
   cat > test.ts << 'EOF'
   import axios from 'axios';
   console.log('Success');
   EOF
   npx tsx test.ts
   ```

6. **Run Linting**
   ```bash
   pnpm run lint

   # If format issues
   pnpm run lint --fix
   ```

7. **Commit Changes**
   ```bash
   git add frontend/package.json pnpm-lock.yaml
   git commit -m "deps(frontend): add axios for HTTP client

   Added axios library for making HTTP calls in frontend.

   [agent-action]
   Co-Authored-By: Full Stack Engineer <agent@playground.local>"
   ```

### Verification Checklist
- [ ] Dependency added to `package.json`
- [ ] `pnpm install` runs successfully
- [ ] `pnpm-lock.yaml` updated
- [ ] Import test works
- [ ] `pnpm run lint` passes
- [ ] `pnpm test:vitest` passes
- [ ] Commit includes lock file

---

## Task 3: Update Node.js Version

**Owner**: DevOps
**Time**: 10-15 minutes

### Scenario
Node.js 22.11.0 is released and team should upgrade from 22.10.0.

### Steps

1. **Verify New Version**
   ```bash
   # Check Node.js releases
   curl https://nodejs.org/en/download/current/

   # Or check locally
   nvm list-remote | grep "22.11"
   ```

2. **Update Version Files**
   ```bash
   # Update .nvmrc
   echo "22.11.0" > .nvmrc

   # Update .node-version
   echo "22.11.0" > .node-version

   # Verify both files match
   diff .nvmrc .node-version
   ```

3. **Update package.json**
   ```json
   {
     "engines": {
       "node": ">=22.11.0",
       "pnpm": ">=9.0.0"
     }
   }
   ```

4. **Test Locally**
   ```bash
   nvm use
   node --version  # Should show v22.11.0

   # Install pnpm via corepack
   corepack enable
   corepack install -g pnpm

   # Install dependencies
   pnpm install --frozen-lockfile

   # Run tests
   pnpm test:vitest
   ```

5. **Update Documentation**
   ```bash
   # Update CLAUDE.md
   sed -i 's/22.10.0/22.11.0/g' CLAUDE.md

   # Update README.md if version mentioned
   sed -i 's/22.10.0/22.11.0/g' README.md

   # Verify changes
   grep -r "22.11.0" .
   ```

6. **Update GitHub Actions**
   ```bash
   # Check workflows
   grep -r "node-version:" .github/workflows/

   # Update to latest or pin version
   # No change needed if using: node-version: 22
   # (GitHub Actions automatically uses latest 22.x)
   ```

7. **Create PR**
   ```bash
   git checkout -b chore/update-node-lts

   git add .nvmrc .node-version frontend/package.json CLAUDE.md README.md .github/workflows/
   git commit -m "chore: update Node.js to 22.11.0

   - Update .nvmrc and .node-version
   - Update frontend/package.json engines field
   - Update documentation

   Benefits:
   - Node.js 22.11.0 security updates
   - Improved performance

   Testing:
   - nvm use && node --version
   - pnpm install --frozen-lockfile
   - pnpm test:vitest

   [agent-action]
   Co-Authored-By: DevOps <agent@playground.local>"

   git push -u origin chore/update-node-lts
   gh pr create --title "chore: update Node.js to 22.11.0" --body "..."
   ```

### Verification Checklist
- [ ] `.nvmrc` and `.node-version` updated and match
- [ ] `package.json` `engines` field updated
- [ ] Documentation updated (CLAUDE.md, README.md)
- [ ] `nvm use` switches to new version
- [ ] `pnpm install` succeeds
- [ ] All tests pass with new version
- [ ] GitHub Actions configuration reviewed

---

## Task 4: Create New Database Migration

**Owner**: Full Stack Engineer (create) + DevOps (validate)
**Time**: 15-30 minutes

### Scenario
Need to add a new `posts` table to the database schema.

### Steps

1. **Update Prisma Schema**
   ```bash
   # Edit schema.prisma
   cat prisma/schema.prisma
   ```

   ```prisma
   // Add to prisma/schema.prisma
   model Post {
     id        Int     @id @default(autoincrement())
     title     String  @db.VarChar(255)
     content   String  @db.Text
     published Boolean @default(false)
     authorId  Int
     author    User    @relation(fields: [authorId], references: [id])
     createdAt DateTime @default(now())
     updatedAt DateTime @updatedAt

     @@index([authorId])
   }

   // Update User model
   model User {
     // ... existing fields ...
     posts Post[]  // Add this line
   }
   ```

2. **Create Migration**
   ```bash
   cd frontend

   # Create migration from schema changes
   pnpm exec prisma migrate dev --name add_posts_table

   # This will:
   # 1. Create SQL migration file
   # 2. Apply to SQLite dev database
   # 3. Generate Prisma Client
   ```

3. **Review Generated SQL**
   ```bash
   # Check migration file
   ls -la prisma/migrations/

   # View SQL
   cat prisma/migrations/*/migration.sql
   ```

4. **Test Locally**
   ```bash
   # Verify schema applied to SQLite
   sqlite3 dev.db ".schema Post"

   # Test Prisma Client can query new table
   node -e "
   const { PrismaClient } = require('@prisma/client');
   const prisma = new PrismaClient();
   prisma.post.findMany().then(() => console.log('Success'));
   "
   ```

5. **Update Frontend Code**
   ```bash
   # Create API route
   cat > app/api/posts/route.ts << 'EOF'
   import { prisma } from '@/lib/prisma';
   import { NextResponse } from 'next/server';

   export async function GET() {
     const posts = await prisma.post.findMany();
     return NextResponse.json(posts);
   }

   export async function POST(request: Request) {
     const { title, content, authorId } = await request.json();
     const post = await prisma.post.create({
       data: { title, content, authorId }
     });
     return NextResponse.json(post, { status: 201 });
   }
   EOF
   ```

6. **Update Backend (if needed)**
   ```bash
   # If backend also uses same database
   cd backend

   # Create SQLAlchemy model
   cat > models.py << 'EOF'
   from sqlalchemy import Column, Integer, String, Text, Boolean, DateTime, ForeignKey
   from sqlalchemy.orm import relationship
   from datetime import datetime

   class Post(Base):
       __tablename__ = 'posts'

       id = Column(Integer, primary_key=True)
       title = Column(String(255), nullable=False)
       content = Column(Text, nullable=False)
       published = Column(Boolean, default=False)
       author_id = Column(Integer, ForeignKey('users.id'))
       created_at = Column(DateTime, default=datetime.utcnow)
       updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

       author = relationship('User', back_populates='posts')
   EOF
   ```

7. **Run Tests**
   ```bash
   cd frontend
   pnpm test:vitest  # Should pass with new schema

   cd ../backend
   uv run pytest  # Should pass with new models
   ```

8. **Commit Changes**
   ```bash
   git add prisma/schema.prisma
   git add prisma/migrations/
   git commit -m "feat(schema): add posts table

   Added posts table to schema with:
   - id (primary key)
   - title, content (post data)
   - authorId (foreign key to users)
   - createdAt, updatedAt (timestamps)

   Migration created: [timestamp]_add_posts_table

   [agent-action]
   Co-Authored-By: Full Stack Engineer <agent@playground.local>"

   git push -u origin feat/add-posts-table
   ```

### Verification Checklist
- [ ] Prisma schema updated
- [ ] Migration created: `pnpm exec prisma migrate dev`
- [ ] SQLite dev database updated
- [ ] Prisma Client code generated
- [ ] Schema accessible in frontend: `const posts = await prisma.post.findMany()`
- [ ] Backend models updated (if applicable)
- [ ] All tests pass
- [ ] Migration file reviewed for correctness

---

## Task 5: Run Pre-commit Hooks Locally

**Owner**: Any Agent
**Time**: 2-5 minutes

### Scenario
Before pushing changes, ensure all pre-commit hooks pass.

### Steps

1. **Install Pre-commit (first time only)**
   ```bash
   # Install pre-commit framework with uv
   uv tool install pre-commit --with pre-commit-uv

   # Install git hooks
   pre-commit install

   # Verify installation
   pre-commit --version
   ```

2. **Run on Staged Files** (before commit)
   ```bash
   # Run on currently staged files
   pre-commit run

   # If failures, fix and re-run
   # Most issues are auto-fixed by Ruff and Biome
   ```

3. **Run on All Files** (optional, thorough check)
   ```bash
   # Run on all files in repository
   pre-commit run --all-files

   # Monitor execution time (should be ~5-10 seconds)
   time pre-commit run --all-files
   ```

4. **If Failures Occur**
   ```bash
   # Ruff failures (Python)
   uv run ruff check --fix backend/

   # Biome failures (Frontend)
   pnpm run lint --fix

   # Rerun pre-commit
   pre-commit run --all-files
   ```

5. **Commit Changes**
   ```bash
   git add .  # Stage all changes (including auto-fixes)
   git commit -m "fix: resolve pre-commit hook issues

   - Ruff: fixed linting issues
   - Biome: formatted code
   - lint-staged: verified frontend checks

   [agent-action]
   Co-Authored-By: Full Stack Engineer <agent@playground.local>"
   ```

### Pre-commit Hooks Included

| Hook | Purpose | Files |
|------|---------|-------|
| check-merge-conflict | Prevent merge conflict markers | All |
| check-yaml | Validate YAML syntax | `*.yaml`, `*.yml` |
| trailing-whitespace | Remove trailing spaces | All |
| end-of-file-fixer | Ensure files end with newline | All |
| check-json | Validate JSON syntax | `*.json` |
| Ruff | Python linting & formatting | `backend/`, `scripts/` |
| lint-staged | Frontend linting (changed files only) | `src/`, `prisma/` |
| detect-secrets | Prevent API keys/credentials | All |

### Common Issues

**Issue**: "Ruff fails after my changes"
```bash
# Let Ruff auto-fix
uv run ruff check --fix backend/

# Verify fix
uv run ruff check backend/

# Re-run pre-commit
pre-commit run --all-files
```

**Issue**: "Biome formatting differs"
```bash
# Apply Biome formatting
pnpm run lint

# Verify
pre-commit run

# Commit formatted files
git add frontend/
```

**Issue**: "Detect-secrets finds false positive"
```bash
# Review the detected secret
pre-commit run --all-files

# If false positive, update baseline
detect-secrets scan --baseline .secrets.baseline

git add .secrets.baseline
git commit -m "chore: update secrets baseline"
```

---

## Task 6: Setup Development Environment (New Team Member)

**Owner**: New Agent
**Time**: 30-45 minutes

### Scenario
New agent joining the team needs to set up their development environment.

### Steps

1. **Clone Repository**
   ```bash
   git clone https://github.com/pluto-atom-4/agent-team-playground.git
   cd agent-team-playground
   ```

2. **Setup Node.js 22 LTS** (one-time)
   ```bash
   # Install Node.js 22 LTS from https://nodejs.org/

   # If using nvm:
   nvm install 22.10.0
   nvm use  # Uses .nvmrc automatically

   # Enable corepack
   corepack enable
   corepack install -g pnpm

   # Verify
   node --version    # v22.10.0+
   pnpm --version    # 9.0.0+
   ```

3. **Setup Frontend**
   ```bash
   cd frontend
   nvm use
   pnpm install --frozen-lockfile

   # Test setup
   pnpm run lint
   pnpm test:vitest
   ```

4. **Setup Backend**
   ```bash
   cd backend

   # Install Python 3.10-3.12 (if needed)
   python3 --version

   # Create and activate virtual environment
   uv venv
   source .venv/bin/activate  # or .venv\Scripts\activate on Windows

   # Install dependencies
   uv sync

   # Verify
   uv run ruff check
   uv run pytest
   ```

5. **Setup Pre-commit Hooks**
   ```bash
   # Go back to repo root
   cd ..

   # Install pre-commit
   uv tool install pre-commit --with pre-commit-uv

   # Install git hooks
   pre-commit install

   # Test hooks
   pre-commit run --all-files
   ```

6. **Verify Full Setup**
   ```bash
   # All commands should succeed
   nvm use
   node --version
   pnpm --version
   cd frontend && pnpm install && pnpm run lint && pnpm test:vitest
   cd ../backend && uv run ruff check && uv run pytest
   cd .. && pre-commit run --all-files
   ```

7. **Read Documentation**
   - [ ] Read `CLAUDE.md` for project overview
   - [ ] Read `.claude/agents/team.md` to understand your role
   - [ ] Read `README.md` for setup details
   - [ ] Read `PLAN.md` for project roadmap

### Verification Checklist
- [ ] Node.js 22 LTS installed and verified
- [ ] pnpm 9+ working
- [ ] Frontend dependencies installed
- [ ] Backend dependencies installed
- [ ] `uv sync` works
- [ ] `pnpm install` works
- [ ] Pre-commit hooks installed
- [ ] All tests pass
- [ ] Documentation read and understood

---

## Task 7: Create and Merge PR with Agent Coordination

**Owner**: Full Stack Engineer (code) + QA Engineer (tests) + DevOps (validation)
**Time**: 1-2 hours

### Scenario
Implementing a new feature that requires backend, frontend, and database changes.

### Workflow

1. **Full Stack Engineer: Create Feature Branch**
   ```bash
   git checkout main
   git pull origin main
   git checkout -b feat/user-authentication

   # Implement backend endpoint
   # Implement frontend component
   # Create database migration
   ```

2. **Full Stack Engineer: Commit Changes**
   ```bash
   git add backend/main.py frontend/components/Login.tsx prisma/schema.prisma
   git commit -m "feat(auth): implement user authentication

   Implemented:
   - FastAPI /auth/login endpoint
   - Next.js Login component
   - Prisma User model with password hash

   Testing:
   - Unit tests: backend/tests/test_auth.py
   - E2E tests: tests/e2e/login.spec.ts
   - Manual testing: See PR description

   [agent-action]
   Co-Authored-By: Full Stack Engineer <agent@playground.local>"

   git push -u origin feat/user-authentication
   ```

3. **Full Stack Engineer: Create PR**
   ```bash
   gh pr create \
     --title "feat(auth): implement user authentication" \
     --body "## Summary
   Implements user login functionality across backend and frontend.

   ## Test Plan
   - [ ] Manual: Navigate to /login
   - [ ] Manual: Enter valid credentials
   - [ ] Manual: Verify JWT token received
   - [ ] Run: \`pnpm test:vitest\`
   - [ ] Run: \`pnpm exec playwright test\`
   - [ ] Run: \`uv run pytest\`

   ## Files Changed
   - backend/main.py - /auth/login endpoint
   - frontend/components/Login.tsx - Login form
   - prisma/schema.prisma - User model

   ## Migration
   - prisma/migrations/[...] - Add users table"
   ```

4. **QA Engineer: Run Tests**
   ```bash
   # Checkout PR branch
   gh pr checkout 42

   # Run test suite
   cd frontend && pnpm test:vitest
   pnpm exec playwright test
   cd ../backend && uv run pytest

   # Check coverage
   pnpm test:coverage

   # Comment on PR
   gh pr comment 42 --body "✅ All tests pass (coverage: 84%)"
   ```

5. **DevOps: Validate Migration**
   ```bash
   # Checkout PR branch
   gh pr checkout 42

   # Test migration
   cd frontend
   pnpm exec prisma migrate dev

   # Verify SQLite
   sqlite3 dev.db ".schema users"

   # Verify pre-commit passes
   pre-commit run --all-files

   # Comment on PR
   gh pr comment 42 --body "✅ Migration valid, pre-commit passes"
   ```

6. **Project Manager: Approve and Merge**
   ```bash
   # Verify all checks passed
   gh pr checks 42

   # Approve PR
   gh pr review 42 --approve --body "LGTM - all checks passed"

   # Merge to main
   gh pr merge 42 --squash --delete-branch

   # Update PLAN.md
   # Mark issue as complete
   gh issue close <issue-number>
   ```

### Verification Checklist
- [ ] Feature branch created from main
- [ ] Code changes implemented
- [ ] Commit message includes `[agent-action]`
- [ ] PR created with test plan
- [ ] All tests pass (Vitest + Playwright + pytest)
- [ ] Migration validated
- [ ] Pre-commit hooks pass
- [ ] Code review approved
- [ ] PR merged to main
- [ ] Issue closed and PLAN.md updated

