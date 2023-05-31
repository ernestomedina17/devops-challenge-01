output "unicron_eks_endpoint" {
  value = aws_eks_cluster.unicron.endpoint
}

output "unicron_eks_identity" {
  value = aws_eks_cluster.unicron.identity
}

output "unicron_eks_version" {
  value = aws_eks_cluster.unicron.platform_version
}

output "unicron_eks_status" {
  value = aws_eks_cluster.unicron.status
}

output "unicron_eks_vpc_config" {
  value = aws_eks_cluster.unicron.vpc_config
}

data "aws_ssm_parameter" "eks_ami_release_version" {
  name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.unicron.version}/amazon-linux-2-arm64/recommended/release_version"
}

output "recommended_ami_release_version" {
  value = nonsensitive(data.aws_ssm_parameter.eks_ami_release_version.value)
}
