# Scaffold Project From Template Skill

**Purpose**: Automate repository creation and project customization using shell scripts powered by GitHub CLI.

**Version**: 1.0
**Last Updated**: 2026-02-28
**Type**: Automation Skill
**Status**: Production Ready

---

## Overview

This skill provides a two-step automation workflow to quickly scaffold a new project from a template repository:

1. **Create GitHub Repository** → Create a remote GitHub repo and push local artifacts
2. **Rename & Create PR** → Find/replace template names and create a pull request for review

### Key Benefits

✅ **Automated Setup** - Zero-manual GitHub configuration
✅ **Template Customization** - Find/replace template names in all project files
✅ **GitHub Integration** - Native `gh` CLI for repo creation and PR management
✅ **Error Handling** - Comprehensive validation and meaningful error messages
✅ **Audit Trail** - All actions tagged with `[agent-action]` for tracking

---

## Quick Start

### Prerequisites

```bash
# Ensure these are installed and available
which git        # Version control
which gh         # GitHub CLI
which sed        # Text processing (usually pre-installed)

# Authenticate with GitHub
gh auth login
```

### Basic Usage

```bash
# Step 1: Initialize repository (creates GitHub repo + pushes code)
./scripts/repo-init.sh -repo my-awesome-project

# Step 2: Rename template and create PR (customizes + creates PR)
./scripts/rename-and-pr.sh -repo my-awesome-project
```

**Time**: ~30 seconds for both steps
**Result**: A new GitHub repository with customized project files and an open PR ready for review

### Dry-Run Mode

Preview what would happen without making any changes:

```bash
# Preview repository creation
./scripts/repo-init.sh -repo my-awesome-project --dry-run

# Preview template rename and PR creation
./scripts/rename-and-pr.sh -repo my-awesome-project --dry-run
```

**Why use dry-run?**
- ✅ Verify operations before executing
- ✅ See list of files that would be modified
- ✅ See count of replacements per file
- ✅ Preview commit and PR content
- ✅ No actual changes made to repository

---

## Workflow Overview

```
Template Repository (local)
    ↓
    ├─→ Step 1: repo-init.sh
    │   ├─ Validate environment (git repo, gh authenticated, clean tree)
    │   ├─ Create GitHub repository
    │   ├─ Configure git remote (origin)
    │   └─ Push local artifacts to GitHub
    │
    └─→ Step 2: rename-and-pr.sh
        ├─ Create feature branch (feat/rename-to-*)
        ├─ Find/replace template names in files
        ├─ Commit changes with audit trail
        ├─ Push feature branch to GitHub
        └─ Create pull request for review

Result: Production-ready repository with PR ready to merge
```

---

## Files Modified by This Skill

**Scripts** (in `scripts/`):
- `repo-init.sh` - GitHub repository creation and artifact push
- `rename-and-pr.sh` - Template rename and PR creation
- `lib/common.sh` - Shared utilities and validation functions

**Documentation** (in `.claude/skills/scaffold-project-from-template/docs/`):
- `setup.md` - Installation and environment setup
- `api.md` - Complete script reference
- `examples.md` - Real-world usage patterns

---

## Quick Navigation

### For Beginners

Start with **[Setup Guide](docs/setup.md)** to install prerequisites and verify your environment.

### For Developers (Full Stack Engineer)

1. Read **[API Reference](docs/api.md)** to understand script options
2. Check **[Examples](docs/examples.md)** for common scenarios
3. Run the scripts following the Quick Start section above

### For DevOps / Automation

1. Review **[API Reference](docs/api.md)** for all options
2. Integrate into CI/CD pipelines using the script paths
3. Check error codes and validation logic in `scripts/lib/common.sh`

---

## Common Tasks

### Create a new project from template

```bash
# Scaffold a new project
./scripts/repo-init.sh -repo my-project
./scripts/rename-and-pr.sh -repo my-project
```

### Replace different template name

```bash
# If your template uses a different name
./scripts/rename-and-pr.sh -repo my-project -from old-template-name
```

### Customize exclusion patterns

```bash
# Skip certain files from replacement
./scripts/rename-and-pr.sh -repo my-project -exclude "vendor|cache"
```

---

## Error Handling

Both scripts validate prerequisites and provide clear error messages:

| Error | Solution |
|-------|----------|
| "Not a git repository" | Run scripts from project root |
| "GitHub CLI not authenticated" | Run `gh auth login` |
| "Working tree has uncommitted changes" | Commit or stash changes first |
| "Must be on main or master branch" | Checkout main/master before rename |
| "Repository already exists" | Use a different repository name |

---

## Logging

Scripts use color-coded output for clarity:

- 🔵 `[INFO]` - Informational messages
- 🟢 `[SUCCESS]` - Successful completion
- 🟡 `[WARN]` - Warning messages
- 🔴 `[ERROR]` - Errors (exits with code 1)

---

## Integration with Agent Team

This skill integrates with the agent team workflow:

1. **Full Stack Engineer** - Uses `repo-init.sh` and `rename-and-pr.sh` to scaffold projects
2. **DevOps / SRE** - Validates scripts in CI/CD pipeline
3. **Project Manager** - Tracks repository creation and PR workflow

### Tagging for Audit Trail

Both scripts tag commits with `[agent-action]` for traceability:

```
[agent-action] Generated by scaffold-project-from-template
```

---

## Core Sections

### [1. Setup Guide](docs/setup.md)
Prerequisites, environment validation, and dependency installation.

### [2. API Reference](docs/api.md)
Complete documentation for both scripts with all options and examples.

### [3. Examples](docs/examples.md)
Real-world scenarios and workflows using the scripts.

---

## Key Features

| Feature | Details |
|---------|---------|
| **Validation** | Environment checks (git, GitHub auth, clean tree) |
| **Error Handling** | Meaningful messages and early exit on issues |
| **Logging** | Color-coded output for clarity |
| **Flexibility** | Customizable template names and exclusion patterns |
| **GitHub Native** | Direct `gh` CLI integration |
| **Audit Trail** | All actions tagged `[agent-action]` |

---

## Architecture

### Scripts

**`repo-init.sh`** (90 lines)
- Parses `-repo` option
- Validates GitHub auth and repo name
- Creates GitHub repository
- Updates git remote
- Pushes artifacts

**`rename-and-pr.sh`** (150 lines)
- Parses `-repo`, `-from`, `-exclude` options
- Creates feature branch
- Finds and replaces template names
- Commits with audit trail
- Pushes branch and creates PR

**`lib/common.sh`** (100 lines)
- Shared logging functions (info, success, warn, error)
- Command validation (check if installed)
- Git utilities (branch, clean tree, repo status)
- GitHub utilities (auth check, username, repo exists)
- Parameter validation (repo name format)

### Design Principles

✅ **Fail Fast** - Validate all prerequisites before making changes
✅ **Clear Logging** - Color-coded messages for easy following
✅ **Reusable Utils** - Common functions in `lib/common.sh` for DRY code
✅ **Error Handling** - `set -euo pipefail` + explicit error checks
✅ **Audit Trail** - Every commit tagged for tracking

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-02-28 | Initial skill with repo creation and rename automation |

---

## Getting Started

1. **Verify Prerequisites** → Read [Setup Guide](docs/setup.md)
2. **Understand the Scripts** → Read [API Reference](docs/api.md)
3. **Run an Example** → Follow [Examples](docs/examples.md)
4. **Execute** → Use Quick Start section above

---

## Support

For questions about this skill:

1. **Setup issues?** → Check [Setup Guide](docs/setup.md)
2. **How to use?** → Read [API Reference](docs/api.md)
3. **Real examples?** → See [Examples](docs/examples.md)
4. **Git/GitHub issues?** → Review error handling in script output

---

**Created**: 2026-02-28
**Last Reviewed**: 2026-02-28
**Status**: Production Ready
**Next Review**: 2026-03-28
