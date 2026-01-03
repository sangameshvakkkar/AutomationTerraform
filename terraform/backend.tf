terraform {
  backend "s3" {
    bucket         = "aura-cicd-terraform-state"
    key            = "cicd/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
