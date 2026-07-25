data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "tfstate-dev-us-east-1-1nt90y"
    key = "dev/vpc/terraform.tfstate"
    region = var.aws_region
  }
}


data "aws_eks_cluster_auth" "this" {
  name = aws_eks_cluster.main.name
}

data "aws_caller_identity" "current" {}

data "aws_eks_addon_version" "pia_latest" {
  addon_name         = "eks-pod-identity-agent"
  kubernetes_version = aws_eks_cluster.main.version
  most_recent        = true
}

