resource "aws_s3_bucket" "demo" {
  bucket = "${var.environment}-${var.bucket_name}"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Project = "Aura-Terraform-CICD"
    Owner   = "suraj"
    Environment = var.environment
  }
}

