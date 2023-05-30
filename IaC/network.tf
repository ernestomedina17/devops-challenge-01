resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Main"
  }
}

resource "aws_subnet" "main_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.availability_zone_names[0]
  tags = {
    Name = "Main A"
  }
}


resource "aws_subnet" "main_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = var.availability_zone_names[1]

  tags = {
    Name = "Main B"
  }
}

resource "aws_subnet" "main_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = var.availability_zone_names[2]

  tags = {
    Name = "Main C"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Main"
  }
}

resource "aws_subnet" "k8s_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = var.availability_zone_names[0]
  tags = {
    Name                                                    = "K8s A"
    "kubernetes.io/cluster/${aws_eks_cluster.unicron.name}" = "shared"
  }
}


resource "aws_subnet" "k8s_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = var.availability_zone_names[1]

  tags = {
    Name                                                    = "K8s B"
    "kubernetes.io/cluster/${aws_eks_cluster.unicron.name}" = "shared"
  }
}

resource "aws_subnet" "k8s_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = var.availability_zone_names[2]

  tags = {
    Name                                                    = "K8s C"
    "kubernetes.io/cluster/${aws_eks_cluster.unicron.name}" = "shared"
  }
}
