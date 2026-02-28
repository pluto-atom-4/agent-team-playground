# Setup Guide

This guide covers prerequisites, installation, and environment validation for the `scaffold-project-from-template` skill.

---

## Prerequisites

### Required Software

1. **Git** (version 2.20+)
   - Check: `git --version`
   - Install: https://git-scm.com/downloads

2. **GitHub CLI (gh)** (version 2.0+)
   - Check: `gh --version`
   - Install: https://cli.github.com/

3. **sed** (usually pre-installed)
   - Check: `sed --version`
   - Install: Already included in macOS and Linux

4. **bash** (version 4.0+)
   - Check: `bash --version`
   - Note: Scripts use `set -euo pipefail` for safety

---

## Installation Steps

### 1. Verify Git Installation

```bash
git --version
# Output should be: git version 2.20+
```

### 2. Verify GitHub CLI Installation

```bash
gh --version
# Output should be: gh version 2.0+
```

If not installed, follow: https://cli.github.com/

### 3. Authenticate with GitHub

```bash
gh auth login

# When prompted:
# 1. Select: GitHub.com
# 2. Select: HTTPS
# 3. Enter "Y" for credential authentication
# 4. Paste your personal access token (or create new)
```

**Verify authentication**:
```bash
gh auth status
# Output: Logged in to github.com as <your-username>
```

### 4. Make Scripts Executable

```bash
chmod +x scripts/repo-init.sh
chmod +x scripts/rename-and-pr.sh
chmod +x scripts/lib/common.sh
```

### 5. Verify Environment

Run the validation script to confirm everything is set up:

```bash
# Check all prerequisites
git rev-parse --git-dir >/dev/null && echo "✓ Git repo"
gh auth status >/dev/null && echo "✓ GitHub CLI authenticated"
command -v sed >/dev/null && echo "✓ sed available"
```

Expected output:
```
✓ Git repo
✓ GitHub CLI authenticated
✓ sed available
```

---

## Environment Validation

### Script Validation

The scripts automatically validate the environment before running:

```bash
./scripts/repo-init.sh -repo test-repo

# This validates:
# - git and gh commands are available
# - You're inside a git repository
# - GitHub CLI is authenticated
# - Working tree is clean (no uncommitted changes)
```

### Common Issues

#### Issue: "command not found: gh"

**Solution**: Install GitHub CLI
```bash
# macOS (using Homebrew)
brew install gh

# Ubuntu/Debian
sudo apt install gh

# Windows (using Chocolatey)
choco install gh

# Or download: https://cli.github.com/
```

#### Issue: "GitHub CLI not authenticated"

**Solution**: Authenticate with GitHub
```bash
gh auth login

# Or check status
gh auth status
```

#### Issue: "Not a git repository"

**Solution**: Run from project root
```bash
cd /path/to/your/project
./scripts/repo-init.sh -repo my-project
```

#### Issue: "Working tree has uncommitted changes"

**Solution**: Commit or stash changes
```bash
# Option 1: Commit changes
git add .
git commit -m "Your message"

# Option 2: Stash changes
git stash
```

---

## Optional Setup

### Add to PATH (optional)

Make scripts accessible from anywhere:

```bash
# Add scripts directory to PATH
export PATH="$PATH:$(pwd)/scripts"

# Then you can run:
repo-init.sh -repo my-project
rename-and-pr.sh -repo my-project
```

Add to `~/.bashrc` or `~/.zshrc` for persistence:
```bash
export PATH="$PATH:/path/to/project/scripts"
```

### Git Configuration (optional)

Configure git for consistent commits:

```bash
# Set your name and email (if not already set)
git config user.name "Your Name"
git config user.email "your.email@example.com"

# Verify
git config --list | grep user
```

---

## Testing the Setup

### Quick Test

1. **Create a test branch**:
   ```bash
   git checkout -b setup-test
   ```

2. **Run validation**:
   ```bash
   ./scripts/repo-init.sh --help
   # Should show the help message
   ```

3. **Clean up**:
   ```bash
   git checkout main
   git branch -D setup-test
   ```

### Full Workflow Test (Optional)

If you want to test the full workflow before using on a real project:

```bash
# 1. Create a temporary test directory
mkdir -p /tmp/test-project && cd /tmp/test-project
git init
git add . && git commit -m "Initial commit" --allow-empty

# 2. Copy scripts or create symlinks
cp -r /path/to/original/scripts .

# 3. Test repo creation
./scripts/repo-init.sh -repo test-scaffold-$(date +%s)
```

**Warning**: This creates actual GitHub repositories. Clean them up afterward!

---

## Troubleshooting

### Debug Mode

Enable detailed output for troubleshooting:

```bash
# Run script with bash debug flag
bash -x ./scripts/repo-init.sh -repo my-project
```

This shows every executed command.

### Check Script Syntax

Verify scripts have no syntax errors:

```bash
bash -n scripts/repo-init.sh      # Check syntax
bash -n scripts/rename-and-pr.sh  # Check syntax
```

### Manual Command Testing

Test individual commands:

```bash
# Check git status
git status

# Check GitHub CLI status
gh auth status

# Check sed availability
sed --version

# Check current branch
git rev-parse --abbrev-ref HEAD
```

---

## Next Steps

1. **Understand the Scripts** → Read [API Reference](api.md)
2. **See Real Examples** → Review [Examples](examples.md)
3. **Get Started** → Use the Quick Start in main [SKILL.md](../SKILL.md)

---

**Last Updated**: 2026-02-28
**Status**: Current
