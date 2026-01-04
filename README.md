# AutomationTerraform

This repository contains the Terraform infrastructure for our project, organized by environments (`dev`, `prod`) and reusable `modules`.

## Directory Structure

- `envs/`: Contains environment-specific configurations.
  - `dev/`: Development environment.
  - `prod/`: Production environment.
- `modules/`: Reusable Terraform modules (e.g., `s3`).
- `.github/workflows/`: CI/CD pipelines.

## CI/CD Workflows

We use **GitHub Actions** for continuous deployment.

### Push to Deploy (`terraform-apply.yml`)

The deployment is triggered automatically when you push changes to the `main` branch.

- **Selective Deployment**: The workflow detects which files changed.
  - If you change files in `envs/dev/**`, it triggers the **Deploy API to Dev** job.
  - If you change files in `envs/prod/**`, it triggers the **Deploy API to Prod** job.
  - If you change files in `modules/**`, it triggers **BOTH** jobs (to ensure changes propagate).

### Manual Trigger

You can also manually trigger the `Terraform Apply` workflow from the GitHub Actions tab. *Note: This will currently attempt to run both Dev and Prod deployments.*

## Getting Started

1.  **Clone the repo**: `git clone <repo-url>`
2.  **Make changes**: Edit `.tf` files in `envs/dev` or `modules`.
3.  **Push**: `git add .`, `git commit -m "Update S3 bucket"`, `git push origin main`.
4.  **Watch Magic**: Go to the "Actions" tab in GitHub to see your deployment running!

## Standards

- **Versions**: We use `versions.tf` to ensure everyone uses compatible Terraform and Provider versions.
- **State**: State is stored in S3 with key locking enabled.
