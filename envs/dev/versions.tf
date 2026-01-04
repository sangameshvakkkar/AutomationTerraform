terraform {
  # Best Practice: Always define which version of Terraform this code is compatible with.
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      # Best Practice: Pin the AWS provider version.
      # ">= 4.0.0" means anything starting from 4.0.0 is okay.
      # In stricter production environments, you might see something like "~> 4.0" to lock it to the 4.x series.
      version = ">= 4.0.0"
    }
  }
}
