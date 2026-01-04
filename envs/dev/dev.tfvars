bucket_name = "aura-terraform-state"
environment = "dev"

tags = {
  Name        = "${var.environment}-s3"
  Project     = "Aura"
  Environment = var.environment
}

