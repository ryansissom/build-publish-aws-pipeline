########################################
# Terraform Configuration
########################################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

########################################
# Provider
########################################

provider "aws" { 
  region = var.region 
}

########################################
# Data Sources
########################################

data "aws_availability_zones" "available" {}

########################################
# Locals
########################################

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 3)

  public_subnets = [
    for i in range(length(local.azs)) : cidrsubnet("10.0.0.0/16", 8, i)
  ]

  private_subnets = [
    for i in range(length(local.azs)) : cidrsubnet("10.0.0.0/16", 8, i + 100)
  ]
}

########################################
# Modules
########################################

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc-main"
  cidr = "10.0.0.0/16"

  azs             = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets

  enable_nat_gateway = false
  enable_vpn_gateway = false

  # tags = {
  #   Terraform = "true"
  #   Environment = "dev"
  # }
}

########################################
# Resources
########################################

resource "aws_ecr_repository" "my_app_repo" {
  name = "my-app"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}
