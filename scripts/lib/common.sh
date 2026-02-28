#!/bin/bash
# Common utilities for scaffold-project-from-template scripts
# Provides: error handling, logging, validation, GitHub CLI helpers

set -euo pipefail

# Color codes for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m' # No Color

# Global dry-run flag
DRY_RUN="${DRY_RUN:-0}"

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

log_dry_run() {
    echo -e "${CYAN}[DRY-RUN]${NC} $*"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $*"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $*"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

# Exit with error message
die() {
    log_error "$@"
    exit 1
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Validate required commands are available
require_commands() {
    local missing=()
    for cmd in "$@"; do
        if ! command_exists "$cmd"; then
            missing+=("$cmd")
        fi
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        die "Missing required commands: ${missing[*]}"
    fi
}

# Check if we're in a git repository
is_git_repo() {
    git rev-parse --git-dir >/dev/null 2>&1
}

# Get current git branch
get_current_branch() {
    git rev-parse --abbrev-ref HEAD
}

# Check if git working tree is clean
is_git_clean() {
    [[ -z $(git status --porcelain) ]]
}

# Check if GitHub CLI is authenticated
is_gh_authenticated() {
    gh auth status >/dev/null 2>&1
}

# Validate repository name format (GitHub requirements)
validate_repo_name() {
    local name="$1"

    # GitHub allows: alphanumeric, hyphens, underscores, dots
    # Cannot start/end with hyphen
    if [[ ! $name =~ ^[a-zA-Z0-9._-]+$ ]] || \
       [[ $name =~ ^- ]] || \
       [[ $name =~ -$ ]]; then
        die "Invalid repository name: '$name'. Use alphanumeric, hyphens, underscores, or dots (no leading/trailing hyphens)"
    fi
}

# Get GitHub username
get_github_username() {
    gh api user -q '.login'
}

# Check if repository already exists on GitHub
repo_exists_on_github() {
    local username="$1"
    local repo_name="$2"

    gh repo view "$username/$repo_name" >/dev/null 2>&1
}

# Execute command and handle errors
run_command() {
    local cmd="$1"
    local description="${2:-Running: $cmd}"

    log_info "$description"
    if ! eval "$cmd"; then
        die "Failed: $description"
    fi
}

# Execute command only if not in dry-run mode
# In dry-run mode, just log what would be done
run_or_dry_run() {
    local cmd="$1"
    local description="${2:-Running: $cmd}"

    if [[ "$DRY_RUN" == "1" ]]; then
        log_dry_run "(Would execute) $description"
        return 0
    else
        log_info "$description"
        if ! eval "$cmd"; then
            die "Failed: $description"
        fi
    fi
}

# Check if in dry-run mode
is_dry_run() {
    [[ "$DRY_RUN" == "1" ]]
}

# Export all functions for sourcing
export -f log_info log_success log_warn log_error log_dry_run die
export -f command_exists require_commands
export -f is_git_repo get_current_branch is_git_clean
export -f is_gh_authenticated validate_repo_name get_github_username repo_exists_on_github
export -f run_command run_or_dry_run is_dry_run
