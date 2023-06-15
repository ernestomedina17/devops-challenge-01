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

#output "bastion_public_ip" {
#  value = module.bastion.public_ip
#}
#
#output "bastion_ssh_sg_id" {
#  value = module.bastion.ssh_security_group
#}
#
#output "bastion_ssh_key_name" {
#  value = module.bastion.key_name
#}
#
##output "internal_ec2_instance_ip" {
##  value = aws_instance.internal.private_ip
##}
#
#output "eks_cluster_id" {
#  value = module.eks.cluster_endpoint
#}
#
##output "eks_node_group_id" {
##  value = module.eks.nodes_id
##}
#
#output "eks_endpoint" {
#  value = module.eks.cluster_endpoint
#}
#
#output "eks_identity" {
#  value = module.eks.cluster_identity
#}
#
#output "eks_vpc_config" {
#  value = module.eks.eks_vpc_config
#}
#
##output "eks_nodes_role_arn" {
##  value = module.eks.nodes_role_arn
##}
