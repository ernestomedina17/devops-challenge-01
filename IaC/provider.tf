terraform {
  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "4.67.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.21.1"
    }

  }
}

provider "aws" {
  region = "eu-central-1"
  default_tags {
    tags = {
      Environment = "Prod"
      CreatedBy   = "Terraform"
      Cluster     = "Unicron"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
  #config_context = "my-context"
}
