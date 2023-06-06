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
