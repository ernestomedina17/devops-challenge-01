data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ssm_parameter" "eks_al2_ami_id" {
  name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.unicron.version}/amazon-linux-2-arm64/recommended/image_id"
}

data "aws_ssm_parameter" "eks_al2_ami_release_version" {
  name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.unicron.version}/amazon-linux-2-arm64/recommended/release_version"
}

data "aws_ssm_parameter" "eks_bottlerocket_ami_id" {
  name = "/aws/service/bottlerocket/aws-k8s-${aws_eks_cluster.unicron.version}/arm64/latest/image_id"
}

data "aws_ssm_parameter" "eks_bottlerocket_ami_release_version" {
  name = "/aws/service/bottlerocket/aws-k8s-${aws_eks_cluster.unicron.version}/arm64/latest/image_version"
}
