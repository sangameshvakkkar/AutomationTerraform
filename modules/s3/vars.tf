variable "bucket_name" {
  description = "Base name of the S3 bucket"
  type        = string
}

variable "environment" {
  description = "Environment name (dev/prod)"
  type        = string
}


variable "tags" {
  description = "Common tags to apply to resources"
  type        = map(string)
}

