#!/bin/bash
# rename-and-pr.sh - Find/replace repository names and create PR
#
# Usage: ./rename-and-pr.sh -repo <repository-name> [-from <old-name>] [-exclude <pattern>]
#
# Options:
#   -repo <name>        Target repository name (required)
#   -from <name>        Original template name to replace (default: 'agent-team-playground')
#   -exclude <pattern>  Exclude files matching pattern (default: 'node_modules|.git|.env')
#   -h, --help          Show this help message
#
# Example:
#   ./rename-and-pr.sh -repo my-awesome-project

set -euo pipefail

# Script directory and common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"

# Configuration
REPO_NAME=""
FROM_NAME="agent-team-playground"
EXCLUDE_PATTERN="node_modules|\.git|\.env|scripts/lib|\.claude/skills|\.cargo|dist|build"
BRANCH_NAME=""
COMMIT_MESSAGE=""
DRY_RUN=0

# Derived values
PR_TITLE=""
PR_DESCRIPTION=""

# Parse command line options
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -repo)
                REPO_NAME="$2"
                shift 2
                ;;
            -from)
                FROM_NAME="$2"
                shift 2
                ;;
            -exclude)
                EXCLUDE_PATTERN="$2"
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
Usage: $(basename "$0") -repo <repository-name> [-from <old-name>] [-exclude <pattern>] [--dry-run]

Create a feature branch, rename template references, and create a pull request.

Options:
  -repo <name>        Target repository name (required)
  -from <name>        Original template name to replace (default: 'agent-team-playground')
  -exclude <pattern>  Exclude files matching pattern (default excludes: node_modules, .git, .env, etc.)
  -dry-run            Preview what would be done without making changes
  -h, --help          Show this help message

Examples:
  # Basic usage
  $(basename "$0") -repo my-awesome-project

  # Preview what would happen (dry-run)
  $(basename "$0") -repo my-awesome-project --dry-run

  # Replace a different template name
  $(basename "$0") -repo my-project -from old-template-name

  # Custom exclusion pattern
  $(basename "$0") -repo my-project -exclude "vendor|cache"

Prerequisites:
  - Inside a git repository
  - On the main/master branch
  - Clean working tree

Dry-run:
  Use --dry-run to see what files would be modified and how many replacements
  would be made without actually:
  - Creating the feature branch
  - Modifying any files
  - Creating a commit or pull request

EOF
}

validate_environment() {
    # Check required commands
    require_commands "git" "gh" "sed"

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

    # Verify we're on main/master branch
    local current_branch
    current_branch=$(get_current_branch)
    if [[ "$current_branch" != "main" && "$current_branch" != "master" ]]; then
        die "Must be on main or master branch. Currently on: $current_branch"
    fi
}

validate_inputs() {
    # Check required parameters
    if [[ -z "$REPO_NAME" ]]; then
        die "Missing required option: -repo <repository-name>"
    fi

    # Validate repo name format
    validate_repo_name "$REPO_NAME"

    # Validate that FROM_NAME is different from REPO_NAME
    if [[ "$FROM_NAME" == "$REPO_NAME" ]]; then
        die "Repository name must be different from the template name: $FROM_NAME"
    fi
}

create_feature_branch() {
    log_info "Creating feature branch for repository rename..."

    BRANCH_NAME="feat/rename-to-${REPO_NAME}"

    if [[ "$DRY_RUN" != "1" ]]; then
        if git rev-parse --verify "$BRANCH_NAME" >/dev/null 2>&1; then
            die "Branch already exists: $BRANCH_NAME"
        fi

        git checkout -b "$BRANCH_NAME"
        log_success "Created and checked out branch: $BRANCH_NAME"
    else
        log_dry_run "(Would create) feature branch: $BRANCH_NAME"
    fi
}

find_files_to_replace() {
    log_info "Finding files to update (excluding: $EXCLUDE_PATTERN)..."

    # Find all files, exclude patterns, and filter out binary files
    find . -type f \
        -not -path "*/\.*" \
        -not -path "*.git/*" \
        -not -path "*/node_modules/*" \
        -not -path "*/dist/*" \
        -not -path "*/build/*" \
        ! -size 0 \
        ! -exec file {} \; -print | grep -v "binary" | grep -v "\.git/" | sort
}

replace_in_files() {
    log_info "Replacing '$FROM_NAME' with '$REPO_NAME' in files..."

    local count=0
    local modified_files=()
    local replacement_count=0

    # Use grep to find files containing FROM_NAME
    while IFS= read -r file; do
        # Skip excluded patterns
        if echo "$file" | grep -E "($EXCLUDE_PATTERN)" >/dev/null; then
            continue
        fi

        # Check if file contains FROM_NAME and is readable/writable
        if grep -q "$FROM_NAME" "$file" 2>/dev/null && [[ -w "$file" ]]; then
            modified_files+=("$file")
            ((count++))

            # Count how many replacements would be made in this file
            local file_replacements
            file_replacements=$(grep -o "$FROM_NAME" "$file" 2>/dev/null | wc -l)
            ((replacement_count += file_replacements))

            if [[ "$DRY_RUN" == "1" ]]; then
                log_dry_run "  Would update: $file ($file_replacements replacements)"
            else
                # Use sed to replace (with proper escaping for special characters)
                # Use pipe (|) as delimiter to avoid conflicts with forward slashes
                sed -i "s|${FROM_NAME}|${REPO_NAME}|g" "$file"
                log_info "  Updated: $file"
            fi
        fi
    done < <(find . -type f ! -path "*/\.*" ! -path "*.git/*" ! -size 0)

    if [[ $count -eq 0 ]]; then
        log_warn "No files found containing '$FROM_NAME' to replace"
    else
        if [[ "$DRY_RUN" == "1" ]]; then
            log_dry_run "Would replace in $count files ($replacement_count total replacements)"
        else
            log_success "Replaced in $count files ($replacement_count total replacements)"
        fi
    fi
}

commit_changes() {
    log_info "Committing changes..."

    COMMIT_MESSAGE="feat: rename template to ${REPO_NAME}"

    if [[ "$DRY_RUN" == "1" ]]; then
        log_dry_run "(Would commit) $COMMIT_MESSAGE"
        log_dry_run "  Message: Automated repository rename from '${FROM_NAME}' to '${REPO_NAME}'"
        log_dry_run "  Tags: [agent-action] Generated by scaffold-project-from-template"
    else
        # Check if there are staged changes
        if ! is_git_clean; then
            git add -A
            git commit -m "$COMMIT_MESSAGE" \
                -m "Automated repository rename from '${FROM_NAME}' to '${REPO_NAME}'" \
                -m "[agent-action] Generated by scaffold-project-from-template"

            log_success "Committed: $COMMIT_MESSAGE"
        else
            log_warn "No changes to commit"
        fi
    fi
}

push_to_remote() {
    log_info "Pushing feature branch to remote..."

    if [[ "$DRY_RUN" == "1" ]]; then
        log_dry_run "(Would push) branch: origin/$BRANCH_NAME"
    else
        if ! git push -u origin "$BRANCH_NAME"; then
            die "Failed to push branch to remote"
        fi
        log_success "Pushed branch: origin/$BRANCH_NAME"
    fi
}

create_pull_request() {
    log_info "Creating pull request..."

    PR_TITLE="feat: rename template to ${REPO_NAME}"
    PR_DESCRIPTION="## Summary
Automated repository rename from \`${FROM_NAME}\` to \`${REPO_NAME}\`.

### Changes
- Updated all references to \`${FROM_NAME}\` in project files
- Updated documentation and configuration files
- Maintained all project structure and functionality

### Next Steps
1. Review the changes
2. Merge to main
3. Repository is ready for use

---
Generated by \`scaffold-project-from-template\` skill"

    if [[ "$DRY_RUN" == "1" ]]; then
        log_dry_run "(Would create) Pull request"
        log_dry_run "  Title: $PR_TITLE"
        log_dry_run "  Branch: $BRANCH_NAME → main"
        log_dry_run "  Summary: Automated repository rename from '${FROM_NAME}' to '${REPO_NAME}'"
    else
        if ! gh pr create \
            --title "$PR_TITLE" \
            --body "$PR_DESCRIPTION" \
            --head "$BRANCH_NAME" \
            --base main 2>/dev/null; then
            # Fallback to master if main doesn't exist
            gh pr create \
                --title "$PR_TITLE" \
                --body "$PR_DESCRIPTION" \
                --head "$BRANCH_NAME" \
                --base master || die "Failed to create pull request"
        fi

        log_success "Pull request created"
    fi
}

main() {
    # Parse arguments first to check for dry-run
    parse_args "$@"

    # Display mode
    if [[ "$DRY_RUN" == "1" ]]; then
        log_dry_run "DRY-RUN MODE ENABLED - No changes will be made"
    fi

    log_info "Starting project rename workflow..."

    # Validate environment and inputs
    validate_environment
    validate_inputs

    # Create feature branch
    create_feature_branch

    # Find and replace
    replace_in_files

    # Commit changes
    commit_changes

    # Push to remote
    push_to_remote

    # Create PR
    create_pull_request

    if [[ "$DRY_RUN" == "1" ]]; then
        log_dry_run "Dry-run complete! No actual changes were made."
        log_info "To execute these operations, run without --dry-run flag"
    else
        log_success "Project rename workflow complete!"
    fi

    log_info "Feature branch: $BRANCH_NAME"
    log_info "Next: Review and merge the pull request"
}

main "$@"
