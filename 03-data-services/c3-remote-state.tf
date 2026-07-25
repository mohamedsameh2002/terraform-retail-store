data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "tfstate-dev-us-east-1-1nt90y"
    key = "dev/eks/terraform.tfstate"
    region = var.aws_region
  }
}

