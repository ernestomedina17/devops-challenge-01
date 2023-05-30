resource "aws_kms_key" "unicron" {
  description = "unicron's kms key"
}

resource "aws_kms_key_policy" "unicron" {
  key_id = aws_kms_key.unicron.id
  policy = jsonencode({
    Id = "unicron"
    Statement = [
      {
        # Resource policy 
        Action = "kms:*"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${var.aws_account_id}:root"
        }

        Resource = "*"
        Sid      = "Allows IAM policies to allow access to the KMS key."
      },
    ]
    Version = "2012-10-17"
  })
}

resource "aws_eks_cluster" "unicron" {
  name     = "unicron"
  version  = "1.27"
  role_arn = aws_iam_role.unicron.arn

  encryption_config {
    provider {
      key_arn = aws_kms_key.unicron.arn
    }
    resources = ["secrets"]
  }

  vpc_config {
    subnet_ids = [aws_subnet.main_a.id, aws_subnet.main_b.id, aws_subnet.main_c.id]
  }

  # (Class A)
  # Broadcast: 10.0.7.255            00001010.00000000.000001 11.11111111
  # HostMin:   10.0.4.1              00001010.00000000.000001 00.00000001
  # HostMax:   10.0.7.254            00001010.00000000.000001 11.11111110
  # Hosts/Net: 1022                  (Private Internet)
  kubernetes_network_config {
    service_ipv4_cidr = "10.0.4.0/22"
    ip_family         = "ipv4"
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.unicron-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.unicron-AmazonEKSVPCResourceController,
  ]
}

data "aws_iam_policy_document" "eks_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "unicron" {
  name               = "eks-cluster-unicron"
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role.json
}

resource "aws_iam_role_policy_attachment" "unicron-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.unicron.name
}

# Optionally, enable Security Groups for Pods
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "unicron-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.unicron.name
}


# Node group settings
##

resource "aws_eks_node_group" "decepticons" {
  cluster_name    = aws_eks_cluster.unicron.name
  node_group_name = "decepticons"
  node_role_arn   = aws_iam_role.decepticons.arn
  subnet_ids      = [aws_subnet.k8s_a.id, aws_subnet.k8s_b.id, aws_subnet.k8s_c.id]
  version         = aws_eks_cluster.unicron.version
  ami_type        = "BOTTLEROCKET_ARM_64"
  capacity_type   = "SPOT"
  disk_size       = "50"
  instance_types  = ["t4g.medium"]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  # Optional: Allow external changes without Terraform plan difference
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.decepticons-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.decepticons-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.decepticons-AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "aws_iam_role" "decepticons" {
  name = "eks-node-group-decepticons"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "decepticons-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.decepticons.name
}

resource "aws_iam_role_policy_attachment" "decepticons-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.decepticons.name
}

resource "aws_iam_role_policy_attachment" "decepticons-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.decepticons.name
}
