module "s3" { # Trigger CI/CD execution
  source = "../../modules/s3"

  bucket_name     = var.bucket_name
  environment     = var.environment
  prevent_destroy = false

  tags = var.tags
}


