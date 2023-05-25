output "subnet_a_availability_zone_id" {
  value = aws_subnet.main_a.availability_zone_id
}

output "subnet_b_availability_zone_id" {
  value = aws_subnet.main_b.availability_zone_id
}

output "subnet_c_availability_zone_id" {
  value = aws_subnet.main_c.availability_zone_id
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}

output "unicron_eks_arn" {
  value = aws_eks_cluster.arn
}

output "unicron_eks_ca" {
  value = aws_eks_cluster.certificate_authority
}

output "unicron_eks_id" {
  value = aws_eks_cluster.cluster_id
}

output "unicron_eks_created_at" {
  value = aws_eks_cluster.created_at
}

output "unicron_eks_endpoint" {
  value = aws_eks_cluster.endpoint
}

output "unicron_eks_name" {
  value = aws_eks_cluster.id
}

output "unicron_eks_identity" {
  value = aws_eks_cluster.identity
}

output "unicron_eks_ipv6" {
  value = aws_eks_cluster.kubernetes_network_config.service_ipv6_cidr
}

output "unicron_eks_version" {
  value = aws_eks_cluster.platform_version
}

output "unicron_eks_status" {
  value = aws_eks_cluster.status
}

output "unicron_eks_tags_all" {
  value = aws_eks_cluster.tags_all
}

output "unicron_eks_vpc_config" {
  value = aws_eks_cluster.vpc_config
}
