module "network" {
  source             = "git@github.com:ernestomedina17/tf-modules.git//aws/4/eks-vpc"
  name               = local.name
  cidr_block         = "10.0.0.0/16"
  region             = var.aws_region
  availability_zones = data.aws_availability_zones.available.names
  az_counts          = length(data.aws_availability_zones.available.names)
}

module "kms" {
  source         = "git@github.com:ernestomedina17/tf-modules.git//aws/4/kms"
  name           = local.name
  aws_account_id = var.aws_account_id
}


module "cluster_role" {
  source         = "git@github.com:ernestomedina17/tf-modules.git//aws/4/eks-cluster-role"
  name           = local.name
}

#module "eks" {
#  source              = "git@github.com:ernestomedina17/tf-modules.git//aws/4/eks"
#  name                = local.name
#  myhome              = var.myhome
#  subnets_cluster     = module.network.private_subnet_id
#  subnets_node_group  = [module.network.private_subnet_id[0]] # Only one subnet has NAT GW, to save money.
#  kms_key_arn         = module.kms.kms_key_arn
#  ami_release_version = data.aws_ssm_parameter.eks_al2_ami_release_version.value
#  k8s_version         = local.k8s_version
#  ssh_key_name        = module.bastion.key_name
#
#  # defaults
#  capacity_type  = "ON_DEMAND"
#  disk_size      = 20
#  instance_types = "t4g.medium"
#  ami_type       = "AL2_ARM_64"
#}
