#module "network" {
#  source = "git@github.com:ernestomedina17/tf-modules.git//aws/4/eks-vpc"
#
#  name               = "unicron"
#  cidr_block         = "10.0.0.0/16"
#  region             = var.aws_region
#  availability_zones = data.aws_availability_zones.available.names
#  az_counts          = length(data.aws_availability_zones.available.names)
#}

