## Backend.tf

backend_bucket_name = "aura-terraform-state"
backend_bucket_key  = "dev/aura-cicd-terraform-state"
backend_region      = "ap-south-1"

## main.tf
bucket_name = "aura-terraform-state"
environment = "dev"

tags = {
  Name        = "${var.environment}-s3"
  Project     = "Aura"
  Environment = var.environment
}

