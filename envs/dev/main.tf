module "s3" {
  source = "../../modules/s3"

  bucket_name = var.bucket_name
  environment = var.environment

  tags = var.tags
}

resource "aws_s3_bucket" "dev_guard" {
  bucket = module.s3.bucket_name

  lifecycle {
    prevent_destroy = false
  }
}
