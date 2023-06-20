terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.21.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "4.67.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
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
