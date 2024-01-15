resource "aws_vpc" "my-web-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "my-web-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my-web-vpc.id
}

resource "aws_route_table" "my-web-route-table" {
  vpc_id = aws_vpc.my-web-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "my-web-route-table"
  }
}

variable "subnet_prefix" {
}

resource "aws_subnet" "my-web-subnet" {
  vpc_id            = aws_vpc.my-web-vpc.id
  cidr_block        = var.subnet_prefix[0].cidr_block
  availability_zone = var.subnet_prefix[0].availability_zone

  tags = {
    Name = "prod-subnet"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.my-web-subnet.id
  route_table_id = aws_route_table.my-web-route-table.id
}

resource "aws_security_group" "allow_my-web" {
  name        = "allow_my-web-traffic"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.my-web-vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "CUSTOM TCP"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["49.49.250.21/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_my-web"
  }
}

resource "aws_network_interface" "my-web-server-nic" {
  subnet_id       = aws_subnet.my-web-subnet.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_my-web.id]
}

resource "aws_eip" "one" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.my-web-server-nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on                = [aws_internet_gateway.igw]
}
