locals {
  name              = "little-caesar"
  svcacc_aws_lb_ctr = "${local.name}-aws-load-balancer-controller"
  cluster_name      = "unicron"
  labels = {
    CreatedBy   = "Terraform"
    Environment = var.environment
    Cluster     = "Unicron"
  }
}
