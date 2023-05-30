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
  value = aws_eks_cluster.unicron.arn
}

output "unicron_eks_ca" {
  value = aws_eks_cluster.unicron.certificate_authority
}

output "unicron_eks_id" {
  value = aws_eks_cluster.unicron.cluster_id
}

output "unicron_eks_created_at" {
  value = aws_eks_cluster.unicron.created_at
}

output "unicron_eks_endpoint" {
  value = aws_eks_cluster.unicron.endpoint
}

output "unicron_eks_name" {
  value = aws_eks_cluster.unicron.id
}

output "unicron_eks_identity" {
  value = aws_eks_cluster.unicron.identity
}

output "unicron_eks_version" {
  value = aws_eks_cluster.unicron.platform_version
}

output "unicron_eks_status" {
  value = aws_eks_cluster.unicron.status
}

output "unicron_eks_tags_all" {
  value = aws_eks_cluster.unicron.tags_all
}

output "unicron_eks_vpc_config" {
  value = aws_eks_cluster.unicron.vpc_config
}

data "aws_ssm_parameter" "eks_ami_release_version" {
  name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.unicron.version}/amazon-linux-2/recommended/release_version"
}

output "recommended_ami_version" {
  value =  data.aws_ssm_parameter.eks_ami_release_version.name
}
