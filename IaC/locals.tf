locals {
  name                                 = "unicron"
  k8s_version                          = "1.27"
  eks_bottlerocket_ami_id              = data.aws_ssm_parameter.eks_bottlerocket_ami_id.value
  eks_bottlerocket_ami_release_version = data.aws_ssm_parameter.eks_bottlerocket_ami_release_version.value
  eks_al2_ami_id                       = data.aws_ssm_parameter.eks_al2_ami_id.value
  eks_al2_ami_release_version          = nonsensitive(data.aws_ssm_parameter.eks_al2_ami_release_version.value)

  #  config_map_aws_auth = <<CONFIGMAPAWSAUTH
  #apiVersion: v1
  #kind: ConfigMap
  #metadata:
  #  name: aws-auth
  #  namespace: kube-system
  #data:
  #  mapRoles: |
  #    - rolearn: ${aws_iam_role.decepticons.arn}
  #      username: system:node:{{EC2PrivateDNSName}}
  #      groups:
  #        - system:bootstrappers
  #        - system:nodes
  #CONFIGMAPAWSAUTH
}
