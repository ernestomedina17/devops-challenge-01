# AWS Resources already existing and adopted by Terraform
# with the purpose of setting the Name tag's value.

# Adopted resource not created by Terraform
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = "eu-central-1a"

  tags = {
    Name = "Default 1A"
  }
}

resource "aws_default_subnet" "default_az3" {
  availability_zone = "eu-central-1b"

  tags = {
    Name = "Default 1B"
  }
}

resource "aws_default_subnet" "default_az1" {
  availability_zone = "eu-central-1c"

  tags = {
    Name = "Default 1C"
  }
}

# This resource cannot be destroyed, only managed.
resource "aws_default_network_acl" "default" {
  default_network_acl_id = aws_vpc.main.default_network_acl_id
  subnet_ids             = [aws_subnet.public_a.id, aws_subnet.public_b.id, aws_subnet.private_b.id, aws_subnet.private_c.id]

  tags = {
    Name = "Unicron Default"
  }

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

# This resource cannot be destroyed, only managed.
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Unicron Default"
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

# This resource cannot be destroyed, only managed.
resource "aws_default_route_table" "default" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  tags = {
    Name = "Unicron Default"
  }
}

# This resource cannot be destroyed, only managed.
resource "aws_default_vpc_dhcp_options" "default" {
  tags = {
    Name = "Default DHCP Option Set"
  }
}
