locals {
  name = "little-caesar"
  svcacc_aws_lb_ctr = "${local.name}-aws-load-balancer-controller"
  labels = {
    CreatedBy   = "Terraform"
    Environment = var.environment
    Cluster     = "Unicron"
  }
}
