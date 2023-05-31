data "aws_ssm_parameter" "eks_ami_release_version" {
  name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.unicron.version}/amazon-linux-2-arm64/recommended/release_version"
}
