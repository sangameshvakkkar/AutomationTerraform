terraform {
  backend "s3" {
    bucket         = "suraj-terraform-state-demo"
    key            = "cicd/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
