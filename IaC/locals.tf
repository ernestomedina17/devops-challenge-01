locals {
  name        = "unicron"
  k8s_version = "1.27"
  #eks_al2_ami_release_version          = nonsensitive(data.aws_ssm_parameter.eks_al2_ami_release_version.value)
}
