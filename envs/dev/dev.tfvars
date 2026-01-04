# NOTE: You cannot use ${var.variable} inside a .tfvars file. Values must be static.
bucket_name = "aura-terraform-state"
environment = "dev"

tags = {
  Name        = "dev-s3"
  Project     = "Aura"
  Environment = "dev"
}

