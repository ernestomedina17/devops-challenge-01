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

module "bastion" {
  source              = "git@github.com:ernestomedina17/tf-modules.git//aws/4/bastion"
  ami_id              = data.aws_ami.amzn-linux-2023-ami.id
  instance_type       = "t4g.medium"
  subnet_id           = module.network.public_subnet_id[0]
  security_groups     = [module.network.default_security_group_id]
  name                = "bastion"
  ssh_pub_key_content = sensitive(data.local_file.ssh_pub_key.content)
  vpc_id              = module.network.vpc_network_id
}

resource "aws_instance" "internal" {
  ami             = data.aws_ami.amzn-linux-2023-ami.id
  instance_type   = "t4g.medium"
  subnet_id       = module.network.private_subnet_id[0]
  security_groups = [module.network.default_security_group_id]
  key_name        = module.bastion.key_name

  tags = { Name = "internal" }
}
