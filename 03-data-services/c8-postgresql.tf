module "postgresql" {
  source = "./modules/postgresql"
  username = local.db_secret.POSTGRESQL_USER
  password = local.db_secret.POSTGRESQL_PASSWORD
  vpc_id = data.terraform_remote_state.eks.outputs.vpc_id
  eks_security_group_id = data.terraform_remote_state.eks.outputs.security_group_id
  private_subnet_ids = data.terraform_remote_state.eks.outputs.private_subnet_ids
  environment_name = var.environment_name
  
}