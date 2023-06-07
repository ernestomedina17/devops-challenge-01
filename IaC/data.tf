data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ssm_parameter" "eks_al2_ami_id" {
  name = "/aws/service/eks/optimized-ami/${local.k8s_version}/amazon-linux-2-arm64/recommended/image_id"
}

data "aws_ssm_parameter" "eks_al2_ami_release_version" {
  name = "/aws/service/eks/optimized-ami/${local.k8s_version}/amazon-linux-2-arm64/recommended/release_version"
}

data "aws_ssm_parameter" "eks_bottlerocket_ami_id" {
  name = "/aws/service/bottlerocket/aws-k8s-${local.k8s_version}/arm64/latest/image_id"
}

data "aws_ssm_parameter" "eks_bottlerocket_ami_release_version" {
  name = "/aws/service/bottlerocket/aws-k8s-${local.k8s_version}/arm64/latest/image_version"
}

data "aws_ami" "amzn-linux-2023-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-arm64"]
  }
}

data "local_file" "ssh_pub_key" {
  filename = sensitive("${var.myhome}/.ssh/id_rsa.pub")
}
