data "terraform_remote_state" "eks" {
  backend = "local"

  config = {
    path = "../IaC/terraform.tfstate"
  }
}
