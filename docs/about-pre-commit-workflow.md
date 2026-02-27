# About Pre Commit workflow

To implement a unified pre-commit workflow for your **pnpm** (frontend) and **uv** (backend) monorepo, the most robust approach is using the **pre-commit framework**.


Unlike Husky, which is Node-centric, `pre-commit` is a multi-language manager that can easily orchestrate both Python and JavaScript tools in a single configuration.

1. Root Configuration (`.pre-commit-config.yaml`)


Create this file in your project root to handle both ecosystems. It uses Ruff for lightning-fast Python linting/formatting and **lint-staged** (via a node hook) for the frontend.


```yaml
repos:
  # --- BACKEND (Python/uv) ---
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.9.0  # Use latest version
    hooks:
      - id: ruff
        args: [ --fix ]
        files: ^backend/
      - id: ruff-format
        files: ^backend/

  # --- FRONTEND (Next.js/pnpm) ---
  - repo: https://github.com
    rev: v3.1.0
    hooks:
      - id: prettier
        files: ^frontend/

  # Trigger pnpm-based linting for staged files
  - repo: local
    hooks:
      - id: frontend-lint
        name: Frontend Lint (Next.js)
        entry: bash -c "cd frontend && pnpm exec lint-staged"
        language: system
        files: ^frontend/

```

2. Frontend Setup (`frontend/package.json`)

Configure **lint-staged** inside your frontend directory to run Next.js-specific checks only on changed files.

```json
{
  "lint-staged": {
    "src/**/*.{js,jsx,ts,tsx}": [
      "next lint --fix",
      "prettier --write"
    ]
  }
}
```


3. Installation Steps

Since you are using uv, use it to install and manage the pre-commit tool globally or in a dedicated dev environment.

1. Install pre-commit with uv:

```bash
uv tool install pre-commit --with pre-commit-uv
```


_The `--with pre-commit-uv` plugin allows pre-commit to use `uv` internally to install its own hooks, making them much faster._


2. Initialize the hooks:

```bash
pre-commit install
```

3. Run against all files (Initial check):

```bash
pre-commit run --all-files
```

