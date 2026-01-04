terraform {
  # This enforces that the person running this code must have Terraform v1.0.0 or newer.
  # It helps prevent errors caused by features that might be missing in older versions.
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      # This ensures we are using version 4.0.0 or newer of the AWS provider.
      # Pinning providers prevents your code from breaking if AWS releases a major update (like v5.0.0)
      # that changes how resources are defined.
      version = ">= 4.0.0"
    }
  }
}
