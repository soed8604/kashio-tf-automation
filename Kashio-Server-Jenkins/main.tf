#VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc-kashio"
  cidr = var.vpc_cidr

  azs            = data.aws_availability_zones.azs_kashio.names
  public_subnets = var.subnets_public
  map_public_ip_on_launch = true

  enable_dns_hostnames = true

  tags = {
    Name        = "kashio-vpc"
    Terraform   = "true"
    Environment = "dev"
  }

  public_subnet_tags = {
    Name = "kashio-subnets"
  }
}
#Security Group (SG)
module "sg_kashio" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "kashio-sg"
  description = "Security Group for kashio_server_jenkins"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "HTTP"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = {
    Name = "Kashio_SG_Server_Jenkins"
  }
}

#Instances (EC2)

module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "kashio-Jenkins-Server"

  instance_type               = var.instance_type
  key_name                    = "kashio-jenkins-key"
  monitoring                  = true
  vpc_security_group_ids      = [module.sg_kashio.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  user_data                   = file("jenkins-install.sh")
  availability_zone           = data.aws_availability_zones.azs_kashio.names[0]

  tags = {
    Name        = "kashio-Jenkins-Server"
    Terraform   = "true"
    Environment = "dev"
  }
}