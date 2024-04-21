resource "aws_vpc" "vpc_kashio" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name   = "vpc-kashio"
    Source = "Terraform kashio"
    env    = "dev"
  }
}
resource "aws_internet_gateway" "kashio_igw" {
  vpc_id = aws_vpc.vpc_kashio.id

  tags = {
    Name   = "igw-kashio"
    Source = "Terraform kashio"
  }
}

resource "aws_route_table" "public_routing_table" {
  count  = length(var.subnets_public)
  vpc_id = aws_vpc.vpc_kashio.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kashio_igw.id
  }

  tags = {
    Name   = "rtb-subnet-public-${count.index + 1}-kashio"
    Source = "Terraform kashio"
  }
}

resource "aws_route_table" "private_routing_table" {
  count  = length(var.subnets_private)
  vpc_id = aws_vpc.vpc_kashio.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kashio_igw.id
  }

  tags = {
    Name   = "rtb-subnet-private-${count.index + 1}-kashio"
    Source = "Terraform kashio"
  }
}

resource "aws_subnet" "public_subnets" {
  count                   = length(var.subnets_public)
  vpc_id                  = aws_vpc.vpc_kashio.id
  cidr_block              = var.subnets_public[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name   = "subnets-public-${count.index + 1}-kashio"
    Source = "Terraform"
  }
}

resource "aws_subnet" "private_subnets" {
  count                   = length(var.subnets_private)
  vpc_id                  = aws_vpc.vpc_kashio.id
  cidr_block              = var.subnets_private[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name   = "subnets-private-${count.index + 1}-kashio"
    Source = "Terraform"
  }
}

resource "aws_route_table_association" "public_association_rtb" {
  count = length(var.subnets_public)

  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_routing_table[count.index].id
}

resource "aws_route_table_association" "private_association_rtb" {
  count = length(var.subnets_private)

  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_routing_table[count.index].id
}