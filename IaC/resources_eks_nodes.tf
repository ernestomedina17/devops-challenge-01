resource "aws_eks_node_group" "decepticons" {
  cluster_name    = aws_eks_cluster.unicron.name
  node_group_name = "decepticons"
  node_role_arn   = aws_iam_role.decepticons.arn
  subnet_ids      = concat(module.network.private_subnet_id, module.network.public_subnet_id)
  version         = local.k8s_version
  release_version = local.eks_al2_ami_release_version
  capacity_type   = "ON_DEMAND"
  disk_size       = "20"
  instance_types  = ["t4g.medium"]
  #ami_type       = "BOTTLEROCKET_ARM_64"
  ami_type = "AL2_ARM_64"

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
    #aws_iam_role_policy_attachment.decepticons-AmazonSSMManagedInstanceCore,
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

# Bottlerocket's default SSM agent to get a shell session on the instance.
#resource "aws_iam_role_policy_attachment" "decepticons-AmazonSSMManagedInstanceCore" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
#  role       = aws_iam_role.decepticons.name
#}
