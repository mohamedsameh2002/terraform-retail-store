module "karpenter" {
  source = "./modules/karpenter"
  cluster_name = aws_eks_cluster.main.name
  eks_cluster_endpoint = aws_eks_cluster.main.endpoint
  tags = var.tags
  aws_region = var.aws_region
  account_id = data.aws_caller_identity.current.account_id
  environment_name = var.environment_name
  
}