output "bucket_name" {
  value = var.prevent_destroy ? aws_s3_bucket.protected_bucket[0].bucket : aws_s3_bucket.standard_bucket[0].bucket
}

output "bucket_arn" {
  value = var.prevent_destroy ? aws_s3_bucket.protected_bucket[0].arn : aws_s3_bucket.standard_bucket[0].arn
}
