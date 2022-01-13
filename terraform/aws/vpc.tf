resource "aws_vpc" "sf-vpc-01" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "${var.prefix}-vpc-01"
  }
}

resource "aws_subnet" "sf-subnet-public-01" {
  vpc_id                  = aws_vpc.sf-vpc-01.id
  cidr_block              = "10.0.32.0/20"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "${var.prefix}-subnet-public-01"
  }
}

resource "aws_internet_gateway" "sf-igw-01" {
  vpc_id = aws_vpc.sf-vpc-01.id

  tags = {
    Name = "${var.prefix}-igw-01"
  }
}

resource "aws_route_table" "sf-rt-public-01" {
  vpc_id = aws_vpc.sf-vpc-01.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sf-igw-01.id
  }

  tags = {
    Name = "${var.prefix}-rt-public-01"
  }
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.sf-subnet-public-01.id
  route_table_id = aws_route_table.sf-rt-public-01.id
}
