resource "aws_s3_bucket" "this" {
  bucket = "${var.environment}-${var.bucket_name}"

  tags = var.tags
}