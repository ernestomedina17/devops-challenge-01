output "vpc_network_id" {
  value = module.network.vpc_network_id
}

output "private_subnet_ids" {
  value = module.network.private_subnet_id
}

output "public_subnet_ids" {
  value = module.network.public_subnet_id
}

output "vpc_default_sg_id" {
  value = module.network.default_security_group_id
}

output "az_names" {
  value = data.aws_availability_zones.available.names
}

output "az_count" {
  value = length(data.aws_availability_zones.available.names)
}

output "kms_arn" {
  value = module.kms.kms_key_arn
}

output "kms_alias_arn" {
  value = module.kms.kms_alias_arn
}

output "eks_cluster_role_arn" {
  value = module.cluster_role.eks_cluster_role_arn
}

output "eks_cluster_sg_id" {
  value = module.cluster_sg.eks_cluster_sg_id
}

output "eks_web_identity" {
  value = module.eks_cluster.web_identity
}

output "eks_web_identity_arn" {
  value = module.eks_cluster.web_identity_arn
}

output "eks_nodes_role_arn" {
  value = module.eks_nodes_role.nodes_role_arn
}

output "manual_config_map_aws_auth_yaml" {
  value = module.eks_nodes_role.config_map_aws_auth_yaml
}

output "manual_steps" {
  value = module.eks_nodes_role.manual_steps
}

output "eks_node_group_id" {
  value = module.eks_nodes.node_group_id
}
