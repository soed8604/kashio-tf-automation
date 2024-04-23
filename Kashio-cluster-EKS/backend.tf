terraform {
  backend "s3" {
    bucket = "kashio-devops"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}