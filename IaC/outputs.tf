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
#output "internal_ec2_instance_ip" {
#  value = aws_instance.internal.private_ip
#}

#output "unicron_eks_endpoint" {
#  value = aws_eks_cluster.unicron.endpoint
#}
#
#output "unicron_eks_identity" {
#  value = aws_eks_cluster.unicron.identity
#}
#
#output "unicron_eks_version" {
#  value = aws_eks_cluster.unicron.platform_version
#}
#
#output "unicron_eks_status" {
#  value = aws_eks_cluster.unicron.status
#}
#
#output "unicron_eks_vpc_config" {
#  value = aws_eks_cluster.unicron.vpc_config
#}
