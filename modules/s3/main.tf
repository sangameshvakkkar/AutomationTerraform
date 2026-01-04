resource "aws_s3_bucket" "demo" {
  bucket = "${var.environment}-${var.bucket_name}"

  tags = var.tags
}