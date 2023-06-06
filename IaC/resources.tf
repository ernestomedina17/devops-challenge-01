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

