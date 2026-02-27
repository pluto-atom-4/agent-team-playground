# Enhance Agent Team Skill

**Purpose**: Comprehensive guide for enhancing the Claude agent team with modern tooling, best practices, and configuration improvements.

**Version**: 1.0
**Last Updated**: 2026-02-27
**Type**: Project Enhancement Skill
**Status**: Production Ready

---

## Overview

This skill provides a structured approach to enhancing the agent-team-playground project with:

- 🔧 Modern tooling (pnpm, uv, Ruff, Biome)
- 📋 Clear agent role definitions
- 📚 Comprehensive documentation
- 🚀 Optimized CI/CD pipelines
- 🏗️ Centralized configuration

### Key Learnings

✅ Modern tooling is worth it - 10x+ performance improvements
✅ Centralized config - Single source of truth (pyproject.toml, package.json)
✅ Version pinning - .nvmrc, .node-version, packageManager field
✅ Feature branches - Better organization for complex changes
✅ Comprehensive documentation - Setup guides at every level
✅ Multi-agent coordination - Clear role separation in configuration

---

## Files Modified by This Skill

- `frontend/package.json` - Node.js/pnpm configuration
- `backend/pyproject.toml` - Python configuration
- `README.md` - Setup guide
- `CLAUDE.md` - Developer guidance
- `.claude/agents/team.md` - Agent roles
- `.github/workflows/agentic-dev.md` - CI/CD documentation
- `PLAN.md` - Technology stack

---

## Quick Navigation

### For Beginners
Start with **[Core Principles](docs/principles.md)** to understand the "why" behind modern tooling.

### For Developers (Full Stack Engineer)
1. Review **[Enhancement Phases](docs/phases.md)** to understand the 4-phase approach
2. Use **[Common Tasks](docs/common_tasks.md)** for practical examples
3. Check **[Troubleshooting](docs/troubleshooting.md)** when stuck

### For QA & DevOps
1. Check your responsibilities in **[Agent Roles](docs/agent_roles.md)**
2. Review **[Performance Benchmarks](docs/reference.md)** to understand improvements
3. Use **[Common Tasks](docs/common_tasks.md)** for role-specific workflows

### For Project Managers
1. Track progress using **[Enhancement Phases](docs/phases.md)**
2. Review agent responsibilities in **[Agent Roles](docs/agent_roles.md)**
3. Reference **[Success Metrics](docs/reference.md)** for completion criteria

---

## Core Sections

### [1. Core Principles](docs/principles.md)
Explains the 4 foundational principles:
- Modern Tooling Philosophy (Rust-based tools)
- Centralized Configuration (pyproject.toml, package.json)
- Version Pinning (.nvmrc, .node-version, packageManager)
- Feature Branch Workflow (clear branch naming)

### [2. Enhancement Phases](docs/phases.md)
Structured 4-phase approach:
- **Phase 1**: Audit Current State
- **Phase 2**: Update Configuration Files
- **Phase 3**: Update Documentation
- **Phase 4**: Update CI/CD

### [3. Agent Roles](docs/agent_roles.md)
Role-specific responsibilities and workflows for:
- Full Stack Engineer
- QA Engineer
- DevOps (SRE)
- Project Manager

### [4. Common Tasks](docs/common_tasks.md)
Practical examples for everyday operations:
- Add Python Dependency
- Update Node.js Version
- Create Enhancement PR
- Setup Development Environment

### [5. Troubleshooting](docs/troubleshooting.md)
Problem-solving guide for common issues:
- pnpm not found
- Pre-commit hooks too slow
- Ruff/Biome formatting differs

### [6. Reference](docs/reference.md)
Performance data, metrics, and external resources:
- Performance Benchmarks (20-28s → 4-7s)
- Success Metrics (5 key checkpoints)
- External Documentation Links

---

## Getting Started

### Step 1: Understand the Vision
Read **[Core Principles](docs/principles.md)** to understand why modern tooling matters.

### Step 2: Follow the Phases
Use **[Enhancement Phases](docs/phases.md)** as a checklist for implementation:
```bash
# Phase 1: Audit current state
cat backend/pyproject.toml
cat frontend/package.json

# Phase 2: Update configuration files (follow docs/phases.md)
# Phase 3: Update documentation (follow docs/phases.md)
# Phase 4: Update CI/CD (follow docs/phases.md)
```

### Step 3: Know Your Role
Find your role in **[Agent Roles](docs/agent_roles.md)** for specific responsibilities.

### Step 4: Solve Problems
When stuck, check **[Troubleshooting](docs/troubleshooting.md)** for solutions.

---

## Quick Reference

| Role | Focus | Key File |
|------|-------|----------|
| Full Stack Engineer | Implementation & Linting | [Agent Roles](docs/agent_roles.md) |
| QA Engineer | Testing & lint-staged | [Agent Roles](docs/agent_roles.md) |
| DevOps (SRE) | Infrastructure & Migrations | [Agent Roles](docs/agent_roles.md) |
| Project Manager | Planning & Coordination | [Agent Roles](docs/agent_roles.md) |

---

## Key Statistics

- **Performance Improvement**: 70%+ faster (20-28s → 4-7s)
- **Tool Speedup**: pnpm 30-50x faster than npm, uv 10-100x faster than pip
- **Success Metrics**: 5 key checkpoints defined in [Reference](docs/reference.md)
- **Implementation Time**: 4 phases, ~1-2 days per phase for a team

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-02-27 | Initial skill with modern tooling best practices |

---

## Support & Contact

For questions about this skill:

1. **Understand the concept**: Read the relevant section (Principles, Phases, etc.)
2. **Solve a problem**: Check [Troubleshooting](docs/troubleshooting.md)
3. **Find your role**: Review [Agent Roles](docs/agent_roles.md)
4. **Need help?**: Consult the agent team for role-specific questions

---

**Created**: 2026-02-27
**Last Reviewed**: 2026-02-27
**Status**: Production Ready
**Next Review**: 2026-03-27
