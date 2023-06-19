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
  source = "git@github.com:ernestomedina17/tf-modules.git//aws/4/eks-cluster-role"
  name   = local.name
}

module "cluster_sg" {
  source = "git@github.com:ernestomedina17/tf-modules.git//aws/4/eks-cluster-sg"
  name   = local.name
  vpc_id = module.network.vpc_network_id
}

# Manually enable Session Tokens from the STS endpoints for your Region.
module "eks_cluster" {
  source                  = "git@github.com:ernestomedina17/tf-modules.git//aws/4/eks-cluster"
  name                    = local.name
  aws_account_id          = var.aws_account_id
  iam_role_cluster_arn    = module.cluster_role.eks_cluster_role_arn
  subnets_cluster         = module.network.private_subnet_id
  kms_key_arn             = module.kms.kms_key_arn
  k8s_version             = local.k8s_version
  security_group_ids      = [module.cluster_sg.eks_cluster_sg_id]
  kube_proxy_version      = "v1.27.1-eksbuild.1"
  vpc_cni_version         = "v1.12.6-eksbuild.2"
  endpoint_private_access = true
  endpoint_public_access  = true
  log_retention_days      = 5
}

module "eks_nodes_role" {
  source           = "git@github.com:ernestomedina17/tf-modules.git//aws/4/eks-nodes-role"
  name             = local.name
  web_identity     = module.eks_cluster.web_identity
  web_identity_arn = module.eks_cluster.web_identity_arn
  myhome           = var.myhome
}

module "eks_nodes" {
  source              = "git@github.com:ernestomedina17/tf-modules.git//aws/4/eks-nodes"
  name                = local.name
  nodes_role_arn      = module.eks_nodes_role.nodes_role_arn
  k8s_version         = local.k8s_version
  subnets_node_group  = module.network.private_subnet_id
  ami_release_version = local.ami_nodes_release_version
  capacity_type       = "ON_DEMAND"
  disk_size           = "20"
  instance_types      = "t4g.medium"
  ami_type            = "AL2_ARM_64"
  coredns_version     = "v1.10.1-eksbuild.1"
  #ssh_key_name = ""
}
