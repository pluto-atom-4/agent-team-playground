#!/bin/bash
# repo-init.sh - Create GitHub repository and push local artifacts
#
# Usage: ./repo-init.sh -repo <repository-name>
#
# Options:
#   -repo <name>      GitHub repository name (required)
#   -h, --help        Show this help message
#
# Example:
#   ./repo-init.sh -repo my-awesome-project

set -euo pipefail

# Script directory and common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"

# Configuration
REPO_NAME=""
GITHUB_USER=""
DRY_RUN=0

# Parse command line options
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -repo)
                REPO_NAME="$2"
                shift 2
                ;;
            -dry-run|--dry-run)
                DRY_RUN=1
                export DRY_RUN
                shift 1
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                die "Unknown option: $1"
                ;;
        esac
    done
}

show_help() {
    cat << EOF
Usage: $(basename "$0") -repo <repository-name> [--dry-run]

Create a new GitHub repository and push local artifacts to it.

Options:
  -repo <name>      GitHub repository name (required, alphanumeric/hyphens/underscores/dots)
  -dry-run          Preview what would be done without making changes
  -h, --help        Show this help message

Examples:
  # Create a repo named 'my-awesome-project'
  $(basename "$0") -repo my-awesome-project

  # Preview what would happen (dry-run)
  $(basename "$0") -repo my-awesome-project --dry-run

  # Create a repo named 'project_v2'
  $(basename "$0") -repo project_v2

Prerequisites:
  - GitHub CLI (gh) installed and authenticated
  - Inside a git repository
  - Clean working tree (no uncommitted changes)

Dry-run:
  Use --dry-run to see what operations would be performed without actually:
  - Creating the GitHub repository
  - Updating the git remote
  - Pushing to remote (all validation still occurs)

EOF
}

validate_environment() {
    # Check required commands
    require_commands "git" "gh"

    # Validate we're in a git repo
    if ! is_git_repo; then
        die "Not a git repository. Run from the root of your project."
    fi

    # Check GitHub authentication
    if ! is_gh_authenticated; then
        die "GitHub CLI not authenticated. Run 'gh auth login' first."
    fi

    # Verify working tree is clean
    if ! is_git_clean; then
        die "Working tree has uncommitted changes. Commit or stash them first."
    fi
}

validate_inputs() {
    # Check required parameters
    if [[ -z "$REPO_NAME" ]]; then
        die "Missing required option: -repo <repository-name>"
    fi

    # Validate repo name format
    validate_repo_name "$REPO_NAME"
}

create_github_repository() {
    log_info "Creating GitHub repository: $REPO_NAME"

    # Get current GitHub username
    GITHUB_USER=$(get_github_username)
    log_info "Using GitHub user: $GITHUB_USER"

    # In dry-run, skip the existence check and just log what would happen
    if [[ "$DRY_RUN" != "1" ]]; then
        # Check if repo already exists
        if repo_exists_on_github "$GITHUB_USER" "$REPO_NAME"; then
            die "Repository already exists: $GITHUB_USER/$REPO_NAME"
        fi

        # Create the repository on GitHub
        if ! gh repo create "$REPO_NAME" --source=. --remote=origin --push 2>/dev/null; then
            die "Failed to create repository on GitHub"
        fi
    fi

    log_dry_run "(Would create) Repository: $GITHUB_USER/$REPO_NAME"
    if [[ "$DRY_RUN" != "1" ]]; then
        log_success "Repository created: $GITHUB_USER/$REPO_NAME"
    fi
}

update_git_remote() {
    log_info "Configuring git remote..."

    local remote_url="https://github.com/${GITHUB_USER}/${REPO_NAME}.git"

    if [[ "$DRY_RUN" == "1" ]]; then
        log_dry_run "(Would configure) git remote: $remote_url"
    else
        # Update remote origin
        if git remote get-url origin | grep -q "github.com"; then
            git remote set-url origin "$remote_url"
            log_success "Remote origin updated: $remote_url"
        else
            git remote add origin "$remote_url"
            log_success "Remote origin added: $remote_url"
        fi
    fi
}

push_to_remote() {
    log_info "Pushing to remote repository..."

    local current_branch
    current_branch=$(get_current_branch)

    if [[ "$DRY_RUN" == "1" ]]; then
        log_dry_run "(Would push) branch '$current_branch' to origin"
    else
        if ! git push -u origin "$current_branch"; then
            die "Failed to push to remote repository"
        fi
        log_success "Pushed branch '$current_branch' to origin"
    fi
}

main() {
    # Parse arguments first to check for dry-run
    parse_args "$@"

    # Display mode
    if [[ "$DRY_RUN" == "1" ]]; then
        log_dry_run "DRY-RUN MODE ENABLED - No changes will be made"
    fi

    log_info "Starting repository initialization..."

    # Validate environment
    validate_environment

    # Validate inputs
    validate_inputs

    # Create repository on GitHub
    create_github_repository

    # Update git remote
    update_git_remote

    # Push to remote
    push_to_remote

    if [[ "$DRY_RUN" == "1" ]]; then
        log_dry_run "Dry-run complete! No actual changes were made."
        log_info "To execute these operations, run without --dry-run flag"
    else
        log_success "Repository initialization complete!"
    fi

    log_info "Repository URL: https://github.com/${GITHUB_USER}/${REPO_NAME}"
}

main "$@"
