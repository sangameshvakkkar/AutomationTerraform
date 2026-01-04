# GitHub Actions Workflow Explained: `terraform-apply.yml`

This document provides a line-by-line explanation of our CI/CD workflow. It is designed to take you from a basic understanding to the advanced "Matrix" logic we implemented.

## 1. Triggers (`on:`)

The workflow doesn't run all the time. It waits for specific events.

```yaml
on:
  push:
    branches:
      - main
    paths:          # <--- PATH FILTERS
      - 'envs/dev/**'
      - 'envs/prod/**'
      - 'modules/**'
```

*   **Logic**: "If someone pushes code to `main`..."
*   **Path Filters**: "...BUT ONLY IF they touched files in `dev`, `prod`, or `modules`."
*   **Optimisation**: If you only update `README.md`, this workflow will **not run**, saving money and time.

---

## 2. Job 1: The Brain (`changes`)

This is the "Decision Maker". It doesn't deploy anything. It just looks at *what changed*.

```yaml
  changes:
    outputs:
      dev: ${{ steps.filter.outputs.dev }}
      modules: ${{ steps.filter.outputs.modules }}
      modules_matrix: ${{ steps.set-matrix.outputs.matrix }} # <--- THE MAGIC
```

### The Matrix Generator (Python Script)
We added a Python one-liner to create a **Dynamic Matrix**.

```yaml
run: |
  echo "matrix=$(python3 -c "import os, json; print(json.dumps([d for d in os.listdir('modules') if os.path.isdir(os.path.join('modules', d))]))")" >> $GITHUB_OUTPUT
```

*   **What it does**: It scans the `modules/` folder.
*   **What it finds**: `['s3', 'vpc', 'ec2']` (example list).
*   **Result**: It creates a JSON list formatted like `["s3", "vpc"]`.
*   **Why?**: So we can run a separate validation job for *each module* automatically. If you add a `modules/rds` folder tomorrow, the pipeline detects it automatically!

---

## 3. Job 2 & 3: Deployments (`deploy-dev`, `deploy-prod`)

These jobs deploy actual infrastructure.

```yaml
  deploy-dev:
    needs: changes  # Waits for the 'changes' job
    if: needs.changes.outputs.dev == 'true' # Only runs if 'dev' files changed
    environment: dev
```

*   **Concurrency**:
    ```yaml
    concurrency:
      group: ${{ github.workflow }}-${{ github.ref }}
      cancel-in-progress: true
    ```
    This prevents "Race Conditions". If you push code, then push again 10 seconds later, it destroys the first run to ensure only the latest code deploys.

*   **Steps**:
    1.  **Checkout**: Get code.
    2.  **Auth**: Log in to AWS using OIDC (Secure, no long-lived Keys!).
    3.  **Init/Plan/Apply**: The standard Terraform lifecycle.
    4.  **-var-file**: We explicitly tell it `terraform plan -var-file="dev.tfvars"` so it knows which variables to use.

---

## 4. Job 4: The Dynamic Matrix (`validate-modules`)

This is the advanced part you implemented.

```yaml
  validate-modules:
    name: Validate Module (${{ matrix.module }})
    strategy:
      matrix:
        module: ${{ fromJson(needs.changes.outputs.modules_matrix) }} # <--- DYNAMIC LIST
    defaults:
      run:
        working-directory: modules/${{ matrix.module }} # <--- DYNAMIC FOLDER
```

### How the Matrix Works
Imagine `modules_matrix` contains `["s3", "vpc"]`.
GitHub Actions will effectively spawn **two parallel jobs**:

1.  **Job A**: `matrix.module` = `s3`. Working directory = `modules/s3`.
2.  **Job B**: `matrix.module` = `vpc`. Working directory = `modules/vpc`.

### Why is this "Industrial Grade"?
*   **Isolation**: If `s3` fails validation, `vpc` can still pass.
*   **Speed**: They run in parallel (at the same time).
*   **Scalability**: You can have 50 modules. You don't need to write 50 jobs in the YAML file. You write ONE job, and the Matrix loops over it 50 times.

---

## Verification Checklist
When you view a run in "Actions":
1.  **changes**: Always succeeds.
2.  **deploy-dev**: Skipped unless `envs/dev` modified.
3.  **deploy-prod**: Skipped unless `envs/prod` modified.
4.  **validate-modules**:
    *   Skipped if no modules modified.
    *   If run, it splits into multiple sub-jobs (e.g., `Validate Module (s3)`).
