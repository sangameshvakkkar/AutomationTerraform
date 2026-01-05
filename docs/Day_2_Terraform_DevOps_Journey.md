# 🚀 Day 2: Terraform Efficiency & DevOps Mindset

*Date: January 5, 2026*

## 💡 What We Learned Today

### 1. Terraform Resource Lifecycle & Modules
*   **The Problem:** `lifecycle` blocks (like `prevent_destroy`) are **static**. You cannot use variables inside them (e.g., `prevent_destroy = var.is_prod`).
*   **The Fix:** We had to **refactor the module** to conditionally create one of two resources:
    *   `aws_s3_bucket.standard` (for Dev)
    *   `aws_s3_bucket.protected` (for Prod, with `prevent_destroy = true`)
    *   *Mechanism:* `count = var.prevent_destroy ? 1 : 0`
*   **Outputs:** We used ternary logic (`condition ? true_val : false_val`) in `outputs.tf` to correctly point to the resource that was actually created.

### 2. Intelligent CI/CD (GitHub Actions)
*   **Path Filtering:** We configured the workflow to only deploy `Prod` when files in `envs/prod` change, preventing accidental overrides from `Dev` work.
*   **Dynamic Matrix:** Instead of hardcoding module names for validation, we wrote a script to **auto-discover** directories in `modules/`. This makes the pipeline "future-proof"—add a `vpc` module tomorrow, and it gets verified automatically. 🪄

---

## 🧠 The DevOps Mindset: Daily Rituals

> *Refer to this section every morning.*

### 1. Idempotency is King 👑
*   **Mindset:** "If I run this command 100 times, the result should be exactly the same as running it once."
*   **Action:** Always test your Terraform code by running `plan` -> `apply` -> `plan`. The second plan should show **No Changes**.

### 2. Don't Repeat Yourself (DRY) ♻️
*   **Mindset:** "If I copy-paste code, I'm creating legacy debt."
*   **Action:** We moved S3 logic into a `module`. Now, if we need to change tagging standards, we fix it in **one place** (the module), and it updates Dev, Stage, and Prod instantly.

### 3. Fail Fast, Fail Left ⬅️
*   **Mindset:** "Catch errors before they leave my laptop (or at least in the PR)."
*   **Action:** That's why we added `terraform validate` and `tflint` to the CI pipeline. We don't wait for a deployment to crash to find a syntax error.

### 4. Infrastructure as Code (IaC) is **Code** 💻
*   **Mindset:** "This isn't just a config file; it's software."
*   **Action:** Use version control (Git). Use Pull Requests. detailed commit messages. Code Reviews. It deserves the same respect as application code.

---

## 🔮 Looking Ahead: Day 3 Plan

Now that we have a solid pipeline and reusable modules, we will level up:

1.  **Complex Modules (Networking):** Building a VPC module. This introduces dependencies—you can't build an EC2 instance without a Subnet, which needs a VPC.
2.  **State Management Deep Dive:** We touched on locking today. Next, we'll look at `terraform import` (handling existing infrastructure) and state manipulation.
3.  **Cost Estimation:** Integrating tools like `infracost` into your PRs to see "This change will increase your bill by $50/month" *before* you merge.

---

## 📝 Quick Reference Commands

| Command | Purpose |
| :--- | :--- |
| `terraform init -upgrade` | Updates provider versions and backend config. |
| `terraform validate` | Checks for syntax errors (cheap & fast). |
| `terraform plan -out=tfplan` | Saves the plan implementation plan to a file. |
| `terraform apply tfplan` | Executes the saved plan (safe & deterministic). |
| `terraform state list` | Shows what resources Terraform currently tracks. |
