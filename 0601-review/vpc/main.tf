//VPC configuration
resource "aws_vpc" "tfvpc12" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "tfvpc12"
  }
}

resource "aws_subnet" "tfsub1" {
  vpc_id                  = aws_vpc.tfvpc12.id
  cidr_block              = var.cidr_block_s1
  map_public_ip_on_launch = true
  availability_zone       = var.az

  tags = {
    Name = "tfsub1"
  }
}

resource "aws_subnet" "tfsub2" {
  vpc_id                  = aws_vpc.tfvpc12.id
  cidr_block              = var.cidr_block_s2
  map_public_ip_on_launch = true
  availability_zone       = var.az2

  tags = {
    Name = "tfsub2"
  }
}

resource "aws_internet_gateway" "tfig" {
  vpc_id = aws_vpc.tfvpc12.id

  tags = {
    Name = "tfig"
  }
}

//Route Tables
resource "aws_route_table" "tfrt" {
  vpc_id = aws_vpc.tfvpc12.id

  route {
    cidr_block = var.route_cidr
    gateway_id = aws_internet_gateway.tfig.id
  }

  tags = {
    Name = "tfrt"
  }
}

resource "aws_route_table_association" "tfrta1" {
  route_table_id = aws_route_table.tfrt.id
  subnet_id      = aws_subnet.tfsub1.id
}

resource "aws_route_table_association" "tfrta2" {
  route_table_id = aws_route_table.tfrt.id
  subnet_id      = aws_subnet.tfsub2.id
}
