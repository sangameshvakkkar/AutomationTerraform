resource "aws_s3_bucket" "demo" {
  bucket = var.bucket_name

  tags = {
    Project = "Aura-Terraform-CICD"
    Owner   = "suraj"
  }
}
