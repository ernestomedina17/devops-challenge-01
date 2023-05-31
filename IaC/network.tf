resource "aws_vpc" "main" {
  cidr_block           = "192.168.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "Main"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.0.0/18"
  availability_zone = var.availability_zone_names[0]
  tags = {
    Name                     = "Public A"
    "kubernetes.io/role/elb" = true
  }
}

resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.64.0/18"
  availability_zone = var.availability_zone_names[1]

  tags = {
    Name                     = "Public B"
    "kubernetes.io/role/elb" = true
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.128.0/18"
  availability_zone = var.availability_zone_names[1]

  tags = {
    Name                              = "Private B"
    "kubernetes.io/role/internal-elb" = true
  }
}

resource "aws_subnet" "private_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.192.0/18"
  availability_zone = var.availability_zone_names[2]

  tags = {
    Name                              = "Private C"
    "kubernetes.io/role/internal-elb" = true
  }
}

# aws_internet_gateway_attachment not needed.
resource "aws_internet_gateway" "internet_gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Scope = "Public"
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
    Scope = "Public"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = {
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
