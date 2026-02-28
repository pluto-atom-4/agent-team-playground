# Examples and Workflows

Real-world scenarios and best practices for using the `scaffold-project-from-template` skill.

---

## Scenario 1: Basic Project Scaffolding

**Goal**: Create a new project from the agent-team-playground template.

**Prerequisite**: You have a local clone of agent-team-playground.

### Steps

```bash
# 1. Navigate to your template repository
cd ~/projects/agent-team-playground

# 2. Verify you're on the main branch
git status
# On branch main, working tree clean

# 3. Step 1: Create GitHub repository
./scripts/repo-init.sh -repo my-cool-api

# Output:
# [INFO] Starting repository initialization...
# [INFO] Creating GitHub repository: my-cool-api
# [INFO] Using GitHub user: john-doe
# [INFO] Configuring git remote...
# [INFO] Pushing to remote repository...
# [SUCCESS] Repository initialization complete!
# [INFO] Repository URL: https://github.com/john-doe/my-cool-api

# 4. Step 2: Rename template and create PR
./scripts/rename-and-pr.sh -repo my-cool-api

# Output:
# [INFO] Starting project rename workflow...
# [INFO] Creating feature branch for repository rename...
# [SUCCESS] Created and checked out branch: feat/rename-to-my-cool-api
# ...
# [SUCCESS] Project rename workflow complete!

# 5. Verify the PR was created
gh pr view

# 6. (Optional) Merge the PR
gh pr merge --squash
```

**Result**: New GitHub repository `my-cool-api` with customized project files and merged PR.

---

## Scenario 2: Dry-Run Mode (Preview Before Executing)

**Goal**: Preview what would happen before running the actual scaffolding scripts.

**Use Cases**:
- Verify repository name is correct
- See which files would be modified
- Check replacement count
- Preview commit and PR content

### Steps

```bash
# 1. Navigate to template repository
cd ~/projects/agent-team-playground

# 2. Step 1: Preview repository creation
./scripts/repo-init.sh -repo my-cool-api --dry-run

# Output shows what would happen:
# [DRY-RUN] DRY-RUN MODE ENABLED - No changes will be made
# [INFO] Starting repository initialization...
# [DRY-RUN] (Would create) Repository: john-doe/my-cool-api
# [DRY-RUN] (Would configure) git remote: https://github.com/john-doe/my-cool-api.git
# [DRY-RUN] (Would push) branch 'main' to origin
# [DRY-RUN] Dry-run complete! No actual changes were made.

# 3. Step 2: Preview template rename
./scripts/rename-and-pr.sh -repo my-cool-api --dry-run

# Output shows files that would be modified:
# [DRY-RUN] DRY-RUN MODE ENABLED - No changes will be made
# [DRY-RUN] (Would create) feature branch: feat/rename-to-my-cool-api
# [DRY-RUN]   Would update: README.md (5 replacements)
# [DRY-RUN]   Would update: CLAUDE.md (3 replacements)
# [DRY-RUN]   Would update: frontend/package.json (2 replacements)
# [DRY-RUN] Would replace in 3 files (10 total replacements)
# [DRY-RUN] (Would commit) feat: rename template to my-cool-api
# [DRY-RUN] (Would create) Pull request

# 4. If everything looks good, run without --dry-run
./scripts/repo-init.sh -repo my-cool-api
./scripts/rename-and-pr.sh -repo my-cool-api
```

**Benefits**:
- ✅ Confidence before execution
- ✅ No risk of mistakes
- ✅ See exact list of files to be modified
- ✅ Verify replacement counts are reasonable
- ✅ Perfect for CI/CD validation pipelines

---

## Scenario 3: Multiple Projects from One Template

**Goal**: Create multiple projects using the same template, customizing each one.

### Steps

```bash
# 1. Template repository (your original)
cd ~/projects/agent-team-playground
git status  # main, clean

# 2. Create first project
./scripts/repo-init.sh -repo project-alpha
./scripts/rename-and-pr.sh -repo project-alpha
gh pr merge --squash

# 3. Create second project
./scripts/repo-init.sh -repo project-beta
./scripts/rename-and-pr.sh -repo project-beta
gh pr merge --squash

# 4. Create third project
./scripts/repo-init.sh -repo project-gamma
./scripts/rename-and-pr.sh -repo project-gamma
gh pr merge --squash

# All three repositories now exist with customized names:
# - project-alpha
# - project-beta
# - project-gamma
```

**Key Point**: Always return to main/master and ensure clean tree before creating each project.

---

## Scenario 4: Custom Template Name

**Goal**: Use a template with a non-standard name (not "agent-team-playground").

### Setup

```bash
# Clone a custom template
git clone https://github.com/your-org/my-custom-template.git
cd my-custom-template
git status  # main, clean
```

### Steps

```bash
# 1. Create GitHub repository
./scripts/repo-init.sh -repo awesome-service

# 2. Rename using custom template name
./scripts/rename-and-pr.sh -repo awesome-service -from my-custom-template

# Output shows it replaced "my-custom-template" with "awesome-service"
# [INFO] Replacing 'my-custom-template' with 'awesome-service' in files...
# [INFO]   Updated: README.md
# [INFO]   Updated: CLAUDE.md
# [INFO]   Updated: package.json
# ...
```

**Key Points**:
- Use `-from` to specify your custom template name
- Useful when you have multiple template repositories

---

## Scenario 5: Selective File Replacement

**Goal**: Replace template name but skip certain directories (custom exclusions).

### Problem

The default exclusion pattern skips `node_modules`, `.git`, `.env`, but you want to also skip `vendor/` and `cache/`.

### Steps

```bash
# 1. Create repository
./scripts/repo-init.sh -repo my-vendor-project

# 2. Rename with custom exclusion pattern
./scripts/rename-and-pr.sh -repo my-vendor-project \
  -exclude "node_modules|\.git|\.env|vendor|cache"

# This will:
# - Replace in all other files
# - Skip: node_modules/, .git/, .env, vendor/, cache/
```

### Common Exclusion Patterns

```bash
# Skip vendor directories (PHP/Ruby projects)
-exclude "node_modules|vendor|\.git"

# Skip build artifacts
-exclude "dist|build|target|out|\.git"

# Skip all temporary files
-exclude "tmp|temp|\.cache|\.git"

# Skip documentation
-exclude "docs|\.git|node_modules"
```

---

## Scenario 6: Agent Team Workflow

**Goal**: Full agent team collaboration: PM → Engineer → QA → DevOps.

### Team Roles

```
Project Manager (creates issue)
    ↓
Full Stack Engineer (scaffolds project)
    ↓
QA Engineer (validates PR)
    ↓
DevOps (merges and monitors)
```

### Workflow

#### Phase 1: Project Manager Creates Issue

```bash
# PM creates GitHub issue
gh issue create \
  --title "Scaffold: Create my-cool-api project" \
  --body "Create new project from agent-team-playground template

Target: my-cool-api
Assigned to: @full-stack-engineer"

# Issue number: #42
```

#### Phase 2: Full Stack Engineer Scaffolds Project

```bash
# Engineer reads issue
gh issue view 42

# Engineer scaffolds project
cd ~/projects/agent-team-playground
./scripts/repo-init.sh -repo my-cool-api
./scripts/rename-and-pr.sh -repo my-cool-api

# Engineer verifies PR
gh pr view

# Engineer adds comment
gh pr comment -b "Scaffolding complete. Ready for QA review."
```

#### Phase 3: QA Engineer Validates

```bash
# QA downloads PR
gh pr checkout

# QA verifies template names were replaced
grep -r "agent-team-playground" . 2>/dev/null || echo "✓ No template references found"

# QA validates project structure
test -d backend && test -d frontend && echo "✓ Project structure valid"

# QA approves PR
gh pr review --approve
```

#### Phase 4: DevOps Merges and Monitors

```bash
# DevOps checks PR status
gh pr checks

# DevOps merges PR
gh pr merge --squash --delete-branch

# DevOps verifies repository exists
gh repo view my-cool-api

# DevOps documents completion
gh issue comment 42 -b "✓ Project scaffolding complete and merged"
gh issue close 42
```

**Result**: Fully scaffolded project with audit trail of all agent actions.

---

## Scenario 7: Troubleshooting Workflow Errors

**Goal**: Handle and recover from common errors during scaffolding.

### Error 1: Uncommitted Changes

```bash
git status
# On branch main
# Changes not staged for commit:
#   modified: README.md

# Solution: Commit or stash
git add -A
git commit -m "Update readme"

# Now try again
./scripts/repo-init.sh -repo my-project
```

### Error 2: Not Authenticated

```bash
./scripts/repo-init.sh -repo my-project
# [ERROR] GitHub CLI not authenticated

# Solution: Login
gh auth login

# Verify
gh auth status

# Try again
./scripts/repo-init.sh -repo my-project
```

### Error 3: Repository Already Exists

```bash
./scripts/repo-init.sh -repo existing-repo
# [ERROR] Repository already exists: john-doe/existing-repo

# Solution: Use different name
./scripts/repo-init.sh -repo existing-repo-v2

# Or delete the existing repo and try again
gh repo delete existing-repo
./scripts/repo-init.sh -repo existing-repo
```

### Error 4: Branch Exists

```bash
./scripts/rename-and-pr.sh -repo my-project
# [ERROR] Branch already exists: feat/rename-to-my-project

# Solution: Delete the branch
git branch -D feat/rename-to-my-project

# Try again
./scripts/rename-and-pr.sh -repo my-project
```

### Error 5: Wrong Branch

```bash
./scripts/rename-and-pr.sh -repo my-project
# [ERROR] Must be on main or master branch. Currently on: develop

# Solution: Switch to main
git checkout main

# Try again
./scripts/rename-and-pr.sh -repo my-project
```

---

## Scenario 8: CI/CD Integration

**Goal**: Automate project scaffolding in a CI/CD pipeline.

### GitHub Actions Workflow

```yaml
# .github/workflows/scaffold-project.yml
name: Scaffold Project

on:
  workflow_dispatch:
    inputs:
      repo_name:
        description: "Target repository name"
        required: true
        type: string
      template_name:
        description: "Template name to replace"
        required: false
        default: "agent-team-playground"
        type: string

jobs:
  scaffold:
    runs-on: ubuntu-latest
    permissions:
      contents: write
      pull-requests: write

    steps:
      - uses: actions/checkout@v4

      - name: Setup GitHub CLI
        run: |
          sudo apt-get update
          sudo apt-get install -y gh

      - name: Authenticate GitHub CLI
        run: gh auth setup-git
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}

      - name: Step 1: Create Repository
        run: ./scripts/repo-init.sh -repo ${{ inputs.repo_name }}

      - name: Step 2: Rename and Create PR
        run: ./scripts/rename-and-pr.sh -repo ${{ inputs.repo_name }} -from ${{ inputs.template_name }}

      - name: Report Success
        run: |
          echo "✓ Project scaffolding complete!"
          echo "Repository: https://github.com/${{ github.repository_owner }}/${{ inputs.repo_name }}"
```

**Usage**:
```bash
# Trigger workflow from GitHub Actions UI:
# 1. Go to Actions tab
# 2. Select "Scaffold Project"
# 3. Click "Run workflow"
# 4. Enter repo_name: my-project
# 5. Enter template_name: agent-team-playground (or custom)
```

---

## Scenario 9: Batch Scaffolding with Bash Loop

**Goal**: Create multiple projects in sequence with a shell script.

### Create `scaffold-batch.sh`

```bash
#!/bin/bash
# Create multiple projects from template

set -euo pipefail

PROJECTS=(
  "microservice-auth"
  "microservice-api"
  "microservice-workers"
  "microservice-analytics"
)

cd ~/projects/agent-team-playground

for project in "${PROJECTS[@]}"; do
  echo "📦 Scaffolding: $project"

  # Step 1: Create repo
  ./scripts/repo-init.sh -repo "$project"

  # Step 2: Rename and create PR
  ./scripts/rename-and-pr.sh -repo "$project"

  # (Optional) Merge automatically
  gh pr merge --squash

  echo "✓ $project complete"
  echo ""
done

echo "🎉 All projects scaffolded!"
```

### Run It

```bash
chmod +x scaffold-batch.sh
./scaffold-batch.sh

# Output:
# 📦 Scaffolding: microservice-auth
# [INFO] Starting repository initialization...
# ...
# ✓ microservice-auth complete
#
# 📦 Scaffolding: microservice-api
# ...
# 🎉 All projects scaffolded!
```

---

## Scenario 10: Template Update Propagation

**Goal**: Update the template, then propagate changes to all scaffolded projects.

### Workflow

```bash
# 1. Update template repository
cd ~/projects/agent-team-playground
git checkout -b feature/add-docker
# ... make changes ...
git add -A
git commit -m "Add Docker support"
git push -u origin feature/add-docker
gh pr create

# 2. Merge PR to main
gh pr merge --squash

# 3. Pull latest changes in each scaffolded project
cd ~/projects/my-cool-api
git remote add template https://github.com/you/agent-team-playground.git
git fetch template main
git merge template/main

# 4. Resolve any conflicts and commit
git add -A
git commit -m "Sync with template updates"
git push
```

---

## Scenario 11: Testing with Temporary Directory

**Goal**: Test scripts in isolation before using on a real project.

**Recommended Workflow**: Use `--dry-run` first (Scenario 2), then run without it in a test environment.

### Test Steps

```bash
# 1. Start with dry-run to preview
./scripts/repo-init.sh -repo test-project --dry-run
./scripts/rename-and-pr.sh -repo test-project --dry-run

# 2. If everything looks good, you can test in a temporary directory
mkdir -p /tmp/test-scaffold
cd /tmp/test-scaffold

# 3. Initialize git
git init
git add . && git commit --allow-empty -m "Initial"

# 4. Copy scripts from original project
cp -r ~/projects/agent-team-playground/scripts .

# 5. Test with a test-specific name
./scripts/repo-init.sh -repo test-scaffold-$(date +%s)

# 6. Verify it worked
gh repo view <username>/test-scaffold-<timestamp>

# 7. Clean up (delete test repo)
gh repo delete test-scaffold-<timestamp> --confirm
```

**Better approach**: Use `--dry-run` instead of creating temporary test repositories!

---

## Best Practices

### ✅ Do's

- ✅ Verify clean git tree before running scripts
- ✅ Run from template repository root
- ✅ Use meaningful repository names
- ✅ Review PR before merging
- ✅ Document custom template names in team docs
- ✅ Use audit trail for tracking (scripts tag with `[agent-action]`)

### ❌ Don'ts

- ❌ Run from a subdirectory (errors will occur)
- ❌ Have uncommitted changes in template repo
- ❌ Create repos with invalid names
- ❌ Use `-from` value same as `-repo` value
- ❌ Run both scripts simultaneously (do Step 1, then Step 2)
- ❌ Skip validation steps (they catch errors early)

---

## Performance Tips

| Tip | Time Saved |
|-----|-----------|
| Merge PRs with `--squash` flag | Cleaner history |
| Use batch scripting for multiple projects | 30s per project |
| Cache GitHub CLI auth | Avoids re-login |
| Exclude large directories | Faster find/replace |

---

## See Also

- [API Reference](api.md) - All script options and parameters
- [Setup Guide](setup.md) - Environment setup and troubleshooting
- [SKILL.md](../SKILL.md) - Main skill overview

---

**Last Updated**: 2026-02-28
**Status**: Current
