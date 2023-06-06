output "vpc_network_id" {
  value = module.network.vpc_network_id
}

output "private_subnet_ids" {
  value = module.network.private_subnet_id
}

output "public_subnet_ids" {
  value = module.network.public_subnet_id
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
