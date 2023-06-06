resource "aws_eks_cluster" "unicron" {
  name     = local.name
  version  = local.k8s_version
  role_arn = aws_iam_role.unicron.arn

  encryption_config {
    provider {
      key_arn = module.kms.kms_key_arn
    }
    resources = ["secrets"]
  }

  vpc_config {
    subnet_ids = concat(module.network.private_subnet_id, module.network.public_subnet_id)
  }

  # Different from your AWS VPC
  kubernetes_network_config {
    service_ipv4_cidr = "172.20.0.0/16"
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
  name               = "eks-cluster-${local.name}"
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
