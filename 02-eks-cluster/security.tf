module "name" {
  source = "./modules/security-settings"
  cluster_name = aws_eks_cluster.main.name
  tags = var.tags
  aws_region = var.aws_region
  account_id = data.aws_caller_identity.current.account_id
  
}