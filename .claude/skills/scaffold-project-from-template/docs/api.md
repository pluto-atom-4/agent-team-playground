# API Reference

Complete documentation for all scripts and their options.

---

## Scripts Overview

| Script | Purpose | Time | Status |
|--------|---------|------|--------|
| `repo-init.sh` | Create GitHub repo + push artifacts | 5-15s | Step 1 |
| `rename-and-pr.sh` | Rename template + create PR | 10-20s | Step 2 |
| `lib/common.sh` | Shared utilities (not directly called) | - | Support |

---

## repo-init.sh

Create a new GitHub repository and push local artifacts to it.

### Usage

```bash
./scripts/repo-init.sh -repo <repository-name>
```

### Options

| Option | Required | Description | Example |
|--------|----------|-------------|---------|
| `-repo <name>` | Yes | GitHub repository name | `my-awesome-project` |
| `--dry-run` | No | Preview without making changes | N/A |
| `-h, --help` | No | Show help message | N/A |

### Repository Name Requirements

- **Allowed characters**: Letters (a-z, A-Z), numbers (0-9), hyphens (`-`), underscores (`_`), dots (`.`)
- **Cannot start with**: Hyphen (`-`)
- **Cannot end with**: Hyphen (`-`)
- **Case sensitive**: GitHub treats `MyProject` and `myproject` as different

### Examples

#### Basic Usage

```bash
./scripts/repo-init.sh -repo my-awesome-project
```

Expected output:
```
[INFO] Starting repository initialization...
[INFO] Creating GitHub repository: my-awesome-project
[INFO] Using GitHub user: your-username
[INFO] Configuring git remote...
[INFO] Pushing to remote repository...
[SUCCESS] Repository initialization complete!
[INFO] Repository URL: https://github.com/your-username/my-awesome-project
```

#### With Different Repository Names

```bash
# With hyphens
./scripts/repo-init.sh -repo my-cool-app

# With underscores
./scripts/repo-init.sh -repo my_cool_app

# With version number
./scripts/repo-init.sh -repo project.v2

# With dots
./scripts/repo-init.sh -repo my.project.name
```

#### Dry-Run Mode

```bash
./scripts/repo-init.sh -repo my-awesome-project --dry-run
```

Expected output:
```
[DRY-RUN] DRY-RUN MODE ENABLED - No changes will be made
[INFO] Starting repository initialization...
[DRY-RUN] (Would execute) Validating environment...
[INFO] Using GitHub user: your-username
[DRY-RUN] (Would create) Repository: your-username/my-awesome-project
[DRY-RUN] (Would configure) git remote: https://github.com/your-username/my-awesome-project.git
[DRY-RUN] (Would push) branch 'main' to origin
[DRY-RUN] Dry-run complete! No actual changes were made.
[INFO] To execute these operations, run without --dry-run flag
```

**What dry-run does NOT create**:
- ❌ GitHub repository
- ❌ Git remote updates
- ❌ Pushes to remote

#### Show Help

```bash
./scripts/repo-init.sh --help
```

### What This Script Does

1. **Validate Environment**
   - Checks `git` and `gh` commands are available
   - Verifies you're in a git repository
   - Confirms GitHub CLI is authenticated
   - Ensures working tree is clean (no uncommitted changes)

2. **Create Repository on GitHub**
   - Gets your GitHub username
   - Checks if repository already exists
   - Creates new repository on GitHub using `gh repo create`

3. **Configure Git Remote**
   - Updates or creates `origin` remote
   - Points to new GitHub repository

4. **Push Artifacts**
   - Pushes current branch to remote
   - Sets up upstream tracking

### Error Messages

| Error | Solution |
|-------|----------|
| `Missing required commands: git, gh` | Install git and GitHub CLI |
| `Not a git repository` | Run from project root |
| `GitHub CLI not authenticated` | Run `gh auth login` |
| `Working tree has uncommitted changes` | Commit or stash changes |
| `Invalid repository name: '...'` | Use only alphanumeric, hyphens, underscores, dots |
| `Repository already exists` | Use a different repository name |
| `Failed to create repository on GitHub` | Check GitHub authentication or permissions |

### Exit Codes

| Code | Meaning |
|------|---------|
| `0` | Success |
| `1` | Validation failed or operation error |

---

## rename-and-pr.sh

Create a feature branch, rename template references, and create a pull request.

### Usage

```bash
./scripts/rename-and-pr.sh -repo <repository-name> [-from <old-name>] [-exclude <pattern>]
```

### Options

| Option | Required | Default | Description | Example |
|--------|----------|---------|-------------|---------|
| `-repo <name>` | Yes | - | Target repository name | `my-awesome-project` |
| `-from <name>` | No | `agent-team-playground` | Template name to replace | `old-template` |
| `-exclude <pattern>` | No | `node_modules\|\.git\|\.env...` | Files to skip | `vendor\|cache` |
| `--dry-run` | No | - | Preview without making changes | N/A |
| `-h, --help` | No | - | Show help message | N/A |

### Default Exclusion Pattern

The script skips these by default:
```
node_modules|\.git|\.env|scripts/lib|\.claude/skills|\.cargo|dist|build
```

This prevents replacing in:
- Node modules
- Git directory
- Environment files
- Build artifacts
- Script libraries (preventing self-reference)

### Examples

#### Basic Usage

```bash
./scripts/rename-and-pr.sh -repo my-awesome-project
```

Expected output:
```
[INFO] Starting project rename workflow...
[INFO] Creating feature branch for repository rename...
[SUCCESS] Created and checked out branch: feat/rename-to-my-awesome-project
[INFO] Finding files to update...
[INFO] Replacing 'agent-team-playground' with 'my-awesome-project' in files...
[INFO]   Updated: README.md
[INFO]   Updated: CLAUDE.md
[INFO]   Updated: frontend/package.json
[SUCCESS] Replaced in 3 files
[INFO] Committing changes...
[SUCCESS] Committed: feat: rename template to my-awesome-project
[INFO] Pushing feature branch to remote...
[SUCCESS] Pushed branch: origin/feat/rename-to-my-awesome-project
[INFO] Creating pull request...
[SUCCESS] Pull request created
[SUCCESS] Project rename workflow complete!
```

#### Replace Different Template Name

```bash
# If your template uses 'old-template-name' instead of 'agent-team-playground'
./scripts/rename-and-pr.sh -repo my-project -from old-template-name
```

#### Custom Exclusion Pattern

```bash
# Skip vendor and cache directories
./scripts/rename-and-pr.sh -repo my-project -exclude "vendor|cache"

# Skip multiple patterns
./scripts/rename-and-pr.sh -repo my-project -exclude "node_modules|vendor|\.env"
```

#### Dry-Run Mode

```bash
./scripts/rename-and-pr.sh -repo my-awesome-project --dry-run
```

Expected output:
```
[DRY-RUN] DRY-RUN MODE ENABLED - No changes will be made
[INFO] Starting project rename workflow...
[DRY-RUN] (Would create) feature branch: feat/rename-to-my-awesome-project
[INFO] Finding files to update...
[INFO] Replacing 'agent-team-playground' with 'my-awesome-project' in files...
[DRY-RUN]   Would update: README.md (3 replacements)
[DRY-RUN]   Would update: CLAUDE.md (2 replacements)
[DRY-RUN]   Would update: frontend/package.json (1 replacements)
[DRY-RUN] Would replace in 3 files (6 total replacements)
[DRY-RUN] (Would commit) feat: rename template to my-awesome-project
[DRY-RUN]   Message: Automated repository rename from 'agent-team-playground' to 'my-awesome-project'
[DRY-RUN]   Tags: [agent-action] Generated by scaffold-project-from-template
[DRY-RUN] (Would push) branch: origin/feat/rename-to-my-awesome-project
[DRY-RUN] (Would create) Pull request
[DRY-RUN]   Title: feat: rename template to my-awesome-project
[DRY-RUN]   Branch: feat/rename-to-my-awesome-project → main
[DRY-RUN] Dry-run complete! No actual changes were made.
[INFO] To execute these operations, run without --dry-run flag
```

**Key dry-run information shown**:
- ✅ Files that would be modified
- ✅ Replacement count per file
- ✅ Total replacement count
- ✅ Commit message that would be created
- ✅ Pull request details
- ✅ Feature branch name

**What dry-run does NOT create**:
- ❌ Feature branch
- ❌ File modifications
- ❌ Commits
- ❌ Pushes to remote
- ❌ Pull request

#### Show Help

```bash
./scripts/rename-and-pr.sh --help
```

### What This Script Does

1. **Validate Environment**
   - Checks `git`, `gh`, `sed` are available
   - Verifies you're in a git repository
   - Confirms GitHub CLI is authenticated
   - Ensures working tree is clean
   - Verifies you're on main or master branch

2. **Create Feature Branch**
   - Creates branch: `feat/rename-to-{repo-name}`
   - Checks out to new branch

3. **Find and Replace**
   - Searches all files for template name
   - Skips excluded patterns (node_modules, .git, etc.)
   - Replaces using `sed` (atomic, safe)

4. **Commit with Audit Trail**
   - Stages all changes
   - Creates commit with message
   - Tags with `[agent-action]` for tracking

5. **Push to Remote**
   - Pushes feature branch with upstream tracking

6. **Create Pull Request**
   - Creates PR with title and description
   - Links to main or master branch
   - Includes summary of changes

### Error Messages

| Error | Solution |
|-------|----------|
| `Missing required commands: git, gh, sed` | Install git, GitHub CLI, sed |
| `Not a git repository` | Run from project root |
| `GitHub CLI not authenticated` | Run `gh auth login` |
| `Working tree has uncommitted changes` | Commit or stash changes |
| `Must be on main or master branch` | Checkout main or master first |
| `Branch already exists: ...` | Delete existing branch or use different repo name |
| `Invalid repository name: ...` | Use valid repository name format |
| `Repository name must be different` | Use different name from template name |
| `Failed to push branch to remote` | Check GitHub authentication or permissions |
| `Failed to create pull request` | Check branch exists and GitHub auth |

### Exit Codes

| Code | Meaning |
|------|---------|
| `0` | Success |
| `1` | Validation failed or operation error |

---

## lib/common.sh

Shared utility functions used by both scripts. This file is sourced, not executed directly.

### Functions

#### Logging Functions

```bash
log_info "message"      # Blue [INFO] output
log_success "message"   # Green [SUCCESS] output
log_warn "message"      # Yellow [WARN] output
log_error "message"     # Red [ERROR] output (to stderr)
die "message"           # Red [ERROR] and exit 1
```

#### Command Validation

```bash
command_exists "git"              # Returns 0 if command exists
require_commands "git" "gh" "sed" # Exits if any missing
```

#### Git Utilities

```bash
is_git_repo              # Check if in git repository
get_current_branch       # Get current branch name
is_git_clean             # Check if working tree is clean
```

#### GitHub Utilities

```bash
is_gh_authenticated           # Check GitHub CLI authentication
get_github_username           # Get authenticated GitHub username
repo_exists_on_github <user> <repo>  # Check if repo exists
validate_repo_name <name>     # Validate repository name format
```

#### Command Execution

```bash
run_command "git push" "Pushing to remote"  # Execute with logging
```

---

## Workflow Summary

### Two-Step Process

```
Step 1: repo-init.sh
├─ Create GitHub repository
├─ Configure git remote
└─ Push local artifacts

↓ (wait for verification, or proceed immediately)

Step 2: rename-and-pr.sh
├─ Create feature branch
├─ Replace template names in files
├─ Commit with audit trail
├─ Push branch to GitHub
└─ Create pull request

Result: GitHub repo with customized PR ready to merge
```

### Command Sequence

```bash
# (Optional) Step 0: Preview with dry-run
./scripts/repo-init.sh -repo my-project --dry-run
./scripts/rename-and-pr.sh -repo my-project --dry-run

# Step 1: Repository creation (5-15 seconds)
./scripts/repo-init.sh -repo my-project

# Verify it worked (optional)
git remote -v
# Should show: origin https://github.com/username/my-project.git

# Step 2: Template rename (10-20 seconds)
./scripts/rename-and-pr.sh -repo my-project

# Check results (optional)
gh pr view
# Should show the created pull request
```

**Pro Tip**: Always run with `--dry-run` first to preview what will happen!

---

## Integration Examples

### In CI/CD Pipelines

```bash
#!/bin/bash
# Script to scaffold projects in CI/CD

REPO_NAME="${CI_PROJECT_NAME}"
SOURCE_REPO="${CI_TEMPLATE_REPO:-agent-team-playground}"

# Step 1: Initialize
scripts/repo-init.sh -repo "$REPO_NAME"

# Step 2: Rename
scripts/rename-and-pr.sh -repo "$REPO_NAME" -from "$SOURCE_REPO"

echo "Project scaffolding complete!"
```

### In Agent Team Workflows

```bash
# DevOps validates script execution
gh pr checks --required --fail-fast

# Full Stack Engineer monitors PR
gh pr view --json title,body

# Project Manager merges after approval
gh pr merge --squash
```

---

## Performance Characteristics

| Operation | Time | Notes |
|-----------|------|-------|
| Repo creation | 2-5s | Network dependent |
| File replacement | 1-3s | Depends on project size |
| Total workflow | 15-30s | Both steps sequential |

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-02-28 | Initial API with repo-init and rename-and-pr scripts |

---

## See Also

- [Setup Guide](setup.md) - Installation and environment setup
- [Examples](examples.md) - Real-world usage patterns
- [SKILL.md](../SKILL.md) - Main skill overview

---

**Last Updated**: 2026-02-28
**Status**: Current
