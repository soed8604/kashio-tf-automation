variable "aws_region" {
  default = "us-east-1"
}
variable "vpc_cidr" {
  default = "10.10.0.0/16"
}
variable "subnets_public" {
  default     = ["10.10.0.0/24", "10.10.1.0/24"]
  type        = list(any)
  description = "List of public subnet CIDR blocks"
}

variable "subnets_private" {
  default     = ["10.10.2.0/24", "10.10.3.0/24"]
  type        = list(any)
  description = "List of private subnet CIDR blocks"
}

variable "availability_zones" {
  default     = ["us-east-1a", "us-east-1b"]
  type        = list(any)
  description = "List of availability zones"
}