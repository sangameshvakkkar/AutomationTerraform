terraform {
  # Ensures compatibility with Terraform CLI version.
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      # Ensures you don't accidentally use a version of the provider that doesn't support your resources.
      version = ">= 4.0.0"
    }
  }
}
