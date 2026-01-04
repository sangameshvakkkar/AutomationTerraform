bucket_name = "aura-terraform-state"
environment = "prod"

tags = {
  Name        = "${var.environment}-s3"
  Project     = "Aura"
  Environment = var.environment
}
