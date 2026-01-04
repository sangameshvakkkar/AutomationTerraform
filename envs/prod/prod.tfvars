# NOTE: You cannot use ${var.variable} inside a .tfvars file. Values must be static.
bucket_name = "aura-terraform-state"
environment = "prod"

tags = {
  Name        = "prod-s3"
  Project     = "Aura"
  Environment = "prod"
}
