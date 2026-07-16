terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }
  }
  backend "s3" {
    bucket = "tfstate-dev-us-east-1-1nt90y"
    key = "dev/vpc/terraform.tfstate"
    use_lockfile = true
    region = "us-east-1"
    encrypt = true
  }
}

provider "aws" {
  region = var.aws_region
}