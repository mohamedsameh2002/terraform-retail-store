terraform {
  required_version = ">= 1.12.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.37"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket       = "tfstate-dev-us-east-1-1nt90y"
    key          = "dev/eks/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = var.aws_region
}



provider "kubernetes" {
  host                   = aws_eks_cluster.main.endpoint
  cluster_ca_certificate = base64decode(
    aws_eks_cluster.main.certificate_authority[0].data
  )
  token = data.aws_eks_cluster_auth.this.token
}


provider "helm" {
  kubernetes = {
    host = aws_eks_cluster.main.endpoint

    cluster_ca_certificate = base64decode(
      aws_eks_cluster.main.certificate_authority[0].data
    )

    token = data.aws_eks_cluster_auth.this.token
  }
}