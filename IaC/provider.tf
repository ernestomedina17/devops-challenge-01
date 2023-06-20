terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.67.0"
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
