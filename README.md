# Infra Automation with Terraform

This repository contains the Terraform infrastructure for our project, designed with a strong focus on automation, safety, and module reusability.

## 🏗️ Architecture

The project matches environments (`dev`, `prod`) with reusable `modules`.

```mermaid
graph TD
    subgraph Environments
        Dev[envs/dev]
        Prod[envs/prod]
    end
    subgraph Modules
        S3[modules/s3]
        VPC[modules/vpc]
        EC2[modules/ec2]
    end
    Dev -.->|uses| S3
    Prod -.->|uses| S3
    Dev -.->|uses| VPC
    Prod -.->|uses| VPC
```

## 🧩 Smart Modules

### S3 Lifecycle Protection
We implemented a conditional logic to handle `prevent_destroy`. Since Terraform lifecycle blocks are static, we use a "Split Resource" pattern.

```mermaid
graph LR
    Input[Input: prevent_destroy] --> Check{Is True?}
    Check -->|Yes| Protected[Resource: protected_bucket]
    Check -->|No| Standard[Resource: standard_bucket]
    Protected -.->|lifecycle| Lock[prevent_destroy = true]
    Standard -.->|lifecycle| Normal[Normal Behavior]
```

## 🚀 CI/CD Pipelines

We use **GitHub Actions** for an intelligent, dynamic deployment pipeline.

### 1. Dynamic Validation Matrix
The pipeline automatically discovers new modules in the `modules/` directory and validates them in parallel. No YAML edits required when adding modules!

```mermaid
graph LR
    Push[Push Code] --> Script[Python Discovery Script]
    Script -->|Output JSON| Matrix["['s3', 'vpc', 'ec2']"]
    Matrix --> Job1[Validate S3]
    Matrix --> Job2[Validate VPC]
    Matrix --> Job3[Validate EC2]
```

### 2. Deployment Workflow (`terraform-apply.yml`)

```mermaid
graph TD
    Start([Push to Main]) --> Detect{Changed Paths?}
    Detect -->|envs/dev/**| DeployDev[Deploy Dev]
    Detect -->|envs/prod/**| DeployProd[Deploy Prod]
    Detect -->|modules/**| DeployAll[Deploy All Envs + Validate Modules]
```

### 3. Safe Destroy Workflow (`terraform-destroy.yml`)

A protected workflow to destroy infrastructure.

```mermaid
sequenceDiagram
    participant User
    participant GitHub
    participant Terraform
    
    User->>GitHub: Trigger Destroy
    GitHub->>User: 🛑 "Type DESTROY to confirm"
    
    alt Input is Correct
        User->>GitHub: "DESTROY"
        GitHub->>Terraform: Plan (save to tfplan)
        Terraform->>GitHub: Report Plan
        GitHub->>Terraform: Apply tfplan
        Terraform->>AWS: 🗑️ Delete Resources
    else Input is Wrong
        User->>GitHub: "Pls destroy"
        GitHub->>User: ❌ Error: Exit 1
    end
```

## 🛠️ Getting Started

1.  **Clone**: `git clone <url>`
2.  **Dev**: Edit `envs/dev/main.tf`
3.  **Prod**: Edit `envs/prod/main.tf`
4.  **Push**: Changes trigger the pipeline automatically.

## ⚠️ Troubleshooting

**"Instance cannot be destroyed"**
If you need to destroy a `prod` bucket that has `prevent_destroy = true`:
1.  Go to `modules/s3/main.tf`.
2.  Change `prevent_destroy = true` to `false` in the `protected_bucket` resource.
3.  Run the destroy pipeline.
4.  Revert the change.
