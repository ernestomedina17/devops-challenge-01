resource "aws_vpc" "main" {
  cidr_block           = "192.168.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "Unicron"
  }
}

# This resource cannot be destroy, only managed.
resource "aws_default_network_acl" "default" {
  default_network_acl_id = aws_vpc.main.default_network_acl_id
  subnet_ids             = [aws_subnet.public_a.id, aws_subnet.public_b.id, aws_subnet.private_b.id, aws_subnet.private_c.id]

  tags = {
    Name = "Unicron"
  }

  # Needs some security hardening and matching SGs or secondary ACLs for Public and Private subnets.
  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}

# This resource cannot be destroy, only managed.
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Unicron"
  }

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.0.0/18"
  availability_zone = var.availability_zone_names[0]
  tags = {
    Name                     = "Unicron Public A"
    "kubernetes.io/role/elb" = true
  }
}

resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.64.0/18"
  availability_zone = var.availability_zone_names[1]

  tags = {
    Name                     = "Unicron Public B"
    "kubernetes.io/role/elb" = true
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.128.0/18"
  availability_zone = var.availability_zone_names[1]

  tags = {
    Name                              = "Unicron Private B"
    "kubernetes.io/role/internal-elb" = true
  }
}

resource "aws_subnet" "private_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.192.0/18"
  availability_zone = var.availability_zone_names[2]

  tags = {
    Name                              = "Unicron Private C"
    "kubernetes.io/role/internal-elb" = true
  }
}

# aws_internet_gateway_attachment not needed.
resource "aws_internet_gateway" "internet_gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Scope = "Public"
    Name  = "Unicron"
  }
}

resource "aws_nat_gateway" "private_c" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.private_c.id
  tags = {
    Scope = "Private"
  }
}

resource "aws_nat_gateway" "private_b" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.private_b.id
  tags = {
    Scope = "Private"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name  = "Unicron Public"
    Scope = "Public"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name  = "Unicron Private"
    Scope = "Private"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_igw" {
  gateway_id     = aws_internet_gateway.internet_gw.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_c" {
  subnet_id      = aws_subnet.private_c.id
  route_table_id = aws_route_table.private.id
}
