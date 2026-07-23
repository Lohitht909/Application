terraform {
  required_version = ">= 1.14.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.67"
    }
  }
}

locals {
  region = "us-east-1"
  name   = "mern-stack-cluster"

  vpc_cidr = "10.0.0.0/16"

  azs = ["us-east-1a","us-east-1b"]

  public_subnets  = ["10.0.1.0/24","10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24","10.0.4.0/24"]

  tags = {
    Project     = "mern-devops"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

provider "aws" {
  region = local.region
}