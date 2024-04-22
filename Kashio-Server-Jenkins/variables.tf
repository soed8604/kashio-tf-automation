variable "aws_region" {
  default = "us-east-1"
}
variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}
variable "subnets_public" {
  description = "subnets CIDR"
  type        = list(string)
}
variable "instance_type" {
  description = "Tipo de instancia"
  type        = string
}