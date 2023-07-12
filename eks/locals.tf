locals {
  name        = "unicron"
  k8s_version = "1.27"
  #ami_nodes_release_version = nonsensitive(data.aws_ssm_parameter.eks_al2_ami_release_version.value)
  #ami_type = "AL2_ARM_64"
  ami_nodes_release_version = nonsensitive(data.aws_ssm_parameter.eks_bottlerocket_ami_release_version.value)
  ami_type                  = "BOTTLEROCKET_ARM_64"
}
