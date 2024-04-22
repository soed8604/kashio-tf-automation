terraform {
  backend "s3" {
    bucket = "kashio-devops"
    key    = "jenkins/terraform.tfstate"
    region = "us-east-1"
  }
}