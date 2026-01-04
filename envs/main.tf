resource "aws_s3_bucket" "demo" {
  bucket = "${var.environment}-${var.bucket_name}"


  tags = {
    Project     = "Aura-Terraform-CICD"
    Owner       = "suraj"
    Environment = var.environment
  }
}

