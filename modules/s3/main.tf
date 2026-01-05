resource "aws_s3_bucket" "standard_bucket" {
  count  = var.prevent_destroy ? 0 : 1
  bucket = "${var.environment}-${var.bucket_name}"

  tags = var.tags
}

resource "aws_s3_bucket" "protected_bucket" {
  count  = var.prevent_destroy ? 1 : 0
  bucket = "${var.environment}-${var.bucket_name}"

  tags = var.tags

  lifecycle {
    prevent_destroy = false
  }
}
