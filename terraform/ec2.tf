resource "aws_security_group" "sf-sg-public-01" {
  name        = "sf-sg-public-01"
  description = "SugarFunge public Security Group"
  vpc_id      = aws_vpc.sf-vpc-01.id

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "sf-sg-public-01"
  }
}

resource "aws_security_group" "sf-sg-private-01" {
  name        = "sf-sg-private-01"
  description = "SugarFunge public Security Group"
  vpc_id      = aws_vpc.sf-vpc-01.id

  ingress {
    description      = "PublicSG"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    security_groups  = [aws_security_group.sf-sg-public-01.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "sf-sg-private-01"
  }
}

resource "aws_instance" "sf-api-01" {

  ami             = "ami-09e67e426f25ce0d7"
  instance_type   = "t2.micro"
  key_name        = var.key_name
  subnet_id       = aws_subnet.sf-subnet-private-01.id
  security_groups = [aws_security_group.sf-sg-private-01.id]

  tags = {
    Name = "sf-api-01"
  }
}

resource "aws_instance" "sf-node-01" {

  ami             = "ami-09e67e426f25ce0d7"
  instance_type   = "t2.micro"
  key_name        = var.key_name
  subnet_id       = aws_subnet.sf-subnet-private-01.id
  security_groups = [aws_security_group.sf-sg-private-01.id]

  tags = {
    Name = "sf-node-01"
  }
}

resource "aws_instance" "sf-node-02" {

  ami             = "ami-09e67e426f25ce0d7"
  instance_type   = "t2.micro"
  key_name        = var.key_name
  subnet_id       = aws_subnet.sf-subnet-private-01.id
  security_groups = [aws_security_group.sf-sg-private-01.id]

  tags = {
    Name = "sf-node-02"
  }
}


resource "aws_instance" "sf-ipfs-01" {

  ami             = "ami-09e67e426f25ce0d7"
  instance_type   = "t2.micro"
  key_name        = var.key_name
  subnet_id       = aws_subnet.sf-subnet-private-01.id
  security_groups = [aws_security_group.sf-sg-private-01.id]

  tags = {
    Name = "sf-ipfs-01"
  }
}

resource "aws_instance" "sf-nginx-01" {

  ami             = "ami-09e67e426f25ce0d7"
  instance_type   = "t2.micro"
  key_name        = var.key_name
  subnet_id       = aws_subnet.sf-subnet-public-01.id
  security_groups = [aws_security_group.sf-sg-public-01.id]

  tags = {
    Name = "sf-nginx-01"
  }
}

resource "local_file" "AnsibleInventory" {
  content = templatefile("templates/inventory.tmpl",
    {
      nginx   = aws_instance.sf-nginx-01,
      api     = aws_instance.sf-api-01,
      node_01 = aws_instance.sf-node-01,
      node_02 = aws_instance.sf-node-02,
      ipfs    = aws_instance.sf-ipfs-01,
    }
  )
  filename = "../ansible/inventory.ini"
}

resource "local_file" "AnsibleNginx" {
  content = templatefile("templates/nginx_main.tmpl",
    {
      api     = aws_instance.sf-api-01.private_ip,
      node_01 = aws_instance.sf-node-01.private_ip,
      node_02 = aws_instance.sf-node-02.private_ip,
      ipfs    = aws_instance.sf-ipfs-01.private_ip,
    }
  )
  filename = "../ansible/playbooks/vars/nginx_main.yml"
}
