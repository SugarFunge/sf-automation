resource "aws_vpc" "sf-vpc-01" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "${var.prefix}-vpc-01"
  }
}

resource "aws_subnet" "sf-subnet-private-01" {
  vpc_id     = aws_vpc.sf-vpc-01.id
  cidr_block = "10.0.0.0/20"

  tags = {
    Name = "${var.prefix}-subnet-private-01"
  }
}

resource "aws_subnet" "sf-subnet-private-02" {
  vpc_id     = aws_vpc.sf-vpc-01.id
  cidr_block = "10.0.16.0/20"

  tags = {
    Name = "${var.prefix}-subnet-private-02"
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

resource "aws_eip" "sf-eip-01" {
  vpc = true

  tags = {
    Name = "${var.prefix}-eip-01"
  }
}

resource "aws_nat_gateway" "sf-natgw-01" {
  allocation_id = aws_eip.sf-eip-01.id
  subnet_id     = aws_subnet.sf-subnet-private-01.id

  depends_on = [
    aws_eip.sf-eip-01
  ]

  tags = {
    Name = "${var.prefix}-natgw-01"
  }
}

resource "aws_route_table" "sf-rt-private-01" {
  vpc_id = aws_vpc.sf-vpc-01.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.sf-natgw-01.id
  }

  tags = {
    Name = "${var.prefix}-rt-private-01"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.sf-subnet-private-01.id
  route_table_id = aws_route_table.sf-rt-private-01.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.sf-subnet-public-01.id
  route_table_id = aws_route_table.sf-rt-public-01.id
}
