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
