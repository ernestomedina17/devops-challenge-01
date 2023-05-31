locals {
  eks_ami_release_version = nonsensitive(data.aws_ssm_parameter.eks_ami_release_version.value)
}
